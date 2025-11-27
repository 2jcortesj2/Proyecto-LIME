from django.contrib import admin
from django.utils.html import format_html
from .models import HistorialMantenimiento


@admin.register(HistorialMantenimiento)
class HistorialMantenimientoAdmin(admin.ModelAdmin):
    list_display = [
        'id',
        'equipo',
        'tipo_mantenimiento_colored',
        'fecha_mantenimiento',
        'realizado_por',
        'costo_formatted',
    ]
    
    list_filter = [
        'tipo_mantenimiento',
        'anio_mantenimiento',
        'mes_mantenimiento',
    ]
    
    search_fields = [
        'equipo__codigo_interno',
        'equipo__nombre_equipo',
        'descripcion',
        'realizado_por',
        'observaciones',
    ]
    
    ordering = ['-anio_mantenimiento', '-mes_mantenimiento']
    
    list_per_page = 30
    
    date_hierarchy = None  # Usar mes_mantenimiento y anio_mantenimiento en su lugar
    
    fieldsets = (
        ('Información del Mantenimiento', {
            'fields': (
                'equipo',
                ('tipo_mantenimiento', 'realizado_por'),
                ('mes_mantenimiento', 'anio_mantenimiento'),
            )
        }),
        ('Detalles', {
            'fields': (
                'descripcion',
                'observaciones',
                'costo',
            )
        }),
    )
    
    autocomplete_fields = ['equipo']
    
    readonly_fields = []
    
    def fecha_mantenimiento(self, obj):
        """Muestra la fecha de mantenimiento en formato legible"""
        if obj.mes_mantenimiento and obj.anio_mantenimiento:
            meses = {
                1: 'Enero', 2: 'Febrero', 3: 'Marzo', 4: 'Abril',
                5: 'Mayo', 6: 'Junio', 7: 'Julio', 8: 'Agosto',
                9: 'Septiembre', 10: 'Octubre', 11: 'Noviembre', 12: 'Diciembre'
            }
            return f"{meses.get(obj.mes_mantenimiento, obj.mes_mantenimiento)} {obj.anio_mantenimiento}"
        return "N/A"
    fecha_mantenimiento.short_description = 'Fecha'
    fecha_mantenimiento.admin_order_field = 'anio_mantenimiento'
    
    def tipo_mantenimiento_colored(self, obj):
        """Muestra el tipo de mantenimiento con color"""
        colors = {
            'Preventivo': 'green',
            'Correctivo': 'orange',
            'Calibración': 'blue',
            'Verificación': 'purple',
        }
        color = colors.get(obj.tipo_mantenimiento, 'gray')
        return format_html(
            '<span style="color: {}; font-weight: bold;">{}</span>',
            color,
            obj.tipo_mantenimiento
        )
    tipo_mantenimiento_colored.short_description = 'Tipo'
    tipo_mantenimiento_colored.admin_order_field = 'tipo_mantenimiento'
    
    def costo_formatted(self, obj):
        """Muestra el costo formateado"""
        if obj.costo:
            return format_html(
                '<span style="color: #006633;">${:,.2f}</span>',
                float(obj.costo)
            )
        return "N/A"
    costo_formatted.short_description = 'Costo'
    costo_formatted.admin_order_field = 'costo'