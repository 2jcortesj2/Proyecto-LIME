from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import make_password, check_password
from .models import Responsable
from .serializers import ResponsableSerializer

@api_view(['GET', 'POST'])
def responsable_list(request):
    """GET: list all responsables
    POST: create a new responsable"""
    if request.method == 'GET':
        responsables = Responsable.objects.all()
        sede_id = request.GET.get('sede_id')
        rol = request.GET.get('rol')
        if sede_id:
            responsables = responsables.filter(sede_id=sede_id)
        if rol:
            responsables = responsables.filter(rol=rol)
        serializer = ResponsableSerializer(responsables, many=True)
        return Response(serializer.data)
    elif request.method == 'POST':
        data = request.data.copy()
        if 'password_hash' in data:
            data['password_hash'] = make_password(data['password_hash'])
        serializer = ResponsableSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def responsable_detail(request, pk):
    """GET: retrieve an responsable
    PUT: update an responsable
    DELETE: deactivate an responsable"""
    try:
        responsable = Responsable.objects.get(pk=pk)
    except Responsable.DoesNotExist:
        return Response({'error': 'Responsable no encontrado'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ResponsableSerializer(responsable)
        return Response(serializer.data)
    elif request.method == 'PUT':
        data = request.data.copy()
        if 'password_hash' in data and data['password_hash']:
            data['password_hash'] = make_password(data['password_hash'])
        else:
            data.pop('password_hash', None)
        serializer = ResponsableSerializer(responsable, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == 'DELETE':
        responsable.estado = False
        responsable.save()
        return Response({'message': 'Responsable desactivado correctamente'}, status=status.HTTP_200_OK)

@api_view(['POST'])
def responsable_login(request):
    """Verify login credentials for a responsable"""
    email = request.data.get('email')
    password = request.data.get('password')
    if not email or not password:
        return Response({'error': 'Email y contraseña son requeridos'}, status=status.HTTP_400_BAD_REQUEST)
    try:
        responsable = Responsable.objects.get(email=email, estado=True)
        if check_password(password, responsable.password_hash):
            serializer = ResponsableSerializer(responsable)
            return Response({'message': 'Login exitoso', 'responsable': serializer.data})
        else:
            return Response({'error': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)
    except Responsable.DoesNotExist:
        return Response({'error': 'Credenciales inválidas'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['GET'])
def responsables_por_sede(request, sede_id):
    """Get responsables for a specific sede"""
    responsables = Responsable.objects.filter(sede_id=sede_id, estado=True)
    serializer = ResponsableSerializer(responsables, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def responsables_tecnicos(request):
    """Get responsables with role 'tecnico'"""
    responsables = Responsable.objects.filter(rol='tecnico', estado=True)
    serializer = ResponsableSerializer(responsables, many=True)
    return Response(serializer.data)
