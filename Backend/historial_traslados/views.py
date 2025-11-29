from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import HistorialTraslado
from .serializers import HistorialTrasladoSerializer
from equipos.models import Equipo

@api_view(['GET', 'POST'])
def traslado_list(request):
    """
    GET: Lista todos los traslados
    POST: Registra un nuevo traslado
    """
    if request.method == 'GET':
        equipo_id = request.GET.get('equipo_id', None)
        
        if equipo_id:
            traslados = HistorialTraslado.objects.select_related(
                'equipo', 'sede_origen', 'sede_destino',
                'servicio_origen', 'servicio_destino'
            ).filter(equipo_id=equipo_id)
        else:
            traslados = HistorialTraslado.objects.select_related(
                'equipo', 'sede_origen', 'sede_destino',
                'servicio_origen', 'servicio_destino'
            ).all()
            
        # Filtros de fecha (mes y año)
        mes = request.GET.get('mes', None)
        anio = request.GET.get('anio', None)
        
        if mes and mes != 'todos':
            traslados = traslados.filter(fecha_traslado__month=mes)
        if anio:
            traslados = traslados.filter(fecha_traslado__year=anio)
        
        serializer = HistorialTrasladoSerializer(traslados, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = HistorialTrasladoSerializer(data=request.data)
        if serializer.is_valid():
            # Guardar el traslado
            traslado = serializer.save()
            
            # Actualizar la ubicación del equipo
            equipo = traslado.equipo
            equipo.sede = traslado.sede_destino
            equipo.servicio = traslado.servicio_destino
            equipo.save()
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def traslado_por_equipo(request, equipo_id):
    """Obtiene el historial de traslados de un equipo específico"""
    traslados = HistorialTraslado.objects.select_related(
        'equipo', 'sede_origen', 'sede_destino',
        'servicio_origen', 'servicio_destino'
    ).filter(equipo_id=equipo_id)
    serializer = HistorialTrasladoSerializer(traslados, many=True)
    return Response(serializer.data)