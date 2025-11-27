from rest_framework import serializers
from .models import HistorialTraslado

class HistorialTrasladoSerializer(serializers.ModelSerializer):
    equipo_codigo = serializers.CharField(source='equipo.codigo_interno', read_only=True)
    equipo_nombre = serializers.CharField(source='equipo.nombre_equipo', read_only=True)
    equipo_marca = serializers.CharField(source='equipo.marca', read_only=True)
    equipo_modelo = serializers.CharField(source='equipo.modelo', read_only=True)
    
    sede_origen_nombre = serializers.CharField(source='sede_origen.nombre', read_only=True)
    servicio_origen_nombre = serializers.CharField(source='servicio_origen.nombre', read_only=True)
    
    sede_destino_nombre = serializers.CharField(source='sede_destino.nombre', read_only=True)
    servicio_destino_nombre = serializers.CharField(source='servicio_destino.nombre', read_only=True)
    
    class Meta:
        model = HistorialTraslado
        fields = '__all__'