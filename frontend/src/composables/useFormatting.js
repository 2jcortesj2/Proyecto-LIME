/**
 * Composable: useFormatting
 * Funciones reutilizables para formateo de datos
 */

export function useFormatting() {
    /**
     * Formatea una fecha en formato legible en español
     * @param {string} fecha - Fecha en formato ISO
     * @returns {string} Fecha formateada (ej: "Enero 2024")
     */
    function formatFecha(fecha) {
        if (!fecha) return 'N/A'
        const date = new Date(fecha)
        const meses = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ]
        return `${meses[date.getMonth()]} ${date.getFullYear()}`
    }

    /**
     * Obtiene la clase CSS para badge de riesgo
     * @param {string} riesgo - Clasificación de riesgo (I, IIa, IIb, III)
     * @returns {string} Clase CSS
     */
    function getRiesgoBadgeClass(riesgo) {
        if (!riesgo) return 'badge-secondary'
        if (riesgo === 'III' || riesgo === 'IIb') return 'badge-danger'
        if (riesgo === 'IIa') return 'badge-warning'
        return 'badge-success'
    }

    /**
     * Obtiene la clase CSS para badge de estado
     * @param {string} estado - Estado del equipo
     * @returns {string} Clase CSS
     */
    function getEstadoBadgeClass(estado) {
        if (!estado) return 'estado-inactivo'
        if (estado === 'Activo') return 'estado-activo'
        if (estado === 'En Mantenimiento' || estado === 'Mantenimiento') return 'estado-mantenimiento'
        if (estado === 'Baja') return 'estado-baja'
        return 'estado-inactivo'
    }

    /**
     * Formatea el estado del equipo para display
     * @param {string} estado - Estado del equipo
     * @returns {string} Estado formateado
     */
    function formatEstado(estado) {
        if (!estado) return 'N/A'
        if (estado === 'En Mantenimiento') return 'Mantenimiento'
        return estado
    }

    /**
     * Obtiene la clase CSS para badge de estado de mantenimiento
     * @param {string} estado - Estado de mantenimiento (Vencido, Próximo, Normal)
     * @returns {string} Clase CSS
     */
    function getMantenimientoBadgeClass(estado) {
        if (!estado) return 'badge-secondary'
        if (estado === 'Vencido') return 'badge-danger'
        if (estado === 'Próximo' || estado === 'Proximo') return 'badge-warning'
        if (estado === 'Normal') return 'badge-success'
        return 'badge-secondary'
    }

    /**
     * Formatea un valor de moneda en COP
     * @param {number} valor - Valor numérico
     * @returns {string} Valor formateado (ej: "$1.250.000")
     */
    function formatMoneda(valor) {
        if (!valor) return 'N/A'
        return new Intl.NumberFormat('es-CO', {
            style: 'currency',
            currency: 'COP',
            minimumFractionDigits: 0
        }).format(valor)
    }

    return {
        formatFecha,
        getRiesgoBadgeClass,
        getEstadoBadgeClass,
        formatEstado,
        getMantenimientoBadgeClass,
        formatMoneda
    }
}
