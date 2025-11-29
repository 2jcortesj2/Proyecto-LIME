<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header">
        <div class="modal-title">🔐 Verificación de Seguridad</div>
        <button class="close-btn" @click="$emit('close')">&times;</button>
      </div>
      <div class="modal-body">
        <div class="password-group">
          <p style="margin-bottom: 15px; color: #616161; font-size: 14px;">
            Este campo es <strong>crítico para la integridad del sistema</strong>. Para modificarlo, ingrese su contraseña de administrador:
          </p>
          <div class="form-group">
            <label class="form-label required">Campo a modificar:</label>
            <input type="text" class="form-input" disabled :value="campo">
          </div>
          <div class="form-group">
            <label class="form-label required">Contraseña de Administrador:</label>
            <input type="password" class="form-input" v-model="password" placeholder="Ingrese su contraseña">
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-danger" @click="handleUnlock">🔓 Desbloquear Campo</button>
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
  campo: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['close', 'unlock'])

const password = ref('')

const handleUnlock = () => {
  emit('unlock', password.value)
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
.form-label { display: block; margin-bottom: 4px; font-weight: 600; font-size: 13px; color: #212121; }
.form-label.required::after { content: " *"; color: #f44336; }
.form-input { width: 100%; padding: 8px 12px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-family: inherit; transition: border-color 0.3s; }
.form-input:focus { outline: none; border-color: #006633; box-shadow: 0 0 0 3px rgba(0,102,51,0.1); }
.form-input:disabled { background: #f5f5f5; color: #616161; cursor: not-allowed; }

.password-group { background: rgba(244,67,54,0.05); padding: 20px; border-radius: 8px; border: 2px solid #f44336; margin-top: 15px; }
</style>
