from django.contrib import admin
from django.utils.html import format_html
from .models import Sede
from ubicaciones.models import Ubicacion


@admin.register(Sede)
class SedeAdmin(admin.ModelAdmin):
    list_display = [
        'id',
        'nombre',
        'ciudad',
        'direccion',
        'telefono',
        'total_ubicaciones',
        'total_equipos',
        'estado_colored',
    ]
    
    list_filter = ['estado', 'ciudad']
    
    search_fields = ['nombre', 'ciudad', 'direccion', 'telefono']
    
    ordering = ('nombre',)
    
    list_per_page = 25
    
    fieldsets = (
        ('Información Básica', {
            'fields': (
                ('nombre', 'ciudad'),
                'direccion',
                ('telefono', 'estado'),
            )
        }),
    )
    
    readonly_fields = []
    
    actions = ['activar_sedes', 'inactivar_sedes']
    
    def total_ubicaciones(self, obj):
        """Muestra el total de ubicaciones asociadas"""
        count = obj.ubicaciones.count() if hasattr(obj, 'ubicaciones') else 0
        return format_html(
            '<span style="color: #006633; font-weight: bold;">{}</span>',
            count
        )
    total_ubicaciones.short_description = 'Ubicaciones'
    
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
    
    def activar_sedes(self, request, queryset):
        """Activa las sedes seleccionadas"""
        count = queryset.update(estado='Activo')
        self.message_user(request, f'{count} sede(s) activada(s) correctamente.')
    activar_sedes.short_description = "Activar sedes seleccionadas"
    
    def inactivar_sedes(self, request, queryset):
        """Inactiva las sedes seleccionadas"""
        count = queryset.update(estado='Inactivo')
        self.message_user(request, f'{count} sede(s) inactivada(s) correctamente.')
    inactivar_sedes.short_description = "Inactivar sedes seleccionadas"