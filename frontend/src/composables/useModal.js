/**
 * Composable: useModal
 * Gestión de estado de modales
 */
import { ref } from 'vue'

export function useModal() {
    const isOpen = ref(false)
    const data = ref(null)

    function open(initialData = null) {
        data.value = initialData
        isOpen.value = true
    }

    function close() {
        isOpen.value = false
        // Pequeño delay antes de limpiar data para permitir animaciones de cierre
        setTimeout(() => {
            data.value = null
        }, 300)
    }

    function toggle() {
        if (isOpen.value) {
            close()
        } else {
            open()
        }
    }

    return {
        isOpen,
        data,
        open,
        close,
        toggle
    }
}
