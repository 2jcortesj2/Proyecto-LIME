from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Servicio
from .serializers import ServicioSerializer

@api_view(['GET', 'POST'])
def servicio_list(request):
    """
    GET: Lista todos los servicios
    POST: Crea un nuevo servicio
    """
    if request.method == 'GET':
        # Permitir filtrado por sede
        sede_id = request.GET.get('sede_id', None)
        if sede_id:
            servicios = Servicio.objects.filter(sede_id=sede_id)
        else:
            servicios = Servicio.objects.all()
        
        serializer = ServicioSerializer(servicios, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = ServicioSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def servicio_detail(request, pk):
    """
    GET: Obtiene un servicio específico
    PUT: Actualiza un servicio
    DELETE: Elimina un servicio
    """
    try:
        servicio = Servicio.objects.get(pk=pk)
    except Servicio.DoesNotExist:
        return Response({'error': 'Servicio no encontrado'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = ServicioSerializer(servicio)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        serializer = ServicioSerializer(servicio, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        servicio.estado = False
        servicio.save()
        return Response({'message': 'Servicio desactivado correctamente'}, status=status.HTTP_200_OK)

@api_view(['GET'])
def servicios_por_sede(request, sede_id):
    """Obtiene servicios de una sede específica"""
    servicios = Servicio.objects.filter(sede_id=sede_id, estado=True)
    serializer = ServicioSerializer(servicios, many=True)
    return Response(serializer.data)