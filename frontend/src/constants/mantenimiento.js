/**
 * Constantes para el módulo de Mantenimientos
 * Centraliza todas las opciones y configuraciones hardcodeadas
 */

export const TIPOS_MANTENIMIENTO = [
    { value: 'preventivo', label: 'Preventivo', badgeClass: 'badge-success' },
    { value: 'correctivo', label: 'Correctivo', badgeClass: 'badge-danger' },
    { value: 'calibracion', label: 'Calibración', badgeClass: 'badge-info' },
    { value: 'calificacion', label: 'Calificación', badgeClass: 'badge-warning' },
    { value: 'verificacion', label: 'Verificación', badgeClass: 'badge-secondary' }
]

export const MESES_NOMBRES = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

export const MESES_NOMBRES_CORTOS = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
]

export const ESTADOS_MANTENIMIENTO = {
    VENCIDO: 'Vencido',
    PROXIMO: 'Próximo',
    NORMAL: 'Normal',
    NO_REQUIERE: 'No Requiere',
    NO_PROGRAMADO: 'No Programado'
}

export const OPCIONES_FILTRO_MESES = [
    { value: 3, label: 'Próximos 3 meses' },
    { value: 6, label: 'Próximos 6 meses' },
    { value: 12, label: 'Próximos 12 meses' }
]
