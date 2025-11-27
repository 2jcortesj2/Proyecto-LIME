from django.contrib import admin
from django.utils.html import format_html
from .models import Servicio


@admin.register(Servicio)
class ServicioAdmin(admin.ModelAdmin):
    list_display = [
        'id',
        'nombre',
        'sede',
        'responsable',
        'total_equipos',
        'estado_colored',
    ]
    
    list_filter = ['estado', 'sede']
    
    search_fields = ['nombre', 'responsable', 'sede__nombre']
    
    ordering = ('sede', 'nombre')
    
    list_per_page = 25
    
    fieldsets = (
        ('Información del Servicio', {
            'fields': (
                ('nombre', 'sede'),
                ('responsable', 'estado'),
            )
        }),
    )
    
    autocomplete_fields = ['sede']
    
    actions = ['activar_servicios', 'inactivar_servicios']
    
    def total_equipos(self, obj):
        """Muestra el total de equipos asociados"""
        count = obj.equipos.count() if hasattr(obj, 'equipos') else 0
        return format_html(
            '<span style="color: #00a99d; font-weight: bold;">{}</span>',
            count
        )
    total_equipos.short_description = 'Equipos'
    
    def estado_colored(self, obj):
        """Muestra el estado con color"""
        color = 'green' if obj.estado == 'Activo' else 'red'
        return format_html(
            '<span style="color: {}; font-weight: bold;">{}</span>',
            color,
            obj.estado
        )
    estado_colored.short_description = 'Estado'
    estado_colored.admin_order_field = 'estado'
    
    def activar_servicios(self, request, queryset):
        """Activa los servicios seleccionados"""
        count = queryset.update(estado='Activo')
        self.message_user(request, f'{count} servicio(s) activado(s) correctamente.')
    activar_servicios.short_description = "Activar servicios seleccionados"
    
    def inactivar_servicios(self, request, queryset):
        """Inactiva los servicios seleccionados"""
        count = queryset.update(estado='Inactivo')
        self.message_user(request, f'{count} servicio(s) inactivado(s) correctamente.')
    inactivar_servicios.short_description = "Inactivar servicios seleccionados"