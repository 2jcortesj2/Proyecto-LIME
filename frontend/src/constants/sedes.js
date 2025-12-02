export const SEDE_CONSTANTS = {
    MESSAGES: {
        CREATE_SUCCESS: 'Sede creada exitosamente',
        UPDATE_SUCCESS: 'Sede actualizada exitosamente',
        DELETE_SUCCESS: 'Sede desactivada exitosamente',
        CREATE_ERROR: 'Error al crear la sede',
        UPDATE_ERROR: 'Error al actualizar la sede',
        DELETE_ERROR: 'Error al desactivar la sede',
        FETCH_ERROR: 'Error al cargar las sedes'
    },
    VALIDATION: {
        NOMBRE_REQUIRED: 'El nombre de la sede es requerido',
        NOMBRE_MIN_LENGTH: 'El nombre debe tener al menos 3 caracteres',
        DIRECCION_REQUIRED: 'La dirección es requerida',
        CIUDAD_REQUIRED: 'La ciudad es requerida',
        TELEFONO_INVALID: 'El formato del teléfono no es válido'
    }
}

export const UBICACION_CONSTANTS = {
    MESSAGES: {
        CREATE_SUCCESS: 'Ubicación creada exitosamente',
        UPDATE_SUCCESS: 'Ubicación actualizada exitosamente',
        DELETE_SUCCESS: 'Ubicación eliminada exitosamente',
        DELETE_ERROR_HAS_EQUIPMENT: 'No se puede eliminar una ubicación con equipos asignados',
        CREATE_ERROR: 'Error al crear la ubicación',
        UPDATE_ERROR: 'Error al actualizar la ubicación',
        DELETE_ERROR: 'Error al eliminar la ubicación',
        FETCH_ERROR: 'Error al cargar las ubicaciones'
    },
    VALIDATION: {
        NOMBRE_REQUIRED: 'El nombre de la ubicación es requerido',
        NOMBRE_MIN_LENGTH: 'El nombre debe tener al menos 3 caracteres',
        SEDE_REQUIRED: 'Debe seleccionar una sede'
    }
}
