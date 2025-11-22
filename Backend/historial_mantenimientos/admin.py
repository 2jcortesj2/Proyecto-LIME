from django.contrib import admin
from .models import HistorialMantenimiento

@admin.register(HistorialMantenimiento)
class HistorialMantenimientoAdmin(admin.ModelAdmin):
    list_display = ['id', 'equipo', 'tipo_mantenimiento', 'mes_mantenimiento', 'anio_mantenimiento', 'realizado_por', 'costo']
    list_filter = ['tipo_mantenimiento', 'anio_mantenimiento', 'mes_mantenimiento']
    search_fields = ['equipo__codigo_interno', 'descripcion', 'realizado_por']
    ordering = ['-anio_mantenimiento', '-mes_mantenimiento']