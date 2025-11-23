import axios from 'axios'

// Base URL del backend Django
const API_BASE_URL = 'http://localhost:8000/api'

// Crear instancia de axios con configuración base
const apiClient = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
})

// ============================================
// EQUIPOS
// ============================================

export const equiposAPI = {
    // Obtener todos los equipos
    getAll(params = {}) {
        return apiClient.get('/equipos/', { params })
    },

    // Obtener un equipo por ID
    getById(id) {
        return apiClient.get(`/equipos/${id}/`)
    },

    // Obtener equipos próximos a mantenimiento
    getProximosMantenimiento() {
        return apiClient.get('/equipos/proximos-mantenimiento/')
    },

    // Crear nuevo equipo
    create(data) {
        return apiClient.post('/equipos/', data)
    },

    // Actualizar equipo
    update(id, data) {
        return apiClient.put(`/equipos/${id}/`, data)
    },

    // Eliminar equipo
    delete(id) {
        return apiClient.delete(`/equipos/${id}/`)
    },
}

// ============================================
// DASHBOARD
// ============================================

export const dashboardAPI = {
    // Obtener estadísticas del dashboard
    getStats() {
        return apiClient.get('/equipos/dashboard-stats/')
    },
}

// ============================================
// MANTENIMIENTOS
// ============================================

export const mantenimientosAPI = {
    // Obtener todos los mantenimientos
    getAll(params = {}) {
        return apiClient.get('/mantenimientos/', { params })
    },

    // Obtener un mantenimiento por ID
    getById(id) {
        return apiClient.get(`/mantenimientos/${id}/`)
    },

    // Crear nuevo mantenimiento
    create(data) {
        return apiClient.post('/mantenimientos/', data)
    },

    // Actualizar mantenimiento
    update(id, data) {
        return apiClient.put(`/mantenimientos/${id}/`, data)
    },

    // Eliminar mantenimiento
    delete(id) {
        return apiClient.delete(`/mantenimientos/${id}/`)
    },
}

// ============================================
// SEDES
// ============================================

export const sedesAPI = {
    getAll() {
        return apiClient.get('/sedes/')
    },

    getById(id) {
        return apiClient.get(`/sedes/${id}/`)
    },
}

// ============================================
// SERVICIOS
// ============================================

export const serviciosAPI = {
    getAll() {
        return apiClient.get('/servicios/')
    },

    getById(id) {
        return apiClient.get(`/servicios/${id}/`)
    },
}

export default apiClient
