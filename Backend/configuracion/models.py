from django.db import models

class Configuracion(models.Model):
    nombre_sistema = models.CharField(max_length=100, default="LIME - Sistema de Inventario")
    email_notificaciones = models.EmailField(max_length=100, null=True, blank=True)
    dias_alerta_mantenimiento = models.IntegerField(default=30)
    dias_alerta_calibracion = models.IntegerField(default=30)
    
    class Meta:
        verbose_name = "Configuración del Sistema"
        verbose_name_plural = "Configuración del Sistema"

    def __str__(self):
        return "Configuración General"

    def save(self, *args, **kwargs):
        # Singleton pattern: ensure only one instance exists
        if not self.pk and Configuracion.objects.exists():
            return Configuracion.objects.first()
        return super(Configuracion, self).save(*args, **kwargs)
