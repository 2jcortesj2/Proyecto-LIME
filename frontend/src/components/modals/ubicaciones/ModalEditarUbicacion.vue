<template>
  <div v-if="show" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Editar Ubicación</h2>
        <button class="modal-close" @click="handleClose"><AppIcon name="close" size="16" /></button>
      </div>
      
      <div class="modal-body">
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        <div v-if="errors.submit" class="error-message">{{ errors.submit }}</div>
        
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label class="form-label required">Sede</label>
            <select 
              v-model="formData.sede" 
              class="form-select"
              :class="{ 'input-error': errors.sede }"
              @change="clearFieldError('sede')"
            >
              <option value="">Seleccione una sede</option>
              <option v-for="sede in sedes" :key="sede.id" :value="sede.id">
                {{ sede.nombre }} - {{ sede.ciudad }}
              </option>
            </select>
            <span v-if="errors.sede" class="error-text">{{ errors.sede }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Nombre de la Ubicación</label>
            <input 
              type="text" 
              v-model="formData.nombre" 
              class="form-input"
              :class="{ 'input-error': errors.nombre }"
              placeholder="Ej: Laboratorio Principal"
              @input="clearFieldError('nombre')"
            >
            <span v-if="errors.nombre" class="error-text">{{ errors.nombre }}</span>
          </div>

          <div class="form-group">
            <label class="form-label">Responsable</label>
            <select 
              v-model="formData.responsable" 
              class="form-select"
            >
              <option value="">Sin responsable asignado</option>
              <option v-for="responsable in responsables" :key="responsable.id" :value="responsable.id">
                {{ responsable.nombre_completo }} - {{ responsable.rol }}
              </option>
            </select>
            <span class="helper-text">Opcional</span>
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
import { ref, watch, onMounted } from 'vue'
import { useSedesUbicaciones } from '../../../composables/useSedesUbicaciones'
import { useFormValidation } from '../../../composables/useFormValidation'
import { useNotifications } from '../../../composables/useNotifications'
import { UBICACION_CONSTANTS } from '../../../constants/sedes'

const props = defineProps({
  show: Boolean,
  ubicacion: Object
})

const emit = defineEmits(['close', 'updated'])

const { updateUbicacion, sedes, responsables, fetchSedes, fetchResponsables } = useSedesUbicaciones()
const { errors, validateUbicacion, clearFieldError, clearErrors } = useFormValidation()
const { showSuccess, showError } = useNotifications()

const formData = ref({
  nombre: '',
  sede: '',
  responsable: ''
})

const loading = ref(false)
const successMessage = ref('')

onMounted(async () => {
  await fetchSedes()
  await fetchResponsables()
})

watch(() => props.ubicacion, (newUbicacion) => {
  if (newUbicacion) {
    formData.value = {
      nombre: newUbicacion.nombre || '',
      sede: newUbicacion.sede?.id || newUbicacion.sede || '',
      responsable: newUbicacion.responsable?.id || newUbicacion.responsable || ''
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
  if (!validateUbicacion(formData.value)) {
    return
  }

  try {
    loading.value = true
    
    // Preparar datos (convertir responsable vacío a null)
    const dataToSend = {
      ...formData.value,
      responsable: formData.value.responsable || null
    }
    
    await updateUbicacion(props.ubicacion.id, dataToSend)
    
    showSuccess(UBICACION_CONSTANTS.MESSAGES.UPDATE_SUCCESS)
    emit('updated')
    emit('close')
  } catch (error) {
    console.error('Error al actualizar ubicación:', error)
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        UBICACION_CONSTANTS.MESSAGES.UPDATE_ERROR
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

.helper-text {
  display: block;
  font-size: 12px;
  color: #757575;
  margin-top: 4px;
}
</style>
