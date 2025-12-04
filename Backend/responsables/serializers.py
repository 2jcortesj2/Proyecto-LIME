from rest_framework import serializers
from .models import Responsable

class ResponsableSerializer(serializers.ModelSerializer):
    equipos_asignados_count = serializers.IntegerField(read_only=True)

    class Meta:
        model = Responsable
        fields = ['id', 'nombre_completo', 'email', 'telefono', 'rol', 'equipos_asignados_count']

class ResponsableListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Responsable
        fields = ['id', 'nombre_completo', 'email', 'rol']
