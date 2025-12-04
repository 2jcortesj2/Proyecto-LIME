<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-container">
      <div class="modal-header">
        <h3><AppIcon name="trash" size="16" /> Eliminar Mantenimiento</h3>
        <button class="btn-close" @click="$emit('close')"><AppIcon name="close" size="16" /></button>
      </div>

      <div class="modal-body">
        <div class="warning-icon"><AppIcon name="alert" size="16" /></div>
        <p class="confirmation-text">
          ¿Estás seguro de que deseas eliminar este registro de mantenimiento?
        </p>
        
        <div class="maintenance-details" v-if="mantenimiento">
          <div class="detail-row">
            <strong>Equipo:</strong> 
            <span>{{ mantenimiento.equipo?.codigo_interno }} - {{ mantenimiento.equipo?.nombre_equipo }}</span>
          </div>
          <div class="detail-row">
            <strong>Tipo:</strong> 
            <span>{{ mantenimiento.tipo_mantenimiento }}</span>
          </div>
          <div class="detail-row">
            <strong>Fecha:</strong> 
            <span>{{ mantenimiento.mes_mantenimiento }}/{{ mantenimiento.anio_mantenimiento }}</span>
          </div>
        </div>

        <p class="warning-text">
          Esta acción no se puede deshacer.
        </p>

        <div class="modal-actions">
          <button type="button" class="btn btn-secondary" @click="$emit('close')">
            Cancelar
          </button>
          <button 
            type="button" 
            class="btn btn-danger" 
            @click="handleDelete" 
            :disabled="loading"
          >
            {{ loading ? 'Eliminando...' : 'Sí, Eliminar' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { mantenimientosAPI } from '../../../services/api'
import { useNotifications } from '../../../composables/useNotifications'

const props = defineProps({
  mantenimiento: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['close', 'deleted'])
const { showSuccess, showError } = useNotifications()

const loading = ref(false)

async function handleDelete() {
  try {
    loading.value = true
    await mantenimientosAPI.delete(props.mantenimiento.id)
    showSuccess('Mantenimiento eliminado exitosamente')
    emit('deleted')
    emit('close')
  } catch (error) {
    console.error('Error eliminando mantenimiento:', error)
    showError(error.response?.data?.message || 'Error al eliminar mantenimiento')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-container {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 450px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from { 
    opacity: 0;
    transform: translateY(20px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  padding: 15px 20px;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #fff5f5; /* Light red background for danger context */
}

.modal-header h3 {
  margin: 0;
  color: #d32f2f;
  font-size: 18px;
  font-weight: 700;
}

.btn-close {
  background: none;
  border: none;
  font-size: 20px;
  color: #616161;
  cursor: pointer;
  padding: 0;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.btn-close:hover {
  background: rgba(0, 0, 0, 0.05);
  color: #212121;
}

.modal-body {
  padding: 25px;
  text-align: center;
}

.warning-icon {
  font-size: 48px;
  margin-bottom: 15px;
}

.confirmation-text {
  font-size: 16px;
  color: #212121;
  margin-bottom: 20px;
  line-height: 1.5;
}

.maintenance-details {
  background: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
  text-align: left;
  font-size: 14px;
  border: 1px solid #e0e0e0;
}

.detail-row {
  margin-bottom: 8px;
  display: flex;
  justify-content: space-between;
}

.detail-row:last-child {
  margin-bottom: 0;
}

.warning-text {
  color: #d32f2f;
  font-size: 13px;
  font-weight: 600;
  margin-bottom: 25px;
}

.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
}

.btn {
  padding: 10px 24px;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-secondary:hover {
  background: #d0d0d0;
}

.btn-danger {
  background: #d32f2f;
  color: white;
}

.btn-danger:hover:not(:disabled) {
  background: #b71c1c;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(211, 47, 47, 0.2);
}

.btn-danger:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
