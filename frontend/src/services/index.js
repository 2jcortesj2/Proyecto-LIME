/**
 * Índice de servicios - Exporta todos los servicios desde un solo lugar
 * Uso: import { equiposService, trasladosService } from '@/services'
 */

export { equiposService } from './equipos.service'
export { trasladosService } from './traslados.service'
export { catalogsService } from './catalogs.service'

// También exporta el cliente API base por si se necesita
export { default as apiClient } from './api'

// Exporta las API específicas para uso directo si se necesita
export {
    equiposAPI,
    mantenimientosAPI,
    sedesAPI,
    ubicacionesAPI,
    trasladosAPI,
    responsablesAPI,
    dashboardAPI
} from './api'
