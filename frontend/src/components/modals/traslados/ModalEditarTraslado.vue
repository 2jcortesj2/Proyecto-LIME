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
            
            <!-- Responsable con Dropdown Personalizado -->
            <div class="form-group" style="position: relative;">
              <label class="form-label required">Responsable</label>
              <input 
                type="text"
                v-model="responsableDropdown.searchTerm.value"
                @focus="responsableDropdown.openDropdown()"
                class="form-input"
                :class="{ 'input-error': errors.responsable_registro }"
                placeholder="Escribe o selecciona..."
              >
              <span v-if="errors.responsable_registro" class="error-message">{{ errors.responsable_registro }}</span>
              
              <!-- Dropdown de responsables -->
              <div v-if="responsableDropdown.isOpen.value" class="custom-dropdown">
                <div v-if="responsableDropdown.filteredItems.value.length === 0" class="dropdown-item info">No hay responsables</div>
                <div v-else class="dropdown-list">
                  <div 
                    v-for="resp in responsableDropdown.filteredItems.value" 
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
                v-model="ubicacionOrigenDropdown.searchTerm.value"
                @focus="ubicacionOrigenDropdown.openDropdown()"
                :disabled="!form.sede_origen"
                class="form-input"
                :class="{ 'input-error': errors.ubicacion_origen }"
                placeholder="Escribe o selecciona..."
              >
              <span v-if="errors.ubicacion_origen" class="error-message">{{ errors.ubicacion_origen }}</span>
              
              <!-- Dropdown de ubicaciones origen -->
              <div v-if="ubicacionOrigenDropdown.isOpen.value && form.sede_origen" class="custom-dropdown">
                <div v-if="ubicacionOrigenDropdown.filteredItems.value.length === 0" class="dropdown-item info">No hay ubicaciones para esta sede</div>
                <div v-else class="dropdown-list">
                  <div 
                    v-for="ub in ubicacionOrigenDropdown.filteredItems.value" 
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
                v-model="ubicacionDestinoDropdown.searchTerm.value"
                @focus="ubicacionDestinoDropdown.openDropdown()"
                :disabled="!form.sede_destino"
                class="form-input"
                :class="{ 'input-error': errors.ubicacion_destino }"
                placeholder="Escribe o selecciona..."
              >
              <span v-if="errors.ubicacion_destino" class="error-message">{{ errors.ubicacion_destino }}</span>
              
              <!-- Dropdown de ubicaciones destino -->
              <div v-if="ubicacionDestinoDropdown.isOpen.value && form.sede_destino" class="custom-dropdown">
                <div v-if="ubicacionDestinoDropdown.filteredItems.value.length === 0" class="dropdown-item info">No hay ubicaciones para esta sede</div>
                <div v-else class="dropdown-list">
                  <div 
                    v-for="ub in ubicacionDestinoDropdown.filteredItems.value" 
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
          {{ isSubmitting ? 'Guardando...' : 'Guardar Cambios' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted, toRef } from 'vue'
import { useFormatting, useDropdown } from '@/composables'

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

// Ubicaciones base filtradas por sede
const ubicacionesOrigenBase = computed(() => {
  if (!form.value.sede_origen) return []
  return props.ubicaciones.filter(ub => {
    const sedeId = ub.sede_id || (ub.sede?.id) || ub.sede
    return sedeId === form.value.sede_origen
  })
})

const ubicacionesDestinoBase = computed(() => {
  if (!form.value.sede_destino) return []
  return props.ubicaciones.filter(ub => {
    const sedeId = ub.sede_id || (ub.sede?.id) || ub.sede
    return sedeId === form.value.sede_destino
  })
})

// --- USANDO COMPOSABLE USE DROPDOWN ---

// Responsables
const responsablesRef = toRef(props, 'responsables')
const responsableDropdown = useDropdown(responsablesRef, ['nombre_completo'])

function selectResponsable(resp) {
  form.value.responsable_registro = resp.id
  responsableDropdown.selectItem(resp)
  if (errors.value.responsable_registro) delete errors.value.responsable_registro
}

// Ubicaciones Origen
const ubicacionOrigenDropdown = useDropdown(ubicacionesOrigenBase, ['nombre'], (item) => formatUbicacion(item.nombre))

function selectUbicacionOrigen(ub) {
  form.value.ubicacion_origen = ub.id
  ubicacionOrigenDropdown.selectItem(ub)
  if (errors.value.ubicacion_origen) delete errors.value.ubicacion_origen
}

// Ubicaciones Destino
const ubicacionDestinoDropdown = useDropdown(ubicacionesDestinoBase, ['nombre'], (item) => formatUbicacion(item.nombre))

function selectUbicacionDestino(ub) {
  form.value.ubicacion_destino = ub.id
  ubicacionDestinoDropdown.selectItem(ub)
  if (errors.value.ubicacion_destino) delete errors.value.ubicacion_destino
}

// Estado de validación
const errors = ref({})
const errorMessage = ref('')
const isSubmitting = ref(false)
const isInitializing = ref(false)

// Fecha máxima (hoy)
const today = new Date().toISOString().split('T')[0]

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
    isInitializing.value = true
    form.value = {
      fecha_traslado: props.traslado.fecha_traslado,
      sede_origen: props.traslado.sede_origen,
      ubicacion_origen: props.traslado.ubicacion_origen,
      sede_destino: props.traslado.sede_destino,
      ubicacion_destino: props.traslado.ubicacion_destino,
      justificacion: props.traslado.justificacion,
      responsable_registro: props.traslado.responsable_registro
    }
    
    // Inicializar responsable search
    const responsable = props.responsables.find(r => r.id === props.traslado.responsable_registro)
    if (responsable) {
      responsableDropdown.setInitialValue(responsable)
    }
    
    // Inicializar ubicación origen search
    // Usar == para permitir coincidencia si uno es string y otro número
    const ubicOrigen = props.ubicaciones.find(u => u.id == props.traslado.ubicacion_origen)
    
    if (ubicOrigen) {
      ubicacionOrigenDropdown.setInitialValue(ubicOrigen)
    } else if (props.traslado.ubicacion_origen_nombre) {
      // Fallback: usar el nombre que viene en el traslado si no se encuentra en la lista
      ubicacionOrigenDropdown.setSearchTerm(formatUbicacion(props.traslado.ubicacion_origen_nombre))
    }
    
    // Inicializar ubicación destino search
    const ubicDestino = props.ubicaciones.find(u => u.id == props.traslado.ubicacion_destino)
    
    if (ubicDestino) {
      ubicacionDestinoDropdown.setInitialValue(ubicDestino)
    } else if (props.traslado.ubicacion_destino_nombre) {
      // Fallback
      ubicacionDestinoDropdown.setSearchTerm(formatUbicacion(props.traslado.ubicacion_destino_nombre))
    }
    
    errors.value = {}
    errorMessage.value = ''
    
    // Desactivar flag de inicialización después de que los watchers hayan corrido
    setTimeout(() => {
      isInitializing.value = false
    }, 100)
  }
})

// Limpiar ubicación cuando cambia la sede
watch(() => form.value.sede_origen, (newVal, oldVal) => {
  if (isInitializing.value) return
  if (newVal !== oldVal && oldVal !== undefined) {
    form.value.ubicacion_origen = ''
    ubicacionOrigenDropdown.reset()
  }
})

watch(() => form.value.sede_destino, (newVal, oldVal) => {
  if (isInitializing.value) return
  if (newVal !== oldVal && oldVal !== undefined) {
    form.value.ubicacion_destino = ''
    ubicacionDestinoDropdown.reset()
  }
})

// Click fuera del dropdown para cerrarlo
function handleClickOutside(event) {
  const target = event.target
  if (!target.closest('.form-group')) {
    responsableDropdown.closeDropdown()
    ubicacionOrigenDropdown.closeDropdown()
    ubicacionDestinoDropdown.closeDropdown()
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
</style>
