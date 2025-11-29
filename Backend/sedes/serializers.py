from rest_framework import serializers
from .models import Sede
from servicios.models import Servicio

class SedeServicioSerializer(serializers.ModelSerializer):
    num_equipos = serializers.SerializerMethodField()
    
    class Meta:
        model = Servicio
        fields = ['id', 'nombre', 'responsable', 'num_equipos']
        
    def get_num_equipos(self, obj):
        return obj.equipos.count()

class SedeSimpleSerializer(serializers.ModelSerializer):
    """Serializer ligero para listados y selects"""
    class Meta:
        model = Sede
        fields = ['id', 'nombre', 'ciudad']

class SedeSerializer(serializers.ModelSerializer):
    servicios = SedeServicioSerializer(many=True, read_only=True)
    total_servicios = serializers.SerializerMethodField()
    total_equipos = serializers.SerializerMethodField()
    
    class Meta:
        model = Sede
        fields = ['id', 'nombre', 'direccion', 'ciudad', 'telefono', 'estado', 'servicios', 'total_servicios', 'total_equipos']
        
    def get_total_servicios(self, obj):
        return obj.servicios.count()
        
    def get_total_equipos(self, obj):
        return obj.equipos.count()