from django.db import models
from sedes.models import Sede
from servicios.models import Servicio

class Equipo(models.Model):

    # ---------------------------
    # INFORMACIÓN GENERAL
    # ---------------------------
    sede = models.ForeignKey(Sede, on_delete=models.SET_NULL, null=True, blank=True, related_name='equipos')
    servicio = models.ForeignKey(Servicio, on_delete=models.SET_NULL, null=True, blank=True, related_name='equipos')
    nombre_equipo = models.CharField(max_length=200, null=True, blank=True)

    codigo_interno = models.CharField(max_length=100, null=True, blank=True)
    codigo_ips = models.CharField(max_length=20, null=True, blank=True)
    codigo_ecri = models.CharField(max_length=50, null=True, blank=True)

    responsable = models.CharField(max_length=150, null=True, blank=True)
    ubicacion_fisica = models.CharField(max_length=200, null=True, blank=True)

    marca = models.CharField(max_length=100, null=True, blank=True)
    modelo = models.CharField(max_length=100, null=True, blank=True)
    serie = models.CharField(max_length=100, null=True, blank=True)

    CLASIF_MISIONAL_CHOICES = [
        ("Docencia", "Docencia"),
        ("Investigación", "Investigación"),
        ("Extensión", "Extensión"),
        ("Mixto", "Mixto"),
    ]
    clasificacion_misional = models.CharField(
        max_length=20, choices=CLASIF_MISIONAL_CHOICES,
        null=True, blank=True
    )

    CLASIF_IPS_CHOICES = [
        ("IND", "IND"),
        ("BIO", "BIO"),
        ("GASES", "GASES"),
    ]
    clasificacion_ips = models.CharField(
        max_length=10, choices=CLASIF_IPS_CHOICES,
        null=True, blank=True
    )

    CLASIFICACION_RIESGO_CHOICES = [
        ("I", "Clase I"),
        ("IIa", "Clase IIa"),
        ("IIb", "Clase IIb"),
        ("III", "Clase III"),
    ]
    clasificacion_riesgo = models.CharField(
        max_length=10, choices=CLASIFICACION_RIESGO_CHOICES,
        null=True, blank=True
    )

    registro_invima = models.CharField(max_length=100, null=True, blank=True)
    
    tiempo_vida_util = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return f"{self.nombre_equipo} ({self.codigo_interno})"


class RegistroAdquisicion(models.Model):
    equipo = models.OneToOneField(Equipo, on_delete=models.CASCADE, related_name='registro_adquisicion')
    fecha_adquisicion = models.DateField(null=True, blank=True)
    fecha_fabricacion = models.DateField(null=True, blank=True)
    propietario = models.CharField(max_length=100, null=True, blank=True)
    
    nit_proveedor = models.CharField(max_length=20, null=True, blank=True)
    nombre_proveedor = models.CharField(max_length=150, null=True, blank=True)
    
    en_garantia = models.BooleanField(default=False)
    fecha_fin_garantia = models.DateField(null=True, blank=True)
    
    FORMA_ADQUISICION_CHOICES = [
        ("Compra", "Compra"),
        ("Apoyo Tecnológico", "Apoyo Tecnológico"),
        ("Donación", "Donación"),
        ("Convenio", "Convenio"),
    ]
    forma_adquisicion = models.CharField(
        max_length=50, choices=FORMA_ADQUISICION_CHOICES,
        null=True, blank=True
    )
    
    tipo_documento = models.CharField(max_length=50, null=True, blank=True)
    numero_documento = models.CharField(max_length=50, null=True, blank=True)
    valor_compra = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)

    def __str__(self):
        return f"Registro Adquisición - {self.equipo}"


class DocumentacionEquipo(models.Model):
    equipo = models.OneToOneField(Equipo, on_delete=models.CASCADE, related_name='documentacion')
    hoja_vida = models.BooleanField(default=False)
    registro_importacion = models.BooleanField(default=False)
    manual_operacion = models.BooleanField(default=False)
    manual_servicio = models.BooleanField(default=False)
    guia_rapida = models.BooleanField(default=False)
    protocolo_mto_preventivo = models.BooleanField(default=False)
    frecuencia_metrologica = models.CharField(max_length=50, null=True, blank=True)

    def __str__(self):
        return f"Documentación - {self.equipo}"


class InformacionMetrologica(models.Model):
    equipo = models.OneToOneField(Equipo, on_delete=models.CASCADE, related_name='informacion_metrologica')
    magnitud = models.CharField(max_length=100, null=True, blank=True)
    rango_equipo = models.CharField(max_length=100, null=True, blank=True)
    rango_trabajo = models.CharField(max_length=100, null=True, blank=True)
    error_maximo = models.CharField(max_length=100, null=True, blank=True)
    resolucion = models.CharField(max_length=100, null=True, blank=True)
    
    requiere_mantenimiento = models.BooleanField(default=False)
    frecuencia_mantenimiento = models.CharField(max_length=50, null=True, blank=True)
    requiere_calibracion = models.BooleanField(default=False)
    frecuencia_calibracion = models.CharField(max_length=50, null=True, blank=True)

    def __str__(self):
        return f"Info Metrológica - {self.equipo}"


class CondicionesFuncionamiento(models.Model):
    equipo = models.OneToOneField(Equipo, on_delete=models.CASCADE, related_name='condiciones_funcionamiento')
    voltaje = models.CharField(max_length=50, null=True, blank=True)
    corriente = models.CharField(max_length=50, null=True, blank=True)
    humedad_relativa = models.CharField(max_length=50, null=True, blank=True)
    temperatura = models.CharField(max_length=50, null=True, blank=True)
    dimensiones = models.CharField(max_length=100, null=True, blank=True)
    peso = models.CharField(max_length=50, null=True, blank=True)
    otros = models.TextField(null=True, blank=True)

    def __str__(self):
        return f"Condiciones - {self.equipo}"
