"""
Script para verificar inconsistencias entre:
1. La ubicación actual del equipo (equipo.sede, equipo.ubicacion)
2. El historial de traslados
3. Las ubicaciones que aparecen en el historial pero ya no tienen equipos
"""
import os
import django

# Configuración de Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

from equipos.models import Equipo
from historial_traslados.models import HistorialTraslado
from sedes.models import Sede
from ubicaciones.models import Ubicacion
from django.db.models import Count

def verificar_inconsistencias():
    print("=" * 80)
    print("VERIFICACIÓN DE INCONSISTENCIAS - EQUIPOS Y UBICACIONES")
    print("=" * 80)
    print()
    
    # 1. Verificar cuántos equipos dicen estar en cada sede (según el modelo Equipo)
    print("1. EQUIPOS POR SEDE (según campo equipo.sede):")
    print("-" * 80)
    sedes = Sede.objects.annotate(
        num_equipos_directos=Count('equipos')
    ).order_by('-num_equipos_directos')
    
    for sede in sedes:
        print(f"   {sede.nombre}: {sede.num_equipos_directos} equipos")
    print()
    
    # 2. Verificar cuántos equipos dicen estar en cada ubicación (según el modelo Equipo)
    print("2. EQUIPOS POR UBICACIÓN (según campo equipo.ubicacion):")
    print("-" * 80)
    ubicaciones = Ubicacion.objects.select_related('sede').annotate(
        num_equipos_directos=Count('equipos')
    ).order_by('-num_equipos_directos')
    
    for ubicacion in ubicaciones:
        print(f"   {ubicacion.sede.nombre} > {ubicacion.nombre}: {ubicacion.num_equipos_directos} equipos")
    print()
    
    # 3. Verificar ubicaciones que aparecen en historial de traslados pero tienen 0 equipos
    print("3. UBICACIONES EN HISTORIAL DE TRASLADOS CON 0 EQUIPOS ACTUALES:")
    print("-" * 80)
    
    # Obtener todas las ubicaciones que aparecen en traslados
    ubicaciones_en_traslados_origen = set(
        HistorialTraslado.objects.exclude(ubicacion_origen=None)
        .values_list('ubicacion_origen', flat=True)
        .distinct()
    )
    
    ubicaciones_en_traslados_destino = set(
        HistorialTraslado.objects.exclude(ubicacion_destino=None)
        .values_list('ubicacion_destino', flat=True)
        .distinct()
    )
    
    todas_ubicaciones_en_traslados = ubicaciones_en_traslados_origen.union(ubicaciones_en_traslados_destino)
    
    ubicaciones_sin_equipos = []
    for ubicacion_id in todas_ubicaciones_en_traslados:
        try:
            ubicacion = Ubicacion.objects.get(id=ubicacion_id)
            num_equipos = ubicacion.equipos.count()
            if num_equipos == 0:
                ubicaciones_sin_equipos.append(ubicacion)
        except Ubicacion.DoesNotExist:
            print(f"   ⚠️  Ubicación ID {ubicacion_id} en historial pero NO EXISTE en la BD")
    
    print(f"   Ubicaciones con historial pero 0 equipos actuales: {len(ubicaciones_sin_equipos)}")
    for ubicacion in ubicaciones_sin_equipos[:10]:  # Mostrar solo las primeras 10
        print(f"      - {ubicacion.sede.nombre} > {ubicacion.nombre}")
    
    if len(ubicaciones_sin_equipos) > 10:
        print(f"      ... y {len(ubicaciones_sin_equipos) - 10} más")
    print()
    
    # 4. Verificar equipos y su última ubicación según historial vs. ubicación actual
    print("4. COMPARACIÓN: ÚLTIMA UBICACIÓN EN HISTORIAL vs. UBICACIÓN ACTUAL DEL EQUIPO:")
    print("-" * 80)
    
    equipos = Equipo.objects.select_related('sede', 'ubicacion').all()[:20]  # Muestra solo primeros 20
    inconsistencias = []
    
    for equipo in equipos:
        # Obtener el último traslado del equipo
        ultimo_traslado = equipo.traslados.order_by('-fecha_traslado').first()
        
        if ultimo_traslado:
            ubicacion_historica = ultimo_traslado.ubicacion_destino
            ubicacion_actual = equipo.ubicacion
            
            if ubicacion_historica != ubicacion_actual:
                inconsistencias.append({
                    'equipo': equipo,
                    'ubicacion_actual': ubicacion_actual,
                    'ubicacion_historica': ubicacion_historica,
                    'fecha_ultimo_traslado': ultimo_traslado.fecha_traslado
                })
    
    if inconsistencias:
        print(f"   ⚠️  Se encontraron {len(inconsistencias)} inconsistencias:")
        for inc in inconsistencias[:10]:  # Mostrar solo las primeras 10
            print(f"\n      Equipo: {inc['equipo'].codigo_interno} - {inc['equipo'].nombre_equipo}")
            print(f"      Ubicación ACTUAL en BD: {inc['ubicacion_actual']}")
            print(f"      Última ubicación en HISTORIAL: {inc['ubicacion_historica']}")
            print(f"      Fecha último traslado: {inc['fecha_ultimo_traslado']}")
    else:
        print("   ✓ No se encontraron inconsistencias evidentes")
    print()
    
    # 5. Resumen
    print("=" * 80)
    print("RESUMEN:")
    print("=" * 80)
    print(f"Total de sedes: {Sede.objects.count()}")
    print(f"Total de ubicaciones: {Ubicacion.objects.count()}")
    print(f"Total de equipos: {Equipo.objects.count()}")
    print(f"Total de traslados registrados: {HistorialTraslado.objects.count()}")
    print(f"Ubicaciones con historial pero sin equipos actuales: {len(ubicaciones_sin_equipos)}")
    print(f"Equipos con inconsistencia ubicación actual vs. historial: {len(inconsistencias)}")
    print()
    
    # 6. Conclusión
    print("=" * 80)
    print("CONCLUSIÓN:")
    print("=" * 80)
    if len(ubicaciones_sin_equipos) > 0:
        print("✓ CONFIRMADO: Hay ubicaciones que aparecen en el historial de traslados")
        print("  pero actualmente tienen 0 equipos. Esto es NORMAL y ESPERADO, ya que:")
        print("  - El historial muestra DÓNDE ESTUVIERON los equipos en el pasado")
        print("  - La ubicación actual del equipo muestra DÓNDE ESTÁN AHORA")
        print("  - Es normal que equipos se hayan trasladado de una ubicación a otra")
    
    if len(inconsistencias) > 0:
        print("\n⚠️  PROBLEMA ENCONTRADO: Hay equipos cuya ubicación actual NO coincide")
        print("   con su último traslado registrado. Esto puede indicar:")
        print("   - Datos de muestra incorrectos")
        print("   - Falta de sincronización entre traslados y ubicación del equipo")
        print("   - Necesidad de actualizar equipo.sede y equipo.ubicacion al crear traslados")
    else:
        print("\n✓ Los equipos están correctamente sincronizados con su historial")
    print("=" * 80)

if __name__ == "__main__":
    verificar_inconsistencias()
