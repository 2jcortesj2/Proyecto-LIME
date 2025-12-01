/**
 * Composable: usePagination
 * Lógica reutilizable para paginación de listas
 */
import { ref, computed } from 'vue'

export function usePagination(items, initialPageSize = 10) {
    const currentPage = ref(1)
    const itemsPerPage = ref(initialPageSize)
    const itemsPerPageOptions = [10, 20, 50, 100]

    const totalPages = computed(() =>
        Math.ceil(items.value.length / itemsPerPage.value)
    )

    const paginatedItems = computed(() => {
        const start = (currentPage.value - 1) * itemsPerPage.value
        const end = start + itemsPerPage.value
        return items.value.slice(start, end)
    })

    function changePage(page) {
        const pageNum = Number(page)
        if (pageNum >= 1 && pageNum <= totalPages.value) {
            currentPage.value = pageNum
        }
    }

    function resetPage() {
        currentPage.value = 1
    }

    // Reset to page 1 when items per page changes
    function changeItemsPerPage(newSize) {
        itemsPerPage.value = newSize
        currentPage.value = 1
    }

    return {
        currentPage,
        itemsPerPage,
        itemsPerPageOptions,
        totalPages,
        paginatedItems,
        changePage,
        resetPage,
        changeItemsPerPage
    }
}
