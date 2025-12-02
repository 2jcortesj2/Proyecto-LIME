/**
 * Composable: useDateCalculations
 * Funciones reutilizables para cálculos y validaciones de fechas
 */

import { MESES_NOMBRES, MESES_NOMBRES_CORTOS } from '../constants/mantenimiento'

export function useDateCalculations() {
    /**
     * Verifica si una fecha está vencida (anterior a hoy)
     * @param {string|Date} fecha - Fecha a verificar
     * @returns {boolean} True si la fecha está vencida
     */
    function isDateOverdue(fecha) {
        if (!fecha) return false
        const fechaObj = new Date(fecha)
        if (isNaN(fechaObj.getTime())) return false

        const hoy = new Date()
        hoy.setHours(0, 0, 0, 0)
        fechaObj.setHours(0, 0, 0, 0)

        return fechaObj < hoy
    }

    /**
     * Verifica si una fecha está próxima a vencer (dentro de N meses)
     * @param {string|Date} fecha - Fecha a verificar
     * @param {number} monthsAhead - Número de meses hacia adelante
     * @returns {boolean} True si la fecha está dentro del rango
     */
    function isDateUpcoming(fecha, monthsAhead = 3) {
        if (!fecha) return false
        const fechaObj = new Date(fecha)
        if (isNaN(fechaObj.getTime())) return false

        const hoy = new Date()
        hoy.setHours(0, 0, 0, 0)
        fechaObj.setHours(0, 0, 0, 0)

        const limite = new Date(hoy)
        limite.setMonth(limite.getMonth() + monthsAhead)

        return fechaObj >= hoy && fechaObj <= limite
    }

    /**
     * Calcula la diferencia en meses entre dos fechas
     * @param {Date} fecha1 - Primera fecha
     * @param {Date} fecha2 - Segunda fecha
     * @returns {number} Diferencia en meses
     */
    function getMonthsDifference(fecha1, fecha2) {
        const d1 = new Date(fecha1)
        const d2 = new Date(fecha2)

        return (d2.getFullYear() - d1.getFullYear()) * 12 +
            (d2.getMonth() - d1.getMonth())
    }

    /**
     * Convierte mes y año a objeto Date (día 1 del mes)
     * @param {number} mes - Mes (1-12)
     * @param {number} anio - Año
     * @returns {Date} Objeto Date
     */
    function parseMantenimientoDate(mes, anio) {
        return new Date(anio, mes - 1, 1)
    }

    /**
     * Divide una fecha en mes y año para el backend
     * @param {string} fechaISO - Fecha en formato ISO (YYYY-MM-DD)
     * @returns {Object} { mes: number, anio: number }
     */
    function splitDateToMonthYear(fechaISO) {
        const [anio, mes] = fechaISO.split('-')
        return {
            mes: parseInt(mes),
            anio: parseInt(anio)
        }
    }

    /**
     * Obtiene el nombre del mes por índice (0-11)
     * @param {number} mesIndex - Índice del mes (0-11)
     * @param {boolean} corto - Si true, retorna nombre corto
     * @returns {string} Nombre del mes
     */
    function getMesNombre(mesIndex, corto = false) {
        const nombres = corto ? MESES_NOMBRES_CORTOS : MESES_NOMBRES
        return nombres[mesIndex] || 'N/A'
    }

    /**
     * Formatea mes y año en formato "Mes Año"
     * @param {number} mes - Mes (1-12)
     * @param {number} anio - Año
     * @returns {string} Formato "Enero 2024"
     */
    function formatMesAnio(mes, anio) {
        if (!mes || !anio) return 'N/A'
        return `${MESES_NOMBRES[mes - 1]} ${anio}`
    }

    /**
     * Verifica si un mes está deshabilitado (es pasado)
     * @param {number} monthIndex - Índice del mes (0-11)
     * @param {number} year - Año
     * @returns {boolean} True si está deshabilitado
     */
    function isMonthDisabled(monthIndex, year) {
        const hoy = new Date()
        const currentYear = hoy.getFullYear()
        const currentMonth = hoy.getMonth()

        if (year > currentYear) return false
        if (year < currentYear) return true

        return monthIndex < currentMonth
    }

    /**
     * Verifica si un mes es el mes actual
     * @param {number} monthIndex - Índice del mes (0-11)
     * @param {number} year - Año
     * @returns {boolean} True si es el mes actual
     */
    function isCurrentMonth(monthIndex, year) {
        const hoy = new Date()
        return year === hoy.getFullYear() && monthIndex === hoy.getMonth()
    }

    return {
        // Constantes exportadas
        MESES_NOMBRES,
        MESES_NOMBRES_CORTOS,

        // Funciones
        isDateOverdue,
        isDateUpcoming,
        getMonthsDifference,
        parseMantenimientoDate,
        splitDateToMonthYear,
        getMesNombre,
        formatMesAnio,
        isMonthDisabled,
        isCurrentMonth
    }
}
