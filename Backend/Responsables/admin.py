from django.contrib import admin
from django.utils.html import format_html
from .models import Responsable


@admin.register(Responsable)
class ResponsableAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'nombre_completo',
        'email',
        'telefono',
        'rol_colored',
        'estado_colored',
    )
    
    list_filter = ('rol', 'estado')
    
    search_fields = (
        'nombre_completo',
        'email',
        'cedula',
        'telefono',
    )
    
    ordering = ('nombre_completo',)
    
    list_per_page = 25
    
    fieldsets = (
        ('Información Personal', {
            'fields': (
                ('nombre_completo', 'cedula'),
                ('email', 'telefono'),
            )
        }),
        ('Información Laboral', {
            'fields': (
                ('rol', 'estado'),
            )
        }),
    )
    
    actions = ['activar_responsables', 'inactivar_responsables']
    
    def rol_colored(self, obj):
        """Muestra el rol con color"""
        colors = {
            'Profesional': 'blue',
            'Auxiliar': 'green',
            'Tecnólogo': 'purple',
        }
        color = colors.get(obj.rol, 'gray')
        return format_html(
            '<span style="color: {}; font-weight: bold;">{}</span>',
            color,
            obj.rol
        )
    rol_colored.short_description = 'Rol'
    rol_colored.admin_order_field = 'rol'
    
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
    
    def activar_responsables(self, request, queryset):
        """Activa los responsables seleccionados"""
        count = queryset.update(estado='Activo')
        self.message_user(request, f'{count} responsable(s) activado(s) correctamente.')
    activar_responsables.short_description = "Activar responsables seleccionados"
    
    def inactivar_responsables(self, request, queryset):
        """Inactiva los responsables seleccionados"""
        count = queryset.update(estado='Inactivo')
        self.message_user(request, f'{count} responsable(s) inactivado(s) correctamente.')
    inactivar_responsables.short_description = "Inactivar responsables seleccionados"
