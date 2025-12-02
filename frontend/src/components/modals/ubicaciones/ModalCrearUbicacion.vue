<template>
  <div v-if="show" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Nueva Ubicación</h2>
        <button class="modal-close" @click="handleClose">×</button>
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
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
              {{ loading ? 'Creando...' : 'Crear Ubicación' }}
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
  sedeId: Number // Opcional: pre-seleccionar sede
})

const emit = defineEmits(['close', 'created'])

const { createUbicacion, sedes, responsables, fetchSedes, fetchResponsables } = useSedesUbicaciones()
const { errors, validateUbicacion, clearFieldError, clearErrors } = useFormValidation()
const { showSuccess, showError } = useNotifications()

const formData = ref({
  nombre: '',
  sede: props.sedeId || '',
  responsable: '',
  estado: true
})

const loading = ref(false)
const successMessage = ref('')

onMounted(async () => {
  await fetchSedes()
  await fetchResponsables()
})

watch(() => props.show, (newVal) => {
  if (newVal) {
    resetForm()
  }
})

watch(() => props.sedeId, (newSedeId) => {
  if (newSedeId) {
    formData.value.sede = newSedeId
  }
})

function resetForm() {
  formData.value = {
    nombre: '',
    sede: props.sedeId || '',
    responsable: '',
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
    
    await createUbicacion(dataToSend)
    
    showSuccess(UBICACION_CONSTANTS.MESSAGES.CREATE_SUCCESS)
    emit('created')
    emit('close')
  } catch (error) {
    console.error('Error al crear ubicación:', error)
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        UBICACION_CONSTANTS.MESSAGES.CREATE_ERROR
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
