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
    )
    
    list_filter = ('rol',)
    
    search_fields = (
        'nombre_completo',
        'email',
        'telefono',
    )
    
    ordering = ('nombre_completo',)
    
    list_per_page = 25
    
    fieldsets = (
        ('Información Personal', {
            'fields': (
                'nombre_completo',
                ('email', 'telefono'),
            )
        }),
        ('Información Laboral', {
            'fields': (
                'rol',
            )
        }),
    )
    
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
            obj.rol if obj.rol else 'N/A'
        )
    rol_colored.short_description = 'Rol'
    rol_colored.admin_order_field = 'rol'
