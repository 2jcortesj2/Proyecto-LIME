from django.contrib import admin
from .models import Equipo

@admin.register(Equipo)
class EquipoAdmin(admin.ModelAdmin):
    list_display = ['codigo_inventario', 'nombre_equipo', 'marca', 'modelo', 'sede', 'servicio', 'estado']
    list_filter = ['estado', 'sede', 'servicio', 'requiere_mantenimiento', 'requiere_calibracion']
    search_fields = ['codigo_inventario', 'nombre_equipo', 'marca', 'modelo', 'serie']
    fieldsets = (
        ('Información Básica', {
            'fields': ('proceso', 'nombre_equipo', 'codigo_inventario', 'marca', 'modelo', 'serie', 'responsable', 'ubicacion_fisica', 'estado')
        }),
        ('Ubicación', {
            'fields': ('sede', 'servicio')
        }),
        ('Información Técnica', {
            'fields': ('voltaje', 'peso', 'dimensiones', 'temperatura', 'capacidad', 'potencia'),
            'classes': ('collapse',)
        }),
        ('Mantenimiento', {
            'fields': ('requiere_mantenimiento', 'frecuencia_mantenimiento', 'ultimo_mantenimiento', 'proximo_mantenimiento'),
            'classes': ('collapse',)
        }),
        ('Documentación', {
            'fields': ('hoja_vida', 'manual_operacion', 'manual_servicio', 'guia_rapida'),
            'classes': ('collapse',)
        })
    )