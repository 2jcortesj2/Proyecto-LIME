from rest_framework import serializers
from .models import HistorialMantenimiento
from equipos.serializers import EquipoListSerializer

class HistorialMantenimientoSerializer(serializers.ModelSerializer):
    equipo = EquipoListSerializer(read_only=True)
    equipo_id = serializers.PrimaryKeyRelatedField(
        queryset=HistorialMantenimiento.objects.all(),
        source='equipo',
        write_only=True
    )
    fecha_display = serializers.CharField(read_only=True)
    
    class Meta:
        model = HistorialMantenimiento
        fields = [
            'id', 'equipo', 'equipo_id', 'tipo_mantenimiento',
            'mes_mantenimiento', 'anio_mantenimiento', 'descripcion',
            'realizado_por', 'costo', 'usuario_registro', 'observaciones',
            'created_at', 'fecha_display'
        ]
        read_only_fields = ['created_at']
    
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