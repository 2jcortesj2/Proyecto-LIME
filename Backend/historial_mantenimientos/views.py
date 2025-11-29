from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import HistorialMantenimiento
from .serializers import HistorialMantenimientoSerializer
from equipos.models import Equipo
from datetime import datetime, date
from dateutil.relativedelta import relativedelta
from django.db.models import Q

@api_view(['GET', 'POST'])
def mantenimiento_list(request):
    """
    GET: Lista todos los mantenimientos
    POST: Registra un nuevo mantenimiento
    """
    if request.method == 'GET':
        equipo_id = request.GET.get('equipo_id', None)
        tipo = request.GET.get('tipo', None)
        
        mantenimientos = HistorialMantenimiento.objects.select_related(
            'equipo__sede', 'equipo__servicio', 'equipo__responsable',
            'equipo__registro_adquisicion', 'equipo__informacion_metrologica'
        ).all()
        
        if equipo_id:
            mantenimientos = mantenimientos.filter(equipo_id=equipo_id)
        if tipo:
            mantenimientos = mantenimientos.filter(tipo_mantenimiento=tipo)
        
        serializer = HistorialMantenimientoSerializer(mantenimientos, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = HistorialMantenimientoSerializer(data=request.data)
        if serializer.is_valid():
            # Guardar el mantenimiento
            mantenimiento = serializer.save()
            
            # Actualizar el equipo (Información Metrológica)
            equipo = mantenimiento.equipo
            
            # Asegurar que existe la relación
            if hasattr(equipo, 'informacion_metrologica'):
                metrologia = equipo.informacion_metrologica
                
                # Crear fecha temporal para cálculos (día 1 del mes)
                fecha_temp = date(
                    mantenimiento.anio_mantenimiento,
                    mantenimiento.mes_mantenimiento,
                    1
                )
                
                metrologia.ultimo_mantenimiento = fecha_temp
                
                # Calcular próximo mantenimiento según frecuencia
                if metrologia.frecuencia_mantenimiento:
                    frecuencia = metrologia.frecuencia_mantenimiento.lower()
                    
                    if 'anual' in frecuencia or '1 vez por año' in frecuencia:
                        metrologia.proximo_mantenimiento = fecha_temp + relativedelta(years=1)
                    elif 'semestral' in frecuencia or '2 veces por año' in frecuencia:
                        metrologia.proximo_mantenimiento = fecha_temp + relativedelta(months=6)
                    elif 'trimestral' in frecuencia or '4 veces por año' in frecuencia:
                        metrologia.proximo_mantenimiento = fecha_temp + relativedelta(months=3)
                    elif 'mensual' in frecuencia:
                        metrologia.proximo_mantenimiento = fecha_temp + relativedelta(months=1)
                
                metrologia.save()
                # También guardamos equipo por si acaso se tocó algo allí
                equipo.save()
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def mantenimiento_detail(request, pk):
    """Obtiene un mantenimiento específico"""
    try:
        mantenimiento = HistorialMantenimiento.objects.get(pk=pk)
        serializer = HistorialMantenimientoSerializer(mantenimiento)
        return Response(serializer.data)
    except HistorialMantenimiento.DoesNotExist:
        return Response({'error': 'Mantenimiento no encontrado'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def mantenimiento_por_equipo(request, equipo_id):
    """Obtiene el historial de mantenimientos de un equipo específico"""
    mantenimientos = HistorialMantenimiento.objects.select_related(
        'equipo__sede', 'equipo__servicio', 'equipo__responsable',
        'equipo__registro_adquisicion', 'equipo__informacion_metrologica'
    ).filter(equipo_id=equipo_id)
    serializer = HistorialMantenimientoSerializer(mantenimientos, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def mantenimientos_recientes(request):
    """Obtiene los mantenimientos de los últimos 3 meses"""
    hoy = date.today()
    hace_3_meses = hoy - relativedelta(months=3)
    
    # Filtrar por año y mes
    mantenimientos = HistorialMantenimiento.objects.select_related(
        'equipo__sede', 'equipo__servicio', 'equipo__responsable',
        'equipo__registro_adquisicion', 'equipo__informacion_metrologica'
    ).filter(
        Q(anio_mantenimiento__gt=hace_3_meses.year) |
        Q(anio_mantenimiento=hace_3_meses.year, mes_mantenimiento__gte=hace_3_meses.month)
    ).order_by('-anio_mantenimiento', '-mes_mantenimiento')
    
    serializer = HistorialMantenimientoSerializer(mantenimientos, many=True)
    return Response(serializer.data)