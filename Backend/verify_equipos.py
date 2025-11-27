from equipos.models import Equipo
from datetime import date
from dateutil.relativedelta import relativedelta

# Get all active equipment
equipos = Equipo.objects.filter(estado='Activo')

# Filter equipment that requires maintenance
con_requiere = [e for e in equipos if hasattr(e, 'informacion_metrologica') 
                and e.informacion_metrologica 
                and e.informacion_metrologica.requiere_mantenimiento]

print(f'==== ANÁLISIS DE EQUIPOS PENDIENTES ====')
print(f'Total equipos activos: {equipos.count()}')
print(f'Con requiere_mantenimiento=True: {len(con_requiere)}')
print()

# VENCIDOS (overdue)
vencidos = [e for e in con_requiere if e.informacion_metrologica.estado_mantenimiento == "Vencido"]
print(f'VENCIDOS (Realizar revisión): {len(vencidos)}')
for e in vencidos:
    print(f'  - {e.codigo_interno} | {e.nombre_equipo} | Próximo: {e.informacion_metrologica.fecha_proximo_mantenimiento_calculada}')
print()

# PRÓXIMOS (upcoming within 3 months)
proximos = [e for e in con_requiere if e.informacion_metrologica.estado_mantenimiento == "Próximo"]
print(f'PRÓXIMOS (Próximos a revisión en 3 meses): {len(proximos)}')
for e in proximos:
    print(f'  - {e.codigo_interno} | {e.nombre_equipo} | Próximo: {e.informacion_metrologica.fecha_proximo_mantenimiento_calculada}')
print()

# NORMALES (more than 3 months away)
normales = [e for e in con_requiere if e.informacion_metrologica.estado_mantenimiento == "Normal"]
print(f'NORMALES (Mantenimiento Programado +3 meses): {len(normales)}')
for e in normales:
    print(f'  - {e.codigo_interno} | {e.nombre_equipo} | Próximo: {e.informacion_metrologica.fecha_proximo_mantenimiento_calculada}')
print()

# NO PROGRAMADOS (requires maintenance but no date set)
no_programados = [e for e in con_requiere if e.informacion_metrologica.estado_mantenimiento == "No Programado"]
print(f'NO PROGRAMADOS (requiere=True pero sin fecha): {len(no_programados)}')
for e in no_programados:
    print(f'  - {e.codigo_interno} | {e.nombre_equipo}')
