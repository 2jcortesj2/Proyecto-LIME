from django.db import models
from sedes.models import Sede

class Usuario(models.Model):
    ROL_CHOICES = [
        ('admin', 'Administrador'),
        ('tecnico', 'Técnico'),
        ('supervisor', 'Supervisor'),
        ('consulta', 'Consulta'),
    ]
    
    nombre_completo = models.CharField(max_length=150)
    email = models.EmailField(max_length=100, unique=True)
    password_hash = models.CharField(max_length=255)
    rol = models.CharField(max_length=20, choices=ROL_CHOICES)
    sede = models.ForeignKey(Sede, on_delete=models.CASCADE, related_name='usuarios')
    estado = models.BooleanField(default=True)

    class Meta:
        db_table = 'usuarios'
        verbose_name = 'Usuario'
        verbose_name_plural = 'Usuarios'

    def __str__(self):
        return self.nombre_completo