import { ref } from 'vue'

/**
 * Composable para manejar estado de accordion/expansión de filas
 */
export function useAccordion() {
    const expandedRows = ref(new Set())

    /**
     * Toggle de una fila específica
     */
    function toggleRow(id) {
        if (expandedRows.value.has(id)) {
            expandedRows.value.delete(id)
        } else {
            expandedRows.value.add(id)
        }
        // Trigger reactivity
        expandedRows.value = new Set(expandedRows.value)
    }

    /**
     * Verifica si una fila está expandida
     */
    function isExpanded(id) {
        return expandedRows.value.has(id)
    }

    /**
     * Colapsa todas las filas
     */
    function collapseAll() {
        expandedRows.value.clear()
        expandedRows.value = new Set()
    }

    /**
     * Expande todas las filas de una lista de IDs
     */
    function expandAll(ids) {
        expandedRows.value = new Set(ids)
    }

    /**
     * Expande una fila específica
     */
    function expand(id) {
        expandedRows.value.add(id)
        expandedRows.value = new Set(expandedRows.value)
    }

    /**
     * Colapsa una fila específica
     */
    function collapse(id) {
        expandedRows.value.delete(id)
        expandedRows.value = new Set(expandedRows.value)
    }

    return {
        expandedRows,
        toggleRow,
        isExpanded,
        collapseAll,
        expandAll,
        expand,
        collapse
    }
}
