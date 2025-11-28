/**
 * API Configuration
 * Centralizes API base URL and provides helper functions
 */

/**
 * Get the API base URL from environment variables
 * @returns {string} The base URL for the API
 */
export function getApiUrl() {
    return import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000'
}

/**
 * Build a full API endpoint URL
 * @param {string} endpoint - The endpoint path (e.g., '/api/equipos/')
 * @returns {string} The complete URL
 */
export function buildApiUrl(endpoint) {
    const baseUrl = getApiUrl()
    // Remove trailing slash from base URL if present
    const cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    // Ensure endpoint starts with /
    const cleanEndpoint = endpoint.startsWith('/') ? endpoint : `/${endpoint}`
    return `${cleanBaseUrl}${cleanEndpoint}`
}

/**
 * Common API endpoints
 */
export const API_ENDPOINTS = {
    EQUIPOS: '/api/equipos/',
    RESPONSABLES: '/api/responsables/',
    SEDES: '/api/sedes/',
    SERVICIOS: '/api/servicios/',
    TRASLADOS: '/api/traslados/',
    MANTENIMIENTOS: '/api/mantenimientos/',
    DASHBOARD_STATS: '/api/equipos/dashboard-stats/',
    MAINTENANCE_STATS: '/api/equipos/maintenance-stats/',
}

/**
 * Helper function to make API requests
 * @param {string} endpoint - The API endpoint
 * @param {object} options - Fetch options (method, headers, body, etc.)
 * @returns {Promise<any>} The response data
 */
export async function apiRequest(endpoint, options = {}) {
    const url = buildApiUrl(endpoint)

    const defaultHeaders = {
        'Content-Type': 'application/json',
    }

    const config = {
        ...options,
        headers: {
            ...defaultHeaders,
            ...options.headers,
        },
    }

    const response = await fetch(url, config)

    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}))
        throw new Error(errorData.detail || errorData.message || `HTTP error! status: ${response.status}`)
    }

    return response.json()
}
