<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 700px;">
      <div class="modal-header">
        <h3 class="modal-title">➕ Registrar Nuevo Traslado</h3>
        <button class="close-btn" @click="handleClose">&times;</button>
      </div>
      <div class="modal-body">
        <!-- Error Alert -->
        <div v-if="errorMessage" class="alert alert-warning">
          ⚠️ {{ errorMessage }}
        </div>

        <form @submit.prevent="handleSubmit">
          <!-- Búsqueda de Equipo -->
          <div class="form-group" style="position: relative;">
            <label class="form-label required">Equipo a Trasladar</label>
            <input 
              type="text" 
              v-model="equipoSearchTerm" 
              @input="searchEquipos"
              @click="showDropdown = true"
              class="form-input" 
              :class="{ 'input-error': errors.equipo }"
              placeholder="Escribe nombre o código del equipo..."
            >
            <span v-if="errors.equipo" class="error-message">{{ errors.equipo }}</span>
            
            <!-- Dropdown de resultados -->
            <div v-if="showDropdown && equipoSearchTerm" class="dropdown-results">
              <div v-if="isSearching" class="dropdown-item info">Buscando...</div>
              <div v-else-if="equiposFound.length === 0" class="dropdown-item info">No se encontraron equipos</div>
              <ul v-else class="dropdown-list">
                <li 
                  v-for="equipo in equiposFound" 
                  :key="equipo.id" 
                  @click="selectEquipo(equipo)"
                  class="dropdown-item"
                >
                  <strong>{{ equipo.nombre_equipo }}</strong> - {{ equipo.codigo_interno }}
                  <div style="font-size: 11px; color: #666;">{{ equipo.marca }} {{ equipo.modelo }}</div>
                </li>
              </ul>
            </div>
          </div>

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
          {{ isSubmitting ? 'Guardando...' : 'Registrar Traslado' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { equiposService } from '@/services'
import { useFormatting } from '@/composables'

const { formatUbicacion } = useFormatting()

const props = defineProps({
  show: Boolean,
  sedes: Array,
  ubicaciones: Array,
  responsables: Array
})

const emit = defineEmits(['close', 'save'])

// Estado del formulario
const form = ref({
  equipo: null,
  fecha_traslado: new Date().toISOString().split('T')[0],
  sede_origen: '',
  ubicacion_origen: '',
  sede_destino: '',
  ubicacion_destino: '',
  justificacion: '',
  responsable_registro: ''
})

// Búsqueda de equipos
const equipoSearchTerm = ref('')
const equiposFound = ref([])
const showDropdown = ref(false)
const isSearching = ref(false)
let searchTimeout = null

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

// Búsqueda de equipos con debounce
async function searchEquipos() {
  if (!equipoSearchTerm.value || equipoSearchTerm.value.length < 2) {
    equiposFound.value = []
    return
  }

  isSearching.value = true
  showDropdown.value = true

  if (searchTimeout) clearTimeout(searchTimeout)

  searchTimeout = setTimeout(async () => {
    try {
      const response = await equiposService.search(equipoSearchTerm.value)
      equiposFound.value = response
    } catch (err) {
      console.error('Error buscando equipos:', err)
      equiposFound.value = []
    } finally {
      isSearching.value = false
    }
  }, 300)
}

function selectEquipo(equipo) {
  form.value.equipo = equipo.id
  equipoSearchTerm.value = `${equipo.nombre_equipo} - ${equipo.codigo_interno}`
  showDropdown.value = false
  
  // Auto-fill origen si está disponible
  if (equipo.sede) form.value.sede_origen = equipo.sede
  if (equipo.ubicacion) form.value.ubicacion_origen = equipo.ubicacion
  
  // Limpiar error de equipo si existía
  if (errors.value.equipo) delete errors.value.equipo
}

// Validación del formulario
function validateForm() {
  errors.value = {}
  errorMessage.value = ''

  if (!form.value.equipo) {
    errors.value.equipo = 'Debe seleccionar un equipo'
  }

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
    await emit('save', form.value)
    resetForm()
  } catch (err) {
    errorMessage.value = err.message || 'Error al crear el traslado'
  } finally {
    isSubmitting.value = false
  }
}

function handleClose() {
  resetForm()
  emit('close')
}

function resetForm() {
  form.value = {
    equipo: null,
    fecha_traslado: new Date().toISOString().split('T')[0],
    sede_origen: '',
    ubicacion_origen: '',
    sede_destino: '',
    ubicacion_destino: '',
    justificacion: '',
    responsable_registro: ''
  }
  equipoSearchTerm.value = ''
  equiposFound.value = []
  showDropdown.value = false
  errors.value = {}
  errorMessage.value = ''
}

// Limpiar ubicación cuando cambia la sede
watch(() => form.value.sede_origen, () => {
  form.value.ubicacion_origen = ''
})

watch(() => form.value.sede_destino, () => {
  form.value.ubicacion_destino = ''
})

// Reset cuando se cierra el modal
watch(() => props.show, (newVal) => {
  if (!newVal) {
    resetForm()
  }
})
</script>

<style scoped>
@import '../inventario/modal-styles.css';

/* Dropdown Styles */
.dropdown-results {
  position: absolute;
  top: 100%;
  left: 0;
  width: 100%;
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 0 0 6px 6px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  z-index: 100;
  max-height: 200px;
  overflow-y: auto;
}

.dropdown-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.dropdown-item {
  padding: 10px 15px;
  cursor: pointer;
  border-bottom: 1px solid #f0f0f0;
  transition: background 0.2s;
}

.dropdown-item:last-child {
  border-bottom: none;
}

.dropdown-item:hover {
  background: #f5f5f5;
  color: #006633;
}

.dropdown-item.info {
  color: #666;
  font-style: italic;
  cursor: default;
  text-align: center;
}

.input-error {
  border-color: #f44336 !important;
}
</style>
