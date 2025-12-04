<template>
  <div v-if="show" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Editar Sede</h2>
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
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
              {{ loading ? 'Guardando...' : 'Guardar Cambios' }}
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
  show: Boolean,
  sede: Object
})

const emit = defineEmits(['close', 'updated'])

const { updateSede } = useSedesUbicaciones()
const { errors, validateSede, clearFieldError, clearErrors } = useFormValidation()
const { showSuccess, showError } = useNotifications()

const formData = ref({
  nombre: '',
  direccion: '',
  ciudad: '',
  telefono: ''
})

const loading = ref(false)
const successMessage = ref('')

watch(() => props.sede, (newSede) => {
  if (newSede) {
    formData.value = {
      nombre: newSede.nombre || '',
      direccion: newSede.direccion || '',
      ciudad: newSede.ciudad || '',
      telefono: newSede.telefono || ''
    }
  }
}, { immediate: true })

watch(() => props.show, (newVal) => {
  if (newVal) {
    clearErrors()
    successMessage.value = ''
  }
})

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
    await updateSede(props.sede.id, formData.value)
    
    showSuccess(SEDE_CONSTANTS.MESSAGES.UPDATE_SUCCESS)
    emit('updated')
    emit('close')
  } catch (error) {
    console.error('Error al actualizar sede:', error)
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        SEDE_CONSTANTS.MESSAGES.UPDATE_ERROR
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
