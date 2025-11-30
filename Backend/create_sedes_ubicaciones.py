import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

from sedes.models import Sede
from ubicaciones.models import Ubicacion

# Create 4 sedes as mentioned by user
sedes_data = [
    {"nombre": "Sede Centro", "ciudad": "Bogotá", "direccion": "Calle 10 #5-20", "telefono": "6012345678"},
    {"nombre": "Sede Norte", "ciudad": "Bogotá", "direccion": "Carrera 15 #100-50", "telefono": "6012345679"},
    {"nombre": "Sede Sur", "ciudad": "Bogotá", "direccion": "Calle 45 Sur #30-10", "telefono": "6012345680"},
    {"nombre": "Sede Occidente", "ciudad": "Bogotá", "direccion": "Avenida 68 #40-30", "telefono": "6012345681"},
]

ubicaciones_data = [
    # Sede Centro
    ("Laboratorio de Química", "Sede Centro"),
    ("Laboratorio de Física", "Sede Centro"),
    ("Sala de Equipos Biomédicos", "Sede Centro"),
    ("Almacén General", "Sede Centro"),
    
    # Sede Norte
    ("Laboratorio de Microbiología", "Sede Norte"),
    ("Laboratorio de Investigación", "Sede Norte"),
    ("Área de Gases Medicinales", "Sede Norte"),
    
    # Sede Sur
    ("Laboratorio de Análisis", "Sede Sur"),
    ("Taller de Mantenimiento", "Sede Sur"),
    ("Bodega de Equipos", "Sede Sur"),
    
    # Sede Occidente
    ("Laboratorio de Docencia", "Sede Occidente"),
    ("Centro de Calibración", "Sede Occidente"),
    ("Servicios Generales", "Sede Occidente"),
]

print("Creating Sedes...")
sedes_map = {}
for sede_data in sedes_data:
    sede, created = Sede.objects.get_or_create(
        nombre=sede_data["nombre"],
        defaults=sede_data
    )
    sedes_map[sede.nombre] = sede
    print(f"  {'Created' if created else 'Found'}: {sede.nombre}")

print("\nCreating Ubicaciones...")
for ubicacion_nombre, sede_nombre in ubicaciones_data:
    sede = sedes_map[sede_nombre]
    ubicacion, created = Ubicacion.objects.get_or_create(
        nombre=ubicacion_nombre,
        sede=sede,
        defaults={"estado": True}
    )
    print(f"  {'Created' if created else 'Found'}: {ubicacion_nombre} @ {sede_nombre}")

print(f"\n✅ Setup complete!")
print(f"  - Sedes: {Sede.objects.count()}")
print(f"  - Ubicaciones: {Ubicacion.objects.count()}")
