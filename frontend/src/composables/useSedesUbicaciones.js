/**
 * Composable: useSedesUbicaciones
 * Gestión de lógica de negocio para Sedes y Ubicaciones
 */
import { ref } from 'vue'
import apiClient, { sedesAPI, ubicacionesAPI, responsablesAPI } from '../services/api'

export function useSedesUbicaciones() {
    const sedes = ref([])
    const ubicaciones = ref([])
    const responsables = ref([])
    const loading = ref(false)
    const error = ref(null)

    /**
     * Obtiene todas las sedes con sus ubicaciones
     */
    async function fetchSedes() {
        try {
            loading.value = true
            error.value = null
            const response = await sedesAPI.getAll()
            sedes.value = response.data
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al cargar las sedes'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Obtiene todas las ubicaciones
     */
    async function fetchUbicaciones(params = {}) {
        try {
            loading.value = true
            error.value = null
            const response = await ubicacionesAPI.getAll(params)
            ubicaciones.value = response.data
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al cargar las ubicaciones'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Obtiene todos los responsables
     */
    async function fetchResponsables() {
        try {
            const response = await responsablesAPI.getAll()
            responsables.value = response.data
            return response.data
        } catch (err) {
            console.error('Error al cargar responsables:', err)
            throw err
        }
    }

    /**
     * Crea una nueva sede
     */
    async function createSede(data) {
        try {
            loading.value = true
            error.value = null
            const response = await sedesAPI.create(data)
            await fetchSedes() // Recargar lista
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al crear la sede'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Actualiza una sede existente
     */
    async function updateSede(id, data) {
        try {
            loading.value = true
            error.value = null
            const response = await sedesAPI.update(id, data)
            await fetchSedes() // Recargar lista
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al actualizar la sede'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Elimina una sede (soft delete)
     */
    async function deleteSede(id) {
        try {
            loading.value = true
            error.value = null
            const response = await sedesAPI.delete(id)
            await fetchSedes() // Recargar lista
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al desactivar la sede'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Crea una nueva ubicación
     */
    async function createUbicacion(data) {
        try {
            loading.value = true
            error.value = null
            const response = await ubicacionesAPI.create(data)
            await fetchSedes() // Recargar lista de sedes con ubicaciones actualizadas
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al crear la ubicación'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Actualiza una ubicación existente
     */
    async function updateUbicacion(id, data) {
        try {
            loading.value = true
            error.value = null
            const response = await ubicacionesAPI.update(id, data)
            await fetchSedes() // Recargar lista
            return response.data
        } catch (err) {
            error.value = err.response?.data?.message || 'Error al actualizar la ubicación'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Elimina una ubicación
     * Validará en el backend que no tenga equipos
     */
    async function deleteUbicacion(id) {
        try {
            loading.value = true
            error.value = null
            const response = await ubicacionesAPI.delete(id)
            await fetchSedes() // Recargar lista
            return response.data
        } catch (err) {
            error.value = err.response?.data?.error || err.response?.data?.message || 'Error al eliminar la ubicación'
            throw err
        } finally {
            loading.value = false
        }
    }

    /**
     * Obtiene los equipos de una ubicación específica
     */
    async function fetchEquiposByUbicacion(ubicacionId) {
        try {
            // No usamos loading global para no bloquear toda la UI
            const response = await apiClient.get('/equipos/', {
                params: { ubicacion: ubicacionId }
            })
            return response.data
        } catch (err) {
            console.error('Error al cargar equipos de la ubicación:', err)
            throw err
        }
    }

    return {
        // State
        sedes,
        ubicaciones,
        responsables,
        loading,
        error,

        // Sedes methods
        fetchSedes,
        createSede,
        updateSede,
        deleteSede,

        // Ubicaciones methods
        fetchUbicaciones,
        createUbicacion,
        updateUbicacion,
        deleteUbicacion,
        fetchEquiposByUbicacion,

        // Other
        fetchResponsables
    }
}
