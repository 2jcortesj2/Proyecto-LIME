<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 700px;">
      <div class="modal-header">
        <h3 class="modal-title">✏️ Editar Traslado</h3>
        <button class="close-btn" @click="handleClose">&times;</button>
      </div>
      <div class="modal-body">
        <!-- Error Alert -->
        <div v-if="errorMessage" class="alert alert-warning">
          ⚠️ {{ errorMessage }}
        </div>

        <!-- Info del equipo (no editable) -->
        <div class="info-box">
          <div class="info-box-title">Equipo</div>
          <div><strong>{{ traslado?.equipo_nombre }}</strong> - {{ traslado?.equipo_codigo }}</div>
          <div style="font-size: 12px; color: #666;">{{ traslado?.equipo_marca }} {{ traslado?.equipo_modelo }}</div>
        </div>

        <form @submit.prevent="handleSubmit">
          <!-- Fecha y Responsable -->
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Fecha del Traslado</label>
              <input 
                type="date" 
                v-model="form.fecha_traslado" 
                class="form-input"
                :class="{ 'input-error': errors.fecha_traslado }"
                :max="today"
              >
              <span v-if="errors.fecha_traslado" class="error-message">{{ errors.fecha_traslado }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Responsable</label>
              <select 
                v-model="form.responsable_registro" 
                class="form-select"
                :class="{ 'input-error': errors.responsable_registro }"
              >
                <option value="">Seleccione...</option>
                <option v-for="resp in responsables" :key="resp.id" :value="resp.id">
                  {{ resp.nombre_completo }}
                </option>
              </select>
              <span v-if="errors.responsable_registro" class="error-message">{{ errors.responsable_registro }}</span>
            </div>
          </div>

          <div class="section-divider"></div>
          <h4 class="section-title">Origen</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede Origen</label>
              <select 
                v-model="form.sede_origen" 
                class="form-select"
                :class="{ 'input-error': errors.sede_origen }"
              >
                <option value="">Seleccione sede...</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
              <span v-if="errors.sede_origen" class="error-message">{{ errors.sede_origen }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Ubicación Origen</label>
              <select 
                v-model="form.ubicacion_origen" 
                class="form-select"
                :class="{ 'input-error': errors.ubicacion_origen }"
                :disabled="!form.sede_origen"
              >
                <option value="">Seleccione ubicación...</option>
                <option v-for="ub in ubicacionesOrigenFiltradas" :key="ub.id" :value="ub.id">{{ formatUbicacion(ub.nombre) }}</option>
              </select>
              <span v-if="errors.ubicacion_origen" class="error-message">{{ errors.ubicacion_origen }}</span>
            </div>
          </div>

          <div class="section-divider"></div>
          <h4 class="section-title">Destino</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede Destino</label>
              <select 
                v-model="form.sede_destino" 
                class="form-select"
                :class="{ 'input-error': errors.sede_destino }"
              >
                <option value="">Seleccione sede...</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
              <span v-if="errors.sede_destino" class="error-message">{{ errors.sede_destino }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Ubicación Destino</label>
              <select 
                v-model="form.ubicacion_destino" 
                class="form-select"
                :class="{ 'input-error': errors.ubicacion_destino }"
                :disabled="!form.sede_destino"
              >
                <option value="">Seleccione ubicación...</option>
                <option v-for="ub in ubicacionesDestinoFiltradas" :key="ub.id" :value="ub.id">{{ formatUbicacion(ub.nombre) }}</option>
              </select>
              <span v-if="errors.ubicacion_destino" class="error-message">{{ errors.ubicacion_destino }}</span>
            </div>
          </div>

          <!-- Justificación -->
          <div class="form-group full-width" style="margin-top: 15px;">
            <label class="form-label required">Justificación</label>
            <textarea 
              v-model="form.justificacion" 
              class="form-textarea" 
              :class="{ 'input-error': errors.justificacion }"
              rows="3" 
              placeholder="Motivo del traslado (mínimo 10 caracteres)..."
            ></textarea>
            <span v-if="errors.justificacion" class="error-message">{{ errors.justificacion }}</span>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="handleClose">Cancelar</button>
        <button class="btn btn-primary" @click="handleSubmit" :disabled="isSubmitting">
          {{ isSubmitting ? 'Guardando...' : 'Guardar Cambios' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useFormatting } from '@/composables'

const { formatUbicacion } = useFormatting()

const props = defineProps({
  show: Boolean,
  traslado: Object,
  sedes: Array,
  ubicaciones: Array,
  responsables: Array
})

const emit = defineEmits(['close', 'save'])

// Estado del formulario
const form = ref({
  fecha_traslado: '',
  sede_origen: '',
  ubicacion_origen: '',
  sede_destino: '',
  ubicacion_destino: '',
  justificacion: '',
  responsable_registro: ''
})

// Estado de validación
const errors = ref({})
const errorMessage = ref('')
const isSubmitting = ref(false)

// Fecha máxima (hoy)
const today = new Date().toISOString().split('T')[0]

// Ubicaciones filtradas por sede
const ubicacionesOrigenFiltradas = computed(() => {
  if (!form.value.sede_origen) return []
  return props.ubicaciones.filter(ub => ub.sede === form.value.sede_origen)
})

const ubicacionesDestinoFiltradas = computed(() => {
  if (!form.value.sede_destino) return []
  return props.ubicaciones.filter(ub => ub.sede === form.value.sede_destino)
})

// Validación del formulario
function validateForm() {
  errors.value = {}
  errorMessage.value = ''

  if (!form.value.fecha_traslado) {
    errors.value.fecha_traslado = 'La fecha es requerida'
  } else if (new Date(form.value.fecha_traslado) > new Date()) {
    errors.value.fecha_traslado = 'La fecha no puede ser futura'
  }

  if (!form.value.sede_origen) {
    errors.value.sede_origen = 'La sede origen es requerida'
  }

  if (!form.value.ubicacion_origen) {
    errors.value.ubicacion_origen = 'La ubicación origen es requerida'
  }

  if (!form.value.sede_destino) {
    errors.value.sede_destino = 'La sede destino es requerida'
  }

  if (!form.value.ubicacion_destino) {
    errors.value.ubicacion_destino = 'La ubicación destino es requerida'
  }

  // Validar que origen y destino sean diferentes
  if (form.value.sede_origen && form.value.sede_destino && 
      form.value.sede_origen === form.value.sede_destino &&
      form.value.ubicacion_origen === form.value.ubicacion_destino) {
    errorMessage.value = 'La ubicación de origen y destino no pueden ser iguales'
  }

  if (!form.value.justificacion || form.value.justificacion.trim().length < 10) {
    errors.value.justificacion = 'La justificación debe tener al menos 10 caracteres'
  }

  if (!form.value.responsable_registro) {
    errors.value.responsable_registro = 'Debe seleccionar un responsable'
  }

  return Object.keys(errors.value).length === 0 && !errorMessage.value
}

async function handleSubmit() {
  if (!validateForm()) {
    return
  }

  isSubmitting.value = true
  try {
    const updatedData = {
      id: props.traslado.id,
      ...form.value
    }
    await emit('save', updatedData)
  } catch (err) {
    errorMessage.value = err.message || 'Error al actualizar el traslado'
  } finally {
    isSubmitting.value = false
  }
}

function handleClose() {
  errors.value = {}
  errorMessage.value = ''
  emit('close')
}

// Cargar datos del traslado cuando se abre el modal
watch(() => props.show, (newVal) => {
  if (newVal && props.traslado) {
    form.value = {
      fecha_traslado: props.traslado.fecha_traslado,
      sede_origen: props.traslado.sede_origen,
      ubicacion_origen: props.traslado.ubicacion_origen,
      sede_destino: props.traslado.sede_destino,
      ubicacion_destino: props.traslado.ubicacion_destino,
      justificacion: props.traslado.justificacion,
      responsable_registro: props.traslado.responsable_registro
    }
    errors.value = {}
    errorMessage.value = ''
  }
})

// Limpiar ubicación cuando cambia la sede
watch(() => form.value.sede_origen, (newVal, oldVal) => {
  if (newVal !== oldVal && oldVal !== undefined) {
    form.value.ubicacion_origen = ''
  }
})

watch(() => form.value.sede_destino, (newVal, oldVal) => {
  if (newVal !== oldVal && oldVal !== undefined) {
    form.value.ubicacion_destino = ''
  }
})
</script>

<style scoped>
@import '../inventario/modal-styles.css';

.input-error {
  border-color: #f44336 !important;
}
</style>
