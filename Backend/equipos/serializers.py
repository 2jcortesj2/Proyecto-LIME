from rest_framework import serializers
from .models import (
    Equipo, RegistroAdquisicion, DocumentacionEquipo,
    InformacionMetrologica, CondicionesFuncionamiento
)
from sedes.serializers import SedeSerializer
from servicios.serializers import ServicioSerializer

class RegistroAdquisicionSerializer(serializers.ModelSerializer):
    class Meta:
        model = RegistroAdquisicion
        fields = '__all__'

class DocumentacionEquipoSerializer(serializers.ModelSerializer):
    class Meta:
        model = DocumentacionEquipo
        fields = '__all__'

class InformacionMetrologicaSerializer(serializers.ModelSerializer):
    estado_mantenimiento = serializers.ReadOnlyField()
    fecha_proximo_mantenimiento_calculada = serializers.ReadOnlyField()

    class Meta:
        model = InformacionMetrologica
        fields = '__all__'

class CondicionesFuncionamientoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CondicionesFuncionamiento
        fields = '__all__'

class EquipoSerializer(serializers.ModelSerializer):
    sede_info = SedeSerializer(source='sede', read_only=True)
    servicio_info = ServicioSerializer(source='servicio', read_only=True)
    responsable_nombre = serializers.CharField(source='responsable.nombre_completo', read_only=True)
    
    registro_adquisicion = RegistroAdquisicionSerializer(read_only=True)
    documentacion = DocumentacionEquipoSerializer(read_only=True)
    informacion_metrologica = InformacionMetrologicaSerializer(read_only=True)
    condiciones_funcionamiento = CondicionesFuncionamientoSerializer(read_only=True)
    
    class Meta:
        model = Equipo
        fields = '__all__'

class EquipoListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para listados"""
    sede = SedeSerializer(read_only=True)
    servicio = ServicioSerializer(read_only=True)
    responsable_nombre = serializers.CharField(source='responsable.nombre_completo', read_only=True)
    registro_adquisicion = RegistroAdquisicionSerializer(read_only=True)
    informacion_metrologica = InformacionMetrologicaSerializer(read_only=True)
    
    class Meta:
        model = Equipo
        fields = [
            'id', 'codigo_interno', 'nombre_equipo', 
            'marca', 'modelo', 'serie', 
            'registro_invima', 'clasificacion_riesgo',
            'sede', 'servicio', 'responsable', 'responsable_nombre',
            'estado', 'registro_adquisicion', 'informacion_metrologica'
        ]