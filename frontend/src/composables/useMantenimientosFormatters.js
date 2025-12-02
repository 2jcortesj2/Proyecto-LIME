/**
 * Composable para formateo de datos de mantenimientos
 */

// Constantes de tipos de mantenimiento
export const TIPOS_MANTENIMIENTO = {
    preventivo: 'Preventivo',
    correctivo: 'Correctivo',
    calibracion: 'Calibración',
    calificacion: 'Calificación',
    verificacion: 'Verificación'
}

// Constantes de clases de badges
export const BADGE_CLASSES = {
    preventivo: 'badge-success',
    correctivo: 'badge-danger',
    calibracion: 'badge-info',
    calificacion: 'badge-warning',
    verificacion: 'badge-secondary'
}

// Nombres de meses
export const MESES_NOMBRES = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

export function useMantenimientosFormatters() {
    /**
     * Formatea mes y año en español
     */
    function formatMes(mes, anio) {
        if (!mes || !anio) return 'N/A'
        return `${MESES_NOMBRES[mes - 1]} ${anio}`
    }

    /**
     * Formatea costo en pesos colombianos
     */
    function formatCosto(costo) {
        if (!costo) return 'N/A'
        return new Intl.NumberFormat('es-CO', {
            style: 'currency',
            currency: 'COP',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(costo)
    }

    /**
     * Obtiene el label legible del tipo de mantenimiento
     */
    function getTipoLabel(tipo) {
        return TIPOS_MANTENIMIENTO[tipo] || tipo
    }

    /**
     * Obtiene la clase CSS para el badge del tipo
     */
    function getTipoBadgeClass(tipo) {
        return BADGE_CLASSES[tipo] || 'badge-secondary'
    }

    /**
     * Formatea fecha completa
     */
    function formatFecha(fecha) {
        if (!fecha) return 'N/A'
        const date = new Date(fecha)
        return new Intl.DateTimeFormat('es-CO', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(date)
    }

    /**
     * Formatea fecha y hora
     */
    function formatFechaHora(fecha) {
        if (!fecha) return 'N/A'
        const date = new Date(fecha)
        return new Intl.DateTimeFormat('es-CO', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        }).format(date)
    }

    return {
        formatMes,
        formatCosto,
        getTipoLabel,
        getTipoBadgeClass,
        formatFecha,
        formatFechaHora,
        // Exportar constantes también
        TIPOS_MANTENIMIENTO,
        BADGE_CLASSES,
        MESES_NOMBRES
    }
}
