/**
 * Servicio centralizado para operaciones con Traslados
 */
import { trasladosAPI } from './api'

export const trasladosService = {
    /**
     * Obtener todos los traslados
     * @param {Object} params - Parámetros de filtrado opcionales
     * @returns {Promise} Promesa con los datos de traslados
     */
    async getAll(params = {}) {
        const response = await trasladosAPI.getAll(params)
        return response.data
    },

    /**
     * Obtener traslados de un equipo específico
     * @param {number} equipoId - ID del equipo
     * @returns {Promise} Promesa con traslados del equipo
     */
    async getByEquipo(equipoId) {
        const response = await trasladosAPI.getByEquipo(equipoId)
        return response.data
    },

    /**
     * Crear un nuevo traslado
     * @param {Object} data - Datos del traslado
     * @returns {Promise} Promesa con el traslado creado
     */
    async create(data) {
        const response = await trasladosAPI.create(data)
        return response.data
    },

    /**
     * Actualizar un traslado existente
     * @param {number} id - ID del traslado
     * @param {Object} data - Datos a actualizar
     * @returns {Promise} Promesa con el traslado actualizado
     */
    async update(id, data) {
        const response = await trasladosAPI.update(id, data)
        return response.data
    },

    /**
     * Eliminar un traslado
     * @param {number} id - ID del traslado
     * @returns {Promise} Promesa con confirmación
     */
    async delete(id) {
        const response = await trasladosAPI.delete(id)
        return response.data
    },
}
