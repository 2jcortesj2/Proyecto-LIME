/**
 * Composable: useFilters
 * Lógica reutilizable para filtrado y ordenamiento de listas
 */
import { ref, computed } from 'vue'

export function useFilters(items, config = {}) {
    const showFilterPanel = ref(false)
    const searchQuery = ref('')
    const filtros = ref(config.initialFilters || {
        sedes: [],
        ubicaciones: [],
        riesgos: [],
        estados: [],
        responsables: [],
        tiene_invima: null
    })
    const ordenamiento = ref(config.defaultSort || 'codigo-asc')

    /**
     * Valores únicos extraídos de los items para los filtros
     */
    const valoresUnicos = computed(() => {
        const sedes = items.value
            .map(e => e.sede)
            .filter((sede, index, self) => sede && self.findIndex(s => s?.id === sede?.id) === index)
            .sort((a, b) => (a?.nombre || '').localeCompare(b?.nombre || ''))

        const ubicaciones = items.value
            .map(e => e.ubicacion_fisica)
            .filter((ub, index, self) => ub && self.findIndex(u => u?.id === ub?.id) === index)
            .sort((a, b) => (a?.nombre || '').localeCompare(b?.nombre || ''))

        const riesgos = [...new Set(items.value.map(e => e.clasificacion_riesgo))].filter(Boolean)
            .sort((a, b) => ['I', 'IIa', 'IIb', 'III'].indexOf(a) - ['I', 'IIa', 'IIb', 'III'].indexOf(b))

        const responsables = [...new Set(items.value.map(e => e.responsable_nombre))].filter(Boolean)
            .sort()

        const estados = [...new Set(items.value.map(e => e.estado))].filter(Boolean)
            .sort()

        return { sedes, ubicaciones, riesgos, responsables, estados }
    })

    /**
     * Items filtrados y ordenados
     */
    const filteredItems = computed(() => {
        let result = items.value

        // Filtro por búsqueda de texto
        if (searchQuery.value) {
            const query = searchQuery.value.toLowerCase()
            const searchFields = config.searchFields || ['nombre_equipo', 'codigo_interno', 'marca', 'modelo', 'serie']
            result = result.filter(item =>
                searchFields.some(field => item[field]?.toString().toLowerCase().includes(query))
            )
        }

        // Filtro por sedes
        if (filtros.value.sedes?.length > 0) {
            result = result.filter(item =>
                item.sede && filtros.value.sedes.some(s => s.id === item.sede.id)
            )
        }

        // Filtro por ubicaciones
        if (filtros.value.ubicaciones?.length > 0) {
            result = result.filter(item =>
                item.ubicacion_fisica && filtros.value.ubicaciones.some(u => u.id === item.ubicacion_fisica.id)
            )
        }

        // Filtro por riesgos
        if (filtros.value.riesgos?.length > 0) {
            result = result.filter(item => filtros.value.riesgos.includes(item.clasificacion_riesgo))
        }

        // Filtro por estados
        if (filtros.value.estados?.length > 0) {
            result = result.filter(item => filtros.value.estados.includes(item.estado))
        }

        // Filtro por responsables
        if (filtros.value.responsables?.length > 0) {
            result = result.filter(item => filtros.value.responsables.includes(item.responsable_nombre))
        }

        // Filtro por INVIMA
        if (filtros.value.tiene_invima === 'si') {
            result = result.filter(item => item.registro_invima)
        } else if (filtros.value.tiene_invima === 'no') {
            result = result.filter(item => !item.registro_invima)
        }

        // Ordenamiento
        switch (ordenamiento.value) {
            case 'codigo-asc':
                result.sort((a, b) => (a.codigo_interno || '').localeCompare(b.codigo_interno || ''))
                break
            case 'codigo-desc':
                result.sort((a, b) => (b.codigo_interno || '').localeCompare(a.codigo_interno || ''))
                break
            case 'nombre-asc':
                result.sort((a, b) => (a.nombre_equipo || '').localeCompare(b.nombre_equipo || ''))
                break
            case 'nombre-desc':
                result.sort((a, b) => (b.nombre_equipo || '').localeCompare(a.nombre_equipo || ''))
                break
            case 'riesgo-mayor':
                const ordenRiesgo = { 'III': 4, 'IIb': 3, 'IIa': 2, 'I': 1 }
                result.sort((a, b) => (ordenRiesgo[b.clasificacion_riesgo] || 0) - (ordenRiesgo[a.clasificacion_riesgo] || 0))
                break
        }

        return result
    })

    /**
     * Contador de filtros activos
     */
    const filtrosActivos = computed(() => {
        return (filtros.value.sedes?.length || 0) +
            (filtros.value.ubicaciones?.length || 0) +
            (filtros.value.riesgos?.length || 0) +
            (filtros.value.estados?.length || 0) +
            (filtros.value.responsables?.length || 0) +
            (filtros.value.tiene_invima ? 1 : 0)
    })

    function toggleFilterPanel() {
        showFilterPanel.value = !showFilterPanel.value
    }

    function toggleArrayFilter(array, item, compareKey = 'id') {
        const index = array.findIndex(i =>
            compareKey ? i[compareKey] === item[compareKey] : i === item
        )
        if (index > -1) {
            array.splice(index, 1)
        } else {
            array.push(item)
        }
    }

    function borrarTodosFiltros() {
        filtros.value = {
            sedes: [],
            ubicaciones: [],
            riesgos: [],
            estados: [],
            responsables: [],
            tiene_invima: null
        }
        ordenamiento.value = config.defaultSort || 'codigo-asc'
    }

    return {
        searchQuery,
        filtros,
        ordenamiento,
        showFilterPanel,
        valoresUnicos,
        filteredItems,
        filtrosActivos,
        toggleFilterPanel,
        toggleArrayFilter,
        borrarTodosFiltros
    }
}
