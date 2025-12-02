/**
 * Composable: useMantenimiento
 * Funciones reutilizables para lógica de mantenimientos
 */

import { TIPOS_MANTENIMIENTO } from '../constants/mantenimiento'

export function useMantenimiento() {
    /**
     * Obtiene las opciones de tipos de mantenimiento
     * @returns {Array} Array de opciones
     */
    function getTipoMantenimientoOptions() {
        return TIPOS_MANTENIMIENTO
    }

    /**
     * Obtiene la etiqueta formateada de un tipo de mantenimiento
     * @param {string} tipo - Tipo de mantenimiento
     * @returns {string} Etiqueta formateada
     */
    function getTipoLabel(tipo) {
        const tipoObj = TIPOS_MANTENIMIENTO.find(t => t.value === tipo)
        return tipoObj ? tipoObj.label : tipo
    }

    /**
     * Obtiene la clase CSS del badge para un tipo de mantenimiento
     * @param {string} tipo - Tipo de mantenimiento
     * @returns {string} Clase CSS
     */
    function getTipoBadgeClass(tipo) {
        const tipoObj = TIPOS_MANTENIMIENTO.find(t => t.value === tipo)
        return tipoObj ? tipoObj.badgeClass : 'badge-secondary'
    }

    /**
     * Valida un formulario de mantenimiento
     * @param {Object} form - Datos del formulario
     * @returns {Object} { isValid: boolean, message: string }
     */
    function validateMantenimientoForm(form) {
        if (!form.tipo_mantenimiento) {
            return { isValid: false, message: 'Debe seleccionar un tipo de mantenimiento' }
        }

        if (!form.fecha_mantenimiento) {
            return { isValid: false, message: 'Debe seleccionar una fecha' }
        }

        if (!form.realizado_por || form.realizado_por.trim() === '') {
            return { isValid: false, message: 'Debe indicar quién realizó el mantenimiento' }
        }

        if (!form.descripcion || form.descripcion.trim() === '') {
            return { isValid: false, message: 'Debe proporcionar una descripción del trabajo realizado' }
        }

        if (!form.usuario_registro || form.usuario_registro.trim() === '') {
            return { isValid: false, message: 'Debe indicar quién registra el mantenimiento' }
        }

        return { isValid: true, message: '' }
    }

    /**
     * Prepara los datos de mantenimiento para enviar al backend
     * @param {Object} form - Datos del formulario
     * @param {number} equipoId - ID del equipo
     * @param {number} mes - Mes del mantenimiento
     * @param {number} anio - Año del mantenimiento
     * @returns {Object} Datos formateados para el backend
     */
    function prepareMantenimientoData(form, equipoId, mes, anio) {
        return {
            equipo_id: equipoId,
            tipo_mantenimiento: form.tipo_mantenimiento,
            mes_mantenimiento: mes,
            anio_mantenimiento: anio,
            descripcion: form.descripcion,
            realizado_por: form.realizado_por,
            costo: form.costo || 0,
            usuario_registro: form.usuario_registro,
            observaciones: form.observaciones || ''
        }
    }

    return {
        getTipoMantenimientoOptions,
        getTipoLabel,
        getTipoBadgeClass,
        validateMantenimientoForm,
        prepareMantenimientoData
    }
}
