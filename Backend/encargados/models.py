from django.db import models

class Encargado(models.Model):
    nombre_completo = models.CharField(max_length=200)
    email = models.EmailField(unique=True)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    rol = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return self.nombre_completo
