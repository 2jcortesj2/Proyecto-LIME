from django.db import models
from multiselectfield import MultiSelectField
from sedes.models import Sede
from ubicaciones.models import Ubicacion

class Equipo(models.Model):

    # ---------------------------
    # INFORMACIÓN GENERAL
    # ---------------------------
    proceso = models.CharField(max_length=200, null=True, blank=True)
    sede = models.ForeignKey(Sede, on_delete=models.SET_NULL, null=True, blank=True, related_name='equipos')
    ubicacion = models.ForeignKey(Ubicacion, on_delete=models.SET_NULL, null=True, blank=True, related_name='equipos')
    nombre_equipo = models.CharField(max_length=200, null=True, blank=True)

    codigo_interno = models.CharField(max_length=100, null=True, blank=True)
    codigo_ips = models.CharField(max_length=20, null=True, blank=True)
    codigo_ecri = models.CharField(max_length=50, null=True, blank=True)

    responsable = models.ForeignKey('responsables.Responsable', on_delete=models.SET_NULL, null=True, blank=True, related_name='equipos_asignados')

    marca = models.CharField(max_length=100, null=True, blank=True)
    modelo = models.CharField(max_length=100, null=True, blank=True)
    serie = models.CharField(max_length=100, null=True, blank=True)

    CLASIF_MISIONAL_CHOICES = [
        ("Docencia", "Docencia"),
        ("Investigación", "Investigación"),
        ("Extensión", "Extensión"),
    ]
    clasificacion_misional = MultiSelectField(
        max_length=50, choices=CLASIF_MISIONAL_CHOICES,
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
        ("I", "I"),
        ("IIa", "IIa"),
        ("IIb", "IIb"),
        ("III", "III"),
    ]
    clasificacion_riesgo = models.CharField(
        max_length=10, choices=CLASIFICACION_RIESGO_CHOICES,
        null=True, blank=True
    )

    registro_invima = models.CharField(max_length=100, null=True, blank=True)
    
    tiempo_vida_util = models.IntegerField(null=True, blank=True)
    
    ESTADO_CHOICES = [
        ('Activo', 'Activo'),
        ('Inactivo', 'Inactivo'),
        ('Baja', 'Baja'),
        ('En Mantenimiento', 'En Mantenimiento'),
    ]
    estado = models.CharField(max_length=20, choices=ESTADO_CHOICES, default='Activo')

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
    ultimo_mantenimiento = models.DateField(null=True, blank=True)
    proximo_mantenimiento = models.DateField(null=True, blank=True)
    
    requiere_calibracion = models.BooleanField(default=False)
    frecuencia_calibracion = models.CharField(max_length=50, null=True, blank=True)
    ultima_calibracion = models.DateField(null=True, blank=True)
    proxima_calibracion = models.DateField(null=True, blank=True)

    requiere_calificacion = models.BooleanField(default=False)
    frecuencia_calificacion = models.CharField(max_length=50, null=True, blank=True)
    ultima_calificacion = models.DateField(null=True, blank=True)
    proxima_calificacion = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"Info Metrológica - {self.equipo}"

    @property
    def fecha_proximo_mantenimiento_calculada(self):
        """
        Calcula la fecha del próximo mantenimiento.
        Si 'proximo_mantenimiento' está definido, lo usa.
        Si no, lo calcula basado en la fecha de adquisición y la frecuencia.
        """
        if self.proximo_mantenimiento:
            return self.proximo_mantenimiento
            
        if not self.frecuencia_mantenimiento:
            return None
            
        # Acceder a fecha de adquisición a través del equipo
        try:
            fecha_adquisicion = self.equipo.registro_adquisicion.fecha_adquisicion
            if not fecha_adquisicion:
                return None
        except:
            return None
            
        frecuencia = self.frecuencia_mantenimiento.lower()
        from dateutil.relativedelta import relativedelta
        
        fecha_base = fecha_adquisicion
        
        # Lógica de cálculo (simplificada para coincidir con el frontend anterior)
        # En un escenario real, esto debería calcularse desde el último mantenimiento si existe
        if self.ultimo_mantenimiento:
            fecha_base = self.ultimo_mantenimiento
            
        if 'semestral' in frecuencia or '6' in frecuencia:
            return fecha_base + relativedelta(months=6)
        elif 'trimestral' in frecuencia or '3' in frecuencia:
            return fecha_base + relativedelta(months=3)
        elif 'mensual' in frecuencia:
            return fecha_base + relativedelta(months=1)
        else:
            # Por defecto anual
            return fecha_base + relativedelta(years=1)

    @property
    def estado_mantenimiento(self):
        """
        Determina el estado del mantenimiento: 'Vencido', 'Próximo', 'Normal', 'No Requiere'
        - Vencido: Fecha anterior a hoy O en el mes/año actual
        - Próximo: Dentro de los próximos 3 meses (pero no en el mes actual)
        - Normal: Más de 3 meses en el futuro
        """
        if not self.requiere_mantenimiento:
            return "No Requiere"
            
        fecha_proxima = self.fecha_proximo_mantenimiento_calculada
        if not fecha_proxima:
            return "No Programado"
            
        from datetime import date
        from dateutil.relativedelta import relativedelta
        
        hoy = date.today()
        inicio_mes_siguiente = date(hoy.year, hoy.month, 1) + relativedelta(months=1)
        limite_proximo = hoy + relativedelta(months=3)
        
        # Si la fecha es anterior al inicio del mes siguiente (es decir, mes actual o anterior), es Vencido
        if fecha_proxima < inicio_mes_siguiente:
            return "Vencido"
        elif fecha_proxima <= limite_proximo:
            return "Próximo"
        else:
            return "Normal"


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
