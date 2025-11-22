from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Configuracion
from .serializers import ConfiguracionSerializer

@api_view(['GET', 'POST'])
def configuracion_detail(request):
    """
    GET: Obtiene la configuración actual (crea una por defecto si no existe)
    POST: Actualiza la configuración
    """
    # Obtener o crear la instancia única
    configuracion = Configuracion.objects.first()
    if not configuracion:
        configuracion = Configuracion.objects.create()
    
    if request.method == 'GET':
        serializer = ConfiguracionSerializer(configuracion)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = ConfiguracionSerializer(configuracion, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
