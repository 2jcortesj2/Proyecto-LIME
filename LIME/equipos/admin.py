from django.contrib import admin
from .models import Equipo

@admin.register(Equipo)
class EquipoAdmin(admin.ModelAdmin):

    list_display = [
        'codigo_interno',
        'nombre_equipo',
        'marca',
        'modelo',
        'sede',
        'proceso',
        'responsable'
    ]

    list_filter = [
        'sede',
        'proceso',
        'clasificacion_misional',
        'clasificacion_ips',
        'clasificacion_riesgo',
        'requiere_mantenimiento',
        'requiere_calibracion',
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
                'sede', 'proceso', 'nombre_equipo',
                'codigo_interno', 'codigo_ips', 'codigo_ecri',
                'responsable', 'ubicacion_fisica',
                'marca', 'modelo', 'serie',
                'clasificacion_misional', 'clasificacion_ips',
                'clasificacion_riesgo', 'registro_invima'
            )
        }),

        ('Fechas y Vida Útil', {
            'fields': (
                'fecha_adquisicion', 'fecha_fabricacion',
                'tiempo_vida_util', 'propietario'
            )
        }),

        ('Proveedor y Garantía', {
            'fields': (
                'nit_proveedor', 'nombre_proveedor',
                'en_garantia', 'fecha_fin_garantia',
                'forma_adquisicion', 'tipo_documento',
                'numero_documento', 'valor_compra'
            ),
            'classes': ('collapse',)
        }),

        ('Documentos Existentes', {
            'fields': (
                'hoja_vida', 'registro_importacion',
                'manual_operacion', 'manual_servicio',
                'guia_rapida', 'instructivo_manejo',
                'protocolo_mto_preventivo'
            ),
            'classes': ('collapse',)
        }),

        ('Información Metrológica', {
            'fields': (
                'frecuencia_metrologica',
                'requiere_mantenimiento', 'frecuencia_mantenimiento',
                'requiere_calibracion', 'frecuencia_calibracion',
                'magnitud', 'rango_equipo', 'resolucion',
                'error_maximo'
            ),
            'classes': ('collapse',)
        }),

        ('Condiciones de funcionamiento', {
            'fields': (
                'voltaje', 'corriente', 'humedad_relativa',
                'temperatura', 'dimensiones', 'peso', 'otros'
            ),
            'classes': ('collapse',)
        })
    )
