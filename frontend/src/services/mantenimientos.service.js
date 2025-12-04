/**
 * Servicio centralizado para operaciones con Mantenimientos
 */
import { mantenimientosAPI } from './api'

export const mantenimientosService = {
    /**
     * Obtener todos los mantenimientos
     * @param {Object} params - Parámetros de filtrado opcionales
     * @returns {Promise} Promesa con los datos de mantenimientos
     */
    async getAll(params = {}) {
        const response = await mantenimientosAPI.getAll(params)
        return response.data
    },

    /**
     * Obtener un mantenimiento por ID
     * @param {number} id - ID del mantenimiento
     * @returns {Promise} Promesa con el mantenimiento
     */
    async getById(id) {
        const response = await mantenimientosAPI.getById(id)
        return response.data
    },

    /**
     * Obtener mantenimientos de un equipo específico
     * @param {number} equipoId - ID del equipo
     * @returns {Promise} Promesa con mantenimientos del equipo
     */
    async getByEquipo(equipoId) {
        const response = await mantenimientosAPI.getByEquipo(equipoId)
        // La respuesta del backend está paginada, accedemos a 'results'
        return response.data.results || response.data
    },

    /**
     * Crear un nuevo mantenimiento
     * @param {Object} data - Datos del mantenimiento
     * @returns {Promise} Promesa con el mantenimiento creado
     */
    async create(data) {
        const response = await mantenimientosAPI.create(data)
        return response.data
    },

    /**
     * Actualizar un mantenimiento existente
     * @param {number} id - ID del mantenimiento
     * @param {Object} data - Datos a actualizar
     * @returns {Promise} Promesa con el mantenimiento actualizado
     */
    async update(id, data) {
        const response = await mantenimientosAPI.update(id, data)
        return response.data
    },

    /**
     * Eliminar un mantenimiento
     * @param {number} id - ID del mantenimiento
     * @returns {Promise} Promesa con confirmación
     */
    async delete(id) {
        const response = await mantenimientosAPI.delete(id)
        return response.data
    },
}
