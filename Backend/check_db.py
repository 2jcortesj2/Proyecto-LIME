import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

from equipos.models import Equipo
from historial_mantenimientos.models import HistorialMantenimiento
from historial_traslados.models import HistorialTraslado
from sedes.models import Sede
from ubicaciones.models import Ubicacion
from responsables.models import Responsable

print("=== Database Statistics ===\n")
print(f"Equipos: {Equipo.objects.count()}")
print(f"  - Activos: {Equipo.objects.filter(estado='Activo').count()}")
print(f"  - Inactivos: {Equipo.objects.filter(estado='Inactivo').count()}")
print(f"  - LIME proceso: {Equipo.objects.filter(proceso='LIME').count()}")
print(f"\nMantenimientos: {HistorialMantenimiento.objects.count()}")
print(f"Traslados: {HistorialTraslado.objects.count()}")
print(f"Sedes: {Sede.objects.count()}")
print(f"Ubicaciones: {Ubicacion.objects.count()}")
print(f"Responsables: {Responsable.objects.count()}")

# Check calibration/qualification
equipos_con_calibracion = Equipo.objects.filter(informacion_metrologica__requiere_calibracion=True).count()
equipos_con_calificacion = Equipo.objects.filter(informacion_metrologica__requiere_calificacion=True).count()
equipos_con_mantenimiento = Equipo.objects.filter(informacion_metrologica__requiere_mantenimiento=True).count()

print(f"\n=== Metrology ===")
print(f"Equipos con Calibración: {equipos_con_calibracion}")
print(f"Equipos con Calificación: {equipos_con_calificacion}")
print(f"Equipos con Mantenimiento: {equipos_con_mantenimiento}")
