from rest_framework import serializers
from .models import HistorialTraslado

class HistorialTrasladoSerializer(serializers.ModelSerializer):
    equipo_codigo = serializers.CharField(source='equipo.codigo_inventario', read_only=True)
    sede_origen_nombre = serializers.CharField(source='sede_origen.nombre', read_only=True)
    sede_destino_nombre = serializers.CharField(source='sede_destino.nombre', read_only=True)
    
    class Meta:
        model = HistorialTraslado
        fields = '__all__'