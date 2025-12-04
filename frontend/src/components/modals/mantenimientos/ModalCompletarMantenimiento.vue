<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">✅ Completar Mantenimiento</h3>
        <button class="close-btn" @click="$emit('close')">❌</button>
      </div>
      
      <div class="modal-body">
        <div class="equipo-info">
          <div class="info-label">Equipo:</div>
          <div class="info-value">{{ equipo?.nombre_equipo }}</div>
          <div class="info-sub">{{ equipo?.codigo_interno }} - {{ equipo?.marca }} {{ equipo?.modelo }}</div>
        </div>

        <form @submit.prevent="confirmarCompletado">
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Tipo de Mantenimiento</label>
              <select v-model="form.tipo_mantenimiento" class="form-select" required>
                <option value="" disabled>Seleccione tipo...</option>
                <option value="preventivo">Preventivo</option>
                <option value="correctivo">Correctivo</option>
                <option value="calibracion">Calibración</option>
                <option value="calificacion">Calificación</option>
                <option value="verificacion">Verificación</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Fecha Realización</label>
              <input type="date" v-model="form.fecha_mantenimiento" class="form-input" required>
            </div>
          </div>

          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Realizado Por</label>
              <input type="text" v-model="form.realizado_por" class="form-input" placeholder="Técnico o Empresa" required>
            </div>
            <div class="form-group">
              <label class="form-label">Costo</label>
              <input type="number" v-model="form.costo" class="form-input" placeholder="0.00">
            </div>
          </div>

          <div class="form-group full-width">
            <label class="form-label required">Descripción del Trabajo</label>
            <textarea v-model="form.descripcion" class="form-textarea" rows="3" placeholder="Detalles del mantenimiento realizado..." required></textarea>
          </div>

          <div class="form-group full-width">
            <label class="form-label">Observaciones</label>
            <textarea v-model="form.observaciones" class="form-textarea" rows="2" placeholder="Observaciones adicionales..."></textarea>
          </div>
          
          <div class="form-group full-width">
            <label class="form-label required">Registrado Por</label>
            <input type="text" v-model="form.usuario_registro" class="form-input" placeholder="Nombre de quien registra" required>
          </div>
        </form>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-primary" @click="confirmarCompletado">Registrar Mantenimiento</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue'

const props = defineProps({
  show: Boolean,
  equipo: Object
})

const emit = defineEmits(['close', 'submit'])

const form = ref({
  tipo_mantenimiento: 'preventivo',
  fecha_mantenimiento: new Date().toISOString().split('T')[0],
  realizado_por: '',
  costo: '',
  descripcion: '',
  observaciones: '',
  usuario_registro: '' // Idealmente vendría del usuario logueado
})

// Reset form when modal opens
watch(() => props.show, (newVal) => {
  if (newVal) {
    form.value = {
      tipo_mantenimiento: 'preventivo',
      fecha_mantenimiento: new Date().toISOString().split('T')[0],
      realizado_por: '',
      costo: '',
      descripcion: '',
      observaciones: '',
      usuario_registro: ''
    }
  }
})

function confirmarCompletado() {
  // Basic validation
  if (!form.value.tipo_mantenimiento || !form.value.fecha_mantenimiento || !form.value.realizado_por || !form.value.descripcion || !form.value.usuario_registro) {
    alert('Por favor complete todos los campos obligatorios')
    return
  }

  // Split date to get month and year
  const dateParts = form.value.fecha_mantenimiento.split('-')
  const year = parseInt(dateParts[0])
  const month = parseInt(dateParts[1])

  emit('submit', {
    equipo_id: props.equipo.id,
    tipo_mantenimiento: form.value.tipo_mantenimiento,
    mes_mantenimiento: month,
    anio_mantenimiento: year,
    descripcion: form.value.descripcion,
    realizado_por: form.value.realizado_por,
    costo: form.value.costo || 0,
    usuario_registro: form.value.usuario_registro,
    observaciones: form.value.observaciones
  })
}
</script>

<style scoped>
.modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 1000; backdrop-filter: blur(4px); }
.modal.active { display: flex; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 12px; width: 95%; max-width: 600px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 40px rgba(0,0,0,0.3); animation: slideUp 0.3s ease; }

@keyframes slideUp {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

.modal-header { padding: 20px 25px; border-bottom: 1px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; background: #fff; border-radius: 12px 12px 0 0; }
.modal-title { font-size: 20px; color: #006633; font-weight: 700; margin: 0; }
.close-btn { background: none; border: none; font-size: 28px; cursor: pointer; color: #999; transition: color 0.2s; line-height: 1; }
.close-btn:hover { color: #f44336; }

.modal-body { padding: 25px; overflow-y: auto; }

.equipo-info { margin-bottom: 25px; text-align: center; background: #f9f9f9; padding: 15px; border-radius: 8px; border-left: 4px solid #006633; }
.info-label { font-size: 11px; text-transform: uppercase; color: #666; letter-spacing: 1px; margin-bottom: 4px; }
.info-value { font-size: 16px; font-weight: 700; color: #212121; margin-bottom: 2px; }
.info-sub { font-size: 12px; color: #666; }

/* Form Styles */
.form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 15px; }
.form-group { margin-bottom: 15px; }
.form-group.full-width { grid-column: 1 / -1; margin-bottom: 15px; }

.form-label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px; color: #444; }
.form-label.required::after { content: ' *'; color: #d32f2f; }

.form-input, .form-select, .form-textarea { 
  width: 100%; 
  padding: 10px 12px; 
  border: 1px solid #ddd; 
  border-radius: 8px; 
  font-size: 14px; 
  font-family: inherit; 
  transition: all 0.3s; 
  background: #fafafa;
}

.form-input:focus, .form-select:focus, .form-textarea:focus { 
  outline: none; 
  border-color: #006633; 
  box-shadow: 0 0 0 3px rgba(0,102,51,0.1); 
  background: white;
}

.form-textarea { resize: vertical; min-height: 80px; }

.modal-footer { padding: 20px 25px; border-top: 1px solid #e0e0e0; display: flex; justify-content: flex-end; gap: 12px; background: #fafafa; border-radius: 0 0 12px 12px; }

.btn { padding: 10px 24px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 14px; transition: all 0.2s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,102,51,0.2); }
.btn-secondary { background: #e0e0e0; color: #444; }
.btn-secondary:hover { background: #d0d0d0; }
</style>
