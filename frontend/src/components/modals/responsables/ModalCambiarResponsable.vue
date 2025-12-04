<template>
  <div v-if="show" class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-container">
      <div class="modal-header">
        <h3><AppIcon name="refresh" size="16" /> Cambiar Responsable</h3>
        <button class="close-btn" @click="$emit('close')"><AppIcon name="close" size="16" /></button>
      </div>

      <div class="modal-body">
        <div v-if="equipo" class="info-section">
          <h4>Información del Equipo</h4>
          <div class="info-grid">
            <div class="info-item">
              <span class="label">Código:</span>
              <span class="value"><strong>{{ equipo.codigo_interno }}</strong></span>
            </div>
            <div class="info-item">
              <span class="label">Nombre:</span>
              <span class="value">{{ equipo.nombre_equipo }}</span>
            </div>
            <div class="info-item">
              <span class="label">Responsable Actual:</span>
              <span class="value">{{ equipo.responsable_nombre || 'N/A' }}</span>
            </div>
          </div>
        </div>

        <div class="form-section">
          <div class="form-group">
            <label for="nuevo-responsable">Nuevo Responsable *</label>
            <select 
              id="nuevo-responsable" 
              v-model="nuevoResponsableId" 
              class="form-control"
              required
            >
              <option value="">Seleccione un responsable...</option>
              <option 
                v-for="resp in responsables" 
                :key="resp.id" 
                :value="resp.id"
              >
                {{ resp.nombre_completo }} - {{ resp.rol }}
              </option>
            </select>
          </div>

          <div class="form-group">
            <label for="justificacion">Justificación</label>
            <textarea 
              id="justificacion" 
              v-model="justificacion" 
              class="form-control"
              rows="3"
              placeholder="Motivo del cambio de responsable (opcional)"
            ></textarea>
          </div>
        </div>

        <div v-if="error" class="error-message">{{ error }}</div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button 
          class="btn btn-primary" 
          @click="handleSubmit"
          :disabled="!nuevoResponsableId || loading"
        >
          {{ loading ? 'Guardando...' : 'Cambiar Responsable' }}
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
  },
  responsables: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['close', 'save'])

const nuevoResponsableId = ref('')
const justificacion = ref('')
const loading = ref(false)
const error = ref('')

// Reset form when modal opens/closes
watch(() => props.show, (newVal) => {
  if (newVal) {
    nuevoResponsableId.value = ''
    justificacion.value = ''
    error.value = ''
  }
})

async function handleSubmit() {
  if (!nuevoResponsableId.value) {
    error.value = 'Debe seleccionar un nuevo responsable'
    return
  }

  loading.value = true
  error.value = ''

  try {
    await emit('save', {
      equipoId: props.equipo.id,
      nuevoResponsableId: nuevoResponsableId.value,
      justificacion: justificacion.value
    })
  } catch (err) {
    error.value = err.message || 'Error al cambiar responsable'
    loading.value = false
  }
}
</script>

<style scoped>
@import '@/assets/styles/modal.css';

.info-section {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 6px;
  margin-bottom: 20px;
}

.info-section h4 {
  margin: 0 0 12px 0;
  font-size: 14px;
  color: #424242;
  font-weight: 600;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item .label {
  font-size: 12px;
  color: #757575;
  font-weight: 500;
}

.info-item .value {
  font-size: 14px;
  color: #212121;
}
</style>
