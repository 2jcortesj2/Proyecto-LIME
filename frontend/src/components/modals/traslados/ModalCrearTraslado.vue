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
              @focus="showEquipoDropdown = true"
              class="form-input" 
              :class="{ 'input-error': errors.equipo }"
              placeholder="Escribe nombre o código del equipo..."
            >
            <span v-if="errors.equipo" class="error-message">{{ errors.equipo }}</span>
            
            <!-- Dropdown de resultados -->
            <div v-if="showEquipoDropdown && equipoSearchTerm.length >= 2" class="custom-dropdown">
              <div v-if="isSearching" class="dropdown-item info">Buscando...</div>
              <div v-else-if="equiposFound.length === 0" class="dropdown-item info">No se encontraron equipos</div>
              <div v-else class="dropdown-list">
                <div 
                  v-for="equipo in equiposFound" 
                  :key="equipo.id" 
                  @click="selectEquipo(equipo)"
                  class="dropdown-item clickable"
                >
                  <strong>{{ equipo.nombre_equipo }}</strong> - {{ equipo.codigo_interno }}
                  <div style="font-size: 11px; color: #666;">{{ equipo.marca }} {{ equipo.modelo }}</div>
                </div>
              </div>
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
            
            <!-- Responsable con Dropdown Personalizado -->
            <div class="form-group" style="position: relative;">
              <label class="form-label required">Responsable</label>
              <input 
                type="text"
                v-model="responsableSearch"
                @input="filterResponsables"
                @focus="showResponsableDropdown = true"
                class="form-input"
                :class="{ 'input-error': errors.responsable_registro }"
                placeholder="Escribe o selecciona..."
              >
              <span v-if="errors.responsable_registro" class="error-message">{{ errors.responsable_registro }}</span>
              
              <!-- Dropdown de responsables -->
              <div v-if="showResponsableDropdown" class="custom-dropdown">
                <div v-if="filteredResponsables.length === 0" class="dropdown-item info">No hay responsables</div>
                <div v-else class="dropdown-list">
                  <div 
                    v-for="resp in filteredResponsables" 
                    :key="resp.id" 
                    @click="selectResponsable(resp)"
                    class="dropdown-item clickable"
                  >
                    {{ resp.nombre_completo }}
                  </div>
                </div>
              </div>
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
            
            <!-- Ubicación Origen con Dropdown Personalizado -->
            <div class="form-group" style="position: relative;">
              <label class="form-label required">Ubicación Origen</label>
              <input 
                type="text"
                v-model="ubicacionOrigenSearch"
                @input="filterUbicacionesOrigen"
                @focus="showUbicacionOrigenDropdown = true"
                :disabled="!form.sede_origen"
                class="form-input"
                :class="{ 'input-error': errors.ubicacion_origen }"
                placeholder="Escribe o selecciona..."
              >
              <span v-if="errors.ubicacion_origen" class="error-message">{{ errors.ubicacion_origen }}</span>
              
              <!-- Dropdown de ubicaciones origen -->
              <div v-if="showUbicacionOrigenDropdown && form.sede_origen" class="custom-dropdown">
                <div v-if="filteredUbicacionesOrigen.length === 0" class="dropdown-item info">No hay ubicaciones para esta sede</div>
                <div v-else class="dropdown-list">
                  <div 
                    v-for="ub in filteredUbicacionesOrigen" 
                    :key="ub.id" 
                    @click="selectUbicacionOrigen(ub)"
                    class="dropdown-item clickable"
                  >
                    {{ formatUbicacion(ub.nombre) }}
                  </div>
                </div>
              </div>
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
            
            <!-- Ubicación Destino con Dropdown Personalizado -->
            <div class="form-group" style="position: relative;">
              <label class="form-label required">Ubicación Destino</label>
              <input 
                type="text"
                v-model="ubicacionDestinoSearch"
                @input="filterUbicacionesDestino"
                @focus="showUbicacionDestinoDropdown = true"
                :disabled="!form.sede_destino"
                class="form-input"
                :class="{ 'input-error': errors.ubicacion_destino }"
                placeholder="Escribe o selecciona..."
              >
              <span v-if="errors.ubicacion_destino" class="error-message">{{ errors.ubicacion_destino }}</span>
              
              <!-- Dropdown de ubicaciones destino -->
              <div v-if="showUbicacionDestinoDropdown && form.sede_destino" class="custom-dropdown">
                <div v-if="filteredUbicacionesDestino.length === 0" class="dropdown-item info">No hay ubicaciones para esta sede</div>
                <div v-else class="dropdown-list">
                  <div 
                    v-for="ub in filteredUbicacionesDestino" 
                    :key="ub.id" 
                    @click="selectUbicacionDestino(ub)"
                    class="dropdown-item clickable"
                  >
                    {{ formatUbicacion(ub.nombre) }}
                  </div>
                </div>
              </div>
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
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
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
const showEquipoDropdown = ref(false)
const isSearching = ref(false)
let searchTimeout = null

// Responsables
const responsableSearch = ref('')
const filteredResponsables = ref([])
const showResponsableDropdown = ref(false)

// Ubicaciones Origen
const ubicacionOrigenSearch = ref('')
const filteredUbicacionesOrigen = ref([])
const showUbicacionOrigenDropdown = ref(false)

// Ubicaciones Destino
const ubicacionDestinoSearch = ref('')
const filteredUbicacionesDestino = ref([])
const showUbicacionDestinoDropdown = ref(false)

// Estado de validación
const errors = ref({})
const errorMessage = ref('')
const isSubmitting = ref(false)

// Fecha máxima (hoy)
const today = new Date().toISOString().split('T')[0]

// Ubicaciones base filtradas por sede
const ubicacionesOrigenBase = computed(() => {
  if (!form.value.sede_origen) return []
  console.log('Filtrando ubicaciones origen para sede:', form.value.sede_origen)
  console.log('Ubicaciones disponibles:', props.ubicaciones)
  const filtered = props.ubicaciones.filter(ub => ub.sede === form.value.sede_origen)
  console.log('Ubicaciones filtradas:', filtered)
  return filtered
})

const ubicacionesDestinoBase = computed(() => {
  if (!form.value.sede_destino) return []
  return props.ubicaciones.filter(ub => ub.sede === form.value.sede_destino)
})

// Búsqueda de equipos con debounce
async function searchEquipos() {
  if (!equipoSearchTerm.value || equipoSearchTerm.value.length < 2) {
    equiposFound.value = []
    showEquipoDropdown.value = false
    return
  }

  isSearching.value = true
  showEquipoDropdown.value = true

  if (searchTimeout) clearTimeout(searchTimeout)

  searchTimeout = setTimeout(async () => {
    try {
      console.log('🔍 Buscando equipos con:', equipoSearchTerm.value)
      const response = await equiposService.search(equipoSearchTerm.value)
      console.log('✅ Equipos encontrados:', response)
      equiposFound.value = Array.isArray(response) ? response : []
    } catch (err) {
      console.error('❌ Error buscando equipos:', err)
      equiposFound.value = []
    } finally {
      isSearching.value = false
    }
  }, 300)
}

function selectEquipo(equipo) {
  form.value.equipo = equipo.id
  equipoSearchTerm.value = `${equipo.nombre_equipo} - ${equipo.codigo_interno}`
  showEquipoDropdown.value = false
  
  // Auto-fill origen si está disponible
  if (equipo.sede) form.value.sede_origen = equipo.sede
  if (equipo.ubicacion) {
    form.value.ubicacion_origen = equipo.ubicacion
    // Buscar el nombre de la ubicación para mostrarlo
    const ub = props.ubicaciones.find(u => u.id === equipo.ubicacion)
    if (ub) ubicacionOrigenSearch.value = formatUbicacion(ub.nombre)
  }
  
  if (errors.value.equipo) delete errors.value.equipo
}

// Filtrar responsables (busca en cualquier parte del nombre)
function filterResponsables() {
  if (!responsableSearch.value) {
    filteredResponsables.value = props.responsables || []
    return
  }
  
  const search = responsableSearch.value.toLowerCase()
  filteredResponsables.value = (props.responsables || []).filter(resp => 
    resp.nombre_completo.toLowerCase().includes(search)
  )
}

function selectResponsable(resp) {
  form.value.responsable_registro = resp.id
  responsableSearch.value = resp.nombre_completo
  showResponsableDropdown.value = false
  if (errors.value.responsable_registro) delete errors.value.responsable_registro
}

// Filtrar ubicaciones origen
function filterUbicacionesOrigen() {
  if (!ubicacionOrigenSearch.value) {
    filteredUbicacionesOrigen.value = ubicacionesOrigenBase.value
    return
  }
  
  const search = ubicacionOrigenSearch.value.toLowerCase()
  filteredUbicacionesOrigen.value = ubicacionesOrigenBase.value.filter(ub => 
    ub.nombre.toLowerCase().includes(search)
  )
}

function selectUbicacionOrigen(ub) {
  form.value.ubicacion_origen = ub.id
  ubicacionOrigenSearch.value = formatUbicacion(ub.nombre)
  showUbicacionOrigenDropdown.value = false
  if (errors.value.ubicacion_origen) delete errors.value.ubicacion_origen
}

// Filtrar ubicaciones destino
function filterUbicacionesDestino() {
  if (!ubicacionDestinoSearch.value) {
    filteredUbicacionesDestino.value = ubicacionesDestinoBase.value
    return
  }
  
  const search = ubicacionDestinoSearch.value.toLowerCase()
  filteredUbicacionesDestino.value = ubicacionesDestinoBase.value.filter(ub => 
    ub.nombre.toLowerCase().includes(search)
  )
}

function selectUbicacionDestino(ub) {
  form.value.ubicacion_destino = ub.id
  ubicacionDestinoSearch.value = formatUbicacion(ub.nombre)
  showUbicacionDestinoDropdown.value = false
  if (errors.value.ubicacion_destino) delete errors.value.ubicacion_destino
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
  responsableSearch.value = ''
  ubicacionOrigenSearch.value = ''
  ubicacionDestinoSearch.value = ''
  errors.value = {}
  errorMessage.value = ''
}

// Limpiar ubicación cuando cambia la sede
watch(() => form.value.sede_origen, () => {
  form.value.ubicacion_origen = ''
  ubicacionOrigenSearch.value = ''
  filteredUbicacionesOrigen.value = ubicacionesOrigenBase.value
})

watch(() => form.value.sede_destino, () => {
  form.value.ubicacion_destino = ''
  ubicacionDestinoSearch.value = ''
  filteredUbicacionesDestino.value = ubicacionesDestinoBase.value
})

// Inicializar listas cuando se abre el modal
watch(() => props.show, (newVal) => {
  if (newVal) {
    filteredResponsables.value = props.responsables || []
    filteredUbicacionesOrigen.value = ubicacionesOrigenBase.value
    filteredUbicacionesDestino.value = ubicacionesDestinoBase.value
  } else {
    resetForm()
  }
})

// Click fuera del dropdown para cerrarlo
function handleClickOutside(event) {
  const target = event.target
  if (!target.closest('.form-group')) {
    showEquipoDropdown.value = false
    showResponsableDropdown.value = false
    showUbicacionOrigenDropdown.value = false
    showUbicacionDestinoDropdown.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
@import '../inventario/modal-styles.css';

/* Custom Dropdown Styles */
.custom-dropdown {
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
  margin-top: 2px;
}

.dropdown-list {
  padding: 0;
  margin: 0;
}

.dropdown-item {
  padding: 10px 15px;
  border-bottom: 1px solid #f0f0f0;
  transition: background 0.2s;
}

.dropdown-item:last-child {
  border-bottom: none;
}

.dropdown-item.clickable {
  cursor: pointer;
}

.dropdown-item.clickable:hover {
  background: #f5f5f5;
  color: #006633;
}

.dropdown-item.info {
  color: #666;
  font-style: italic;
  text-align: center;
}

.input-error {
  border-color: #f44336 !important;
}
</style>
