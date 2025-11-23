from rest_framework import serializers
from .models import Encargado

class EncargadoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Encargado
        fields = ['id', 'nombre_completo', 'email', 'telefono', 'rol']

class EncargadoListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Encargado
        fields = ['id', 'nombre_completo', 'email', 'rol']
