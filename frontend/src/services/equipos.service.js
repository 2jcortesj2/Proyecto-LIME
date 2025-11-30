/**
 * Servicio centralizado para operaciones con Equipos
 * Reemplaza las llamadas fetch hardcodeadas en los componentes
 */
import { equiposAPI, dashboardAPI } from './api'

export const equiposService = {
    /**
     * Listar todos los equipos con filtros opcionales
     * @param {Object} params - Parámetros de filtrado (sede_id, ubicacion_id, estado, busqueda)
     * @returns {Promise} Promesa con los datos de equipos
     */
    async getAll(params = {}) {
        const response = await equiposAPI.getAll(params)
        return response.data
    },

    /**
     * Obtener un equipo específico por ID
     * @param {number} id - ID del equipo
     * @returns {Promise} Promesa con los datos del equipo
     */
    async getById(id) {
        const response = await equiposAPI.getById(id)
        return response.data
    },

    /**
     * Buscar equipos (wrapper para filtro de búsqueda)
     * @param {string} query - Texto de búsqueda
     * @returns {Promise} Promesa con equipos que coinciden
     */
    async search(query) {
        const response = await equiposAPI.getAll({ busqueda: query })
        return response.data
    },

    /**
     * Crear un nuevo equipo
     * @param {Object} data - Datos del equipo a crear
     * @returns {Promise} Promesa con el equipo creado
     */
    async create(data) {
        const response = await equiposAPI.create(data)
        return response.data
    },

    /**
     * Actualizar un equipo existente
     * @param {number} id - ID del equipo
     * @param {Object} data - Datos a actualizar
     * @returns {Promise} Promesa con el equipo actualizado
     */
    async update(id, data) {
        const response = await equiposAPI.update(id, data)
        return response.data
    },

    /**
     * Eliminar (desactivar) un equipo
     * @param {number} id - ID del equipo
     * @returns {Promise} Promesa con confirmación
     */
    async delete(id) {
        const response = await equiposAPI.delete(id)
        return response.data
    },

    /**
     * Obtener equipos próximos a mantenimiento
     * @returns {Promise} Promesa con equipos próximos
     */
    async getProximosMantenimiento() {
        const response = await equiposAPI.getProximosMantenimiento()
        return response.data
    },

    /**
     * Obtener estadísticas de mantenimiento
     * @returns {Promise} Promesa con stats (vencidos, próximos, normales)
     */
    async getMaintenanceStats() {
        const response = await equiposAPI.getMaintenanceStats()
        return response.data
    },

    /**
     * Reprogramar mantenimiento de un equipo
     * @param {number} id - ID del equipo
     * @param {string} fecha - Nueva fecha (formato YYYY-MM-DD)
     * @returns {Promise} Promesa con confirmación
     */
    async reprogramarMantenimiento(id, fecha) {
        const response = await equiposAPI.reprogramar(id, fecha)
        return response.data
    },

    /**
     * Obtener estadísticas del dashboard
     * @returns {Promise} Promesa con estadísticas generales
     */
    async getDashboardStats() {
        const response = await dashboardAPI.getStats()
        return response.data
    },
}
