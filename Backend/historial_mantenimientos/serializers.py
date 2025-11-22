from rest_framework import serializers
from .models import HistorialMantenimiento

class HistorialMantenimientoSerializer(serializers.ModelSerializer):
    equipo_codigo = serializers.CharField(source='equipo.codigo_inventario', read_only=True)
    equipo_nombre = serializers.CharField(source='equipo.nombre_equipo', read_only=True)
    
    class Meta:
        model = HistorialMantenimiento
        fields = '__all__'