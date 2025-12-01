import axios from 'axios'

// Base URL del backend Django - usa variables de entorno
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000'

// Crear instancia de axios con configuración base
const apiClient = axios.create({
    baseURL: API_BASE_URL + '/api',
    timeout: import.meta.env.VITE_API_TIMEOUT || 10000,
    headers: {
        'Content-Type': 'application/json',
    },
})

// Request interceptor - Agrega token de autenticación a cada petición
apiClient.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('authToken')
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }
        return config
    },
    (error) => {
        return Promise.reject(error)
    }
)

// Response interceptor - Manejo centralizado de errores
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        // Si recibimos 401 (No autorizado), limpiar sesión y redirigir a login
        if (error.response?.status === 401) {
            localStorage.removeItem('authToken')
            window.location.href = '/login'
        }

        // Log de errores para debugging en desarrollo
        if (import.meta.env.DEV) {
            console.error('API Error:', {
                url: error.config?.url,
                method: error.config?.method,
                status: error.response?.status,
                message: error.response?.data?.message || error.message
            })
        }

        return Promise.reject(error)
    }
)

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

    // Obtener estadísticas de mantenimiento
    getMaintenanceStats() {
        return apiClient.get('/equipos/maintenance-stats/')
    },

    // Reprogramar mantenimiento
    reprogramar(id, fecha) {
        return apiClient.post(`/equipos/${id}/reprogramar/`, { nueva_fecha: fecha })
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

    // Obtener mantenimientos por equipo
    getByEquipo(equipoId) {
        return apiClient.get('/mantenimientos/', {
            params: { equipo_id: equipoId }
        })
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
// UBICACIONES
// ============================================

export const ubicacionesAPI = {
    getAll() {
        return apiClient.get('/ubicaciones/')
    },

    getById(id) {
        return apiClient.get(`/ubicaciones/${id}/`)
    },
}

// ============================================
// TRASLADOS
// ============================================

export const trasladosAPI = {
    // Obtener todos los traslados
    getAll(params = {}) {
        return apiClient.get('/traslados/', { params })
    },

    // Obtener traslados por equipo
    getByEquipo(equipoId) {
        return apiClient.get('/traslados/', {
            params: { equipo_id: equipoId }
        })
    },

    // Crear nuevo traslado
    create(data) {
        return apiClient.post('/traslados/', data)
    },

    // Actualizar traslado
    update(id, data) {
        return apiClient.put(`/traslados/${id}/`, data)
    },

    // Eliminar traslado
    delete(id) {
        return apiClient.delete(`/traslados/${id}/`)
    },
}

// ============================================
// RESPONSABLES
// ============================================

export const responsablesAPI = {
    // Obtener todos los responsables
    getAll() {
        return apiClient.get('/responsables/')
    },

    // Obtener un responsable por ID
    getById(id) {
        return apiClient.get(`/responsables/${id}/`)
    },

    // Crear nuevo responsable
    create(data) {
        return apiClient.post('/responsables/', data)
    },

    // Actualizar responsable
    update(id, data) {
        return apiClient.put(`/responsables/${id}/`, data)
    },

    // Eliminar responsable
    delete(id) {
        return apiClient.delete(`/responsables/${id}/`)
    },
}

export default apiClient
