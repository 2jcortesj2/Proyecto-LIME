/**
 * Servicio centralizado para operaciones con Responsables
 */
import { responsablesAPI } from './api'

export const responsablesService = {
    /**
     * Obtener todos los responsables
     * @returns {Promise} Promesa con los datos de responsables
     */
    async getAll() {
        const response = await responsablesAPI.getAll()
        return response.data
    },

    /**
     * Obtener un responsable por ID
     * @param {number} id - ID del responsable
     * @returns {Promise} Promesa con el responsable
     */
    async getById(id) {
        const response = await responsablesAPI.getById(id)
        return response.data
    },

    /**
     * Crear un nuevo responsable
     * @param {Object} data - Datos del responsable
     * @returns {Promise} Promesa con el responsable creado
     */
    async create(data) {
        const response = await responsablesAPI.create(data)
        return response.data
    },

    /**
     * Actualizar un responsable existente
     * @param {number} id - ID del responsable
     * @param {Object} data - Datos a actualizar
     * @returns {Promise} Promesa con el responsable actualizado
     */
    async update(id, data) {
        const response = await responsablesAPI.update(id, data)
        return response.data
    },

    /**
     * Eliminar un responsable
     * @param {number} id - ID del responsable
     * @returns {Promise} Promesa con confirmación
     */
    async delete(id) {
        const response = await responsablesAPI.delete(id)
        return response.data
    },
}
