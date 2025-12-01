import { ref, computed, watch } from 'vue'

/**
 * Composable para manejar la lógica de dropdowns filtrables (combobox)
 * @param {Ref<Array>} items - Referencia reactiva a la lista de items
 * @param {Array<String>} searchKeys - Claves del objeto donde buscar (ej: ['nombre', 'codigo'])
 * @param {Function} formatDisplay - Función opcional para formatear el texto a mostrar en el input
 */
export function useDropdown(items, searchKeys = ['nombre'], formatDisplay = null) {
    const searchTerm = ref('')
    const isOpen = ref(false)
    const selectedItem = ref(null)

    // Filtrar items basado en el término de búsqueda
    const filteredItems = computed(() => {
        if (!items.value) return []

        if (!searchTerm.value) {
            return items.value
        }

        const search = searchTerm.value.toLowerCase()

        return items.value.filter(item => {
            return searchKeys.some(key => {
                const value = item[key]
                return value && String(value).toLowerCase().includes(search)
            })
        })
    })

    // Seleccionar un item
    function selectItem(item) {
        selectedItem.value = item
        if (formatDisplay) {
            searchTerm.value = formatDisplay(item)
        } else {
            // Por defecto usa la primera clave de búsqueda
            searchTerm.value = item[searchKeys[0]]
        }
        isOpen.value = false
    }

    // Abrir dropdown
    function openDropdown() {
        isOpen.value = true
    }

    // Cerrar dropdown
    function closeDropdown() {
        isOpen.value = false
    }

    // Resetear estado
    function reset() {
        searchTerm.value = ''
        isOpen.value = false
        selectedItem.value = null
    }

    // Establecer valor inicial (para edición)
    function setInitialValue(item) {
        if (item) {
            selectedItem.value = item
            if (formatDisplay) {
                searchTerm.value = formatDisplay(item)
            } else {
                searchTerm.value = item[searchKeys[0]]
            }
        }
    }

    // Establecer término de búsqueda manualmente (fallback)
    function setSearchTerm(term) {
        searchTerm.value = term
    }

    return {
        searchTerm,
        isOpen,
        selectedItem,
        filteredItems,
        selectItem,
        openDropdown,
        closeDropdown,
        reset,
        setInitialValue,
        setSearchTerm
    }
}
