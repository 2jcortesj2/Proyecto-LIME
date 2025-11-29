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
          <button type="button" class="btn-secondary" @click="$emit('close')" :disabled="submitLoading">
            Cancelar
          </button>
          <button type="button" class="btn-danger" @click="$emit('confirm')" :disabled="submitLoading">
            {{ submitLoading ? 'Eliminando...' : 'Eliminar' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  show: Boolean,
  responsable: Object,
  submitLoading: Boolean
})

defineEmits(['close', 'confirm'])
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.modal-small {
  max-width: 450px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px;
  border-bottom: 1px solid #e0e0e0;
}

.modal-header h2 {
  margin: 0;
  color: #006633;
  font-size: 24px;
}

.modal-close {
  background: none;
  border: none;
  font-size: 32px;
  cursor: pointer;
  color: #757575;
  line-height: 1;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.modal-close:hover {
  background: #f0f0f0;
  color: #212121;
}

.modal-body {
  padding: 24px;
}

.form-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
}

.btn-secondary,
.btn-danger {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-secondary {
  background: #f5f5f5;
  color: #424242;
}

.btn-secondary:hover:not(:disabled) {
  background: #e0e0e0;
}

.btn-danger {
  background: #d32f2f;
  color: white;
}

.btn-danger:hover:not(:disabled) {
  background: #b71c1c;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
}

.btn-secondary:disabled,
.btn-danger:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
