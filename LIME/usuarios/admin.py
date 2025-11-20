from django.contrib import admin
from .models import Usuario

@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ['id', 'nombre_completo', 'email', 'rol', 'sede', 'estado']
    list_filter = ['estado', 'rol', 'sede']
    search_fields = ['nombre_completo', 'email']
    exclude = ['password_hash']  # No mostrar el hash en el admin