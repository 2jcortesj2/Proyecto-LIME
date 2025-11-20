from rest_framework import serializers
from .models import Usuario
from sedes.serializers import SedeSerializer

class UsuarioSerializer(serializers.ModelSerializer):
    sede_info = SedeSerializer(source='sede', read_only=True)
    sede_nombre = serializers.CharField(source='sede.nombre', read_only=True)
    
    class Meta:
        model = Usuario
        fields = '__all__'
        extra_kwargs = {
            'password_hash': {'write_only': True}  # No mostrar la contraseña en las respuestas
        }

class UsuarioListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para listados"""
    sede_nombre = serializers.CharField(source='sede.nombre', read_only=True)
    
    class Meta:
        model = Usuario
        fields = ['id', 'nombre_completo', 'email', 'rol', 'sede_nombre', 'estado']