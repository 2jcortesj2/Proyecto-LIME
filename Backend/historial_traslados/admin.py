from django.contrib import admin
from django.utils.html import format_html
from .models import HistorialTraslado


@admin.register(HistorialTraslado)
class HistorialTrasladoAdmin(admin.ModelAdmin):
    list_display = [
        'id',
        'equipo',
        'fecha_traslado',
        'traslado_info',
        'usuario_registro',
    ]
    
    list_filter = [
        'fecha_traslado',
        'sede_origen',
        'sede_destino',
    ]
    
    search_fields = [
        'equipo__codigo_interno',
        'equipo__nombre_equipo',
        'justificacion',
        'usuario_registro',
    ]
    
    date_hierarchy = 'fecha_traslado'
    
    ordering = ['-fecha_traslado']
    
    list_per_page = 30
    
    fieldsets = (
        ('Información del Traslado', {
            'fields': (
                'equipo',
                'fecha_traslado',
                'usuario_registro',
            )
        }),
        ('Origen y Destino', {
            'fields': (
                ('sede_origen', 'servicio_origen'),
                ('sede_destino', 'servicio_destino'),
            )
        }),
        ('Detalles', {
            'fields': (
                'justificacion',
            )
        }),
    )
    
    autocomplete_fields = ['equipo']
    
    readonly_fields = []
    
    def traslado_info(self, obj):
        """Muestra información del traslado de forma visual"""
        return format_html(
            '<div style="font-size: 12px;">'
            '<div><strong>De:</strong> {} / {}</div>'
            '<div><strong>A:</strong> {} / {}</div>'
            '</div>',
            obj.sede_origen.nombre if obj.sede_origen else 'N/A',
            obj.servicio_origen.nombre if obj.servicio_origen else 'N/A',
            obj.sede_destino.nombre if obj.sede_destino else 'N/A',
            obj.servicio_destino.nombre if obj.servicio_destino else 'N/A',
        )
    traslado_info.short_description = 'Traslado'
    
    def has_delete_permission(self, request, obj=None):
        """
        Evita que se eliminen traslados accidentalmente
        Solo superusuarios pueden eliminar
        """
        return request.user.is_superuser