from rest_framework import serializers
from .models import Servicio
from sedes.serializers import SedeSerializer

class ServicioSimpleSerializer(serializers.ModelSerializer):
    """Serializer ligero para listados y selects"""
    class Meta:
        model = Servicio
        fields = ['id', 'nombre', 'responsable']

class ServicioSerializer(serializers.ModelSerializer):
    sede_info = SedeSerializer(source='sede', read_only=True)
    
    class Meta:
        model = Servicio
        fields = '__all__'