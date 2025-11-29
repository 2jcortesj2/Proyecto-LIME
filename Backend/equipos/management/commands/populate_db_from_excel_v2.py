"""
Django management command to populate the database from Excel file.
This command reads the F-147 inventory Excel file and creates all necessary records.
Updated to use ALL data from Excel columns.
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
            # Read Excel with header row 6, then use first data row as actual headers
            df_headers = pd.read_excel(file_path, header=6, nrows=1)
            actual_headers = df_headers.iloc[0].tolist()
            
            # Now read the full data starting from row 8 (skip header rows)
            df = pd.read_excel(file_path, header=7)
            df = df.dropna(how='all')
            
            # Rename columns with the actual headers
            df.columns = actual_headers[:len(df.columns)]
            
            self.stdout.write(self.style.SUCCESS(f'Loaded {len(df)} rows from Excel'))
            self.stdout.write(f'Found columns: Sede={df.columns[0]}, Proceso={df.columns[1]}, ...'))
            
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
        
        # Columns: 0=Sede, 7=Ubicación física
        if 'Sede' in df.columns and 'Ubicación física' in df.columns:
            unique_combinations = df[['Sede', 'Ubicación física']].drop_duplicates()
            
            with transaction.atomic():
                for _, row in unique_combinations.iterrows():
                    if pd.notna(row['Sede']) and pd.notna(row['Ubicación física']):
                        sede_nombre = str(row['Sede']).strip()
                        ubicacion_nombre = str(row['Ubicación física']).strip()
                        
                        # Create or get Sede
                        if sede_nombre not in sedes_map:
                            sede = Sede.objects.create(
                                nombre=sede_nombre,
                                ciudad='Medellín',  # Default for UdeA
                                direccion=f'Universidad de Antioquia - {sede_nombre}',
                                telefono='6042195000',
                                estado=True
                            )
                            sedes_map[sede_nombre] = sede
                            self.stdout.write(f'  ✓ Sede: {sede_nombre}')
                        
                        # Create Ubicacion
                        ubicacion_key = f'{sede_nombre}|{ubicacion_nombre}'
                        if ubicacion_key not in ubicaciones_map:
                            ubicacion = Ubicacion.objects.create(
                                nombre=ubicacion_nombre,
                                sede=sedes_map[sede_nombre],
                                estado=True
                            )
                            ubicaciones_map[ubicacion_key] = ubicacion

        return sedes_map, ubicaciones_map

    def create_responsables(self, df):
        """Create Responsable objects from Excel data"""
        responsables_map = {}
        
        # Column 6: Responsable del proceso
        if 'Responsable del proceso en el que interviene el equipo y/o inventario UdeA' in df.columns:
            resp_col = 'Responsable del proceso en el que interviene el equipo y/o inventario UdeA'
            unique_responsables = df[resp_col].dropna().unique()
            
            with transaction.atomic():
                for nombre in unique_responsables:
                    nombre = str(nombre).strip()
                    if nombre and nombre not in responsables_map:
                        email = f"{nombre.lower().replace(' ', '.')}@udea.edu.co"
                        
                        counter = 1
                        original_email = email
                        while Responsable.objects.filter(email=email).exists():
                            email = f"{original_email.split('@')[0]}{counter}@udea.edu.co"
                            counter += 1
                        
                        resp = Responsable.objects.create(
                            nombre_completo=nombre,
                            email=email,
                            telefono='6042195000',
                            rol='Responsable de Equipo'
                        )
                        responsables_map[nombre] = resp
                        self.stdout.write(f'  ✓ Responsable: {nombre}')
        
        return responsables_map

    def create_equipos(self, df, sedes_map, ubicaciones_map, responsables_map):
        """Create Equipo objects from Excel data"""
        equipos_list = []
        inactive_count = 0
        
        with transaction.atomic():
            for idx, row in df.iterrows():
                try:
                    # Get equipo data from Excel
                    nombre_equipo = self.get_value(row, 'Nombre del equipo', f'Equipo {idx+1}')
                    proceso = self.get_value(row, 'Proceso', 'Otro')
                    
                    # Get sede/ubicacion
                    sede_nombre = self.get_value(row, 'Sede')
                    ubicacion_nombre = self.get_value(row, 'Ubicación física')
                    ubicacion_key = f'{sede_nombre}|{ubicacion_nombre}'
                    
                    sede = sedes_map.get(sede_nombre, list(sedes_map.values())[0] if sedes_map else None)
                    ubicacion = ubicaciones_map.get(ubicacion_key, list(ubicaciones_map.values())[0] if ubicaciones_map else None)
                    
                    # Get responsable
                    resp_nombre = self.get_value(row, 'Responsable del proceso en el que interviene el equipo y/o inventario UdeA')
                    responsable = responsables_map.get(resp_nombre, list(responsables_map.values())[0] if responsables_map else None)
                    
                    # Estado: 1% inactive, force first one to be inactive
                    if idx == 0:
                        estado = 'Inactivo'
                        inactive_count += 1
                    else:
                        estado = 'Inactivo' if random.random() < 0.01 else 'Activo'
                        if estado == 'Inactivo':
                            inactive_count += 1
                    
                    # Create Equipo with Excel data
                    equipo = Equipo.objects.create(
                        proceso=proceso,
                        sede=sede,
                        ubicacion=ubicacion,
                        responsable=responsable,
                        nombre_equipo=nombre_equipo,
                        codigo_interno=self.get_value(row, 'Código de inventario interno del laboratorio y/o asignado por UdeA'),
                        marca=self.get_value(row, 'Marca'),
                        modelo=self.get_value(row, 'Modelo'),
                        serie=self.get_value(row, 'Serie'),
                        clasificacion_ips=self.get_value(row, 'Clasificación IPS (IND-BIO-Gases)', 'IND'),
                        estado=estado,
                        tiempo_vida_util=self.parse_int(self.get_value(row, 'Tiempo de vida útil'), random.randint(5, 15))
                    )
                    
                    # RegistroAdquisicion from Excel
                    fecha_adq_str = self.get_value(row, 'Antigüedad del eq. (F. adquisición)')
                    fecha_adq = self.parse_date(fecha_adq_str, self.random_date(datetime(2015, 1, 1), datetime(2024, 1, 1)))
                    
                    RegistroAdquisicion.objects.create(
                        equipo=equipo,
                        fecha_adquisicion=fecha_adq,
                        propietario=self.get_value(row, 'Propietario del equipo', 'Universidad de Antioquia'),
                        forma_adquisicion=self.get_value(row, 'Forma de adquisición', 'Compra'),
                        valor_compra=self.parse_decimal(self.get_value(row, 'Valor de compra'), Decimal(random.randint(1000000, 50000000)))
                    )
                    
                    # DocumentacionEquipo from Excel
                    DocumentacionEquipo.objects.create(
                        equipo=equipo,
                        hoja_vida=self.parse_bool(self.get_value(row, 'Hoja de vida')),
                        manual_operacion=self.parse_bool(self.get_value(row, 'Manual operación (Esp)')),
                        manual_servicio=self.parse_bool(self.get_value(row, 'Manual servicio mto (Esp)'))
                    )
                    
                    # InformacionMetrologica from Excel
                    req_mant = self.parse_bool(self.get_value(row, 'Mantenimiento Si/No'))
                    req_cal = self.parse_bool(self.get_value(row, 'Calibración Si/No'))
                    freq_mant = self.get_value(row, 'Frecuencia anual mantenimiento')
                    freq_cal = self.get_value(row, 'Frecuencia anual calibración')
                    
                    # If no calibration data in Excel, assign 15% random
                    if not req_cal and random.random() < 0.15:
                        req_cal = True
                        freq_cal = random.choice(['6 meses', '12 meses'])
                    
                    info_metro = InformacionMetrologica.objects.create(
                        equipo=equipo,
                        requiere_mantenimiento=req_mant,
                        frecuencia_mantenimiento=freq_mant if req_mant else None,
                        requiere_calibracion=req_cal,
                        frecuencia_calibracion=freq_cal if req_cal else None,
                        requiere_calificacion=False  # Not in Excel
                    )
                    
                    # CondicionesFuncionamiento from Excel
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
                        voltaje=self.get_value(row, 'Voltaje'),
                        temperatura=self.get_value(row, 'Temperatura'),
                        otros=otros_text or self.get_value(row, 'Otros')
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

    # [... keep generate_traslados, generate_maintenance_history, and helper methods the same as before ...]
    
    def get_value(self, row, column_name, default=None):
        """Safely get value from row"""
        try:
            if column_name in row.index and pd.notna(row[column_name]):
                val = str(row[column_name]).strip()
                return val if val and val not in ['nan', 'NaN', ''] else default
        except:
            pass
        return default
    
    def parse_int(self, value, default=0):
        """Parse integer value"""
        try:
            if value:
                return int(float(str(value).replace(',', '').replace('.', '')))
        except:
            pass
        return default
    
    def parse_decimal(self, value, default=Decimal('0')):
        """Parse decimal value"""
        try:
            if value:
                return Decimal(str(value).replace(',', '').replace('$', '').strip())
        except:
            pass
        return default
    
    def parse_bool(self, value):
        """Parse boolean value"""
        if not value:
            return False
        val_str = str(value).strip().upper()
        return val_str in ['SI', 'SÍ', 'YES', 'TRUE', '1', 'X']
    
    def parse_date(self, value, default):
        """Parse date value"""
        if not value:
            return default
        try:
            if isinstance(value, (date, datetime)):
                return value
            # Try parsing string date
            return pd.to_datetime(value).to_pydatetime()
        except:
            return default
