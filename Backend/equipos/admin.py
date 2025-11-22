from django.contrib import admin
from .models import (
    Equipo, RegistroAdquisicion, DocumentacionEquipo,
    InformacionMetrologica, CondicionesFuncionamiento
)

class RegistroAdquisicionInline(admin.StackedInline):
    model = RegistroAdquisicion
    can_delete = False
    verbose_name_plural = 'Registro de Adquisición'

class DocumentacionEquipoInline(admin.StackedInline):
    model = DocumentacionEquipo
    can_delete = False
    verbose_name_plural = 'Documentación del Equipo'

class InformacionMetrologicaInline(admin.StackedInline):
    model = InformacionMetrologica
    can_delete = False
    verbose_name_plural = 'Información Metrológica'

class CondicionesFuncionamientoInline(admin.StackedInline):
    model = CondicionesFuncionamiento
    can_delete = False
    verbose_name_plural = 'Condiciones de Funcionamiento'

@admin.register(Equipo)
class EquipoAdmin(admin.ModelAdmin):
    inlines = [
        RegistroAdquisicionInline,
        DocumentacionEquipoInline,
        InformacionMetrologicaInline,
        CondicionesFuncionamientoInline,
    ]

    list_display = [
        'codigo_interno',
        'nombre_equipo',
        'marca',
        'modelo',
        'sede',
        'servicio',
        'responsable'
    ]

    list_filter = [
        'sede',
        'servicio',
        'clasificacion_misional',
        'clasificacion_ips',
        'clasificacion_riesgo',
    ]

    search_fields = [
        'codigo_interno',
        'nombre_equipo',
        'marca',
        'modelo',
        'serie',
        'responsable'
    ]

    fieldsets = (
        ('Información General', {
            'fields': (
                'sede', 'servicio', 'nombre_equipo',
                'codigo_interno', 'codigo_ips', 'codigo_ecri',
                'responsable', 'ubicacion_fisica',
                'marca', 'modelo', 'serie',
                'clasificacion_misional', 'clasificacion_ips',
                'clasificacion_riesgo', 'registro_invima'
            )
        }),
    )
