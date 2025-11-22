from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from equipos.models import Equipo

class HistorialMantenimiento(models.Model):
    TIPO_MANTENIMIENTO = [
        ('preventivo', 'Preventivo'),
        ('correctivo', 'Correctivo'),
        ('calibracion', 'Calibración'),
        ('calificacion', 'Calificación'),
        ('verificacion', 'Verificación'),
    ]

    equipo = models.ForeignKey(Equipo, on_delete=models.CASCADE, related_name='mantenimientos')
    tipo_mantenimiento = models.CharField(max_length=50, choices=TIPO_MANTENIMIENTO)
    
    # Campos para mes y año del mantenimiento
    mes_mantenimiento = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(12)],
        help_text="Mes del mantenimiento (1-12)"
    )
    anio_mantenimiento = models.IntegerField(
        validators=[MinValueValidator(1900), MaxValueValidator(2100)],
        help_text="Año del mantenimiento"
    )
    
    descripcion = models.TextField()
    realizado_por = models.CharField(max_length=150)
    costo = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    usuario_registro = models.CharField(max_length=100)
    observaciones = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'historial_mantenimientos'
        verbose_name = 'Historial de Mantenimiento'
        verbose_name_plural = 'Historial de Mantenimientos'
        ordering = ['-anio_mantenimiento', '-mes_mantenimiento']

    def __str__(self):
        return f"{self.tipo_mantenimiento} - {self.equipo.codigo_interno} - {self.mes_mantenimiento}/{self.anio_mantenimiento}"
    
    @property
    def fecha_display(self):
        """Retorna formato legible: 'Enero 2024'"""
        meses = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ]
        return f"{meses[self.mes_mantenimiento - 1]} {self.anio_mantenimiento}"
