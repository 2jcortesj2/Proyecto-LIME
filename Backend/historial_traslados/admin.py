from django.contrib import admin
from .models import HistorialTraslado

@admin.register(HistorialTraslado)
class HistorialTrasladoAdmin(admin.ModelAdmin):
    list_display = ['id', 'equipo', 'fecha_traslado', 'sede_origen', 'sede_destino', 'usuario_registro']
    list_filter = ['fecha_traslado', 'sede_origen', 'sede_destino']
    search_fields = ['equipo__codigo_inventario', 'justificacion']
    date_hierarchy = 'fecha_traslado'