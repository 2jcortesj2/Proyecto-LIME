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
                'ubicacion_origen', 'ubicacion_destino', 'responsable_registro'
            ).filter(equipo_id=equipo_id)
        else:
            traslados = HistorialTraslado.objects.select_related(
                'equipo', 'sede_origen', 'sede_destino',
                'ubicacion_origen', 'ubicacion_destino', 'responsable_registro'
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
            equipo.ubicacion = traslado.ubicacion_destino
            equipo.save()
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def traslado_por_equipo(request, equipo_id):
    """Obtiene el historial de traslados de un equipo específico"""
    traslados = HistorialTraslado.objects.select_related(
        'equipo', 'sede_origen', 'sede_destino',
        'ubicacion_origen', 'ubicacion_destino', 'responsable_registro'
    ).filter(equipo_id=equipo_id)
    serializer = HistorialTrasladoSerializer(traslados, many=True)
    return Response(serializer.data)

@api_view(['GET', 'PUT', 'DELETE'])
def traslado_detail(request, pk):
    """
    GET: Obtiene un traslado específico
    PUT: Actualiza un traslado
    DELETE: Elimina un traslado
    """
    try:
        traslado = HistorialTraslado.objects.select_related(
            'equipo', 'sede_origen', 'sede_destino',
            'ubicacion_origen', 'ubicacion_destino', 'responsable_registro'
        ).get(pk=pk)
    except HistorialTraslado.DoesNotExist:
        return Response({'error': 'Traslado no encontrado'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = HistorialTrasladoSerializer(traslado)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        serializer = HistorialTrasladoSerializer(traslado, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        traslado.delete()
        return Response({'message': 'Traslado eliminado correctamente'}, status=status.HTTP_204_NO_CONTENT)