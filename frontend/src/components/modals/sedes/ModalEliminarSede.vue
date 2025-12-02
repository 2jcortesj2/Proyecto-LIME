<template>
  <div v-if="show" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Desactivar Sede</h2>
        <button class="modal-close" @click="handleClose">×</button>
      </div>
      
      <div class="modal-body">
        <div v-if="errors.submit" class="error-message">{{ errors.submit }}</div>
        
        <div class="warning-message">
          ⚠️ Esta acción desactivará la sede pero NO eliminará los datos permanentemente.
        </div>

        <div class="info-section">
          <p><strong>Sede a desactivar:</strong> {{ sede?.nombre }}</p>
          <p><strong>Ciudad:</strong> {{ sede?.ciudad }}</p>
          
          <div v-if="sede" class="stats-grid">
            <div class="stat-item">
              <span class="stat-label">Ubicaciones:</span>
              <span class="stat-value">{{ sede.total_ubicaciones || 0 }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Equipos:</span>
              <span class="stat-value">{{ sede.total_equipos || 0 }}</span>
            </div>
          </div>
        </div>

        <p class="confirmation-text">
          ¿Está seguro que desea desactivar esta sede?
        </p>

        <div class="form-actions">
          <button type="button" class="btn btn-cancel" @click="handleClose" :disabled="loading">
            Cancelar
          </button>
          <button type="button" class="btn btn-danger" @click="handleDelete" :disabled="loading" :class="{ loading: loading }">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
            {{ loading ? 'Desactivando...' : 'Desactivar Sede' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useSedesUbicaciones } from '../../../composables/useSedesUbicaciones'
import { useNotifications } from '../../../composables/useNotifications'
import { SEDE_CONSTANTS } from '../../../constants/sedes'

const props = defineProps({
  show: Boolean,
  sede: Object
})

const emit = defineEmits(['close', 'deleted'])

const { deleteSede } = useSedesUbicaciones()
const { showSuccess, showError } = useNotifications()

const loading = ref(false)
const errors = ref({})

function handleClose() {
  if (!loading.value) {
    errors.value = {}
    emit('close')
  }
}

async function handleDelete() {
  if (!props.sede) return

  try {
    loading.value = true
    await deleteSede(props.sede.id)
    
    showSuccess(SEDE_CONSTANTS.MESSAGES.DELETE_SUCCESS)
    emit('deleted')
    emit('close')
  } catch (error) {
    console.error('Error al desactivar sede:', error)
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        SEDE_CONSTANTS.MESSAGES.DELETE_ERROR
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

.stats-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-top: 12px;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: white;
  padding: 8px 12px;
  border-radius: 6px;
}

.stat-label {
  color: #666;
  font-size: 14px;
}

.stat-value {
  font-weight: 700;
  color: #006633;
  font-size: 16px;
}

.confirmation-text {
  font-weight: 600;
  color: #424242;
  margin: 16px 0;
}
</style>
