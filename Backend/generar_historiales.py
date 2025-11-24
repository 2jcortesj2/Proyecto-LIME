"""
Script para generar historiales de mantenimiento y traslados para los equipos
- Genera historiales de mantenimiento solo para equipos que requieren mantenimiento
- Borra historiales de equipos que NO requieren mantenimiento
- Genera historiales de traslados para todos los equipos
"""

import os
import django
import random
from datetime import datetime, timedelta
from decimal import Decimal

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'lime_project.settings')
django.setup()

from equipos.models import Equipo, HistorialMantenimiento, HistorialTraslado
from sedes.models import Sede, Servicio
from responsables.models import Responsable

def generar_fecha_aleatoria(inicio, fin):
    """Genera una fecha aleatoria entre dos fechas"""
    delta = fin - inicio
    random_days = random.randint(0, delta.days)
    return inicio + timedelta(days=random_days)

def generar_historiales_mantenimiento():
    """Genera historiales de mantenimiento para equipos que lo requieren"""
    print("\n=== GENERANDO HISTORIALES DE MANTENIMIENTO ===")
    
    equipos = Equipo.objects.all()
    
    tipos_mantenimiento = ['preventivo', 'correctivo', 'calibracion']
    empresas = [
        'Biomedical Services S.A.S',
        'TecnoMed Colombia',
        'Servicio Técnico Especializado',
        'Mantenimiento Hospitalario Ltda',
        'Calibraciones y Servicios',
        'Interno - Ingeniería Biomédica'
    ]
    
    for equipo in equipos:
        # Verificar si el equipo requiere mantenimiento
        requiere_mant = False
        if hasattr(equipo, 'informacion_metrologica') and equipo.informacion_metrologica:
            requiere_mant = equipo.informacion_metrologica.requiere_mantenimiento
        
        if requiere_mant:
            # Borrar historiales existentes
            HistorialMantenimiento.objects.filter(equipo=equipo).delete()
            
            # Generar entre 3 y 8 registros de mantenimiento
            num_registros = random.randint(3, 8)
            
            fecha_inicio = datetime(2020, 1, 1).date()
            fecha_fin = datetime.now().date()
            
            for i in range(num_registros):
                fecha_mant = generar_fecha_aleatoria(fecha_inicio, fecha_fin)
                tipo = random.choice(tipos_mantenimiento)
                empresa = random.choice(empresas)
                
                # Generar costo realista
                if tipo == 'preventivo':
                    costo = Decimal(random.randint(150000, 500000))
                elif tipo == 'correctivo':
                    costo = Decimal(random.randint(300000, 1500000))
                else:  # calibracion
                    costo = Decimal(random.randint(200000, 800000))
                
                # Generar descripción según el tipo
                descripciones = {
                    'preventivo': [
                        'Mantenimiento preventivo programado',
                        'Revisión general y limpieza',
                        'Verificación de funcionamiento',
                        'Lubricación y ajustes',
                        'Inspección técnica preventiva'
                    ],
                    'correctivo': [
                        'Reparación de falla en sistema',
                        'Cambio de componente defectuoso',
                        'Corrección de error operativo',
                        'Reemplazo de pieza dañada',
                        'Solución de problema técnico'
                    ],
                    'calibracion': [
                        'Calibración según norma ISO',
                        'Verificación metrológica',
                        'Ajuste de parámetros',
                        'Calibración con patrones certificados',
                        'Verificación de exactitud'
                    ]
                }
                
                observaciones_lista = [
                    'Equipo funcionando correctamente',
                    'Se realizaron ajustes menores',
                    'Requiere seguimiento en próximo mantenimiento',
                    'Equipo en óptimas condiciones',
                    'Se recomienda revisión en 6 meses',
                    'Componentes en buen estado',
                    None  # Algunos sin observaciones
                ]
                
                HistorialMantenimiento.objects.create(
                    equipo=equipo,
                    fecha_mantenimiento=fecha_mant,
                    tipo_mantenimiento=tipo,
                    realizado_por=empresa,
                    descripcion=random.choice(descripciones[tipo]),
                    costo=costo,
                    observaciones=random.choice(observaciones_lista)
                )
            
            print(f"✓ {equipo.codigo_interno}: {num_registros} mantenimientos generados")
        else:
            # Borrar historiales si no requiere mantenimiento
            deleted = HistorialMantenimiento.objects.filter(equipo=equipo).delete()
            if deleted[0] > 0:
                print(f"✗ {equipo.codigo_interno}: Historiales borrados (no requiere mantenimiento)")

def generar_historiales_traslados():
    """Genera historiales de traslados para todos los equipos"""
    print("\n=== GENERANDO HISTORIALES DE TRASLADOS ===")
    
    equipos = Equipo.objects.all()
    sedes = list(Sede.objects.all())
    servicios = list(Servicio.objects.all())
    responsables = list(Responsable.objects.all())
    
    if not sedes or not servicios:
        print("⚠ No hay sedes o servicios en la base de datos")
        return
    
    justificaciones = [
        'Reubicación por necesidad del servicio',
        'Optimización de recursos',
        'Ampliación de servicio',
        'Reorganización administrativa',
        'Mejora en la distribución de equipos',
        'Solicitud del área',
        'Cambio de ubicación física',
        'Traslado temporal por mantenimiento',
        'Redistribución de equipos',
        'Actualización de inventario'
    ]
    
    for equipo in equipos:
        # Borrar traslados existentes
        HistorialTraslado.objects.filter(equipo=equipo).delete()
        
        # Generar entre 1 y 5 traslados
        num_traslados = random.randint(1, 5)
        
        fecha_inicio = datetime(2020, 1, 1).date()
        fecha_fin = datetime.now().date()
        
        # Obtener ubicación actual del equipo
        sede_actual = equipo.sede
        servicio_actual = equipo.servicio
        
        for i in range(num_traslados):
            fecha_traslado = generar_fecha_aleatoria(fecha_inicio, fecha_fin)
            
            # Seleccionar origen (puede ser la ubicación actual o una aleatoria)
            if i == 0:
                sede_origen = random.choice(sedes)
                servicio_origen = random.choice(servicios)
            else:
                sede_origen = sede_destino
                servicio_origen = servicio_destino
            
            # Seleccionar destino diferente al origen
            sede_destino = random.choice([s for s in sedes if s != sede_origen])
            servicio_destino = random.choice([s for s in servicios if s != servicio_origen])
            
            # El último traslado debe llevar al equipo a su ubicación actual
            if i == num_traslados - 1 and sede_actual and servicio_actual:
                sede_destino = sede_actual
                servicio_destino = servicio_actual
            
            usuario = random.choice(responsables) if responsables else None
            
            HistorialTraslado.objects.create(
                equipo=equipo,
                fecha_traslado=fecha_traslado,
                sede_origen=sede_origen,
                servicio_origen=servicio_origen,
                sede_destino=sede_destino,
                servicio_destino=servicio_destino,
                justificacion=random.choice(justificaciones),
                usuario_registro=usuario.nombre if usuario else 'Sistema'
            )
        
        print(f"✓ {equipo.codigo_interno}: {num_traslados} traslados generados")

def main():
    print("=" * 60)
    print("GENERACIÓN DE HISTORIALES PARA EQUIPOS")
    print("=" * 60)
    
    total_equipos = Equipo.objects.count()
    print(f"\nTotal de equipos en la base de datos: {total_equipos}")
    
    # Generar historiales
    generar_historiales_mantenimiento()
    generar_historiales_traslados()
    
    # Estadísticas finales
    print("\n" + "=" * 60)
    print("ESTADÍSTICAS FINALES")
    print("=" * 60)
    
    total_mantenimientos = HistorialMantenimiento.objects.count()
    total_traslados = HistorialTraslado.objects.count()
    
    equipos_con_mant = Equipo.objects.filter(
        informacion_metrologica__requiere_mantenimiento=True
    ).count()
    
    print(f"\nEquipos que requieren mantenimiento: {equipos_con_mant}")
    print(f"Total de registros de mantenimiento: {total_mantenimientos}")
    print(f"Total de registros de traslados: {total_traslados}")
    print(f"Promedio de mantenimientos por equipo: {total_mantenimientos / equipos_con_mant if equipos_con_mant > 0 else 0:.1f}")
    print(f"Promedio de traslados por equipo: {total_traslados / total_equipos if total_equipos > 0 else 0:.1f}")
    
    print("\n✅ Proceso completado exitosamente!")

if __name__ == '__main__':
    main()
