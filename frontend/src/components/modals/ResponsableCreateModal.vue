<template>
  <div v-if="show" class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Nuevo Responsable</h2>
        <button class="modal-close" @click="$emit('close')">×</button>
      </div>
      
      <div class="modal-body">
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        <div v-if="formErrors.submit" class="error-message">{{ formErrors.submit }}</div>
        
        <form @submit.prevent="submitForm">
          <div class="form-group">
            <label class="form-label required">Nombre Completo</label>
            <input 
              type="text" 
              v-model="form.nombre_completo" 
              class="form-input"
              :class="{ 'input-error': formErrors.nombre_completo }"
              placeholder="Ej: Juan Pérez"
            >
            <span v-if="formErrors.nombre_completo" class="error-text">{{ formErrors.nombre_completo }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Rol</label>
            <input 
              type="text" 
              v-model="form.rol" 
              class="form-input"
              :class="{ 'input-error': formErrors.rol }"
              placeholder="Ej: Ingeniero Biomédico"
            >
            <span v-if="formErrors.rol" class="error-text">{{ formErrors.rol }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Email</label>
            <input 
              type="email" 
              v-model="form.email" 
              class="form-input"
              :class="{ 'input-error': formErrors.email }"
              placeholder="Ej: juan.perez@hospital.com"
            >
            <span v-if="formErrors.email" class="error-text">{{ formErrors.email }}</span>
          </div>

          <div class="form-group">
            <label class="form-label">Teléfono</label>
            <input 
              type="text" 
              v-model="form.telefono" 
              class="form-input"
              placeholder="Ej: +57 300 123 4567"
            >
          </div>

          <div class="form-actions">
            <button type="button" class="btn-secondary" @click="$emit('close')" :disabled="submitLoading">
              Cancelar
            </button>
            <button type="submit" class="btn-primary" :disabled="submitLoading">
              {{ submitLoading ? 'Guardando...' : 'Guardar' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { buildApiUrl } from '../../config/api'

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['close', 'success'])

const form = ref({
  nombre_completo: '',
  rol: '',
  email: '',
  telefono: '',
  activo: true
})

const submitLoading = ref(false)
const formErrors = ref({})
const successMessage = ref('')

// Reset form when modal is closed
watch(() => props.show, (newVal) => {
  if (!newVal) {
    resetForm()
  }
})

function resetForm() {
  form.value = {
    nombre_completo: '',
    rol: '',
    email: '',
    telefono: '',
    activo: true
  }
  formErrors.value = {}
  successMessage.value = ''
}

function validateForm() {
  const errors = {}
  
  if (!form.value.nombre_completo?.trim()) {
    errors.nombre_completo = 'El nombre es requerido'
  }
  if (!form.value.rol?.trim()) {
    errors.rol = 'El rol es requerido'
  }
  if (!form.value.email?.trim()) {
    errors.email = 'El email es requerido'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
    errors.email = 'El email no es válido'
  }
  
  formErrors.value = errors
  return Object.keys(errors).length === 0
}

async function submitForm() {
  if (!validateForm()) {
    successMessage.value = ''
    return
  }
  
  submitLoading.value = true
  successMessage.value = ''
  
  try {
    const response = await fetch(buildApiUrl('/api/responsables/'), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(form.value)
    })
    
    if (!response.ok) {
      const errorData = await response.json()
      console.error('Error response:', errorData)
      throw new Error(errorData.detail || 'Error al crear el responsable')
    }
    
    successMessage.value = '✅ Responsable creado exitosamente'
    
    // Emit success event to parent
    setTimeout(() => {
      emit('success')
      emit('close')
      resetForm()
    }, 1500)
    
  } catch (err) {
    console.error('Error creating responsable:', err)
    formErrors.value = { submit: err.message || 'Error al crear el responsable. Por favor, intente nuevamente.' }
  } finally {
    submitLoading.value = false
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

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #e0e0e0;
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
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

/* Form Styles */
.form-group {
  margin-bottom: 20px;
}

.form-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #424242;
  font-size: 14px;
}

.form-label.required::after {
  content: ' *';
  color: #f44336;
}

.form-input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.2s;
}

.form-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.form-input.input-error {
  border-color: #f44336;
}

.error-text {
  display: block;
  color: #f44336;
  font-size: 12px;
  margin-top: 4px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.btn-primary, .btn-secondary {
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  border: none;
}

.btn-primary {
  background: #006633;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #2d5016;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.3);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-secondary:hover:not(:disabled) {
  background: #d5d5d5;
}

/* Messages */
.success-message {
  background: #e8f5e9;
  color: #2e7d32;
  padding: 12px 16px;
  border-radius: 6px;
  margin-bottom: 16px;
  border-left: 4px solid #4caf50;
}

.error-message {
  background: #ffebee;
  color: #c62828;
  padding: 12px 16px;
  border-radius: 6px;
  margin-bottom: 16px;
  border-left: 4px solid #f44336;
}
</style>
