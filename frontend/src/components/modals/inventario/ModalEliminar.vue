<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 600px;">
      <div class="modal-header">
        <div class="modal-title">⚠️ Dar de Baja Equipo</div>
        <button class="close-btn" @click="$emit('close')">&times;</button>
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
        </div>

        <div class="password-group">
          <div style="font-weight: 600; color: #f44336; margin-bottom: 10px;">🔒 Autorización Requerida</div>
          <p style="font-size: 13px; color: #616161; margin-bottom: 15px;">Para confirmar esta acción, ingrese su contraseña:</p>
          <input type="password" class="form-input" v-model="password" placeholder="Contraseña">
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-danger" @click="handleConfirm">🗑️ Confirmar Baja</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

defineProps({
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

const handleConfirm = () => {
  emit('confirm', { motivo: motivo.value, password: password.value })
  motivo.value = ''
  password.value = ''
}
</script>

<style scoped>
/* Modal Styles */
.modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 1000; backdrop-filter: blur(4px); }
.modal.active { display: flex; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 12px; width: 95%; max-width: 1100px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 40px rgba(0,0,0,0.3); }
.modal-header { padding: 25px; border-bottom: 2px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(90deg, rgba(0,102,51,0.05) 0%, transparent 100%); flex-shrink: 0; }
.modal-title { font-size: 22px; color: #006633; font-weight: 600; }
.close-btn { background: none; border: none; font-size: 28px; cursor: pointer; color: #616161; }
.close-btn:hover { color: #f44336; }
.modal-body { padding: 25px; overflow-y: auto; flex: 1; }
.modal-footer { padding: 20px 25px; border-top: 1px solid #e0e0e0; display: flex; justify-content: flex-end; gap: 12px; background: #f5f5f5; flex-shrink: 0; }

/* Button Styles */
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-secondary { background: #e0e0e0; }
.btn-danger { background: #f44336; color: white; }

/* Form Styles */
.form-group { margin-bottom: 12px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-label { display: block; margin-bottom: 4px; font-weight: 600; font-size: 13px; color: #212121; }
.form-label.required::after { content: " *"; color: #f44336; }
.form-input, .form-textarea { width: 100%; padding: 8px 12px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-family: inherit; transition: border-color 0.3s; }
.form-input:focus, .form-textarea:focus { outline: none; border-color: #006633; box-shadow: 0 0 0 3px rgba(0,102,51,0.1); }
.form-textarea { resize: vertical; min-height: 80px; }

.alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; cursor: pointer; transition: all 0.3s; }
.alert-warning { background: rgba(255, 152, 0, 0.1); color: #ff9800; border-left: 4px solid #ff9800; }

.info-box { background: rgba(0,102,51,0.05); border-left: 4px solid #006633; padding: 15px; border-radius: 4px; margin-bottom: 12px; }
.info-box-title { font-weight: 600; color: #006633; margin-bottom: 8px; }

.password-group { background: rgba(244,67,54,0.05); padding: 20px; border-radius: 8px; border: 2px solid #f44336; margin-top: 15px; }
</style>
