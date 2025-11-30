from django.db import models
from sedes.models import Sede
from responsables.models import Responsable

class Ubicacion(models.Model):
    nombre = models.CharField(max_length=100)
    sede = models.ForeignKey(Sede, on_delete=models.CASCADE, related_name='ubicaciones')
    responsable = models.ForeignKey(Responsable, on_delete=models.SET_NULL, null=True, blank=True, related_name='ubicaciones')
    estado = models.BooleanField(default=True)

    class Meta:
        db_table = 'ubicaciones'
        verbose_name = 'Ubicación'
        verbose_name_plural = 'Ubicaciones'
        ordering = ['nombre']

    def __str__(self):
        return f"{self.nombre} - {self.sede.nombre}"
