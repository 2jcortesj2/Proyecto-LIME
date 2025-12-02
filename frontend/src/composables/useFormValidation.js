/**
 * Composable: useFormValidation
 * Validación reutilizable de formularios
 */
import { ref } from 'vue'
import { SEDE_CONSTANTS, UBICACION_CONSTANTS } from '../constants/sedes'

export function useFormValidation() {
    const errors = ref({})

    /**
     * Limpia todos los errores
     */
    function clearErrors() {
        errors.value = {}
    }

    /**
     * Limpia error de un campo específico
     */
    function clearFieldError(field) {
        delete errors.value[field]
    }

    /**
     * Establece un error para un campo
     */
    function setError(field, message) {
        errors.value[field] = message
    }

    /**
     * Valida datos de sede
     */
    function validateSede(formData) {
        clearErrors()
        let isValid = true

        // Nombre
        if (!formData.nombre || formData.nombre.trim() === '') {
            setError('nombre', SEDE_CONSTANTS.VALIDATION.NOMBRE_REQUIRED)
            isValid = false
        } else if (formData.nombre.trim().length < 3) {
            setError('nombre', SEDE_CONSTANTS.VALIDATION.NOMBRE_MIN_LENGTH)
            isValid = false
        }

        // Dirección
        if (!formData.direccion || formData.direccion.trim() === '') {
            setError('direccion', SEDE_CONSTANTS.VALIDATION.DIRECCION_REQUIRED)
            isValid = false
        }

        // Ciudad
        if (!formData.ciudad || formData.ciudad.trim() === '') {
            setError('ciudad', SEDE_CONSTANTS.VALIDATION.CIUDAD_REQUIRED)
            isValid = false
        }

        // Teléfono (opcional, pero si se proporciona debe ser válido)
        if (formData.telefono && formData.telefono.trim() !== '') {
            const phoneRegex = /^[\d\s\+\-\(\)]+$/
            if (!phoneRegex.test(formData.telefono)) {
                setError('telefono', SEDE_CONSTANTS.VALIDATION.TELEFONO_INVALID)
                isValid = false
            }
        }

        return isValid
    }

    /**
     * Valida datos de ubicación
     */
    function validateUbicacion(formData) {
        clearErrors()
        let isValid = true

        // Nombre
        if (!formData.nombre || formData.nombre.trim() === '') {
            setError('nombre', UBICACION_CONSTANTS.VALIDATION.NOMBRE_REQUIRED)
            isValid = false
        } else if (formData.nombre.trim().length < 3) {
            setError('nombre', UBICACION_CONSTANTS.VALIDATION.NOMBRE_MIN_LENGTH)
            isValid = false
        }

        // Sede
        if (!formData.sede) {
            setError('sede', UBICACION_CONSTANTS.VALIDATION.SEDE_REQUIRED)
            isValid = false
        }

        // Responsable es opcional, no se valida

        return isValid
    }

    return {
        errors,
        clearErrors,
        clearFieldError,
        setError,
        validateSede,
        validateUbicacion
    }
}
