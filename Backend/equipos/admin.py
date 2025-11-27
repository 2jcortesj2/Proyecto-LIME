from django.contrib import admin
from django.utils.html import format_html
from .models import (
    Equipo, RegistroAdquisicion, DocumentacionEquipo,
    InformacionMetrologica, CondicionesFuncionamiento
)


class RegistroAdquisicionInline(admin.StackedInline):
    model = RegistroAdquisicion
    can_delete = False
    verbose_name_plural = 'Registro de Adquisición'
    extra = 0
    classes = ['collapse']
    
    fieldsets = (
        (None, {
            'fields': (
                ('tiempo_vida_util', 'fecha_adquisicion'),
                ('propietario', 'fecha_fabricacion'),
                ('nit_proveedor', 'nombre_proveedor'),
                ('en_garantia', 'fecha_finalizacion_garantia'),
                ('forma_adquisicion', 'tipo_documento'),
                ('numero_documento', 'valor_compra'),
            )
        }),
    )


class DocumentacionEquipoInline(admin.StackedInline):
    model = DocumentacionEquipo
    can_delete = False
    verbose_name_plural = 'Documentación del Equipo'
    extra = 0
    classes = ['collapse']
    
    fieldsets = (
        ('Documentos Disponibles', {
            'fields': (
                ('hoja_vida', 'registro_importacion'),
                ('manual_operacion', 'idioma_manual'),
                ('manual_servicio', 'guia_rapida'),
                ('instructivo_manejo', 'protocolo_mto_preventivo'),
                'frecuencia_metrologica',
            )
        }),
    )


class InformacionMetrologicaInline(admin.StackedInline):
    model = InformacionMetrologica
    can_delete = False
    verbose_name_plural = 'Información Metrológica'
    extra = 0
    classes = ['collapse']
    
    readonly_fields = ['fecha_proximo_mantenimiento_calculada', 'estado_mantenimiento']
    
    fieldsets = (
        ('Mantenimiento', {
            'fields': (
                ('requiere_mantenimiento', 'frecuencia_mantenimiento'),
                ('ultimo_mantenimiento', 'fecha_proximo_mantenimiento_calculada'),
                'estado_mantenimiento',
            )
        }),
        ('Calibración', {
            'fields': (
                ('requiere_calibracion', 'magnitud'),
                ('rango_equipo', 'rango_trabajo'),
                ('resolucion', 'error_maximo'),
            )
        }),
    )


class CondicionesFuncionamientoInline(admin.StackedInline):
    model = CondicionesFuncionamiento
    can_delete = False
    verbose_name_plural = 'Condiciones de Funcionamiento'
    extra = 0
    classes = ['collapse']
    
    fieldsets = (
        ('Condiciones Eléctricas', {
            'fields': (
                ('voltaje', 'corriente'),
                'potencia',
            )
        }),
        ('Otras Condiciones', {
            'fields': (
                'presion',
                ('dimensiones', 'peso'),
                'otros',
            )
        }),
    )


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
        'responsable',
        'estado_colored',
        'clasificacion_riesgo',
    ]

    list_filter = [
        'estado',
        'sede',
        'servicio',
        'clasificacion_misional',
        'clasificacion_ips',
        'clasificacion_riesgo',
    ]

    search_fields = [
        'codigo_interno',
        'codigo_ips',
        'codigo_ecri',
        'nombre_equipo',
        'marca',
        'modelo',
        'serie',
        'registro_invima',
    ]
    
    list_per_page = 25
    list_max_show_all = 200
    
    readonly_fields = ['proceso']

    fieldsets = (
        ('Información General', {
            'fields': (
                ('proceso', 'estado'),
                ('sede', 'servicio'),
                ('nombre_equipo', 'codigo_interno'),
                ('codigo_ips', 'codigo_ecri'),
                ('responsable', 'ubicacion_fisica'),
            )
        }),
        ('Información del Equipo', {
            'fields': (
                ('marca', 'modelo', 'serie'),
                ('clasificacion_misional', 'clasificacion_ips'),
                ('clasificacion_riesgo', 'registro_invima'),
            )
        }),
    )
    
    actions = ['activar_equipos', 'inactivar_equipos']
    
    def estado_colored(self, obj):
        """Muestra el estado con color"""
        if obj.estado == 'Activo':
            color = 'green'
        elif obj.estado == 'Inactivo':
            color = 'red'
        else:
            color = 'gray'
        return format_html(
            '<span style="color: {}; font-weight: bold;">{}</span>',
            color,
            obj.estado
        )
    estado_colored.short_description = 'Estado'
    estado_colored.admin_order_field = 'estado'
    
    def activar_equipos(self, request, queryset):
        """Activa los equipos seleccionados"""
        count = queryset.update(estado='Activo')
        self.message_user(request, f'{count} equipo(s) activado(s) correctamente.')
    activar_equipos.short_description = "Activar equipos seleccionados"
    
    def inactivar_equipos(self, request, queryset):
        """Inactiva los equipos seleccionados"""
        count = queryset.update(estado='Inactivo')
        self.message_user(request, f'{count} equipo(s) inactivado(s) correctamente.')
    inactivar_equipos.short_description = "Inactivar equipos seleccionados"
