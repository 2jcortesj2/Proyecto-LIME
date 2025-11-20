from django.contrib import admin
from .models import HistorialMantenimiento

@admin.register(HistorialMantenimiento)
class HistorialMantenimientoAdmin(admin.ModelAdmin):
    list_display = ['id', 'equipo', 'tipo_mantenimiento', 'fecha_mantenimiento', 'realizado_por', 'costo']
    list_filter = ['tipo_mantenimiento', 'fecha_mantenimiento']
    search_fields = ['equipo__codigo_inventario', 'descripcion', 'realizado_por']
    date_hierarchy = 'fecha_mantenimiento'