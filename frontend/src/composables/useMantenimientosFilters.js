import { ref, computed } from 'vue'

/**
 * Composable para manejar filtros y ordenamiento de mantenimientos
 */
export function useMantenimientosFilters(mantenimientos) {
    // Estado de filtros
    const searchQuery = ref('')
    const filtros = ref({
        tipos: [],
        proveedores: [],
        anios: [],
        meses: []
    })
    const ordenamiento = ref('reciente')

    // Nombres de meses
    const mesesNombres = [
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ]

    // Valores únicos para filtros
    const tiposUnicos = computed(() => {
        const tipos = [...new Set(mantenimientos.value.map(m => m.tipo_mantenimiento))].filter(Boolean)
        return tipos.sort()
    })

    const proveedoresUnicos = computed(() => {
        const proveedores = [...new Set(mantenimientos.value.map(m => m.realizado_por))].filter(Boolean)
        return proveedores.sort()
    })

    const aniosUnicos = computed(() => {
        const anios = [...new Set(mantenimientos.value.map(m => m.anio_mantenimiento))].filter(Boolean)
        return anios.sort((a, b) => b - a) // Más reciente primero
    })

    // Mantenimientos filtrados
    const filteredMantenimientos = computed(() => {
        let result = mantenimientos.value

        // Filtro por búsqueda
        if (searchQuery.value) {
            const query = searchQuery.value.toLowerCase()
            result = result.filter(mant =>
                (mant.equipo?.codigo_interno && mant.equipo.codigo_interno.toLowerCase().includes(query)) ||
                (mant.equipo?.nombre_equipo && mant.equipo.nombre_equipo.toLowerCase().includes(query)) ||
                (mant.tipo_mantenimiento && mant.tipo_mantenimiento.toLowerCase().includes(query)) ||
                (mant.realizado_por && mant.realizado_por.toLowerCase().includes(query))
            )
        }

        // Filtro por tipos
        if (filtros.value.tipos.length > 0) {
            result = result.filter(mant => filtros.value.tipos.includes(mant.tipo_mantenimiento))
        }

        // Filtro por proveedores
        if (filtros.value.proveedores.length > 0) {
            result = result.filter(mant => filtros.value.proveedores.includes(mant.realizado_por))
        }

        // Filtro por años
        if (filtros.value.anios.length > 0) {
            result = result.filter(mant => filtros.value.anios.includes(mant.anio_mantenimiento))
        }

        // Filtro por meses
        if (filtros.value.meses.length > 0) {
            result = result.filter(mant => filtros.value.meses.includes(mant.mes_mantenimiento))
        }

        // Ordenamiento
        switch (ordenamiento.value) {
            case 'reciente':
                result.sort((a, b) => {
                    if (b.anio_mantenimiento !== a.anio_mantenimiento) {
                        return b.anio_mantenimiento - a.anio_mantenimiento
                    }
                    return b.mes_mantenimiento - a.mes_mantenimiento
                })
                break
            case 'antiguo':
                result.sort((a, b) => {
                    if (a.anio_mantenimiento !== b.anio_mantenimiento) {
                        return a.anio_mantenimiento - b.anio_mantenimiento
                    }
                    return a.mes_mantenimiento - b.mes_mantenimiento
                })
                break
            case 'costo-mayor':
                result.sort((a, b) => (b.costo || 0) - (a.costo || 0))
                break
            case 'costo-menor':
                result.sort((a, b) => (a.costo || 0) - (b.costo || 0))
                break
            case 'equipo-asc':
                result.sort((a, b) => (a.equipo?.nombre_equipo || '').localeCompare(b.equipo?.nombre_equipo || ''))
                break
        }

        return result
    })

    // Métodos de toggle
    function toggleTipoFilter(tipo) {
        const index = filtros.value.tipos.indexOf(tipo)
        if (index > -1) {
            filtros.value.tipos.splice(index, 1)
        } else {
            filtros.value.tipos.push(tipo)
        }
    }

    function toggleProveedorFilter(proveedor) {
        const index = filtros.value.proveedores.indexOf(proveedor)
        if (index > -1) {
            filtros.value.proveedores.splice(index, 1)
        } else {
            filtros.value.proveedores.push(proveedor)
        }
    }

    function toggleAnioFilter(anio) {
        const index = filtros.value.anios.indexOf(anio)
        if (index > -1) {
            filtros.value.anios.splice(index, 1)
        } else {
            filtros.value.anios.push(anio)
        }
    }

    function toggleMesFilter(mes) {
        const index = filtros.value.meses.indexOf(mes)
        if (index > -1) {
            filtros.value.meses.splice(index, 1)
        } else {
            filtros.value.meses.push(mes)
        }
    }

    function borrarTodosFiltros() {
        filtros.value.tipos = []
        filtros.value.proveedores = []
        filtros.value.anios = []
        filtros.value.meses = []
        ordenamiento.value = 'reciente'
    }

    // Contador de filtros activos
    const filtrosActivos = computed(() => {
        return filtros.value.tipos.length + filtros.value.proveedores.length +
            filtros.value.anios.length + filtros.value.meses.length
    })

    return {
        // Estado
        searchQuery,
        filtros,
        ordenamiento,
        mesesNombres,

        // Computed
        tiposUnicos,
        proveedoresUnicos,
        aniosUnicos,
        filteredMantenimientos,
        filtrosActivos,

        // Métodos
        toggleTipoFilter,
        toggleProveedorFilter,
        toggleAnioFilter,
        toggleMesFilter,
        borrarTodosFiltros
    }
}
