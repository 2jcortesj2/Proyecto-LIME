from django.db import models
from equipos.models import Equipo
from sedes.models import Sede
from ubicaciones.models import Ubicacion
from responsables.models import Responsable

class HistorialTraslado(models.Model):
    equipo = models.ForeignKey(Equipo, on_delete=models.CASCADE, related_name='traslados')
    fecha_traslado = models.DateTimeField()
    sede_origen = models.ForeignKey(Sede, on_delete=models.SET_NULL, null=True, related_name='traslados_origen')
    sede_destino = models.ForeignKey(Sede, on_delete=models.SET_NULL, null=True, related_name='traslados_destino')
    ubicacion_origen = models.ForeignKey(Ubicacion, on_delete=models.SET_NULL, null=True, related_name='traslados_origen')
    ubicacion_destino = models.ForeignKey(Ubicacion, on_delete=models.SET_NULL, null=True, related_name='traslados_destino')
    justificacion = models.TextField()
    responsable_registro = models.ForeignKey(Responsable, on_delete=models.SET_NULL, null=True, related_name='traslados_registrados')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'historial_traslados'
        verbose_name = 'Historial de Traslado'
        verbose_name_plural = 'Historial de Traslados'
        ordering = ['-fecha_traslado']

    def __str__(self):
        return f"Traslado {self.equipo.codigo_interno} - {self.fecha_traslado}"