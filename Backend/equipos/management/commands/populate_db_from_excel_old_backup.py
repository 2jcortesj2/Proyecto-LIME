"""
Django management command to populate the database from Excel file.
This command reads the F-147 inventory Excel file and creates all necessary records.
"""
import os
import re
import random
from datetime import datetime, timedelta, date
from decimal import Decimal
from django.core.management.base import BaseCommand
from django.db import transaction
from equipos.models import (
    Equipo, RegistroAdquisicion, DocumentacionEquipo,
    InformacionMetrologica, CondicionesFuncionamiento
)
from sedes.models import Sede
from ubicaciones.models import Ubicacion
from responsables.models import Responsable
from historial_traslados.models import HistorialTraslado
from historial_mantenimientos.models import HistorialMantenimiento

try:
    import pandas as pd
    PANDAS_AVAILABLE = True
except ImportError:
    PANDAS_AVAILABLE = False


class Command(BaseCommand):
    help = 'Populates the database from the F-147 Excel inventory file'

    def add_arguments(self, parser):
        parser.add_argument(
            '--file',
            type=str,
            default='F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx',
            help='Path to the Excel file'
        )
        parser.add_argument(
            '--flush',
            action='store_true',
            help='Flush existing data before importing'
        )

    def handle(self, *args, **options):
        if not PANDAS_AVAILABLE:
            self.stdout.write(self.style.ERROR('pandas is not installed. Please install it with: pip install pandas openpyxl'))
            return

        file_path = options['file']
        
        # If relative path, look in project root
        if not os.path.isabs(file_path):
            from django.conf import settings
            file_path = os.path.join(settings.BASE_DIR.parent, file_path)

        if not os.path.exists(file_path):
            self.stdout.write(self.style.ERROR(f'File not found: {file_path}'))
            return

        try:
            # Try header=6 first (typical for F-147 format), fallback to header=0
            try:
                df = pd.read_excel(file_path, header=6)
                # Check if we got valid data
                if df.empty or len(df.columns) < 5:
                    df = pd.read_excel(file_path, header=0)
            except:
                df = pd.read_excel(file_path, header=0)
            
            # Drop completely empty rows
            df = df.dropna(how='all')
            
            self.stdout.write(self.style.SUCCESS(f'Loaded {len(df)} rows from Excel'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error reading Excel file: {e}'))
            self.stdout.write(self.style.WARNING('If the file is open in Excel, please close it and try again.'))
            return

        if options['flush']:
            self.stdout.write(self.style.WARNING('Flushing existing data...'))
            with transaction.atomic():
                HistorialMantenimiento.objects.all().delete()
                HistorialTraslado.objects.all().delete()
                CondicionesFuncionamiento.objects.all().delete()
                InformacionMetrologica.objects.all().delete()
                DocumentacionEquipo.objects.all().delete()
                RegistroAdquisicion.objects.all().delete()
                Equipo.objects.all().delete()
                Ubicacion.objects.all().delete()
                Responsable.objects.all().delete()
                Sede.objects.all().delete()
            self.stdout.write(self.style.SUCCESS('Database flushed'))

        self.populate_database(df)

    def populate_database(self, df):
        """Main population logic"""
        
        # Data structures to track created objects
        sedes_map = {}
        ubicaciones_map = {}
        responsables_map = {}
        equipos_list = []

        self.stdout.write('Creating Sedes and Ubicaciones...')
        sedes_map, ubicaciones_map = self.create_sedes_ubicaciones(df)
        
        self.stdout.write('Creating Responsables...')
        responsables_map = self.create_responsables(df)
        
        self.stdout.write('Creating Equipos...')
        equipos_list = self.create_equipos(df, sedes_map, ubicaciones_map, responsables_map)
        
        self.stdout.write('Generating random Traslados...')
        self.generate_traslados(equipos_list, sedes_map, ubicaciones_map, responsables_map)
        
        self.stdout.write('Generating Maintenance/Calibration history...')
        self.generate_maintenance_history(equipos_list)
        
        self.stdout.write(self.style.SUCCESS(f'\n✅ Database populated successfully!'))
        self.stdout.write(f'  - Sedes: {len(sedes_map)}')
        self.stdout.write(f'  - Ubicaciones: {len(ubicaciones_map)}')
        self.stdout.write(f'  - Responsables: {len(responsables_map)}')
        self.stdout.write(f'  - Equipos: {len(equipos_list)}')

    def create_sedes_ubicaciones(self, df):
        """Create Sede and Ubicacion objects from Excel data"""
        sedes_map = {}
        ubicaciones_map = {}
        
        # Expected columns: 'SEDE', 'UBICACIÓN' or similar
        sede_col = self.find_column(df, ['SEDE', 'Sede', 'sede'])
        ubicacion_col = self.find_column(df, ['UBICACIÓN', 'UBICACION', 'Ubicación', 'Ubicacion'])
        
        if not sede_col or not ubicacion_col:
            self.stdout.write(self.style.WARNING('Could not find SEDE/UBICACION columns, using defaults'))
            # Create a default sede
            sede = Sede.objects.create(
                nombre='Sede Principal',
                ciudad='Bogotá',
                direccion='Calle 1',
                telefono='1234567',
                estado=True
            )
            sedes_map['default'] = sede
            
            ubicacion = Ubicacion.objects.create(
                nombre='Ubicación Principal',
                sede=sede,
                estado=True
            )
            ubicaciones_map['default'] = ubicacion
            return sedes_map, ubicaciones_map
        
        # Extract unique combinations
        unique_combinations = df[[sede_col, ubicacion_col]].drop_duplicates()
        
        with transaction.atomic():
            for _, row in unique_combinations.iterrows():
                sede_nombre = str(row[sede_col]).strip() if pd.notna(row[sede_col]) else 'Sin Sede'
                ubicacion_nombre = str(row[ubicacion_col]).strip() if pd.notna(row[ubicacion_col]) else 'Sin Ubicación'
                
                # Create or get Sede
                if sede_nombre not in sedes_map:
                    sede = Sede.objects.create(
                        nombre=sede_nombre,
                        ciudad='Bogotá',  # Default, can be enhanced
                        direccion=f'Dirección {sede_nombre}',
                        telefono='1234567',
                        estado=True
                    )
                    sedes_map[sede_nombre] = sede
                    self.stdout.write(f'  Created Sede: {sede_nombre}')
                
                # Create Ubicacion
                ubicacion_key = f'{sede_nombre}|{ubicacion_nombre}'
                if ubicacion_key not in ubicaciones_map:
                    ubicacion = Ubicacion.objects.create(
                        nombre=ubicacion_nombre,
                        sede=sedes_map[sede_nombre],
                        estado=True
                    )
                    ubicaciones_map[ubicacion_key] = ubicacion
                    self.stdout.write(f'  Created Ubicación: {ubicacion_nombre} @ {sede_nombre}')
        
        return sedes_map, ubicaciones_map

    def create_responsables(self, df):
        """Create Responsable objects from Excel data"""
        responsables_map = {}
        
        # Expected column: 'RESPONSABLE' or similar
        resp_col = self.find_column(df, ['RESPONSABLE', 'Responsable', 'responsable', 'USUARIO', 'Usuario'])
        
        if not resp_col:
            # Create a default responsable
            resp = Responsable.objects.create(
                nombre_completo='Sin Asignar',
                email='sin.asignar@example.com',
                telefono='0000000',
                rol='Sin Rol'
            )
            responsables_map['default'] = resp
            return responsables_map
        
        # Extract unique responsables
        unique_responsables = df[resp_col].dropna().unique()
        
        with transaction.atomic():
            for nombre in unique_responsables:
                nombre = str(nombre).strip()
                if nombre and nombre not in responsables_map:
                    # Generate a simple email
                    email = f"{nombre.lower().replace(' ', '.')}@example.com"
                    
                    # Check if email already exists
                    counter = 1
                    original_email = email
                    while Responsable.objects.filter(email=email).exists():
                        email = f"{original_email.split('@')[0]}{counter}@example.com"
                        counter += 1
                    
                    resp = Responsable.objects.create(
                        nombre_completo=nombre,
                        email=email,
                        telefono='0000000',
                        rol='Responsable de Equipo'
                    )
                    responsables_map[nombre] = resp
                    self.stdout.write(f'  Created Responsable: {nombre}')
        
        return responsables_map

    def create_equipos(self, df, sedes_map, ubicaciones_map, responsables_map):
        """Create Equipo objects and related models"""
        equipos_list = []
        
        # Find relevant columns
        nombre_col = self.find_column(df, ['NOMBRE', 'Nombre', 'EQUIPO', 'Equipo', 'DESCRIPCIÓN', 'Descripcion'])
        sede_col = self.find_column(df, ['SEDE', 'Sede'])
        ubicacion_col = self.find_column(df, ['UBICACIÓN', 'UBICACION', 'Ubicación'])
        resp_col = self.find_column(df, ['RESPONSABLE', 'Responsable'])
        marca_col = self.find_column(df, ['MARCA', 'Marca'])
        modelo_col = self.find_column(df, ['MODELO', 'Modelo'])
        serie_col = self.find_column(df, ['SERIE', 'Serie', 'No. SERIE', 'NÚMERO DE SERIE'])
        
        # Metrology columns
        freq_calib_col = self.find_column(df, ['FRECUENCIA DE CALIBRACIÓN', 'Frecuencia de calibración', 'FRECUENCIA CALIBRACION'])
        
        with transaction.atomic():
            for idx, row in df.iterrows():
                try:
                    # Get nombre_equipo
                    nombre_equipo = str(row[nombre_col]).strip() if nombre_col and pd.notna(row[nombre_col]) else f'Equipo {idx+1}'
                    
                    # Determine proceso - LIME si el nombre empieza con LIME
                    proceso = 'LIME' if nombre_equipo.upper().startswith('LIME') else 'Otro'
                    
                    # Get sede/ubicacion
                    sede_nombre = str(row[sede_col]).strip() if sede_col and pd.notna(row[sede_col]) else 'default'
                    ubicacion_nombre = str(row[ubicacion_col]).strip() if ubicacion_col and pd.notna(row[ubicacion_col]) else 'default'
                    ubicacion_key = f'{sede_nombre}|{ubicacion_nombre}' if sede_col and ubicacion_col else 'default'
                    
                    sede = sedes_map.get(sede_nombre, list(sedes_map.values())[0] if sedes_map else None)
                    ubicacion = ubicaciones_map.get(ubicacion_key, list(ubicaciones_map.values())[0] if ubicaciones_map else None)
                    
                    # Get responsable
                    resp_nombre = str(row[resp_col]).strip() if resp_col and pd.notna(row[resp_col]) else 'default'
                    responsable = responsables_map.get(resp_nombre, list(responsables_map.values())[0] if responsables_map else None)
                    
                    # Random estado - 1% Inactivo, 99% Activo
                    estado = 'Inactivo' if random.random() < 0.01 else 'Activo'
                    
                    # Create Equipo
                    equipo = Equipo.objects.create(
                        proceso=proceso,
                        sede=sede,
                        ubicacion=ubicacion,
                        responsable=responsable,
                        nombre_equipo=nombre_equipo,
                        codigo_interno=f'LIME-{idx+1:04d}',
                        marca=str(row[marca_col]).strip() if marca_col and pd.notna(row[marca_col]) else None,
                        modelo=str(row[modelo_col]).strip() if modelo_col and pd.notna(row[modelo_col]) else None,
                        serie=str(row[serie_col]).strip() if serie_col and pd.notna(row[serie_col]) else None,
                        clasificacion_ips=random.choice(['IND', 'BIO', 'GASES']),
                        estado=estado,
                        tiempo_vida_util=random.randint(5, 15)
                    )
                    
                    # Create RegistroAdquisicion
                    fecha_adq = self.random_date(datetime(2015, 1, 1), datetime(2024, 1, 1))
                    RegistroAdquisicion.objects.create(
                        equipo=equipo,
                        fecha_adquisicion=fecha_adq,
                        propietario='Universidad',
                        forma_adquisicion=random.choice(['Compra', 'Donación', 'Convenio']),
                        valor_compra=Decimal(random.randint(1000000, 50000000))
                    )
                    
                    # Create DocumentacionEquipo
                    DocumentacionEquipo.objects.create(
                        equipo=equipo,
                        hoja_vida=random.choice([True, False]),
                        manual_operacion=random.choice([True, False]),
                        manual_servicio=random.choice([True, False])
                    )
                    
                    # Create InformacionMetrologica - parse calibration frequency
                    freq_calib = str(row[freq_calib_col]).strip() if freq_calib_col and pd.notna(row[freq_calib_col]) else ''
                    
                    requiere_mantenimiento = random.choice([True, False])
                    requiere_calibracion = False
                    requiere_calificacion = False
                    frecuencia_calibracion = None
                    frecuencia_calificacion = None
                    
                    # Parse frequency - format could be "1(calificación)" or "12" for months
                    if freq_calib:
                        if 'calificación' in freq_calib.lower() or 'calificacion' in freq_calib.lower():
                            requiere_calificacion = True
                            # Extract number
                            match = re.search(r'(\d+)', freq_calib)
                            if match:
                                months = int(match.group(1))
                                frecuencia_calificacion = f'{months} meses'
                        else:
                            requiere_calibracion = True
                            match = re.search(r'(\d+)', freq_calib)
                            if match:
                                months = int(match.group(1))
                                frecuencia_calibracion = f'{months} meses'
                    else:
                        # Even if Excel doesn't have frequency, randomly assign some equipment
                        # to require calibration or qualification for testing
                        rand_val = random.random()
                        if rand_val < 0.15:  # 15% chance
                            requiere_calibracion = True
                            frecuencia_calibracion = random.choice(['6 meses', '12 meses', '24 meses'])
                        elif rand_val < 0.25:  # Additional 10% chance
                            requiere_calificacion = True
                            frecuencia_calificacion = random.choice(['12 meses', '24 meses'])
                    
                    info_metro = InformacionMetrologica.objects.create(
                        equipo=equipo,
                        requiere_mantenimiento=requiere_mantenimiento,
                        frecuencia_mantenimiento='6 meses' if requiere_mantenimiento else None,
                        requiere_calibracion=requiere_calibracion,
                        frecuencia_calibracion=frecuencia_calibracion,
                        requiere_calificacion=requiere_calificacion,
                        frecuencia_calificacion=frecuencia_calificacion
                    )
                    
                    # Create CondicionesFuncionamiento
                    # Add decommissioning reason for inactive equipment
                    otros_text = None
                    if estado == 'Inactivo':
                        razones = [
                            'Equipo obsoleto - Reemplazado por tecnología más moderna',
                            'Daño irreparable - Costo de reparación excede valor del equipo',
                            'Fuera de servicio - No cumple con normativas vigentes',
                            'Baja por antigüedad - Superó vida útil estimada',
                            'Equipo descontinuado - Sin soporte técnico del fabricante'
                        ]
                        otros_text = f'MOTIVO DE BAJA: {random.choice(razones)}'
                    
                    CondicionesFuncionamiento.objects.create(
                        equipo=equipo,
                        voltaje='110V' if random.random() > 0.3 else '220V',
                        temperatura='15-25°C',
                        otros=otros_text
                    )
                    
                    equipos_list.append({
                        'equipo': equipo,
                        'info_metro': info_metro,
                        'fecha_adq': fecha_adq
                    })
                    
                    if (idx + 1) % 10 == 0:
                        self.stdout.write(f'  Created {idx + 1} equipos...')
                
                except Exception as e:
                    self.stdout.write(self.style.WARNING(f'  Error creating equipo at row {idx}: {e}'))
                    continue
        
        return equipos_list

    def generate_traslados(self, equipos_list, sedes_map, ubicaciones_map, responsables_map):
        """Generate random transfer history"""
        
        if not equipos_list:
            return
        
        ubicaciones_list = list(ubicaciones_map.values())
        
        # Need at least 2 ubicaciones to generate traslados
        if len(ubicaciones_list) < 2:
            self.stdout.write(self.style.WARNING('  Skipping traslados: need at least 2 ubicaciones'))
            return
        
        # Generate traslados for ~30% of equipos
        num_traslados = int(len(equipos_list) * 0.3)
        selected_equipos = random.sample(equipos_list, min(num_traslados, len(equipos_list)))
        
        responsables_list = list(responsables_map.values())
        
        traslados_created = 0
        
        with transaction.atomic():
            for equipo_data in selected_equipos:
                equipo = equipo_data['equipo']
                
                # Generate 1-3 traslados per selected equipo
                num_traslados_equipo = random.randint(1, 3)
                
                # Start from acquisition date
                current_date = equipo_data['fecha_adq']
                current_ubicacion = equipo.ubicacion
                
                for _ in range(num_traslados_equipo):
                    # Random date between current and Nov 2025
                    fecha_traslado = self.random_date(
                        current_date,
                        datetime(2025, 11, 30)
                    )
                    
                    # Pick a different ubicacion
                    available_ubicaciones = [u for u in ubicaciones_list if u != current_ubicacion]
                    if not available_ubicaciones:
                        break  # No other ubicaciones available
                    new_ubicacion = random.choice(available_ubicaciones)
                    
                    HistorialTraslado.objects.create(
                        equipo=equipo,
                        fecha_traslado=fecha_traslado,
                        sede_origen=current_ubicacion.sede if current_ubicacion else None,
                        ubicacion_origen=current_ubicacion,
                        sede_destino=new_ubicacion.sede,
                        ubicacion_destino=new_ubicacion,
                        justificacion='Traslado por necesidad operativa',
                        responsable_registro=random.choice(responsables_list) if responsables_list else None
                    )
                    
                    current_ubicacion = new_ubicacion
                    current_date = fecha_traslado
                    traslados_created += 1
                
                # Update equipo's current ubicacion
                equipo.ubicacion = current_ubicacion
                equipo.sede = current_ubicacion.sede
                equipo.save()
        
        self.stdout.write(f'  Generated {traslados_created} traslados')

    def generate_maintenance_history(self, equipos_list):
        """Generate maintenance/calibration/qualification history"""
        
        mantenimientos_created = 0
        
        with transaction.atomic():
            for equipo_data in equipos_list:
                equipo = equipo_data['equipo']
                info_metro = equipo_data['info_metro']
                fecha_adq = equipo_data['fecha_adq']
                
                # Generate maintenance history
                if info_metro.requiere_mantenimiento and info_metro.frecuencia_mantenimiento:
                    months_interval = self.parse_frequency(info_metro.frecuencia_mantenimiento)
                    mantenimientos_created += self.generate_history_entries(
                        equipo, fecha_adq, months_interval, 'Preventivo', 'Mantenimiento'
                    )
                
                # Generate calibration history
                if info_metro.requiere_calibracion and info_metro.frecuencia_calibracion:
                    months_interval = self.parse_frequency(info_metro.frecuencia_calibracion)
                    mantenimientos_created += self.generate_history_entries(
                        equipo, fecha_adq, months_interval, 'Calibración', 'Calibración'
                    )
                
                # Generate qualification history
                if info_metro.requiere_calificacion and info_metro.frecuencia_calificacion:
                    months_interval = self.parse_frequency(info_metro.frecuencia_calificacion)
                    mantenimientos_created += self.generate_history_entries(
                        equipo, fecha_adq, months_interval, 'Verificación', 'Calificación'
                    )
        
        self.stdout.write(f'  Generated {mantenimientos_created} maintenance records')

    def generate_history_entries(self, equipo, fecha_inicio, months_interval, tipo_mant, descripcion_base):
        """Generate periodic history entries up to Nov 2025"""
        
        if months_interval <= 0:
            return 0
        
        count = 0
        current_date = fecha_inicio
        end_date = datetime(2025, 11, 30)
        
        while current_date <= end_date:
            # Add some random variation (±15 days)
            variation_days = random.randint(-15, 15)
            fecha_mant = current_date + timedelta(days=variation_days)
            
            if fecha_mant > end_date:
                break
            
            HistorialMantenimiento.objects.create(
                equipo=equipo,
                tipo_mantenimiento=tipo_mant,
                mes_mantenimiento=fecha_mant.month,
                anio_mantenimiento=fecha_mant.year,
                realizado_por='Proveedor Externo' if random.random() > 0.3 else 'Personal Interno',
                descripcion=f'{descripcion_base} programado',
                costo=Decimal(random.randint(100000, 2000000))
            )
            
            count += 1
            
            # Move to next interval
            current_date = current_date + timedelta(days=30 * months_interval)
        
        # Update last maintenance dates in InformacionMetrologica
        if count > 0 and hasattr(equipo, 'informacion_metrologica'):
            info = equipo.informacion_metrologica
            last_date = fecha_mant.date() if isinstance(fecha_mant, datetime) else fecha_mant
            
            if tipo_mant == 'Preventivo':
                info.ultimo_mantenimiento = last_date
            elif tipo_mant == 'Calibración':
                info.ultima_calibracion = last_date
            elif tipo_mant == 'Verificación':
                info.ultima_calificacion = last_date
            
            info.save()
        
        return count

    def parse_frequency(self, freq_str):
        """Parse frequency string and return interval in months"""
        if not freq_str:
            return 0
        
        match = re.search(r'(\d+)', freq_str)
        if match:
            return int(match.group(1))
        
        # Default patterns
        if 'semestral' in freq_str.lower():
            return 6
        elif 'trimestral' in freq_str.lower():
            return 3
        elif 'mensual' in freq_str.lower():
            return 1
        elif 'anual' in freq_str.lower() or 'año' in freq_str.lower():
            return 12
        
        return 12  # Default to annual

    def random_date(self, start, end):
        """Generate a random date between start and end"""
        if isinstance(start, datetime):
            start_date = start
        else:
            start_date = datetime.combine(start, datetime.min.time())
        
        if isinstance(end, datetime):
            end_date = end
        else:
            end_date = datetime.combine(end, datetime.min.time())
        
        delta = end_date - start_date
        random_days = random.randint(0, delta.days)
        return start_date + timedelta(days=random_days)

    def find_column(self, df, possible_names):
        """Find a column in the dataframe by possible names"""
        for col in df.columns:
            col_str = str(col).strip()
            if col_str in possible_names:
                return col
            # Case-insensitive match
            if col_str.upper() in [n.upper() for n in possible_names]:
                return col
            # Partial match for cases like "SEDE (UBICACIÓN)"
            for name in possible_names:
                if name.upper() in col_str.upper():
                    return col
        return None
