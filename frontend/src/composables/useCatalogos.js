/**
 * Composable: useCatalogos
 * Carga y gestión de catálogos (Sedes, Ubicaciones, Responsables)
 */
import { ref, computed, onMounted } from 'vue'
import { catalogsService } from '@/services'

export function useCatalogos() {
    const sedes = ref([])
    const ubicaciones = ref([])
    const responsables = ref([])
    const loading = ref(false)
    const error = ref(null)

    /**
     * Carga todos los catálogos en paralelo
     */
    async function fetchAll() {
        loading.value = true
        error.value = null

        try {
            const data = await catalogsService.getAll()
            sedes.value = data.sedes
            ubicaciones.value = data.ubicaciones
            responsables.value = data.responsables
        } catch (err) {
            error.value = err.message
            console.error('Error loading catalogs:', err)
        } finally {
            loading.value = false
        }
    }

    /**
     * Obtiene las ubicaciones filtradas por sede
     * @param {number} sedeId - ID de la sede
     * @returns {Array} Ubicaciones de esa sede
     */
    function getUbicacionesBySede(sedeId) {
        if (!sedeId) return ubicaciones.value
        return ubicaciones.value.filter(u => u.sede === sedeId)
    }

    /**
     * Computed para ubicaciones filtradas reactivas
     * Útil para v-model en formularios
     */
    const createUbicacionesFiltradasComputed = (sedeIdRef) => {
        return computed(() => getUbicacionesBySede(sedeIdRef.value))
    }

    // Auto-fetch on mount
    onMounted(() => {
        fetchAll()
    })

    return {
        sedes,
        ubicaciones,
        responsables,
        loading,
        error,
        fetchAll,
        getUbicacionesBySede,
        createUbicacionesFiltradasComputed
    }
}
