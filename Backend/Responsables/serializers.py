from rest_framework import serializers
from .models import Responsable

class ResponsableSerializer(serializers.ModelSerializer):
    class Meta:
        model = Responsable
        fields = ['id', 'nombre_completo', 'email', 'telefono', 'rol']

class ResponsableListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Responsable
        fields = ['id', 'nombre_completo', 'email', 'rol']
