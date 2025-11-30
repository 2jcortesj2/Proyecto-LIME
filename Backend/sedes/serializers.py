from rest_framework import serializers
from .models import Sede
from ubicaciones.models import Ubicacion

class SedeUbicacionSerializer(serializers.ModelSerializer):
    num_equipos = serializers.SerializerMethodField()
    responsable = serializers.CharField(source='responsable.nombre_completo', read_only=True)
    
    class Meta:
        model = Ubicacion
        fields = ['id', 'nombre', 'responsable', 'num_equipos']
        
    def get_num_equipos(self, obj):
        return obj.equipos.count()

class SedeSimpleSerializer(serializers.ModelSerializer):
    """Serializer ligero para listados y selects"""
    class Meta:
        model = Sede
        fields = ['id', 'nombre', 'ciudad']

class SedeSerializer(serializers.ModelSerializer):
    ubicaciones = SedeUbicacionSerializer(many=True, read_only=True)
    total_ubicaciones = serializers.SerializerMethodField()
    total_equipos = serializers.SerializerMethodField()
    
    class Meta:
        model = Sede
        fields = ['id', 'nombre', 'direccion', 'ciudad', 'telefono', 'estado', 'ubicaciones', 'total_ubicaciones', 'total_equipos']
        
    def get_total_ubicaciones(self, obj):
        return obj.ubicaciones.count()
        
    def get_total_equipos(self, obj):
        return obj.equipos.count()