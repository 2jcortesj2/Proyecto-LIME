from rest_framework import serializers
from .models import HistorialMantenimiento

class HistorialMantenimientoSerializer(serializers.ModelSerializer):
    equipo_codigo = serializers.CharField(source='equipo.codigo_interno', read_only=True)
    equipo_nombre = serializers.CharField(source='equipo.nombre_equipo', read_only=True)
    fecha_display = serializers.CharField(read_only=True)
    
    class Meta:
        model = HistorialMantenimiento
        fields = '__all__'
    
    def validate(self, data):
        """Validación adicional para mes y año"""
        mes = data.get('mes_mantenimiento')
        anio = data.get('anio_mantenimiento')
        
        if mes and (mes < 1 or mes > 12):
            raise serializers.ValidationError({
                'mes_mantenimiento': 'El mes debe estar entre 1 y 12'
            })
        
        if anio and anio < 1900:
            raise serializers.ValidationError({
                'anio_mantenimiento': 'El año debe ser mayor a 1900'
            })
        
        return data