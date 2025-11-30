import os
import django
import random

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

from equipos.models import Equipo, CondicionesFuncionamiento
from sedes.models import Sede
from ubicaciones.models import Ubicacion
from responsables.models import Responsable

# Create additional responsables
responsables_data = [
    {"nombre_completo": "Juan Pérez", "email": "juan.perez@example.com", "rol": "Ingeniero Biomédico"},
    {"nombre_completo": "María García", "email": "maria.garcia@example.com", "rol": "Técnico de Mantenimiento"},
    {"nombre_completo": "Carlos Rodríguez", "email": "carlos.rodriguez@example.com", "rol": "Jefe de Laboratorio"},
    {"nombre_completo": "Ana Martínez", "email": "ana.martinez@example.com", "rol": "Coordinador de Equipos"},
    {"nombre_completo": "Luis Hernández", "email": "luis.hernandez@example.com", "rol": "Especialista en Calibración"},
]

print("Creating additional Responsables...")
for resp_data in responsables_data:
    resp, created = Responsable.objects.get_or_create(
        email=resp_data["email"],
        defaults=resp_data
    )
    print(f"  {'Created' if created else 'Found'}: {resp.nombre_completo}")

# Get all sedes and ubicaciones
sedes = list(Sede.objects.all())
ubicaciones = list(Ubicacion.objects.all())
responsables = list(Responsable.objects.all())

print(f"\nRedistributing {Equipo.objects.count()} equipos across {len(sedes)} sedes and {len(ubicaciones)} ubicaciones...")

# Redistribute existing equipment
equipos = Equipo.objects.all()
for equipo in equipos:
    # Randomly assign sede and ubicacion
    ubicacion = random.choice(ubicaciones)
    equipo.sede = ubicacion.sede
    equipo.ubicacion = ubicacion
    
    # Randomly assign responsable
    equipo.responsable = random.choice(responsables)
    
    equipo.save()

# Ensure at least 1 inactive with decommissioning reason
inactive_count = Equipo.objects.filter(estado='Inactivo').count()
if inactive_count == 0:
    # Make one equipment inactive
    equipo = Equipo.objects.filter(estado='Activo').first()
    if equipo:
        equipo.estado = 'Inactivo'
        equipo.save()
        
        # Add decommissioning reason
        if hasattr(equipo, 'condiciones_funcionamiento'):
            cond = equipo.condiciones_funcionamiento
            razones = [
                'Equipo obsoleto - Reemplazado por tecnología más moderna',
                'Daño irreparable - Costo de reparación excede valor del equipo',
                'Fuera de servicio - No cumple con normativas vigentes',
                'Baja por antigüedad - Superó vida útil estimada',
                'Equipo descontinuado - Sin soporte técnico del fabricante'
            ]
            cond.otros = f'MOTIVO DE BAJA: {random.choice(razones)}'
            cond.save()
        print(f"  Made '{equipo.nombre_equipo}' inactive with decommissioning reason")

print("\n✅ Distribution complete!")
print(f"  - Sedes: {Sede.objects.count()}")
print(f"  - Ubicaciones: {Ubicacion.objects.count()}")
print(f"  - Responsables: {Responsable.objects.count()}")
print(f"  - Equipos: {Equipo.objects.count()}")
print(f"    - Activos: {Equipo.objects.filter(estado='Activo').count()}")
print(f"    - Inactivos: {Equipo.objects.filter(estado='Inactivo').count()}")
