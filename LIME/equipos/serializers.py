from rest_framework import serializers
from .models import Equipo
from sedes.serializers import SedeSerializer
from servicios.serializers import ServicioSerializer

class EquipoSerializer(serializers.ModelSerializer):
    sede_info = SedeSerializer(source='sede', read_only=True)
    servicio_info = ServicioSerializer(source='servicio', read_only=True)
    
    class Meta:
        model = Equipo
        fields = '__all__'

class EquipoListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para listados"""
    sede_nombre = serializers.CharField(source='sede.nombre', read_only=True)
    servicio_nombre = serializers.CharField(source='servicio.nombre', read_only=True)
    
    class Meta:
        model = Equipo
        fields = [
            'id', 'codigo_inventario', 'nombre_equipo', 
            'marca', 'modelo', 'serie', 'estado',
            'sede_nombre', 'servicio_nombre', 'responsable'
        ]