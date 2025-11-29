<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 600px;">
      <div class="modal-header">
        <h3 class="modal-title">➕ Registrar Nuevo Traslado</h3>
        <button class="close-btn" @click="$emit('close')">×</button>
      </div>
      <div class="modal-body">
        <form @submit.prevent="$emit('submit')">
          <div class="form-group" style="position: relative;">
            <label class="form-label required">Equipo a Trasladar</label>
            <input 
              type="text" 
              v-model="equipoSearchTerm" 
              @input="$emit('search-equipo', equipoSearchTerm)"
              @click="$emit('toggle-dropdown')"
              class="form-input" 
              placeholder="Escribe nombre o código del equipo..."
            >
            
            <!-- Dropdown de resultados -->
            <div v-if="showEquipoDropdown" class="dropdown-results">
              <div v-if="isSearching" class="dropdown-item info">Buscando...</div>
              <div v-else-if="equiposFound.length === 0" class="dropdown-item info">No se encontraron equipos</div>
              <ul v-else class="dropdown-list">
                <li 
                  v-for="equipo in equiposFound" 
                  :key="equipo.id" 
                  @click="$emit('select-equipo', equipo)"
                  class="dropdown-item"
                >
                  <strong>{{ equipo.nombre_equipo }}</strong> - {{ equipo.codigo_interno }}
                  <div style="font-size: 11px; color: #666;">{{ equipo.marca }} {{ equipo.modelo }}</div>
                </li>
              </ul>
            </div>
          </div>

          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Fecha del Traslado</label>
              <input type="date" v-model="localForm.fecha_traslado" class="form-input">
            </div>
            <div class="form-group">
              <label class="form-label required">Responsable</label>
              <input type="text" v-model="localForm.usuario_registro" class="form-input" placeholder="Nombre del responsable">
            </div>
          </div>

          <div class="section-divider"></div>
          <h4 class="section-title">Origen</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede Origen</label>
              <select v-model="localForm.sede_origen" class="form-select">
                <option :value="null" disabled>Seleccione sede...</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Ubicación Origen</label>
              <select v-model="localForm.servicio_origen" class="form-select">
                <option :value="null" disabled>Seleccione servicio...</option>
                <option v-for="servicio in servicios" :key="servicio.id" :value="servicio.id">{{ servicio.nombre }}</option>
              </select>
            </div>
          </div>

          <div class="section-divider"></div>
          <h4 class="section-title">Destino</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede Destino</label>
              <select v-model="localForm.sede_destino" class="form-select">
                <option :value="null" disabled>Seleccione sede...</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Ubicación Destino</label>
              <select v-model="localForm.servicio_destino" class="form-select">
                <option :value="null" disabled>Seleccione servicio...</option>
                <option v-for="servicio in servicios" :key="servicio.id" :value="servicio.id">{{ servicio.nombre }}</option>
              </select>
            </div>
          </div>

          <div class="form-group full-width" style="margin-top: 15px;">
            <label class="form-label required">Justificación</label>
            <textarea v-model="localForm.justificacion" class="form-textarea" rows="3" placeholder="Motivo del traslado..."></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-primary" @click="$emit('submit')">Registrar Traslado</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  show: Boolean,
  formData: Object,
  sedes: Array,
  servicios: Array,
  equiposFound: Array,
  showEquipoDropdown: Boolean,
  isSearching: Boolean
})

const emit = defineEmits([
  'close', 
  'submit', 
  'update:formData', 
  'search-equipo', 
  'toggle-dropdown', 
  'select-equipo'
])

const localForm = computed({
  get: () => props.formData,
  set: (value) => emit('update:formData', value)
})

const equipoSearchTerm = ref('')

// Reset search term when modal closes or opens
watch(() => props.show, (newVal) => {
  if (!newVal) {
    equipoSearchTerm.value = ''
  }
})
</script>

<style scoped>
/* Estilos copiados de Traslados.vue */
.modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 1000; backdrop-filter: blur(4px); }
.modal.active { display: flex; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 12px; width: 95%; max-width: 1100px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 40px rgba(0,0,0,0.3); }
.modal-header { padding: 25px; border-bottom: 2px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(90deg, rgba(0,102,51,0.05) 0%, transparent 100%); flex-shrink: 0; }
.modal-title { font-size: 22px; color: #006633; font-weight: 600; }
.close-btn { background: none; border: none; font-size: 28px; cursor: pointer; color: #616161; }
.close-btn:hover { color: #f44336; }
.modal-body { padding: 25px; overflow-y: auto; flex: 1; }
.modal-footer { padding: 20px 25px; border-top: 1px solid #e0e0e0; display: flex; justify-content: flex-end; gap: 12px; background: #f5f5f5; flex-shrink: 0; }

/* Form Styles */
.form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.form-group { margin-bottom: 12px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-label { display: block; margin-bottom: 4px; font-weight: 600; font-size: 13px; color: #212121; }
.form-label.required::after { content: ' *'; color: #d32f2f; }
.form-input, .form-select, .form-textarea { width: 100%; padding: 8px 12px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-family: inherit; transition: border-color 0.3s; }
.form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: #006633; box-shadow: 0 0 0 3px rgba(0,102,51,0.1); }
.form-textarea { resize: vertical; min-height: 80px; }

.section-divider { margin: 15px 0; padding-top: 15px; border-top: 2px solid #e0e0e0; }
.section-title { font-size: 18px; color: #006633; font-weight: 600; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; }

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

/* Button Styles */
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-secondary { background: #e0e0e0; }
.btn-secondary:hover { background: #d0d0d0; }
</style>
