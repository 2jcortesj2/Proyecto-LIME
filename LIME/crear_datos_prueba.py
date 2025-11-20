import os
import django
import sys

# Configurar Django
sys.path.append('.')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

from sedes.models import Sede
from servicios.models import Servicio
from usuarios.models import Usuario
from equipos.models import Equipo
from django.contrib.auth.hashers import make_password
from datetime import date

print("Creando datos de prueba...")

# Crear Sedes
sede1 = Sede.objects.create(
    nombre="Hospital Alma Máter",
    direccion="Carrera 51D #62-29",
    ciudad="Medellín",
    telefono="604-2196000",
    estado=True
)

sede2 = Sede.objects.create(
    nombre="Sede Prado",
    direccion="Calle 50 #41-50",
    ciudad="Medellín",
    telefono="604-2196100",
    estado=True
)

print("✓ Sedes creadas")

# Crear Servicios
servicio1 = Servicio.objects.create(
    nombre="LIME Central",
    sede=sede1,
    descripcion="Laboratorio de Ingeniería de Mantenimiento y Equipos",
    responsable="Dr. Juan Pérez",
    estado=True
)

servicio2 = Servicio.objects.create(
    nombre="UCI",
    sede=sede1,
    descripcion="Unidad de Cuidados Intensivos",
    responsable="Dra. María García",
    estado=True
)

servicio3 = Servicio.objects.create(
    nombre="Procesamiento Sección C",
    sede=sede2,
    descripcion="Área de procesamiento de muestras",
    responsable="Gloria Zapata",
    estado=True
)

print("✓ Servicios creados")

# Crear Usuarios/Encargados
usuario1 = Usuario.objects.create(
    nombre_completo="Gloria Zapata",
    email="gloria.zapata@lime.com",
    password_hash=make_password("password123"),
    rol="tecnico",
    sede=sede2,
    estado=True
)

usuario2 = Usuario.objects.create(
    nombre_completo="Carlos Mendoza",
    email="carlos.mendoza@lime.com",
    password_hash=make_password("password123"),
    rol="admin",
    sede=sede1,
    estado=True
)

print("✓ Usuarios creados")

# Crear Equipos
equipo1 = Equipo.objects.create(
    proceso="LIME",
    nombre_equipo="Congelador",
    codigo_inventario="135306",
    marca="Challenger",
    modelo="CV430",
    serie="9053127",
    responsable="Gloria Zapata",
    ubicacion_fisica="Procesamiento Sección C",
    estado="Activo",
    sede=sede2,
    servicio=servicio3,
    codigo_ips="IND-135306",
    voltaje="115 VAC",
    peso="55.5 kg",
    dimensiones="53.5 x 53 x 142 cm",
    temperatura="Max 38°C",
    requiere_mantenimiento=True,
    frecuencia_mantenimiento="1 vez por año",
    ultimo_mantenimiento=date(2024, 11, 15),
    proximo_mantenimiento=date(2025, 12, 15),
    requiere_calibracion=True,
    tipo_calibracion="Calibración",
    magnitud="Temperatura",
    rango_equipo="T -18",
    rango_trabajo="0 a -33°C",
    fecha_adquisicion=date(2009, 12, 10),
    proveedor="Almacén Navarro Ospina S.A.",
    forma_adquisicion="Compra",
    documento_adquisicion="Factura #47736",
    en_garantia=False,
    hoja_vida=True,
    guia_rapida=False,
    manual_operacion=True
)

equipo2 = Equipo.objects.create(
    proceso="LIME",
    nombre_equipo="Analizador de Gases",
    codigo_inventario="AG-2024-001",
    marca="Siemens",
    modelo="RAPIDPoint 500",
    serie="RP500-2024",
    responsable="Dr. Juan Pérez",
    ubicacion_fisica="UCI - Piso 3",
    estado="Activo",
    sede=sede1,
    servicio=servicio2,
    voltaje="220 VAC",
    requiere_mantenimiento=True,
    frecuencia_mantenimiento="Trimestral",
    requiere_calibracion=True,
    tipo_calibracion="Verificación",
)

print("✓ Equipos creados")

print("\n✅ DATOS DE PRUEBA CREADOS EXITOSAMENTE")
print("\nPuedes acceder a:")
print(f"Admin: http://127.0.0.1:8000/admin/")
print(f"API Sedes: http://127.0.0.1:8000/api/sedes/")
print(f"API Servicios: http://127.0.0.1:8000/api/servicios/")
print(f"API Equipos: http://127.0.0.1:8000/api/equipos/")