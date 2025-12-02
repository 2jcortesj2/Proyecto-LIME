"""
Script para verificar la consistencia del historial de traslados.
Verifica que:
1. La secuencia de traslados tenga sentido (destino de traslado N = origen de traslado N+1)
2. El último traslado coincida con la ubicación actual del equipo
3. No haya traslados ilógicos (misma ubicación, fechas incorrectas, etc.)
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
from datetime import datetime

def verificar_consistencia_traslados():
    print("=" * 80)
    print("VERIFICACIÓN DE CONSISTENCIA DEL HISTORIAL DE TRASLADOS")
    print("=" * 80)
    print()
    
    equipos = Equipo.objects.all()
    total_equipos = equipos.count()
    equipos_con_problemas = []
    problemas_encontrados = {
        'secuencia_inconsistente': [],
        'ubicacion_final_no_coincide': [],
        'traslado_mismo_lugar': [],
        'fechas_futuras': [],
        'fechas_desordenadas': []
    }
    
    print(f"Analizando {total_equipos} equipos...")
    print()
    
    for equipo in equipos:
        traslados = equipo.traslados.order_by('fecha_traslado').all()
        num_traslados = traslados.count()
        
        if num_traslados == 0:
            continue
        
        tiene_problemas = False
        
        # 1. Verificar consistencia de secuencia
        for i in range(len(traslados) - 1):
            traslado_actual = traslados[i]
            traslado_siguiente = traslados[i + 1]
            
            # El destino del traslado actual debería ser el origen del siguiente
            if traslado_actual.sede_destino != traslado_siguiente.sede_origen:
                tiene_problemas = True
                problemas_encontrados['secuencia_inconsistente'].append({
                    'equipo': equipo,
                    'traslado_1': traslado_actual,
                    'traslado_2': traslado_siguiente,
                    'problema': f"Sede destino ({traslado_actual.sede_destino}) != Sede origen siguiente ({traslado_siguiente.sede_origen})"
                })
            
            if traslado_actual.ubicacion_destino != traslado_siguiente.ubicacion_origen:
                tiene_problemas = True
                problemas_encontrados['secuencia_inconsistente'].append({
                    'equipo': equipo,
                    'traslado_1': traslado_actual,
                    'traslado_2': traslado_siguiente,
                    'problema': f"Ubicación destino ({traslado_actual.ubicacion_destino}) != Ubicación origen siguiente ({traslado_siguiente.ubicacion_origen})"
                })
        
        # 2. Verificar que el último traslado coincida con la ubicación actual del equipo
        ultimo_traslado = traslados.last()
        if ultimo_traslado.sede_destino != equipo.sede:
            tiene_problemas = True
            problemas_encontrados['ubicacion_final_no_coincide'].append({
                'equipo': equipo,
                'traslado': ultimo_traslado,
                'problema': f"Sede destino traslado ({ultimo_traslado.sede_destino}) != Sede actual equipo ({equipo.sede})"
            })
        
        if ultimo_traslado.ubicacion_destino != equipo.ubicacion:
            tiene_problemas = True
            problemas_encontrados['ubicacion_final_no_coincide'].append({
                'equipo': equipo,
                'traslado': ultimo_traslado,
                'problema': f"Ubicación destino traslado ({ultimo_traslado.ubicacion_destino}) != Ubicación actual equipo ({equipo.ubicacion})"
            })
        
        # 3. Verificar traslados al mismo lugar
        for traslado in traslados:
            if traslado.sede_origen == traslado.sede_destino and traslado.ubicacion_origen == traslado.ubicacion_destino:
                tiene_problemas = True
                problemas_encontrados['traslado_mismo_lugar'].append({
                    'equipo': equipo,
                    'traslado': traslado,
                    'problema': f"Traslado del mismo lugar al mismo lugar: {traslado.ubicacion_origen}"
                })
        
        # 4. Verificar fechas futuras
        ahora = datetime.now().date()
        for traslado in traslados:
            if traslado.fecha_traslado.date() > ahora:
                tiene_problemas = True
                problemas_encontrados['fechas_futuras'].append({
                    'equipo': equipo,
                    'traslado': traslado,
                    'problema': f"Fecha de traslado en el futuro: {traslado.fecha_traslado}"
                })
        
        # 5. Verificar que las fechas estén en orden
        for i in range(len(traslados) - 1):
            if traslados[i].fecha_traslado >= traslados[i + 1].fecha_traslado:
                tiene_problemas = True
                problemas_encontrados['fechas_desordenadas'].append({
                    'equipo': equipo,
                    'traslado_1': traslados[i],
                    'traslado_2': traslados[i + 1],
                    'problema': f"Fecha 1 ({traslados[i].fecha_traslado}) >= Fecha 2 ({traslados[i + 1].fecha_traslado})"
                })
        
        if tiene_problemas:
            equipos_con_problemas.append(equipo)
    
    # Mostrar resultados
    print("=" * 80)
    print("RESULTADOS DE LA VERIFICACIÓN")
    print("=" * 80)
    print()
    
    total_problemas = sum(len(v) for v in problemas_encontrados.values())
    
    if total_problemas == 0:
        print("✓ ✓ ✓  NO SE ENCONTRARON PROBLEMAS DE CONSISTENCIA  ✓ ✓ ✓")
        print()
        print("El historial de traslados es completamente consistente:")
        print("  - Todas las secuencias de traslados son lógicas")
        print("  - Todos los equipos están en su ubicación correcta según el último traslado")
        print("  - No hay traslados al mismo lugar")
        print("  - No hay fechas futuras o desordenadas")
    else:
        print(f"⚠️  SE ENCONTRARON {total_problemas} PROBLEMAS DE CONSISTENCIA")
        print(f"   Equipos afectados: {len(equipos_con_problemas)}/{total_equipos}")
        print()
        
        # Mostrar cada tipo de problema
        if problemas_encontrados['secuencia_inconsistente']:
            print(f"\n1. SECUENCIA INCONSISTENTE ({len(problemas_encontrados['secuencia_inconsistente'])} problemas):")
            print("-" * 80)
            for p in problemas_encontrados['secuencia_inconsistente'][:5]:
                print(f"\n   Equipo: {p['equipo'].codigo_interno} - {p['equipo'].nombre_equipo}")
                print(f"   Traslado 1: {p['traslado_1'].fecha_traslado}")
                print(f"   Traslado 2: {p['traslado_2'].fecha_traslado}")
                print(f"   Problema: {p['problema']}")
            if len(problemas_encontrados['secuencia_inconsistente']) > 5:
                print(f"\n   ... y {len(problemas_encontrados['secuencia_inconsistente']) - 5} más")
        
        if problemas_encontrados['ubicacion_final_no_coincide']:
            print(f"\n2. UBICACIÓN FINAL NO COINCIDE ({len(problemas_encontrados['ubicacion_final_no_coincide'])} problemas):")
            print("-" * 80)
            for p in problemas_encontrados['ubicacion_final_no_coincide'][:5]:
                print(f"\n   Equipo: {p['equipo'].codigo_interno} - {p['equipo'].nombre_equipo}")
                print(f"   Último traslado: {p['traslado'].fecha_traslado}")
                print(f"   Problema: {p['problema']}")
            if len(problemas_encontrados['ubicacion_final_no_coincide']) > 5:
                print(f"\n   ... y {len(problemas_encontrados['ubicacion_final_no_coincide']) - 5} más")
        
        if problemas_encontrados['traslado_mismo_lugar']:
            print(f"\n3. TRASLADOS AL MISMO LUGAR ({len(problemas_encontrados['traslado_mismo_lugar'])} problemas):")
            print("-" * 80)
            for p in problemas_encontrados['traslado_mismo_lugar'][:5]:
                print(f"\n   Equipo: {p['equipo'].codigo_interno} - {p['equipo'].nombre_equipo}")
                print(f"   Fecha: {p['traslado'].fecha_traslado}")
                print(f"   Problema: {p['problema']}")
            if len(problemas_encontrados['traslado_mismo_lugar']) > 5:
                print(f"\n   ... y {len(problemas_encontrados['traslado_mismo_lugar']) - 5} más")
        
        if problemas_encontrados['fechas_futuras']:
            print(f"\n4. FECHAS FUTURAS ({len(problemas_encontrados['fechas_futuras'])} problemas):")
            print("-" * 80)
            for p in problemas_encontrados['fechas_futuras'][:5]:
                print(f"\n   Equipo: {p['equipo'].codigo_interno} - {p['equipo'].nombre_equipo}")
                print(f"   Problema: {p['problema']}")
            if len(problemas_encontrados['fechas_futuras']) > 5:
                print(f"\n   ... y {len(problemas_encontrados['fechas_futuras']) - 5} más")
        
        if problemas_encontrados['fechas_desordenadas']:
            print(f"\n5. FECHAS DESORDENADAS ({len(problemas_encontrados['fechas_desordenadas'])} problemas):")
            print("-" * 80)
            for p in problemas_encontrados['fechas_desordenadas'][:5]:
                print(f"\n   Equipo: {p['equipo'].codigo_interno} - {p['equipo'].nombre_equipo}")
                print(f"   Problema: {p['problema']}")
            if len(problemas_encontrados['fechas_desordenadas']) > 5:
                print(f"\n   ... y {len(problemas_encontrados['fechas_desordenadas']) - 5} más")
    
    print()
    print("=" * 80)
    print("RESUMEN FINAL")
    print("=" * 80)
    print(f"Total de equipos analizados: {total_equipos}")
    print(f"Equipos con traslados: {Equipo.objects.filter(traslados__isnull=False).distinct().count()}")
    print(f"Equipos con problemas: {len(equipos_con_problemas)}")
    print(f"Total de problemas encontrados: {total_problemas}")
    print("=" * 80)

if __name__ == "__main__":
    verificar_consistencia_traslados()
