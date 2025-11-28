/**
 * useEquipoForm Composable
 * Manages equipment form state, validation, and submission
 */

import { ref, computed } from 'vue'
import { createEquipo, updateEquipo, fetchCatalogs, filterServiciosBySede } from '../services/api/equiposApi'

export function useEquipoForm(mode = 'create') {
    // Form state
    const form = ref({
        // A. Información General
        proceso: 'LIME',
        nombre_equipo: '',
        codigo_interno: '',
        codigo_ips: '',
        codigo_ecri: '',
        responsable: null,
        ubicacion_fisica: '',
        sede: null,
        servicio: null,

        // B. Información del Equipo
        marca: '',
        modelo: '',
        serie: '',
        clasificacion_misional: [],
        clasificacion_ips: '',
        clasificacion_riesgo: '',
        registro_invima: '',

        // C. Registro Histórico
        tiempo_vida_util: '',
        fecha_adquisicion: '',
        propietario: '',
        fecha_fabricacion: '',
        nit_proveedor: '',
        nombre_proveedor: '',
        en_garantia: false,
        fecha_finalizacion_garantia: '',
        forma_adquisicion: '',
        tipo_documento: '',
        numero_documento: '',
        valor_compra: '',

        // D. Documentos
        hoja_vida: false,
        registro_importacion: false,
        manual_operacion: false,
        idioma_manual: '',
        manual_servicio: false,
        guia_rapida: false,
        instructivo_manejo: false,
        protocolo_mto_preventivo: false,
        frecuencia_metrologica_doc: false,

        // E. Información Metrológica
        requiere_mantenimiento: false,
        frecuencia_mantenimiento: '',
        ultimo_mantenimiento: '',
        requiere_calibracion: false,
        magnitud: '',
        rango_equipo: '',
        rango_trabajo: '',
        resolucion: '',
        error_maximo: '',

        // F. Condiciones de Funcionamiento
        voltaje: '',
        corriente: '',
        potencia: '',
        presion: '',
        dimensiones: '',
        peso: '',
        otros: ''
    })

    // Catalog data
    const sedes = ref([])
    const servicios = ref([])
    const responsables = ref([])

    // Filtered servicios based on selected sede
    const serviciosFiltrados = computed(() => {
        return filterServiciosBySede(servicios.value, form.value.sede)
    })

    // Loading and error states
    const submitLoading = ref(false)
    const formErrors = ref({})
    const successMessage = ref('')

    // Active tab for multi-step forms
    const activeTab = ref(1)

    /**
     * Load catalog data for dropdowns
     */
    async function loadCatalogs() {
        try {
            const catalogs = await fetchCatalogs()
            sedes.value = catalogs.sedes
            servicios.value = catalogs.servicios
            responsables.value = catalogs.responsables
        } catch (err) {
            console.error('Error loading catalogs:', err)
        }
    }

    /**
     * Validate the form
     */
    function validateForm() {
        const errors = {}

        // Tab 1 - Información General
        if (!form.value.nombre_equipo?.trim()) {
            errors.nombre_equipo = 'El nombre del equipo es requerido'
        }
        if (!form.value.codigo_interno?.trim()) {
            errors.codigo_interno = 'El código interno es requerido'
        }
        if (!form.value.responsable) {
            errors.responsable = 'El responsable es requerido'
        }
        if (!form.value.ubicacion_fisica?.trim()) {
            errors.ubicacion_fisica = 'La ubicación física es requerida'
        }
        if (!form.value.sede) {
            errors.sede = 'La sede es requerida'
        }
        if (!form.value.servicio) {
            errors.servicio = 'El servicio es requerido'
        }

        // Tab 2 - Datos del Equipo
        if (!form.value.marca?.trim()) {
            errors.marca = 'La marca es requerida'
        }
        if (!form.value.modelo?.trim()) {
            errors.modelo = 'El modelo es requerido'
        }
        if (!form.value.serie?.trim()) {
            errors.serie = 'El número de serie es requerido'
        }

        // Tab 3 - Registro Histórico
        if (!form.value.fecha_adquisicion) {
            errors.fecha_adquisicion = 'La fecha de adquisición es requerida'
        }
        if (!form.value.propietario?.trim()) {
            errors.propietario = 'El propietario es requerido'
        }
        if (!form.value.nit_proveedor?.trim()) {
            errors.nit_proveedor = 'El NIT del proveedor es requerido'
        }
        if (!form.value.nombre_proveedor?.trim()) {
            errors.nombre_proveedor = 'El nombre del proveedor es requerido'
        }
        if (!form.value.forma_adquisicion?.trim()) {
            errors.forma_adquisicion = 'La forma de adquisición es requerida'
        }
        if (!form.value.tipo_documento?.trim()) {
            errors.tipo_documento = 'El tipo de documento es requerido'
        }
        if (!form.value.numero_documento?.trim()) {
            errors.numero_documento = 'El número de documento es requerido'
        }

        formErrors.value = errors

        // Navigate to first tab with errors
        if (Object.keys(errors).length > 0) {
            const firstError = Object.keys(errors)[0]
            const tab1Fields = ['nombre_equipo', 'codigo_interno', 'responsable', 'ubicacion_fisica', 'sede', 'servicio']
            const tab2Fields = ['marca', 'modelo', 'serie']
            const tab3Fields = ['fecha_adquisicion', 'propietario', 'nit_proveedor', 'nombre_proveedor', 'forma_adquisicion', 'tipo_documento', 'numero_documento']

            if (tab1Fields.includes(firstError)) activeTab.value = 1
            else if (tab2Fields.includes(firstError)) activeTab.value = 2
            else if (tab3Fields.includes(firstError)) activeTab.value = 3
        }

        return Object.keys(errors).length === 0
    }

    /**
     * Prepare payload for API submission
     */
    function preparePayload() {
        return {
            // Main equipment fields
            proceso: form.value.proceso,
            nombre_equipo: form.value.nombre_equipo,
            codigo_interno: form.value.codigo_interno,
            codigo_ips: form.value.codigo_ips || null,
            codigo_ecri: form.value.codigo_ecri || null,
            responsable: form.value.responsable,
            ubicacion_fisica: form.value.ubicacion_fisica,
            sede: form.value.sede,
            servicio: form.value.servicio,
            marca: form.value.marca,
            modelo: form.value.modelo,
            serie: form.value.serie,
            clasificacion_misional: form.value.clasificacion_misional.join(','),
            clasificacion_ips: form.value.clasificacion_ips || null,
            clasificacion_riesgo: form.value.clasificacion_riesgo || null,
            registro_invima: form.value.registro_invima || null,
            estado: 'Activo',

            // Registro Adquisición (nested)
            registro_adquisicion: {
                tiempo_vida_util: form.value.tiempo_vida_util || null,
                fecha_adquisicion: form.value.fecha_adquisicion || null,
                propietario: form.value.propietario || null,
                fecha_fabricacion: form.value.fecha_fabricacion || null,
                nit_proveedor: form.value.nit_proveedor || null,
                nombre_proveedor: form.value.nombre_proveedor || null,
                en_garantia: form.value.en_garantia,
                fecha_finalizacion_garantia: form.value.fecha_finalizacion_garantia || null,
                forma_adquisicion: form.value.forma_adquisicion || null,
                tipo_documento: form.value.tipo_documento || null,
                numero_documento: form.value.numero_documento || null,
                valor_compra: form.value.valor_compra || null
            },

            // Documentación
            documentacion: {
                hoja_vida: form.value.hoja_vida,
                registro_importacion: form.value.registro_importacion,
                manual_operacion: form.value.manual_operacion,
                idioma_manual: form.value.idioma_manual || null,
                manual_servicio: form.value.manual_servicio,
                guia_rapida: form.value.guia_rapida,
                protocolo_mto_preventivo: form.value.protocolo_mto_preventivo,
                frecuencia_metrologica: form.value.frecuencia_metrologica_doc || null
            },

            // Información Metrológica
            informacion_metrologica: {
                requiere_mantenimiento: form.value.requiere_mantenimiento,
                frecuencia_mantenimiento: form.value.frecuencia_mantenimiento || null,
                ultimo_mantenimiento: form.value.ultimo_mantenimiento || null,
                requiere_calibracion: form.value.requiere_calibracion,
                magnitud: form.value.magnitud || null,
                rango_equipo: form.value.rango_equipo || null,
                rango_trabajo: form.value.rango_trabajo || null,
                resolucion: form.value.resolucion || null,
                error_maximo: form.value.error_maximo || null
            },

            // Condiciones de Funcionamiento
            condiciones_funcionamiento: {
                voltaje: form.value.voltaje || null,
                corriente: form.value.corriente || null,
                potencia: form.value.potencia || null,
                presion: form.value.presion || null,
                dimensiones: form.value.dimensiones || null,
                peso: form.value.peso || null,
                otros: form.value.otros || null
            }
        }
    }

    /**
     * Submit the form (create or update)
     */
    async function submitForm() {
        if (!validateForm()) {
            successMessage.value = ''
            return { success: false, error: 'Validation failed' }
        }

        submitLoading.value = true
        successMessage.value = ''

        try {
            const payload = preparePayload()

            let result
            if (mode === 'create') {
                result = await createEquipo(payload)
            } else if (mode === 'edit' && form.value.id) {
                result = await updateEquipo(form.value.id, payload)
            }

            successMessage.value = mode === 'create'
                ? '✅ Equipo creado exitosamente'
                : '✅ Equipo actualizado exitosamente'

            return { success: true, data: result }

        } catch (err) {
            console.error(`Error ${mode === 'create' ? 'creating' : 'updating'} equipo:`, err)
            formErrors.value = { submit: err.message || `Error al ${mode === 'create' ? 'crear' : 'actualizar'} el equipo.` }
            return { success: false, error: err.message }
        } finally {
            submitLoading.value = false
        }
    }

    /**
     * Load equipo data into form (for editing)
     */
    function loadEquipoData(equipo) {
        form.value = {
            id: equipo.id,
            proceso: equipo.proceso || 'LIME',
            nombre_equipo: equipo.nombre_equipo || '',
            codigo_interno: equipo.codigo_interno || '',
            codigo_ips: equipo.codigo_ips || '',
            codigo_ecri: equipo.codigo_ecri || '',
            responsable: equipo.responsable || null,
            ubicacion_fisica: equipo.ubicacion_fisica || '',
            sede: equipo.sede?.id || null,
            servicio: equipo.servicio?.id || null,
            marca: equipo.marca || '',
            modelo: equipo.modelo || '',
            serie: equipo.serie || '',
            clasificacion_misional: equipo.clasificacion_misional ? equipo.clasificacion_misional.split(',') : [],
            clasificacion_ips: equipo.clasificacion_ips || '',
            clasificacion_riesgo: equipo.clasificacion_riesgo || '',
            registro_invima: equipo.registro_invima || '',
            tiempo_vida_util: equipo.registro_adquisicion?.tiempo_vida_util || '',
            fecha_adquisicion: equipo.registro_adquisicion?.fecha_adquisicion || '',
            propietario: equipo.registro_adquisicion?.propietario || '',
            fecha_fabricacion: equipo.registro_adquisicion?.fecha_fabricacion || '',
            nit_proveedor: equipo.registro_adquisicion?.nit_proveedor || '',
            nombre_proveedor: equipo.registro_adquisicion?.nombre_proveedor || '',
            en_garantia: equipo.registro_adquisicion?.en_garantia || false,
            fecha_finalizacion_garantia: equipo.registro_adquisicion?.fecha_finalizacion_garantia || '',
            forma_adquisicion: equipo.registro_adquisicion?.forma_adquisicion || '',
            tipo_documento: equipo.registro_adquisicion?.tipo_documento || '',
            numero_documento: equipo.registro_adquisicion?.numero_documento || '',
            valor_compra: equipo.registro_adquisicion?.valor_compra || '',
            hoja_vida: equipo.documentacion?.hoja_vida || false,
            registro_importacion: equipo.documentacion?.registro_importacion || false,
            manual_operacion: equipo.documentacion?.manual_operacion || false,
            idioma_manual: equipo.documentacion?.idioma_manual || '',
            manual_servicio: equipo.documentacion?.manual_servicio || false,
            guia_rapida: equipo.documentacion?.guia_rapida || false,
            instructivo_manejo: equipo.documentacion?.instructivo_manejo || false,
            protocolo_mto_preventivo: equipo.documentacion?.protocolo_mto_preventivo || false,
            frecuencia_metrologica_doc: equipo.documentacion?.frecuencia_metrologica || false,
            requiere_mantenimiento: equipo.informacion_metrologica?.requiere_mantenimiento || false,
            frecuencia_mantenimiento: equipo.informacion_metrologica?.frecuencia_mantenimiento || '',
            ultimo_mantenimiento: equipo.informacion_metrologica?.ultimo_mantenimiento || '',
            requiere_calibracion: equipo.informacion_metrologica?.requiere_calibracion || false,
            magnitud: equipo.informacion_metrologica?.magnitud || '',
            rango_equipo: equipo.informacion_metrologica?.rango_equipo || '',
            rango_trabajo: equipo.informacion_metrologica?.rango_trabajo || '',
            resolucion: equipo.informacion_metrologica?.resolucion || '',
            error_maximo: equipo.informacion_metrologica?.error_maximo || '',
            voltaje: equipo.condiciones_funcionamiento?.voltaje || '',
            corriente: equipo.condiciones_funcionamiento?.corriente || '',
            potencia: equipo.condiciones_funcionamiento?.potencia || '',
            presion: equipo.condiciones_funcionamiento?.presion || '',
            dimensiones: equipo.condiciones_funcionamiento?.dimensiones || '',
            peso: equipo.condiciones_funcionamiento?.peso || '',
            otros: equipo.condiciones_funcionamiento?.otros || ''
        }
    }

    /**
     * Reset form to initial state
     */
    function resetForm() {
        form.value = {
            proceso: 'LIME',
            nombre_equipo: '',
            codigo_interno: '',
            codigo_ips: '',
            codigo_ecri: '',
            responsable: null,
            ubicacion_fisica: '',
            sede: null,
            servicio: null,
            marca: '',
            modelo: '',
            serie: '',
            clasificacion_misional: [],
            clasificacion_ips: '',
            clasificacion_riesgo: '',
            registro_invima: '',
            tiempo_vida_util: '',
            fecha_adquisicion: '',
            propietario: '',
            fecha_fabricacion: '',
            nit_proveedor: '',
            nombre_proveedor: '',
            en_garantia: false,
            fecha_finalizacion_garantia: '',
            forma_adquisicion: '',
            tipo_documento: '',
            numero_documento: '',
            valor_compra: '',
            hoja_vida: false,
            registro_importacion: false,
            manual_operacion: false,
            idioma_manual: '',
            manual_servicio: false,
            guia_rapida: false,
            instructivo_manejo: false,
            protocolo_mto_preventivo: false,
            frecuencia_metrologica_doc: false,
            requiere_mantenimiento: false,
            frecuencia_mantenimiento: '',
            ultimo_mantenimiento: '',
            requiere_calibracion: false,
            magnitud: '',
            rango_equipo: '',
            rango_trabajo: '',
            resolucion: '',
            error_maximo: '',
            voltaje: '',
            corriente: '',
            potencia: '',
            presion: '',
            dimensiones: '',
            peso: '',
            otros: ''
        }
        formErrors.value = {}
        successMessage.value = ''
        activeTab.value = 1
    }

    return {
        // State
        form,
        sedes,
        servicios,
        responsables,
        serviciosFiltrados,
        submitLoading,
        formErrors,
        successMessage,
        activeTab,

        // Methods
        loadCatalogs,
        validateForm,
        submitForm,
        loadEquipoData,
        resetForm
    }
}
