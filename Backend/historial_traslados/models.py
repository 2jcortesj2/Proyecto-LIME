from django.db import models
from equipos.models import Equipo
from sedes.models import Sede
from servicios.models import Servicio

class HistorialTraslado(models.Model):
    equipo = models.ForeignKey(Equipo, on_delete=models.CASCADE, related_name='traslados')
    fecha_traslado = models.DateTimeField()
    sede_origen = models.ForeignKey(Sede, on_delete=models.SET_NULL, null=True, related_name='traslados_origen')
    sede_destino = models.ForeignKey(Sede, on_delete=models.SET_NULL, null=True, related_name='traslados_destino')
    servicio_origen = models.ForeignKey(Servicio, on_delete=models.SET_NULL, null=True, related_name='traslados_origen')
    servicio_destino = models.ForeignKey(Servicio, on_delete=models.SET_NULL, null=True, related_name='traslados_destino')
    justificacion = models.TextField()
    usuario_registro = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'historial_traslados'
        verbose_name = 'Historial de Traslado'
        verbose_name_plural = 'Historial de Traslados'
        ordering = ['-fecha_traslado']

    def __str__(self):
        return f"Traslado {self.equipo.codigo_inventario} - {self.fecha_traslado}"