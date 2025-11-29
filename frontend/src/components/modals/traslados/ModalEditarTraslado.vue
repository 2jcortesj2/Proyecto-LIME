<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 600px;">
      <div class="modal-header">
        <h3 class="modal-title">✏️ Editar Traslado</h3>
        <button class="close-btn" @click="$emit('close')">×</button>
      </div>
      <div class="modal-body">
        <form @submit.prevent="$emit('submit')">
          <div class="form-group">
            <label class="form-label">Equipo</label>
            <input type="text" class="form-input locked" :value="selectedTraslado?.equipo_nombre" disabled>
          </div>

          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Fecha del Traslado</label>
              <input type="date" v-model="localForm.fecha_traslado" class="form-input">
            </div>
            <div class="form-group">
              <label class="form-label">Responsable</label>
              <input type="text" v-model="localForm.usuario_registro" class="form-input">
            </div>
          </div>

          <div class="section-divider"></div>
          <h4 class="section-title">Origen</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Sede Origen</label>
              <select v-model="localForm.sede_origen" class="form-select">
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Ubicación Origen</label>
              <select v-model="localForm.servicio_origen" class="form-select">
                <option v-for="servicio in servicios" :key="servicio.id" :value="servicio.id">{{ servicio.nombre }}</option>
              </select>
            </div>
          </div>

          <div class="section-divider"></div>
          <h4 class="section-title">Destino</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Sede Destino</label>
              <select v-model="localForm.sede_destino" class="form-select">
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Ubicación Destino</label>
              <select v-model="localForm.servicio_destino" class="form-select">
                <option v-for="servicio in servicios" :key="servicio.id" :value="servicio.id">{{ servicio.nombre }}</option>
              </select>
            </div>
          </div>

          <div class="form-group full-width" style="margin-top: 15px;">
            <label class="form-label">Justificación</label>
            <textarea v-model="localForm.justificacion" class="form-textarea" rows="3"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-primary" @click="$emit('submit')">Guardar Cambios</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  show: Boolean,
  formData: Object,
  selectedTraslado: Object,
  sedes: Array,
  servicios: Array
})

const emit = defineEmits(['close', 'submit', 'update:formData'])

const localForm = computed({
  get: () => props.formData,
  set: (value) => emit('update:formData', value)
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
.form-input, .form-select, .form-textarea { width: 100%; padding: 8px 12px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-family: inherit; transition: border-color 0.3s; }
.form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: #006633; box-shadow: 0 0 0 3px rgba(0,102,51,0.1); }
.form-input.locked { background: #fff9e6; border-color: #ff9800; }
.form-textarea { resize: vertical; min-height: 80px; }

.section-divider { margin: 15px 0; padding-top: 15px; border-top: 2px solid #e0e0e0; }
.section-title { font-size: 18px; color: #006633; font-weight: 600; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; }

/* Button Styles */
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-secondary { background: #e0e0e0; }
.btn-secondary:hover { background: #d0d0d0; }
</style>
