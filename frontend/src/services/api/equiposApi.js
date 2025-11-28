/**
 * Equipos API Service
 * Centralizes all API calls related to equipment (equipos)
 */

import { buildApiUrl, apiRequest, API_ENDPOINTS } from '../../config/api'

/**
 * Fetch all equipos
 * @returns {Promise<Array>} List of equipos
 */
export async function fetchEquipos() {
    return apiRequest(API_ENDPOINTS.EQUIPOS, { method: 'GET' })
}

/**
 * Fetch detailed information for a specific equipo
 * @param {number|string} id - Equipo ID
 * @returns {Promise<Object>} Equipo details with history
 */
export async function fetchEquipoDetalle(id) {
    return apiRequest(`${API_ENDPOINTS.EQUIPOS}${id}/`, { method: 'GET' })
}

/**
 * Create a new equipo
 * @param {Object} equipoData - Equipment data
 * @returns {Promise<Object>} Created equipo
 */
export async function createEquipo(equipoData) {
    return apiRequest(API_ENDPOINTS.EQUIPOS, {
        method: 'POST',
        body: JSON.stringify(equipoData)
    })
}

/**
 * Update an existing equipo
 * @param {number|string} id - Equipo ID
 * @param {Object} equipoData - Updated equipment data
 * @returns {Promise<Object>} Updated equipo
 */
export async function updateEquipo(id, equipoData) {
    return apiRequest(`${API_ENDPOINTS.EQUIPOS}${id}/`, {
        method: 'PUT',
        body: JSON.stringify(equipoData)
    })
}

/**
 * Delete (deactivate) an equipo
 * @param {number|string} id - Equipo ID
 * @returns {Promise<Object>} Response message
 */
export async function deleteEquipo(id) {
    return apiRequest(`${API_ENDPOINTS.EQUIPOS}${id}/`, {
        method: 'DELETE'
    })
}

/**
 * Fetch catalog data (sedes, servicios, responsables) for forms
 * @returns {Promise<Object>} Object containing catalogs
 */
export async function fetchCatalogs() {
    const [sedes, servicios, responsables] = await Promise.all([
        apiRequest(API_ENDPOINTS.SEDES, { method: 'GET' }),
        apiRequest(API_ENDPOINTS.SERVICIOS, { method: 'GET' }),
        apiRequest(API_ENDPOINTS.RESPONSABLES, { method: 'GET' })
    ])

    return { sedes, servicios, responsables }
}

/**
 * Filter servicios by sede
 * @param {Array} servicios - All servicios
 * @param {number|string} sedeId - Sede ID to filter by
 * @returns {Array} Filtered servicios
 */
export function filterServiciosBySede(servicios, sedeId) {
    if (!sedeId) return servicios
    return servicios.filter(s => s.sede === sedeId)
}
