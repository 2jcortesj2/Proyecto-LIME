from django.db import models
from sedes.models import Sede
from servicios.models import Servicio

class Equipo(models.Model):
    # Información básica
    proceso = models.CharField(max_length=100, blank=True, null=True)
    nombre_equipo = models.CharField(max_length=150)
    codigo_inventario = models.CharField(max_length=50, unique=True, blank=True, null=True)
    marca = models.CharField(max_length=100, blank=True, null=True)
    modelo = models.CharField(max_length=100, blank=True, null=True)
    serie = models.CharField(max_length=100, blank=True, null=True)
    responsable = models.CharField(max_length=150, blank=True, null=True)
    ubicacion_fisica = models.CharField(max_length=150, blank=True, null=True)
    estado = models.CharField(max_length=50, default='Activo')
    
    # Relaciones
    sede = models.ForeignKey(Sede, on_delete=models.CASCADE, related_name='equipos')
    servicio = models.ForeignKey(Servicio, on_delete=models.CASCADE, related_name='equipos')
    
    # Información técnica
    capacidad = models.CharField(max_length=100, blank=True, null=True)
    potencia = models.CharField(max_length=100, blank=True, null=True)
    alimentacion_electrica = models.CharField(max_length=100, blank=True, null=True)
    presion = models.CharField(max_length=100, blank=True, null=True)
    velocidad = models.CharField(max_length=100, blank=True, null=True)
    temperatura = models.CharField(max_length=100, blank=True, null=True)
    humedad = models.CharField(max_length=100, blank=True, null=True)
    flujo = models.CharField(max_length=100, blank=True, null=True)
    rpm = models.CharField(max_length=100, blank=True, null=True)
    voltaje = models.CharField(max_length=50, blank=True, null=True)
    peso = models.CharField(max_length=50, blank=True, null=True)
    dimensiones = models.CharField(max_length=150, blank=True, null=True)
    
    # Clasificación
    clasificacion_biomedica = models.CharField(max_length=100, blank=True, null=True)
    clasificacion_riesgo = models.CharField(max_length=50, blank=True, null=True)
    tecnologia_predominante = models.CharField(max_length=100, blank=True, null=True)
    clasificacion_uso = models.CharField(max_length=100, blank=True, null=True)
    codigo_ips = models.CharField(max_length=100, blank=True, null=True)
    registro_invima = models.CharField(max_length=100, blank=True, null=True)
    
    # Información administrativa
    fecha_adquisicion = models.DateField(blank=True, null=True)
    fecha_instalacion = models.DateField(blank=True, null=True)
    fecha_fin_garantia = models.DateField(blank=True, null=True)
    proveedor = models.CharField(max_length=200, blank=True, null=True)
    forma_adquisicion = models.CharField(max_length=100, blank=True, null=True)
    documento_adquisicion = models.CharField(max_length=100, blank=True, null=True)
    costo_adquisicion = models.DecimalField(max_digits=12, decimal_places=2, blank=True, null=True)
    vida_util = models.IntegerField(blank=True, null=True)
    numero_acta = models.CharField(max_length=100, blank=True, null=True)
    numero_contrato = models.CharField(max_length=100, blank=True, null=True)
    en_garantia = models.BooleanField(default=False)
    
    # Mantenimiento y calibración
    requiere_mantenimiento = models.BooleanField(default=True)
    frecuencia_mantenimiento = models.CharField(max_length=100, blank=True, null=True)
    ultimo_mantenimiento = models.DateField(blank=True, null=True)
    proximo_mantenimiento = models.DateField(blank=True, null=True)
    requiere_calibracion = models.BooleanField(default=False)
    tipo_calibracion = models.CharField(max_length=100, blank=True, null=True)
    periodicidad_calibracion = models.CharField(max_length=100, blank=True, null=True)
    periodicidad_calificacion = models.CharField(max_length=100, blank=True, null=True)
    
    # Metrología técnica
    magnitud = models.CharField(max_length=100, blank=True, null=True)
    rango_equipo = models.CharField(max_length=100, blank=True, null=True)
    rango_trabajo = models.CharField(max_length=100, blank=True, null=True)
    resolucion = models.CharField(max_length=100, blank=True, null=True)
    error_maximo = models.CharField(max_length=100, blank=True, null=True)
    
    # Documentación
    hoja_vida = models.BooleanField(default=False)
    manual_operacion = models.BooleanField(default=False)
    manual_servicio = models.BooleanField(default=False)
    manual_usuario = models.BooleanField(default=False)
    manual_partes = models.BooleanField(default=False)
    manual_despiece = models.BooleanField(default=False)
    planos = models.BooleanField(default=False)
    guia_rapida = models.BooleanField(default=False)
    registro_importacion = models.BooleanField(default=False)
    protocolo_preventivo = models.BooleanField(default=False)
    instructivo_manejo = models.BooleanField(default=False)
    frecuencia_metrologica = models.BooleanField(default=False)
    otros_documentos = models.TextField(blank=True, null=True)
    
    # Información adicional
    accesorios = models.TextField(blank=True, null=True)
    apoyo_tecnico = models.TextField(blank=True, null=True)
    observaciones = models.TextField(blank=True, null=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'equipos'
        verbose_name = 'Equipo'
        verbose_name_plural = 'Equipos'

    def __str__(self):
        return f"{self.codigo_inventario} - {self.nombre_equipo}"