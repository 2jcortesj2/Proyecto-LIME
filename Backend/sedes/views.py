from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Sede
from .serializers import SedeSerializer

@api_view(['GET', 'POST'])
def sede_list(request):
    """
    GET: Lista todas las sedes
    POST: Crea una nueva sede
    """
    if request.method == 'GET':
        sedes = Sede.objects.all()
        serializer = SedeSerializer(sedes, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = SedeSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def sede_detail(request, pk):
    """
    GET: Obtiene una sede específica
    PUT: Actualiza una sede
    DELETE: Elimina una sede (soft delete)
    """
    try:
        sede = Sede.objects.get(pk=pk)
    except Sede.DoesNotExist:
        return Response({'error': 'Sede no encontrada'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = SedeSerializer(sede)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        serializer = SedeSerializer(sede, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        # Soft delete - solo cambiamos el estado
        sede.estado = False
        sede.save()
        return Response({'message': 'Sede desactivada correctamente'}, status=status.HTTP_200_OK)

@api_view(['GET'])
def sede_active(request):
    """Obtiene solo las sedes activas"""
    sedes = Sede.objects.filter(estado=True)
    serializer = SedeSerializer(sedes, many=True)
    return Response(serializer.data)