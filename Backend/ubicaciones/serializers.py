from rest_framework import serializers
from .models import Ubicacion
from sedes.models import Sede

class UbicacionSerializer(serializers.ModelSerializer):
    sede_nombre = serializers.CharField(source='sede.nombre', read_only=True)
    
    class Meta:
        model = Ubicacion
        fields = ['id', 'nombre', 'sede', 'sede_nombre', 'estado']
        
class UbicacionDetailSerializer(serializers.ModelSerializer):
    sede = serializers.SerializerMethodField()
    
    class Meta:
        model = Ubicacion
        fields = ['id', 'nombre', 'sede', 'estado']
    
    def get_sede(self, obj):
        return {
            'id': obj.sede.id,
            'nombre': obj.sede.nombre,
            'ciudad': obj.sede.ciudad,
        }
