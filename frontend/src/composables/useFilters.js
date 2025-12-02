/**
 * Composable: useFilters
 * Lógica reutilizable para filtrado y ordenamiento de listas
 */
import { ref, computed } from 'vue'
import { useFormatting } from './useFormatting'

export function useFilters(items, config = {}) {
    const { normalizeText } = useFormatting()

    const showFilterPanel = ref(false)
    const searchQuery = ref('')
    const filtros = ref(config.customFilters || config.initialFilters || {
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
        // Soporte para filtros personalizados de traslados
        if (config.customFilters) {
            const result = {}

            // Sedes origen
            if ('sedes_origen' in config.customFilters) {
                result.sedes_origen = items.value
                    .map(t => ({ id: t.sede_origen, nombre: t.sede_origen_nombre }))
                    .filter((sede, index, self) => sede.id && sede.nombre &&
                        self.findIndex(s => s.id === sede.id) === index)
                    .sort((a, b) => a.nombre.localeCompare(b.nombre))
            }

            // Sedes destino
            if ('sedes_destino' in config.customFilters) {
                result.sedes_destino = items.value
                    .map(t => ({ id: t.sede_destino, nombre: t.sede_destino_nombre }))
                    .filter((sede, index, self) => sede.id && sede.nombre &&
                        self.findIndex(s => s.id === sede.id) === index)
                    .sort((a, b) => a.nombre.localeCompare(b.nombre))
            }

            // Ubicaciones origen
            if ('ubicaciones_origen' in config.customFilters) {
                result.ubicaciones_origen = items.value
                    .map(t => ({ id: t.ubicacion_origen, nombre: t.ubicacion_origen_nombre }))
                    .filter((ub, index, self) => ub.id && ub.nombre &&
                        self.findIndex(u => u.id === ub.id) === index)
                    .sort((a, b) => a.nombre.localeCompare(b.nombre))
            }

            // Ubicaciones destino
            if ('ubicaciones_destino' in config.customFilters) {
                result.ubicaciones_destino = items.value
                    .map(t => ({ id: t.ubicacion_destino, nombre: t.ubicacion_destino_nombre }))
                    .filter((ub, index, self) => ub.id && ub.nombre &&
                        self.findIndex(u => u.id === ub.id) === index)
                    .sort((a, b) => a.nombre.localeCompare(b.nombre))
            }

            // Responsables
            if ('responsables' in config.customFilters) {
                result.responsables = [...new Set(items.value.map(t => t.responsable_nombre))].filter(Boolean).sort()
            }

            return result
        }

        // Filtros estándar para equipos
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

        // Filtro por búsqueda de texto (SIN DISTINCIÓN DE MAYÚSCULAS NI TILDES)
        if (searchQuery.value) {
            const normalizedQuery = normalizeText(searchQuery.value)
            const searchFields = config.searchFields || ['nombre_equipo', 'codigo_interno', 'marca', 'modelo', 'serie']
            result = result.filter(item =>
                searchFields.some(field => {
                    const fieldValue = item[field]?.toString() || ''
                    return normalizeText(fieldValue).includes(normalizedQuery)
                })
            )
        }

        // Filtros personalizados para traslados
        if (config.customFilters) {
            // Sedes origen
            if (filtros.value.sedes_origen?.length > 0) {
                result = result.filter(t => filtros.value.sedes_origen.some(s => s.id === t.sede_origen))
            }

            // Sedes destino
            if (filtros.value.sedes_destino?.length > 0) {
                result = result.filter(t => filtros.value.sedes_destino.some(s => s.id === t.sede_destino))
            }

            // Ubicaciones origen
            if (filtros.value.ubicaciones_origen?.length > 0) {
                result = result.filter(t => filtros.value.ubicaciones_origen.some(u => u.id === t.ubicacion_origen))
            }

            // Ubicaciones destino
            if (filtros.value.ubicaciones_destino?.length > 0) {
                result = result.filter(t => filtros.value.ubicaciones_destino.some(u => u.id === t.ubicacion_destino))
            }

            // Responsables
            if (filtros.value.responsables?.length > 0) {
                result = result.filter(t => filtros.value.responsables.includes(t.responsable_nombre))
            }

            // Rango de fechas
            if (filtros.value.fecha_desde) {
                result = result.filter(t => t.fecha_traslado >= filtros.value.fecha_desde)
            }
            if (filtros.value.fecha_hasta) {
                result = result.filter(t => t.fecha_traslado <= filtros.value.fecha_hasta)
            }
        } else {
            // Filtros estándar para equipos
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
        }

        // Ordenamiento
        switch (ordenamiento.value) {
            case 'codigo-asc':
                result.sort((a, b) => (a.codigo_interno || a.equipo_codigo || '').localeCompare(b.codigo_interno || b.equipo_codigo || ''))
                break
            case 'codigo-desc':
                result.sort((a, b) => (b.codigo_interno || b.equipo_codigo || '').localeCompare(a.codigo_interno || a.equipo_codigo || ''))
                break
            case 'nombre-asc':
                result.sort((a, b) => (a.nombre_equipo || a.equipo_nombre || '').localeCompare(b.nombre_equipo || b.equipo_nombre || ''))
                break
            case 'nombre-desc':
                result.sort((a, b) => (b.nombre_equipo || b.equipo_nombre || '').localeCompare(a.nombre_equipo || a.equipo_nombre || ''))
                break
            case 'fecha-desc':
                result.sort((a, b) => new Date(b.fecha_traslado || 0) - new Date(a.fecha_traslado || 0))
                break
            case 'fecha-asc':
                result.sort((a, b) => new Date(a.fecha_traslado || 0) - new Date(b.fecha_traslado || 0))
                break
            case 'equipo-asc':
                result.sort((a, b) => (a.equipo_nombre || '').localeCompare(b.equipo_nombre || ''))
                break
            case 'equipo-desc':
                result.sort((a, b) => (b.equipo_nombre || '').localeCompare(a.equipo_nombre || ''))
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
        let count = 0

        if (config.customFilters) {
            count += (filtros.value.sedes_origen?.length || 0)
            count += (filtros.value.sedes_destino?.length || 0)
            count += (filtros.value.ubicaciones_origen?.length || 0)
            count += (filtros.value.ubicaciones_destino?.length || 0)
            count += (filtros.value.responsables?.length || 0)
            count += filtros.value.fecha_desde ? 1 : 0
            count += filtros.value.fecha_hasta ? 1 : 0
        } else {
            count = (filtros.value.sedes?.length || 0) +
                (filtros.value.ubicaciones?.length || 0) +
                (filtros.value.riesgos?.length || 0) +
                (filtros.value.estados?.length || 0) +
                (filtros.value.responsables?.length || 0) +
                (filtros.value.tiene_invima ? 1 : 0)
        }

        return count
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
        if (config.customFilters) {
            filtros.value = { ...config.customFilters }
        } else {
            filtros.value = {
                sedes: [],
                ubicaciones: [],
                riesgos: [],
                estados: [],
                responsables: [],
                tiene_invima: null
            }
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
