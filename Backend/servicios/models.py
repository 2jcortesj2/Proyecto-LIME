from django.db import models
from sedes.models import Sede

class Servicio(models.Model):
    nombre = models.CharField(max_length=100)
    sede = models.ForeignKey(Sede, on_delete=models.CASCADE, related_name='servicios')
    descripcion = models.TextField(blank=True, null=True)
    responsable = models.CharField(max_length=150)
    estado = models.BooleanField(default=True)

    class Meta:
        db_table = 'servicios'
        verbose_name = 'Servicio'
        verbose_name_plural = 'Servicios'

    def __str__(self):
        return f"{self.nombre} - {self.sede.nombre}"