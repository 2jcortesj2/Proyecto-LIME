<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 600px;">
      <div class="modal-header">
        <div class="modal-title">⚠️ Dar de Baja Equipo</div>
        <button class="close-btn" @click="handleClose">&times;</button>
      </div>
      <div class="modal-body">
        <div class="alert alert-warning">
          <span style="font-size: 20px;">⚠️</span>
          <div><strong>Advertencia:</strong> Esta acción desactivará el equipo del inventario activo. El equipo quedará registrado en el historial pero no aparecerá en los reportes de equipos activos.</div>
        </div>

        <div class="info-box">
          <div class="info-box-title">Equipo a dar de baja</div>
          <p style="margin-top: 10px;"><strong>Código:</strong> {{ equipo?.codigo_interno || 'N/A' }}</p>
          <p><strong>Nombre:</strong> {{ equipo?.nombre_equipo || 'N/A' }}</p>
          <p><strong>Marca/Modelo:</strong> {{ equipo?.marca }} {{ equipo?.modelo }}</p>
        </div>

        <div class="form-group full-width">
          <label class="form-label required">Motivo de la Baja</label>
          <textarea 
            class="form-textarea" 
            v-model="motivo"
            placeholder="Describa el motivo de la baja del equipo..." 
            style="min-height: 120px;"
          ></textarea>
          <span v-if="errors.motivo" class="error-message">{{ errors.motivo }}</span>
        </div>

        <div class="password-group">
          <div style="font-weight: 600; color: #f44336; margin-bottom: 10px;">🔒 Autorización Requerida</div>
          <p style="font-size: 13px; color: #616161; margin-bottom: 15px;">Para confirmar esta acción, ingrese su contraseña:</p>
          <input type="password" class="form-input" v-model="password" placeholder="Contraseña">
          <span v-if="errors.password" class="error-message">{{ errors.password }}</span>
        </div>

        <div v-if="errors.submit" class="alert alert-warning" style="margin-top: 15px;">
          {{ errors.submit }}
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="handleClose" :disabled="loading">Cancelar</button>
        <button class="btn btn-danger" @click="handleConfirm" :disabled="loading">
          <span v-if="loading">Procesando...</span>
          <span v-else>🗑️ Confirmar Baja</span>
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
  equipo: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['close', 'confirm'])

const motivo = ref('')
const password = ref('')
const loading = ref(false)
const errors = ref({})

// Reset form when equipo changes
watch(() => props.equipo, () => {
  motivo.value = ''
  password.value = ''
  errors.value = {}
})

function validate() {
  errors.value = {}
  
  if (!motivo.value.trim()) {
    errors.value.motivo = 'El motivo es requerido'
  }
  
  if (!password.value) {
    errors.value.password = 'La contraseña es requerida'
  }
  
  return Object.keys(errors.value).length === 0
}

async function handleConfirm() {
  if (!validate()) return
  
  loading.value = true
  errors.value = {}
  
  try {
    emit('confirm', { 
      motivo: motivo.value, 
      password: password.value 
    })
    // No reset here, parent will close modal
  } catch (err) {
    errors.value.submit = err.message || 'Error al procesar'
    loading.value = false
  }
}

function handleClose() {
  motivo.value = ''
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
