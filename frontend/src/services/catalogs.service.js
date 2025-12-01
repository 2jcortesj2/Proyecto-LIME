/**
 * Servicio centralizado para operaciones con Catálogos
 * (Sedes, Ubicaciones, Responsables)
 */
import { sedesAPI, ubicacionesAPI, responsablesAPI } from './api'

export const catalogsService = {
    /**
     * Obtener todas las sedes
     * @returns {Promise} Promesa con array de sedes
     */
    async getSedes() {
        const response = await sedesAPI.getAll()
        return response.data
    },

    /**
     * Obtener todas las ubicaciones
     * @returns {Promise} Promesa con array de ubicaciones
     */
    async getUbicaciones() {
        const response = await ubicacionesAPI.getAll()
        // La API devuelve objeto paginado: {count, next, previous, results}
        // Extraemos solo el array de resultados
        return response.data.results || response.data
    },

    /**
     * Obtener todos los responsables
     * @returns {Promise} Promesa con array de responsables
     */
    async getResponsables() {
        const response = await responsablesAPI.getAll()
        // La API devuelve objeto paginado: {count, next, previous, results}
        // Extraemos solo el array de resultados
        return response.data.results || response.data
    },

    /**
     * Cargar todos los catálogos en paralelo
     * @returns {Promise} Promesa con objeto que contiene sedes, ubicaciones y responsables
     */
    async getAll() {
        const [sedes, ubicaciones, responsables] = await Promise.all([
            this.getSedes(),
            this.getUbicaciones(),
            this.getResponsables()
        ])

        return { sedes, ubicaciones, responsables }
    },
}
