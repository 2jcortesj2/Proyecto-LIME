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
        'responsable_registro',
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
        'responsable_registro__nombre_completo',
    ]
    
    date_hierarchy = 'fecha_traslado'
    
    ordering = ['-fecha_traslado']
    
    list_per_page = 30
    
    fieldsets = (
        ('Información del Traslado', {
            'fields': (
                'equipo',
                'fecha_traslado',
                'responsable_registro',
            )
        }),
        ('Origen y Destino', {
            'fields': (
                ('sede_origen', 'ubicacion_origen'),
                ('sede_destino', 'ubicacion_destino'),
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
            obj.ubicacion_origen.nombre if obj.ubicacion_origen else 'N/A',
            obj.sede_destino.nombre if obj.sede_destino else 'N/A',
            obj.ubicacion_destino.nombre if obj.ubicacion_destino else 'N/A',
        )
    traslado_info.short_description = 'Traslado'
    
    def has_delete_permission(self, request, obj=None):
        """
        Evita que se eliminen traslados accidentalmente
        Solo superusuarios pueden eliminar
        """
        return request.user.is_superuser