from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import make_password, check_password
from .models import Usuario
from .serializers import UsuarioSerializer

@api_view(['GET', 'POST'])
def usuario_list(request):
    """
    GET: Lista todos los encargados/usuarios
    POST: Crea un nuevo encargado
    """
    if request.method == 'GET':
        usuarios = Usuario.objects.all()
        
        sede_id = request.GET.get('sede_id', None)
        rol = request.GET.get('rol', None)
        
        if sede_id:
            usuarios = usuarios.filter(sede_id=sede_id)
        if rol:
            usuarios = usuarios.filter(rol=rol)
            
        serializer = UsuarioSerializer(usuarios, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        data = request.data.copy()
        # Encriptar la contraseña antes de guardar
        if 'password_hash' in data:
            data['password_hash'] = make_password(data['password_hash'])
        
        serializer = UsuarioSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def usuario_detail(request, pk):
    """
    GET: Obtiene un encargado específico
    PUT: Actualiza un encargado
    DELETE: Desactiva un encargado
    """
    try:
        usuario = Usuario.objects.get(pk=pk)
    except Usuario.DoesNotExist:
        return Response({'error': 'Encargado no encontrado'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = UsuarioSerializer(usuario)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        data = request.data.copy()
        # Si se está actualizando la contraseña, encriptarla
        if 'password_hash' in data and data['password_hash']:
            data['password_hash'] = make_password(data['password_hash'])
        else:
            # Si no se envía contraseña, mantener la actual
            data.pop('password_hash', None)
        
        serializer = UsuarioSerializer(usuario, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        usuario.estado = False
        usuario.save()
        return Response({'message': 'Encargado desactivado correctamente'}, status=status.HTTP_200_OK)

@api_view(['POST'])
def usuario_login(request):
    """Verifica las credenciales de un encargado"""
    email = request.data.get('email')
    password = request.data.get('password')
    
    if not email or not password:
        return Response(
            {'error': 'Email y contraseña son requeridos'}, 
            status=status.HTTP_400_BAD_REQUEST
        )
    
    try:
        usuario = Usuario.objects.get(email=email, estado=True)
        if check_password(password, usuario.password_hash):
            serializer = UsuarioSerializer(usuario)
            return Response({
                'message': 'Login exitoso',
                'usuario': serializer.data
            })
        else:
            return Response(
                {'error': 'Credenciales inválidas'}, 
                status=status.HTTP_401_UNAUTHORIZED
            )
    except Usuario.DoesNotExist:
        return Response(
            {'error': 'Credenciales inválidas'}, 
            status=status.HTTP_401_UNAUTHORIZED
        )

@api_view(['GET'])
def encargados_por_sede(request, sede_id):
    """Obtiene los encargados de una sede específica"""
    usuarios = Usuario.objects.filter(sede_id=sede_id, estado=True)
    serializer = UsuarioSerializer(usuarios, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def encargados_tecnicos(request):
    """Obtiene solo los encargados con rol técnico"""
    usuarios = Usuario.objects.filter(rol='tecnico', estado=True)
    serializer = UsuarioSerializer(usuarios, many=True)
    return Response(serializer.data)