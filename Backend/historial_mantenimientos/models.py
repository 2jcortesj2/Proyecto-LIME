from django.db import models
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
    fecha_mantenimiento = models.DateField()
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
        ordering = ['-fecha_mantenimiento']

    def __str__(self):
        return f"{self.tipo_mantenimiento} - {self.equipo.codigo_inventario} - {self.fecha_mantenimiento}"
