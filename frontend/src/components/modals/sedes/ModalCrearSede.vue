<template>
  <div v-if="show" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Nueva Sede</h2>
        <button class="modal-close" @click="handleClose"><AppIcon name="close" size="16" /></button>
      </div>
      
      <div class="modal-body">
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        <div v-if="errors.submit" class="error-message">{{ errors.submit }}</div>
        
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label class="form-label required">Nombre de la Sede</label>
            <input 
              type="text" 
              v-model="formData.nombre" 
              class="form-input"
              :class="{ 'input-error': errors.nombre }"
              placeholder="Ej: Sede Principal"
              @input="clearFieldError('nombre')"
            >
            <span v-if="errors.nombre" class="error-text">{{ errors.nombre }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Dirección</label>
            <input 
              type="text" 
              v-model="formData.direccion" 
              class="form-input"
              :class="{ 'input-error': errors.direccion }"
              placeholder="Ej: Calle 123 #45-67"
              @input="clearFieldError('direccion')"
            >
            <span v-if="errors.direccion" class="error-text">{{ errors.direccion }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Ciudad</label>
            <input 
              type="text" 
              v-model="formData.ciudad" 
              class="form-input"
              :class="{ 'input-error': errors.ciudad }"
              placeholder="Ej: Medellín"
              @input="clearFieldError('ciudad')"
            >
            <span v-if="errors.ciudad" class="error-text">{{ errors.ciudad }}</span>
          </div>

          <div class="form-group">
            <label class="form-label">Teléfono</label>
            <input 
              type="text" 
              v-model="formData.telefono" 
              class="form-input"
              :class="{ 'input-error': errors.telefono }"
              placeholder="Ej: +57 (4) 123 4567"
              @input="clearFieldError('telefono')"
            >
            <span v-if="errors.telefono" class="error-text">{{ errors.telefono }}</span>
          </div>

          <div class="form-actions">
            <button type="button" class="btn btn-cancel" @click="handleClose" :disabled="loading">
              Cancelar
            </button>
            <button type="submit" class="btn btn-primary" :disabled="loading" :class="{ loading: loading }">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
              {{ loading ? 'Creando...' : 'Crear Sede' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useSedesUbicaciones } from '../../../composables/useSedesUbicaciones'
import { useFormValidation } from '../../../composables/useFormValidation'
import { useNotifications } from '../../../composables/useNotifications'
import { SEDE_CONSTANTS } from '../../../constants/sedes'

const props = defineProps({
  show: Boolean
})

const emit = defineEmits(['close', 'created'])

const { createSede } = useSedesUbicaciones()
const { errors, validateSede, clearFieldError, clearErrors } = useFormValidation()
const { showSuccess, showError } = useNotifications()

const formData = ref({
  nombre: '',
  direccion: '',
  ciudad: '',
  telefono: '',
  estado: true
})

const loading = ref(false)
const successMessage = ref('')

watch(() => props.show, (newVal) => {
  if (newVal) {
    resetForm()
  }
})

function resetForm() {
  formData.value = {
    nombre: '',
    direccion: '',
    ciudad: '',
    telefono: '',
    estado: true
  }
  clearErrors()
  successMessage.value = ''
}

function handleClose() {
  if (!loading.value) {
    emit('close')
  }
}

async function handleSubmit() {
  // Validar formulario
  if (!validateSede(formData.value)) {
    return
  }

  try {
    loading.value = true
    await createSede(formData.value)
    
    showSuccess(SEDE_CONSTANTS.MESSAGES.CREATE_SUCCESS)
    emit('created')
    emit('close')
  } catch (error) {
    console.error('Error al crear sede:', error)
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        SEDE_CONSTANTS.MESSAGES.CREATE_ERROR
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
</style>
