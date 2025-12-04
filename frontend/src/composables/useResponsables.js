/**
 * Composable para gestionar operaciones con Responsables
 * Centraliza la lógica de negocio, validaciones y llamadas API
 */
import { ref } from 'vue'
import { responsablesService } from '@/services'

export function useResponsables() {
    // Estado reactivo
    const responsables = ref([])
    const loading = ref(false)
    const error = ref(null)
    const submitLoading = ref(false)
    const successMessage = ref('')
    const formErrors = ref({})

    /**
     * Validar datos de creación
     */
    const validateCreateForm = (formData) => {
        const errors = {}

        if (!formData.nombre_completo?.trim()) {
            errors.nombre_completo = 'El nombre es requerido'
        }
        if (!formData.rol?.trim()) {
            errors.rol = 'El rol es requerido'
        }
        if (!formData.email?.trim()) {
            errors.email = 'El email es requerido'
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
            errors.email = 'El email no es válido'
        }

        formErrors.value = errors
        return Object.keys(errors).length === 0
    }

    /**
     * Validar datos de edición
     */
    const validateEditForm = (formData) => {
        const errors = {}

        if (!formData.nombre_completo?.trim()) {
            errors.nombre_completo = 'El nombre es requerido'
        }
        if (!formData.email?.trim()) {
            errors.email = 'El email es requerido'
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
            errors.email = 'El email no es válido'
        }

        formErrors.value = errors
        return Object.keys(errors).length === 0
    }

    /**
     * Obtener todos los responsables
     */
    const fetchResponsables = async () => {
        loading.value = true
        error.value = null
        try {
            responsables.value = await responsablesService.getAll()
            console.log('Responsables fetched:', responsables.value)
        } catch (err) {
            error.value = err.message || 'Error al cargar responsables'
            console.error('Error fetching responsables:', err)
        } finally {
            loading.value = false
        }
    }

    /**
     * Crear un nuevo responsable
     */
    const createResponsable = async (formData) => {
        if (!validateCreateForm(formData)) {
            successMessage.value = ''
            return false
        }

        submitLoading.value = true
        successMessage.value = ''

        try {
            await responsablesService.create(formData)
            successMessage.value = '✅ Responsable creado exitosamente'
            await fetchResponsables()
            return true
        } catch (err) {
            console.error('Error creating responsable:', err)
            formErrors.value = {
                submit: err.response?.data?.detail || err.message || 'Error al crear el responsable. Por favor, intente nuevamente.'
            }
            return false
        } finally {
            submitLoading.value = false
        }
    }

    /**
     * Actualizar un responsable existente
     */
    const updateResponsable = async (id, formData) => {
        if (!validateEditForm(formData)) {
            successMessage.value = ''
            return false
        }

        submitLoading.value = true
        successMessage.value = ''

        try {
            await responsablesService.update(id, formData)
            successMessage.value = '✅ Responsable actualizado exitosamente'
            await fetchResponsables()
            return true
        } catch (err) {
            console.error('Error updating responsable:', err)
            formErrors.value = {
                submit: err.response?.data?.detail || err.message || 'Error al actualizar el responsable. Por favor, intente nuevamente.'
            }
            return false
        } finally {
            submitLoading.value = false
        }
    }

    /**
     * Eliminar un responsable
     */
    const deleteResponsable = async (responsable) => {
        // Prevent deletion if equipment is assigned
        if (responsable.equipos_asignados_count > 0) {
            return {
                success: false,
                message: `No se puede eliminar ${responsable.nombre_completo} porque tiene ${responsable.equipos_asignados_count} equipo(s) asignado(s).`
            }
        }

        submitLoading.value = true

        try {
            await responsablesService.delete(responsable.id)
            await fetchResponsables()
            return { success: true }
        } catch (err) {
            console.error('Error deleting responsable:', err)
            const errorMsg = err.response?.data?.error || 'Error al eliminar el responsable.'
            return { success: false, message: errorMsg }
        } finally {
            submitLoading.value = false
        }
    }

    /**
     * Resetear errores del formulario
     */
    const resetFormErrors = () => {
        formErrors.value = {}
        successMessage.value = ''
    }

    return {
        // Estado
        responsables,
        loading,
        error,
        submitLoading,
        successMessage,
        formErrors,

        // Métodos
        fetchResponsables,
        createResponsable,
        updateResponsable,
        deleteResponsable,
        validateCreateForm,
        validateEditForm,
        resetFormErrors
    }
}
