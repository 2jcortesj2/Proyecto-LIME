<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header">
        <div class="modal-title">🔐 Verificación de Seguridad</div>
        <button class="close-btn" @click="handleClose">&times;</button>
      </div>
      <div class="modal-body">
        <div class="password-group">
          <p style="margin-bottom: 15px; color: #616161; font-size: 14px;">
            Este campo es <strong>crítico para la integridad del sistema</strong>. Para modificarlo, ingrese su contraseña de administrador:
          </p>
          <div class="form-group">
            <label class="form-label required">Campo a modificar:</label>
            <input type="text" class="form-input" disabled :value="fieldName">
          </div>
          <div class="form-group">
            <label class="form-label required">Contraseña de Administrador:</label>
            <input 
              type="password" 
              class="form-input" 
              v-model="password"
              placeholder="Ingrese su contraseña"
              @keyup.enter="handleConfirm"
            >
            <span v-if="errors.password" class="error-message">{{ errors.password }}</span>
          </div>
          <div v-if="errors.submit" class="alert alert-warning" style="margin-top: 15px;">
            {{ errors.submit }}
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="handleClose" :disabled="loading">Cancelar</button>
        <button class="btn btn-danger" @click="handleConfirm" :disabled="loading">
          <span v-if="loading">Verificando...</span>
          <span v-else>🔓 Desbloquear Campo</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  fieldName: {
    type: String,
    default: 'Campo protegido'
  }
})

const emit = defineEmits(['close', 'confirm'])

const password = ref('')
const loading = ref(false)
const errors = ref({})

// Reset cuando cambia el campo
watch(() => props.fieldName, () => {
  password.value = ''
  errors.value = {}
})

function validate() {
  errors.value = {}
  
  if (!password.value) {
    errors.value.password = 'La contraseña es requerida'
    return false
  }
  
  return true
}

async function handleConfirm() {
  if (!validate()) return
  
  loading.value = true
  errors.value = {}
  
  try {
    emit('confirm', password.value)
    // No reset here, parent will close modal
  } catch (err) {
    errors.value.submit = err.message || 'Error al verificar'
    loading.value = false
  }
}

function handleClose() {
  password.value = ''
  errors.value = {}
  loading.value = false
  emit('close')
}

// Reset loading cuando el modal se cierra desde el padre
watch(() => props.show, (newShow) => {
  if (!newShow) {
    loading.value = false
  }
})
</script>

<style scoped>
@import './modal-styles.css';
</style>
