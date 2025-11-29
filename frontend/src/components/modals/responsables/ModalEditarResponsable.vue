<template>
  <div v-if="show" class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Editar Responsable</h2>
        <button class="modal-close" @click="$emit('close')">×</button>
      </div>
      
      <div class="modal-body">
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        <div v-if="formErrors.submit" class="error-message">{{ formErrors.submit }}</div>
        
        <form @submit.prevent="$emit('submit')">
          <div class="form-group">
            <label class="form-label required">Nombre Completo</label>
            <input 
              type="text" 
              v-model="localForm.nombre_completo" 
              class="form-input"
              :class="{ 'input-error': formErrors.nombre_completo }"
            >
            <span v-if="formErrors.nombre_completo" class="error-text">{{ formErrors.nombre_completo }}</span>
          </div>

          <div class="form-group">
            <label class="form-label">Rol</label>
            <input 
              type="text" 
              v-model="localForm.rol" 
              class="form-input"
              :class="{ 'input-error': formErrors.rol }"
            >
            <span v-if="formErrors.rol" class="error-text">{{ formErrors.rol }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Email</label>
            <input 
              type="email" 
              v-model="localForm.email" 
              class="form-input"
              :class="{ 'input-error': formErrors.email }"
            >
            <span v-if="formErrors.email" class="error-text">{{ formErrors.email }}</span>
          </div>

          <div class="form-group">
            <label class="form-label">Teléfono</label>
            <input 
              type="text" 
              v-model="localForm.telefono" 
              class="form-input"
            >
          </div>

          <div class="form-actions">
            <button type="button" class="btn-secondary" @click="$emit('close')" :disabled="submitLoading">
              Cancelar
            </button>
            <button type="submit" class="btn-primary" :disabled="submitLoading">
              {{ submitLoading ? 'Guardando...' : 'Guardar Cambios' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  show: Boolean,
  formData: Object,
  formErrors: Object,
  successMessage: String,
  submitLoading: Boolean
})

const emit = defineEmits(['close', 'submit', 'update:formData'])

const localForm = computed({
  get: () => props.formData,
  set: (value) => emit('update:formData', value)
})
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

.form-group {
  margin-bottom: 20px;
}

.form-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #424242;
}

.form-label.required::after {
  content: ' *';
  color: #d32f2f;
}

.form-input {
  width: 100%;
  padding: 12px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 15px;
  transition: all 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.form-input.input-error {
  border-color: #d32f2f;
}

.error-text {
  display: block;
  color: #d32f2f;
  font-size: 13px;
  margin-top: 4px;
}

.success-message {
  background: #e8f5e9;
  color: #2e7d32;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 20px;
  font-weight: 600;
}

.error-message {
  background: #ffebee;
  color: #c62828;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.form-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
}

.btn-primary,
.btn-secondary {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-primary {
  background: #006633;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #004d26;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 102, 51, 0.3);
}

.btn-secondary {
  background: #f5f5f5;
  color: #424242;
}

.btn-secondary:hover:not(:disabled) {
  background: #e0e0e0;
}

.btn-primary:disabled,
.btn-secondary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
