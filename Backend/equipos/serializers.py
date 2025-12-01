from rest_framework import serializers
from .models import (
    Equipo, RegistroAdquisicion, DocumentacionEquipo,
    InformacionMetrologica, CondicionesFuncionamiento
)
from sedes.serializers import SedeSerializer, SedeSimpleSerializer
from ubicaciones.serializers import UbicacionSerializer
from historial_traslados.models import HistorialTraslado
from historial_mantenimientos.models import HistorialMantenimiento

class HistorialTrasladoSerializer(serializers.ModelSerializer):
    sede_origen_nombre = serializers.CharField(source='sede_origen.nombre', read_only=True)
    sede_destino_nombre = serializers.CharField(source='sede_destino.nombre', read_only=True)
    ubicacion_origen_nombre = serializers.CharField(source='ubicacion_origen.nombre', read_only=True)
    ubicacion_destino_nombre = serializers.CharField(source='ubicacion_destino.nombre', read_only=True)
    responsable_nombre = serializers.CharField(source='responsable_registro.nombre_completo', read_only=True)
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
        extra_kwargs = {'equipo': {'read_only': True}}

class DocumentacionEquipoSerializer(serializers.ModelSerializer):
    class Meta:
        model = DocumentacionEquipo
        fields = '__all__'
        extra_kwargs = {'equipo': {'read_only': True}}

class InformacionMetrologicaSerializer(serializers.ModelSerializer):
    estado_mantenimiento = serializers.ReadOnlyField()
    fecha_proximo_mantenimiento_calculada = serializers.ReadOnlyField()

    class Meta:
        model = InformacionMetrologica
        fields = '__all__'
        extra_kwargs = {'equipo': {'read_only': True}}

class CondicionesFuncionamientoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CondicionesFuncionamiento
        fields = '__all__'
        extra_kwargs = {'equipo': {'read_only': True}}

class EquipoSerializer(serializers.ModelSerializer):
    sede_info = SedeSimpleSerializer(source='sede', read_only=True)
    ubicacion_info = UbicacionSerializer(source='ubicacion', read_only=True)
    responsable_nombre = serializers.CharField(source='responsable.nombre_completo', read_only=True)
    responsable_email = serializers.CharField(source='responsable.email', read_only=True)
    
    # Nested serializers are now writable and optional
    registro_adquisicion = RegistroAdquisicionSerializer(required=False)
    documentacion = DocumentacionEquipoSerializer(required=False)
    informacion_metrologica = InformacionMetrologicaSerializer(required=False)
    condiciones_funcionamiento = CondicionesFuncionamientoSerializer(required=False)
    
    traslados = HistorialTrasladoSerializer(many=True, read_only=True)
    mantenimientos = HistorialMantenimientoSerializer(many=True, read_only=True)
    
    class Meta:
        model = Equipo
        fields = '__all__'

    def create(self, validated_data):
        # Extract nested data
        adquisicion_data = validated_data.pop('registro_adquisicion', None)
        documentacion_data = validated_data.pop('documentacion', None)
        metrologica_data = validated_data.pop('informacion_metrologica', None)
        condiciones_data = validated_data.pop('condiciones_funcionamiento', None)

        # Create Equipo instance
        equipo = Equipo.objects.create(**validated_data)

        # Create related objects if data is present
        if adquisicion_data:
            RegistroAdquisicion.objects.create(equipo=equipo, **adquisicion_data)
        if documentacion_data:
            DocumentacionEquipo.objects.create(equipo=equipo, **documentacion_data)
        if metrologica_data:
            InformacionMetrologica.objects.create(equipo=equipo, **metrologica_data)
        if condiciones_data:
            CondicionesFuncionamiento.objects.create(equipo=equipo, **condiciones_data)

        return equipo

    def update(self, instance, validated_data):
        # Extract nested data
        adquisicion_data = validated_data.pop('registro_adquisicion', None)
        documentacion_data = validated_data.pop('documentacion', None)
        metrologica_data = validated_data.pop('informacion_metrologica', None)
        condiciones_data = validated_data.pop('condiciones_funcionamiento', None)

        # Update Equipo instance
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # Helper function to update or create related objects
        def update_or_create_related(model, related_name, data):
            if data is not None:
                related_instance = getattr(instance, related_name, None)
                if related_instance:
                    for attr, value in data.items():
                        setattr(related_instance, attr, value)
                    related_instance.save()
                else:
                    model.objects.create(equipo=instance, **data)

        # Update related objects
        update_or_create_related(RegistroAdquisicion, 'registro_adquisicion', adquisicion_data)
        update_or_create_related(DocumentacionEquipo, 'documentacion', documentacion_data)
        update_or_create_related(InformacionMetrologica, 'informacion_metrologica', metrologica_data)
        update_or_create_related(CondicionesFuncionamiento, 'condiciones_funcionamiento', condiciones_data)

        return instance

class EquipoListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para listados"""
    sede = SedeSimpleSerializer(read_only=True)
    ubicacion = UbicacionSerializer(read_only=True)
    responsable_nombre = serializers.CharField(source='responsable.nombre_completo', read_only=True)
    responsable_email = serializers.CharField(source='responsable.email', read_only=True)
    registro_adquisicion = RegistroAdquisicionSerializer(read_only=True)
    informacion_metrologica = InformacionMetrologicaSerializer(read_only=True)
    
    class Meta:
        model = Equipo
        fields = [
            'id', 'proceso', 'codigo_interno', 'nombre_equipo', 
            'marca', 'modelo', 'serie', 
            'registro_invima', 'clasificacion_riesgo',
            'sede', 'ubicacion', 'responsable', 'responsable_nombre', 'responsable_email',
            'estado', 'registro_adquisicion', 'informacion_metrologica'
        ]