<template>
  <div v-if="show" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Eliminar Ubicación</h2>
        <button class="modal-close" @click="handleClose"><AppIcon name="close" size="16" /></button>
      </div>
      
      <div class="modal-body">
        <div v-if="errors.submit" class="error-message">{{ errors.submit }}</div>
        
        <!-- Advertencia si tiene equipos -->
        <div v-if="ubicacion && ubicacion.num_equipos > 0" class="error-message">
          <AppIcon name="close" size="16" /> <strong>No se puede eliminar esta ubicación</strong><br>
          Esta ubicación tiene {{ ubicacion.num_equipos }} equipo(s) asignado(s).
          <br><br>
          Debe trasladar o reasignar los equipos antes de eliminar la ubicación.
        </div>

        <!-- Confirmación si está vacía -->
        <div v-else>
          <div class="warning-message">
            <AppIcon name="alert" size="16" /> Esta acción eliminará permanentemente la ubicación y no se puede deshacer.
          </div>

          <div class="info-section">
            <p><strong>Ubicación a eliminar:</strong> {{ ubicacion?.nombre }}</p>
            <p><strong>Sede:</strong> {{ getSedeNombre(ubicacion?.sede) }}</p>
            <p><strong>Responsable:</strong> {{ ubicacion?.responsable || 'Sin responsable' }}</p>
            
            <div class="stat-item-safe">
              <span class="stat-label">Equipos asignados:</span>
              <span class="stat-value-safe">✓ 0 equipos</span>
            </div>
          </div>

          <p class="confirmation-text">
            ¿Está seguro que desea eliminar esta ubicación?
          </p>
        </div>

        <div class="form-actions">
          <button type="button" class="btn btn-cancel" @click="handleClose" :disabled="loading">
            {{ hasEquipment ? 'Cerrar' : 'Cancelar' }}
          </button>
          <button 
            v-if="!hasEquipment"
            type="button" 
            class="btn btn-danger" 
            @click="handleDelete" 
            :disabled="loading" 
            :class="{ loading: loading }"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
            {{ loading ? 'Eliminando...' : 'Eliminar Ubicación' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useSedesUbicaciones } from '../../../composables/useSedesUbicaciones'
import { useNotifications } from '../../../composables/useNotifications'
import { UBICACION_CONSTANTS } from '../../../constants/sedes'

const props = defineProps({
  show: Boolean,
  ubicacion: Object
})

const emit = defineEmits(['close', 'deleted'])

const { deleteUbicacion, sedes } = useSedesUbicaciones()
const { showSuccess, showError } = useNotifications()

const loading = ref(false)
const errors = ref({})

const hasEquipment = computed(() => {
  return props.ubicacion && props.ubicacion.num_equipos > 0
})

function getSedeNombre(sedeIdOrObj) {
  if (!sedeIdOrObj) return 'Desconocida'
  
  // Si es un objeto sede
  if (typeof sedeIdOrObj === 'object') {
    return sedeIdOrObj.nombre
  }
  
  // Si es un ID, buscar en la lista de sedes
  const sede = sedes.value.find(s => s.id === sedeIdOrObj)
  return sede?.nombre || 'Desconocida'
}

function handleClose() {
  if (!loading.value) {
    errors.value = {}
    emit('close')
  }
}

async function handleDelete() {
  if (!props.ubicacion || hasEquipment.value) return

  try {
    loading.value = true
    await deleteUbicacion(props.ubicacion.id)
    
    showSuccess(UBICACION_CONSTANTS.MESSAGES.DELETE_SUCCESS)
    emit('deleted')
    emit('close')
  } catch (error) {
    console.error('Error al eliminar ubicación:', error)
    
    // El backend puede devolver el error sobre equipos
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        UBICACION_CONSTANTS.MESSAGES.DELETE_ERROR
    
    showError(errorMessage)
    errors.value.submit = errorMessage
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
@import '../modal-styles.css';
@import '../button-styles.css';

.info-section {
  background: #f5f5f5;
  padding: 16px;
  border-radius: 8px;
  margin: 16px 0;
}

.info-section p {
  margin: 8px 0;
  color: #424242;
}

.stat-item-safe {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #e8f5e9;
  padding: 8px 12px;
  border-radius: 6px;
  margin-top: 12px;
}

.stat-label {
  color: #666;
  font-size: 14px;
}

.stat-value-safe {
  font-weight: 700;
  color: #2e7d32;
  font-size: 16px;
}

.confirmation-text {
  font-weight: 600;
  color: #424242;
  margin: 16px 0;
}
</style>
