<template>
  <div v-if="show" class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content modal-small">
      <div class="modal-header">
        <h2>Confirmar Eliminación</h2>
        <button class="modal-close" @click="$emit('close')">×</button>
      </div>
      
      <div class="modal-body">
        <p style="margin-bottom: 20px;">
          ¿Está seguro que desea eliminar al responsable <strong>{{ responsable?.nombre_completo }}</strong>?
        </p>
        <p style="color: #d32f2f; font-size: 14px;">
          Esta acción no se puede deshacer.
        </p>
        
        <div class="form-actions">
          <button type="button" class="btn-secondary" @click="$emit('close')" :disabled="loading">
            Cancelar
          </button>
          <button type="button" class="btn-danger" @click="confirmDelete" :disabled="loading">
            {{ loading ? 'Eliminando...' : 'Eliminar' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { buildApiUrl } from '../../config/api'

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  responsable: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['close', 'confirm'])

const loading = ref(false)

async function confirmDelete() {
  if (!props.responsable) return
  
  loading.value = true
  
  try {
    const response = await fetch(buildApiUrl(`/api/responsables/${props.responsable.id}/`), {
      method: 'DELETE'
    })
    
    if (!response.ok) {
      throw new Error('Error al eliminar el responsable')
    }
    
    // Emit confirm event to parent
    emit('confirm')
    emit('close')
    
  } catch (err) {
    console.error('Error deleting responsable:', err)
    alert('Error al eliminar el responsable. Puede estar asociado a equipos.')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
/* Modal Overlay */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(3px);
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.modal-small {
  max-width: 500px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #e0e0e0;
  background: linear-gradient(135deg, #d32f2f 0%, #b71c1c 100%);
  color: white;
  border-radius: 12px 12px 0 0;
}

.modal-header h2 {
  margin: 0;
  font-size: 22px;
  font-weight: 600;
}

.modal-close {
  background: none;
  border: none;
  font-size: 32px;
  color: white;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: all 0.2s;
}

.modal-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

.modal-body {
  padding: 24px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.btn-secondary, .btn-danger {
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  border: none;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-secondary:hover:not(:disabled) {
  background: #d5d5d5;
}

.btn-danger {
  background: #f44336;
  color: white;
}

.btn-danger:hover:not(:disabled) {
  background: #d32f2f;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(244, 67, 54, 0.3);
}

.btn-secondary:disabled,
.btn-danger:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
