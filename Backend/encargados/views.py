from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import make_password, check_password
from .models import Encargado
from .serializers import EncargadoSerializer

@api_view(['GET', 'POST'])
def encargado_list(request):
    """GET: list all encargados
    POST: create a new encargado"""
    if request.method == 'GET':
        encargados = Encargado.objects.all()
        sede_id = request.GET.get('sede_id')
        rol = request.GET.get('rol')
        if sede_id:
            encargados = encargados.filter(sede_id=sede_id)
        if rol:
            encargados = encargados.filter(rol=rol)
        serializer = EncargadoSerializer(encargados, many=True)
        return Response(serializer.data)
    elif request.method == 'POST':
        data = request.data.copy()
        if 'password_hash' in data:
            data['password_hash'] = make_password(data['password_hash'])
        serializer = EncargadoSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def encargado_detail(request, pk):
    """GET: retrieve an encargado
    PUT: update an encargado
    DELETE: deactivate an encargado"""
    try:
        encargado = Encargado.objects.get(pk=pk)
    except Encargado.DoesNotExist:
        return Response({'error': 'Encargado no encontrado'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = EncargadoSerializer(encargado)
        return Response(serializer.data)
    elif request.method == 'PUT':
        data = request.data.copy()
        if 'password_hash' in data and data['password_hash']:
            data['password_hash'] = make_password(data['password_hash'])
        else:
            data.pop('password_hash', None)
        serializer = EncargadoSerializer(encargado, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == 'DELETE':
        encargado.estado = False
        encargado.save()
        return Response({'message': 'Encargado desactivado correctamente'}, status=status.HTTP_200_OK)

@api_view(['POST'])
def encargado_login(request):
    """Verify login credentials for an encargado"""
    email = request.data.get('email')
    password = request.data.get('password')
    if not email or not password:
        return Response({'error': 'Email y contraseña son requeridos'}, status=status.HTTP_400_BAD_REQUEST)
    try:
        encargado = Encargado.objects.get(email=email, estado=True)
        if check_password(password, encargado.password_hash):
            serializer = EncargadoSerializer(encargado)
            return Response({'message': 'Login exitoso', 'encargado': serializer.data})
        else:
            return Response({'error': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)
    except Encargado.DoesNotExist:
        return Response({'error': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['GET'])
def encargados_por_sede(request, sede_id):
    """Get encargados for a specific sede"""
    encargados = Encargado.objects.filter(sede_id=sede_id, estado=True)
    serializer = EncargadoSerializer(encargados, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def encargados_tecnicos(request):
    """Get encargados with role 'tecnico'"""
    encargados = Encargado.objects.filter(rol='tecnico', estado=True)
    serializer = EncargadoSerializer(encargados, many=True)
    return Response(serializer.data)
