"""
Django management command to populate the database from Excel file.
This command reads the F-147 inventory Excel file and creates all necessary records.
Updated to use ALL data from Excel columns and refine parsing logic.
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
            # Read Excel with header=None to find the correct header row
            df_raw = pd.read_excel(file_path, header=None)
            
            header_row_idx = None
            for idx, row in df_raw.iterrows():
                row_str = ' '.join([str(val) for val in row.values if pd.notna(val)])
                if 'Sede' in row_str and 'Proceso' in row_str:
                    header_row_idx = idx
                    break
            
            if header_row_idx is None:
                # Fallback to row 7 (index 7) if not found
                header_row_idx = 7
                self.stdout.write(self.style.WARNING(f'Could not auto-detect header row. Trying row {header_row_idx}...'))
            else:
                self.stdout.write(self.style.SUCCESS(f'Found header at row {header_row_idx}'))

            # Reload with correct header
            df = pd.read_excel(file_path, header=header_row_idx)
            df = df.dropna(how='all')
            
            # Clean column names (strip whitespace and newlines)
            df.columns = [str(c).strip().replace('\n', ' ') for c in df.columns]
            
            self.stdout.write(self.style.SUCCESS(f'Loaded {len(df)} rows from Excel'))
            self.stdout.write(f'Found columns: {list(df.columns)[:5]}...')
            
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

        self.stdout.write('Creating Sedes and Ubicaciones from Excel...')
        sedes_map, ubicaciones_map = self.create_sedes_ubicaciones(df)
        
        self.stdout.write('Creating Responsables from Excel...')
        responsables_map = self.create_responsables(df)
        
        self.stdout.write('Creating Equipos from Excel...')
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
        
        # Find columns
        sede_col = self.find_column(df, ['Sede', 'SEDE'])
        ubicacion_col = self.find_column(df, ['Ubicación física', 'Ubicacion fisica', 'UBICACIÓN FÍSICA'])
        
        if sede_col and ubicacion_col:
            unique_combinations = df[[sede_col, ubicacion_col]].drop_duplicates()
            
            with transaction.atomic():
                for _, row in unique_combinations.iterrows():
                    if pd.notna(row[sede_col]) and pd.notna(row[ubicacion_col]):
                        sede_nombre = str(row[sede_col]).strip()
                        ubicacion_nombre = str(row[ubicacion_col]).strip()
                        
                        if not sede_nombre or not ubicacion_nombre:
                            continue

                        # Create or get Sede
                        if sede_nombre not in sedes_map:
                            sede, created = Sede.objects.get_or_create(
                                nombre=sede_nombre,
                                defaults={
                                    'ciudad': 'Medellín',
                                    'direccion': f'Universidad de Antioquia - {sede_nombre}',
                                    'telefono': '6042195000',
                                    'estado': True
                                }
                            )
                            sedes_map[sede_nombre] = sede
                            if created:
                                self.stdout.write(f'  ✓ Sede: {sede_nombre}')
                        
                        # Create Ubicacion
                        ubicacion_key = f'{sede_nombre}|{ubicacion_nombre}'
                        if ubicacion_key not in ubicaciones_map:
                            ubicacion, created = Ubicacion.objects.get_or_create(
                                nombre=ubicacion_nombre,
                                sede=sedes_map[sede_nombre],
                                defaults={'estado': True}
                            )
                            ubicaciones_map[ubicacion_key] = ubicacion
        else:
            self.stdout.write(self.style.WARNING('Could not find Sede/Ubicacion columns'))

        return sedes_map, ubicaciones_map

    def create_responsables(self, df):
        """Create Responsable objects from Excel data"""
        responsables_map = {}
        
        # Find column
        resp_col = self.find_column(df, ['Responsable del proceso en el que interviene el equipo y/o inventario UdeA', 'Responsable'])
        
        if resp_col:
            unique_responsables = df[resp_col].dropna().unique()
            
            with transaction.atomic():
                for raw_nombre in unique_responsables:
                    raw_nombre = str(raw_nombre).strip()
                    if not raw_nombre:
                        continue
                        
                    # Split by '/' and take the first name to avoid nesting
                    # "Gloria Zapata / Andres Zuluaga" -> "Gloria Zapata"
                    primary_name = raw_nombre.split('/')[0].strip()
                    
                    if primary_name and primary_name not in responsables_map:
                        # Clean email generation
                        # Remove dots, extra spaces, special chars
                        clean_name = re.sub(r'[^\w\s]', '', primary_name).lower()
                        email_name = clean_name.replace(' ', '.')
                        email = f"{email_name}@udea.edu.co"
                        
                        # Handle duplicate emails
                        counter = 1
                        original_email = email
                        while Responsable.objects.filter(email=email).exists():
                            email = f"{original_email.split('@')[0]}{counter}@udea.edu.co"
                            counter += 1
                        
                        resp, created = Responsable.objects.get_or_create(
                            nombre_completo=primary_name,
                            defaults={
                                'email': email,
                                'telefono': '6042195000',
                                'rol': 'Responsable de Equipo'
                            }
                        )
                        # Map the RAW name to this responsible, so lookups work
                        responsables_map[raw_nombre] = resp
                        if created:
                            self.stdout.write(f'  ✓ Responsable: {primary_name} (from "{raw_nombre}")')
        
        return responsables_map

    def create_equipos(self, df, sedes_map, ubicaciones_map, responsables_map):
        """Create Equipo objects from Excel data"""
        equipos_list = []
        inactive_count = 0
        
        # Find columns
        cols = {
            'nombre': self.find_column(df, ['Nombre del equipo', 'Nombre']),
            'proceso': self.find_column(df, ['Proceso']),
            'sede': self.find_column(df, ['Sede']),
            'ubicacion': self.find_column(df, ['Ubicación física', 'Ubicacion']),
            'responsable': self.find_column(df, ['Responsable del proceso en el que interviene el equipo y/o inventario UdeA', 'Responsable']),
            'codigo': self.find_column(df, ['Código de inventario interno del laboratorio y/o asignado por UdeA', 'Codigo']),
            'codigo_ips': self.find_column(df, ['Código IPS']),
            'codigo_ecri': self.find_column(df, ['Código ECRI']),
            'marca': self.find_column(df, ['Marca']),
            'modelo': self.find_column(df, ['Modelo']),
            'serie': self.find_column(df, ['Serie']),
            'clasificacion': self.find_column(df, ['Clasificación IPS (IND-BIO-Gases)', 'Clasificacion']),
            'clasificacion_misional': self.find_column(df, ['Clasificación según eje misional (Docencia y/o Investigación y/o Extensión)']),
            'clasificacion_riesgo': self.find_column(df, ['Clasificación por riesgo']),
            'registro_invima': self.find_column(df, ['Registro Invima/Permiso comercialización/No Requiere']),
            'vida_util': self.find_column(df, ['Tiempo de vida útil', 'Vida util']),
            'fecha_adq': self.find_column(df, ['Antigüedad del eq. (F. adquisición)', 'Fecha adquisicion']),
            'propietario': self.find_column(df, ['Propietario del equipo', 'Propietario']),
            'forma_adq': self.find_column(df, ['Forma de adquisición', 'Forma adquisicion']),
            'valor': self.find_column(df, ['Valor de compra', 'Valor']),
            'hoja_vida': self.find_column(df, ['Hoja de vida']),
            'manual_op': self.find_column(df, ['Manual operación (Esp)', 'Manual operacion']),
            'manual_serv': self.find_column(df, ['Manual servicio mto (Esp)', 'Manual servicio']),
            'req_mant': self.find_column(df, ['Mantenimiento Si/No']),
            'req_cal': self.find_column(df, ['Calibración Si/No', 'Calibracion']),
            'freq_mant': self.find_column(df, ['Frecuencia anual mantenimiento']),
            'freq_cal': self.find_column(df, ['Frecuencia anual calibración', 'Frecuencia calibracion']),
            'voltaje': self.find_column(df, ['Voltaje']),
            'temp': self.find_column(df, ['Temperatura']),
            'otros': self.find_column(df, ['Otros'])
        }
        
        with transaction.atomic():
            for idx, row in df.iterrows():
                try:
                    # Get basic data
                    nombre_equipo = self.get_value(row, cols['nombre'], f'Equipo {idx+1}')
                    proceso = self.get_value(row, cols['proceso'], 'Otro')
                    
                    # Get relations
                    sede_nombre = self.get_value(row, cols['sede'])
                    ubicacion_nombre = self.get_value(row, cols['ubicacion'])
                    ubicacion_key = f'{sede_nombre}|{ubicacion_nombre}'
                    
                    sede = sedes_map.get(sede_nombre)
                    ubicacion = ubicaciones_map.get(ubicacion_key)
                    
                    resp_nombre = self.get_value(row, cols['responsable'])
                    responsable = responsables_map.get(resp_nombre)
                    
                    # Fallbacks if relations not found
                    if not sede and sedes_map:
                        sede = list(sedes_map.values())[0]
                    if not ubicacion and ubicaciones_map:
                        ubicacion = list(ubicaciones_map.values())[0]
                    if not responsable and responsables_map:
                        responsable = list(responsables_map.values())[0]
                    
                    # Estado logic
                    if idx == 0:
                        estado = 'Inactivo'
                        inactive_count += 1
                    else:
                        estado = 'Inactivo' if random.random() < 0.01 else 'Activo'
                        if estado == 'Inactivo':
                            inactive_count += 1
                    
                    # Clasificacion Misional: Replace ' y ' and ' e ' with ', '
                    clasif_misional = self.get_value(row, cols['clasificacion_misional'])
                    if clasif_misional:
                        clasif_misional = clasif_misional.replace(' y ', ', ').replace(' e ', ', ')

                    # Clasificacion Riesgo
                    clasif_riesgo = self.get_value(row, cols['clasificacion_riesgo'])
                    if clasif_riesgo:
                        clasif_riesgo = clasif_riesgo.replace('Clase ', '').strip()
                    
                    # Create Equipo
                    equipo = Equipo.objects.create(
                        proceso=proceso,
                        sede=sede,
                        ubicacion=ubicacion,
                        responsable=responsable,
                        nombre_equipo=nombre_equipo,
                        codigo_interno=self.get_value(row, cols['codigo']),
                        codigo_ips=self.get_value(row, cols['codigo_ips']),
                        codigo_ecri=self.get_value(row, cols['codigo_ecri']),
                        marca=self.get_value(row, cols['marca']),
                        modelo=self.get_value(row, cols['modelo']),
                        serie=self.get_value(row, cols['serie']),
                        clasificacion_ips=self.get_value(row, cols['clasificacion'], 'IND'),
                        clasificacion_misional=clasif_misional,
                        clasificacion_riesgo=clasif_riesgo,
                        registro_invima=self.get_value(row, cols['registro_invima']),
                        estado=estado,
                        tiempo_vida_util=self.parse_int(self.get_value(row, cols['vida_util']), random.randint(5, 15))
                    )
                    
                    # RegistroAdquisicion
                    fecha_adq_str = self.get_value(row, cols['fecha_adq'])
                    fecha_adq = self.parse_date(fecha_adq_str, self.random_date(datetime(2015, 1, 1), datetime(2024, 1, 1)))
                    
                    RegistroAdquisicion.objects.create(
                        equipo=equipo,
                        fecha_adquisicion=fecha_adq,
                        propietario=self.get_value(row, cols['propietario'], 'Universidad de Antioquia'),
                        forma_adquisicion=self.get_value(row, cols['forma_adq'], 'Compra'),
                        valor_compra=self.parse_decimal(self.get_value(row, cols['valor']), Decimal(random.randint(1000000, 50000000)))
                    )
                    
                    # DocumentacionEquipo
                    DocumentacionEquipo.objects.create(
                        equipo=equipo,
                        hoja_vida=self.parse_bool(self.get_value(row, cols['hoja_vida'])),
                        manual_operacion=self.parse_bool(self.get_value(row, cols['manual_op'])),
                        manual_servicio=self.parse_bool(self.get_value(row, cols['manual_serv']))
                    )
                    
                    # InformacionMetrologica
                    req_mant = self.parse_bool(self.get_value(row, cols['req_mant']))
                    freq_mant = self.get_value(row, cols['freq_mant'])
                    
                    # Calibration/Qualification Logic
                    raw_freq_cal = self.get_value(row, cols['freq_cal'])
                    
                    req_cal = False
                    freq_cal = None
                    req_qual = False
                    freq_qual = None
                    
                    if raw_freq_cal:
                        raw_freq_cal_str = str(raw_freq_cal)
                        # Check for Qualification
                        if 'calificación' in raw_freq_cal_str.lower() or 'calificacion' in raw_freq_cal_str.lower():
                            req_qual = True
                            # Extract number
                            match = re.search(r'(\d+)', raw_freq_cal_str)
                            if match:
                                freq_qual = f"{match.group(1)} meses" # Assuming months if just number
                            else:
                                freq_qual = raw_freq_cal_str # Keep original if no number found
                        else:
                            # It's calibration
                            req_cal = True
                            freq_cal = raw_freq_cal_str
                    
                    # Random calibration if missing (only if not qualification)
                    if not req_cal and not req_qual and random.random() < 0.15:
                        req_cal = True
                        freq_cal = random.choice(['6 meses', '12 meses'])
                    
                    info_metro = InformacionMetrologica.objects.create(
                        equipo=equipo,
                        requiere_mantenimiento=req_mant,
                        frecuencia_mantenimiento=freq_mant if req_mant else None,
                        requiere_calibracion=req_cal,
                        frecuencia_calibracion=freq_cal if req_cal else None,
                        requiere_calificacion=req_qual,
                        frecuencia_calificacion=freq_qual if req_qual else None
                    )
                    
                    # CondicionesFuncionamiento
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
                        voltaje=self.get_value(row, cols['voltaje']),
                        temperatura=self.get_value(row, cols['temp']),
                        otros=otros_text or self.get_value(row, cols['otros'])
                    )
                    
                    equipos_list.append({
                        'equipo': equipo,
                        'info_metro': info_metro,
                        'fecha_adq': fecha_adq
                    })
                    
                    if (idx + 1) % 10 == 0:
                        self.stdout.write(f'  Created {idx + 1} equipos...')
                
                except Exception as e:
                    self.stdout.write(self.style.WARNING(f'  Error at row {idx}: {e}'))
                    continue
        
        self.stdout.write(f'  ✓ Created {len(equipos_list)} equipos ({inactive_count} inactive)')
        return equipos_list

    def generate_traslados(self, equipos_list, sedes_map, ubicaciones_map, responsables_map):
        """Generate random transfer history"""
        if not equipos_list:
            return
        
        ubicaciones_list = list(ubicaciones_map.values())
        if len(ubicaciones_list) < 2:
            return
        
        num_traslados = int(len(equipos_list) * 0.3)
        selected_equipos = random.sample(equipos_list, min(num_traslados, len(equipos_list)))
        responsables_list = list(responsables_map.values())
        traslados_created = 0
        
        with transaction.atomic():
            for equipo_data in selected_equipos:
                equipo = equipo_data['equipo']
                current_date = equipo_data['fecha_adq']
                current_ubicacion = equipo.ubicacion
                
                for _ in range(random.randint(1, 3)):
                    fecha_traslado = self.random_date(current_date, datetime(2025, 11, 30))
                    available_ubicaciones = [u for u in ubicaciones_list if u != current_ubicacion]
                    if not available_ubicaciones:
                        break
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
                
                if info_metro.requiere_mantenimiento and info_metro.frecuencia_mantenimiento:
                    mantenimientos_created += self.generate_history_entries(
                        equipo, fecha_adq, self.parse_frequency(info_metro.frecuencia_mantenimiento), 'preventivo', 'Mantenimiento'
                    )
                
                if info_metro.requiere_calibracion and info_metro.frecuencia_calibracion:
                    mantenimientos_created += self.generate_history_entries(
                        equipo, fecha_adq, self.parse_frequency(info_metro.frecuencia_calibracion), 'calibracion', 'Calibración'
                    )
                
                if info_metro.requiere_calificacion and info_metro.frecuencia_calificacion:
                    mantenimientos_created += self.generate_history_entries(
                        equipo, fecha_adq, self.parse_frequency(info_metro.frecuencia_calificacion), 'calificacion', 'Calificación'
                    )
        
        self.stdout.write(f'  Generated {mantenimientos_created} maintenance records')
        
        # Ensure at least 2 equipments have pending maintenance this month (Nov 2025)
        self.ensure_pending_maintenance_this_month(equipos_list)

    def ensure_pending_maintenance_this_month(self, equipos_list):
        """Force at least 2 equipments to have maintenance due in Nov 2025"""
        candidates = [e for e in equipos_list if e['info_metro'].requiere_mantenimiento]
        if len(candidates) < 2:
            return
            
        selected = random.sample(candidates, 2)
        target_month = datetime(2025, 11, 1)
        
        self.stdout.write('\nForcing pending maintenance for 2 equipments:')
        for item in selected:
            equipo = item['equipo']
            info = item['info_metro']
            
            # Set next maintenance to a random day in Nov 2025
            day = random.randint(1, 28)
            next_date = target_month.replace(day=day).date()
            
            info.proximo_mantenimiento = next_date
            
            # Calculate last maintenance based on frequency to make it consistent
            freq = self.parse_frequency(info.frecuencia_mantenimiento)
            if freq > 0:
                last_date = next_date - timedelta(days=30*freq)
                info.ultimo_mantenimiento = last_date
            
            info.save()
            self.stdout.write(f'  - {equipo.nombre_equipo} ({equipo.codigo_interno}): Next Maint = {next_date}')

    def generate_history_entries(self, equipo, fecha_inicio, months_interval, tipo_mant, descripcion_base):
        """Generate periodic history entries"""
        if months_interval <= 0:
            return 0
        
        count = 0
        # Limit history to recent times to avoid too many records
        limit_date = datetime(2024, 1, 1)
        if isinstance(fecha_inicio, date) and not isinstance(fecha_inicio, datetime):
            fecha_inicio = datetime.combine(fecha_inicio, datetime.min.time())
            
        current_date = max(fecha_inicio, limit_date)
        end_date = datetime(2025, 11, 30)
        
        while current_date <= end_date:
            fecha_mant = current_date + timedelta(days=random.randint(-15, 15))
            if fecha_mant > end_date:
                break
            
            HistorialMantenimiento.objects.create(
                equipo=equipo,
                tipo_mantenimiento=tipo_mant,
                mes_mantenimiento=fecha_mant.month,
                anio_mantenimiento=fecha_mant.year,
                realizado_por='Proveedor Externo' if random.random() > 0.3 else 'Personal Interno',
                descripcion=f'{descripcion_base} programado',
                costo=Decimal(random.randint(100000, 2000000)),
                usuario_registro='Sistema'
            )
            count += 1
            current_date = current_date + timedelta(days=30 * months_interval)
            
            # Update last dates
            if count > 0 and hasattr(equipo, 'informacion_metrologica'):
                info = equipo.informacion_metrologica
                last_date = fecha_mant.date() if isinstance(fecha_mant, datetime) else fecha_mant
                if tipo_mant == 'preventivo':
                    info.ultimo_mantenimiento = last_date
                elif tipo_mant == 'calibracion':
                    info.ultima_calibracion = last_date
                elif tipo_mant == 'calificacion':
                    info.ultima_calificacion = last_date
                info.save()
        
        return count

    # Helper methods
    def get_value(self, row, column_name, default=None):
        if not column_name:
            return default
        try:
            if column_name in row.index and pd.notna(row[column_name]):
                val = str(row[column_name]).strip()
                return val if val and val not in ['nan', 'NaN', ''] else default
        except:
            pass
        return default

    def find_column(self, df, possible_names):
        for col in df.columns:
            col_str = str(col).strip()
            if col_str in possible_names:
                return col
            if col_str.upper() in [n.upper() for n in possible_names]:
                return col
            for name in possible_names:
                if name.upper() in col_str.upper():
                    return col
        return None

    def parse_int(self, value, default=0):
        try:
            if value:
                return int(float(str(value).replace(',', '').replace('.', '')))
        except:
            pass
        return default

    def parse_decimal(self, value, default=Decimal('0')):
        try:
            if value:
                return Decimal(str(value).replace(',', '').replace('$', '').strip())
        except:
            pass
        return default

    def parse_bool(self, value):
        if not value:
            return False
        val_str = str(value).strip().upper()
        return val_str in ['SI', 'SÍ', 'YES', 'TRUE', '1', 'X']

    def parse_date(self, value, default):
        if not value:
            return default
        try:
            if isinstance(value, (date, datetime)):
                return value
            return pd.to_datetime(value).to_pydatetime()
        except:
            return default

    def parse_frequency(self, freq_str):
        if not freq_str:
            return 0
        match = re.search(r'(\d+)', freq_str)
        if match:
            return int(match.group(1))
        if 'semestral' in freq_str.lower():
            return 6
        elif 'trimestral' in freq_str.lower():
            return 3
        elif 'mensual' in freq_str.lower():
            return 1
        elif 'anual' in freq_str.lower() or 'año' in freq_str.lower():
            return 12
        return 12

    def random_date(self, start, end):
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
