/**
 * Normaliza texto removiendo tildes y convirtiéndolo a minúsculas
 * para comparaciones case-insensitive y accent-insensitive
 */
export function normalizeText(text) {
    if (!text) return ''
    return text
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
}

/**
 * Filtra un array de equipos basado en un término de búsqueda
 * Busca en: código interno, nombre, marca, modelo, sede, servicio
 */
export function filterEquiposBySearch(equipos, searchTerm) {
    if (!searchTerm || searchTerm.trim() === '') {
        return equipos
    }

    const normalizedSearch = normalizeText(searchTerm)

    return equipos.filter(eq => {
        const codigo = normalizeText(eq.codigo_interno)
        const nombre = normalizeText(eq.nombre_equipo)
        const marca = normalizeText(eq.marca)
        const modelo = normalizeText(eq.modelo)
        const sede = normalizeText(eq.sede?.nombre)
        const servicio = normalizeText(eq.servicio?.nombre)

        return codigo.includes(normalizedSearch) ||
            nombre.includes(normalizedSearch) ||
            marca.includes(normalizedSearch) ||
            modelo.includes(normalizedSearch) ||
            sede.includes(normalizedSearch) ||
            servicio.includes(normalizedSearch)
    })
}
