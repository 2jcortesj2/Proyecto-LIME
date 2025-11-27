from rest_framework import serializers
from .models import (
    Equipo, RegistroAdquisicion, DocumentacionEquipo,
    InformacionMetrologica, CondicionesFuncionamiento
)
from sedes.serializers import SedeSerializer
from servicios.serializers import ServicioSerializer
from historial_traslados.models import HistorialTraslado
from historial_mantenimientos.models import HistorialMantenimiento

class HistorialTrasladoSerializer(serializers.ModelSerializer):
    sede_origen_nombre = serializers.CharField(source='sede_origen.nombre', read_only=True)
    sede_destino_nombre = serializers.CharField(source='sede_destino.nombre', read_only=True)
    servicio_origen_nombre = serializers.CharField(source='servicio_origen.nombre', read_only=True)
    servicio_destino_nombre = serializers.CharField(source='servicio_destino.nombre', read_only=True)
    fecha_display = serializers.SerializerMethodField()

    class Meta:
        model = HistorialTraslado
        fields = '__all__'
    
    def get_fecha_display(self, obj):
        if obj.fecha_traslado:
            return obj.fecha_traslado.strftime('%d/%m/%Y')
        return 'N/A'

class HistorialMantenimientoSerializer(serializers.ModelSerializer):
    fecha_display = serializers.ReadOnlyField()
    
    class Meta:
        model = HistorialMantenimiento
        fields = '__all__'

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
    responsable_email = serializers.CharField(source='responsable.email', read_only=True)
    
    registro_adquisicion = RegistroAdquisicionSerializer(read_only=True)
    documentacion = DocumentacionEquipoSerializer(read_only=True)
    informacion_metrologica = InformacionMetrologicaSerializer(read_only=True)
    condiciones_funcionamiento = CondicionesFuncionamientoSerializer(read_only=True)
    
    traslados = HistorialTrasladoSerializer(many=True, read_only=True)
    mantenimientos = HistorialMantenimientoSerializer(many=True, read_only=True)
    
    class Meta:
        model = Equipo
        fields = '__all__'

class EquipoListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para listados"""
    sede = SedeSerializer(read_only=True)
    servicio = ServicioSerializer(read_only=True)
    responsable_nombre = serializers.CharField(source='responsable.nombre_completo', read_only=True)
    responsable_email = serializers.CharField(source='responsable.email', read_only=True)
    registro_adquisicion = RegistroAdquisicionSerializer(read_only=True)
    informacion_metrologica = InformacionMetrologicaSerializer(read_only=True)
    
    class Meta:
        model = Equipo
        fields = [
            'id', 'codigo_interno', 'nombre_equipo', 
            'marca', 'modelo', 'serie', 
            'registro_invima', 'clasificacion_riesgo',
            'sede', 'servicio', 'responsable', 'responsable_nombre', 'responsable_email',
            'estado', 'registro_adquisicion', 'informacion_metrologica'
        ]