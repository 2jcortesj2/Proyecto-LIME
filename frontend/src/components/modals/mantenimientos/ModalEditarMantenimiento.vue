<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-container">
      <div class="modal-header">
        <h3><AppIcon name="edit" size="16" /> Editar Mantenimiento</h3>
        <button class="btn-close" @click="$emit('close')"><AppIcon name="close" size="16" /></button>
      </div>

      <div class="modal-body">
        <form @submit.prevent="handleSubmit">
          <!-- Equipo (solo lectura) -->
          <div class="form-group">
            <label class="form-label">Equipo</label>
            <input 
              type="text" 
              :value="`${mantenimiento.equipo?.codigo_interno} - ${mantenimiento.equipo?.nombre_equipo}`"
              class="form-control" 
              disabled
            >
          </div>

          <!-- Tipo de Mantenimiento -->
          <div class="form-group">
            <label class="form-label required">Tipo de Mantenimiento</label>
            <select v-model="form.tipo_mantenimiento" class="form-control" required>
              <option value="">Seleccionar tipo...</option>
              <option value="preventivo">Preventivo</option>
              <option value="correctivo">Correctivo</option>
              <option value="calibracion">Calibración</option>
              <option value="calificacion">Calificación</option>
              <option value="verificacion">Verificación</option>
            </select>
          </div>

          <!-- Mes y Año -->
          <div class="form-row">
            <div class="form-group">
              <label class="form-label required">Mes</label>
              <select v-model.number="form.mes_mantenimiento" class="form-control" required>
                <option value="">Mes...</option>
                <option v-for="(mes, index) in MESES_NOMBRES" :key="index" :value="index + 1">
                  {{ mes }}
                </option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Año</label>
              <input 
                type="number" 
                v-model.number="form.anio_mantenimiento" 
                class="form-control" 
                :min="2000" 
                :max="new Date().getFullYear() + 1"
                required
              >
            </div>
          </div>

          <!-- Realizado Por -->
          <div class="form-group">
            <label class="form-label required">Realizado Por</label>
            <input 
              type="text" 
              v-model="form.realizado_por" 
              class="form-control" 
              placeholder="Nombre del proveedor o técnico"
              required
            >
          </div>

          <!-- Costo -->
          <div class="form-group">
            <label class="form-label">Costo (COP)</label>
            <input 
              type="number" 
              v-model.number="form.costo" 
              class="form-control" 
              placeholder="0"
              min="0"
              step="1000"
            >
          </div>

          <!-- Descripción -->
          <div class="form-group">
            <label class="form-label">Descripción</label>
            <textarea 
              v-model="form.descripcion" 
              class="form-control" 
              rows="3"
              placeholder="Descripción del mantenimiento realizado..."
            ></textarea>
          </div>

          <!-- Observaciones -->
          <div class="form-group">
            <label class="form-label">Observaciones</label>
            <textarea 
              v-model="form.observaciones" 
              class="form-control" 
              rows="3"
              placeholder="Observaciones adicionales..."
            ></textarea>
          </div>

          <!-- Botones -->
          <div class="modal-actions">
            <button type="button" class="btn btn-secondary" @click="$emit('close')">
              Cancelar
            </button>
            <button type="submit" class="btn btn-primary" :disabled="loading">
              {{ loading ? 'Guardando...' : 'Guardar Cambios' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { mantenimientosAPI } from '../../../services/api'
import { useNotifications } from '../../../composables/useNotifications'
import { MESES_NOMBRES } from '../../../composables/useMantenimientosFormatters'

const props = defineProps({
  mantenimiento: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['close', 'updated'])
const { showSuccess, showError } = useNotifications()

const loading = ref(false)

const form = ref({
  tipo_mantenimiento: '',
  mes_mantenimiento: 1,
  anio_mantenimiento: new Date().getFullYear(),
  realizado_por: '',
  costo: null,
  descripcion: '',
  observaciones: ''
})

onMounted(() => {
  // Cargar datos del mantenimiento
  form.value = {
    tipo_mantenimiento: props.mantenimiento.tipo_mantenimiento || '',
    mes_mantenimiento: props.mantenimiento.mes_mantenimiento || 1,
    anio_mantenimiento: props.mantenimiento.anio_mantenimiento || new Date().getFullYear(),
    realizado_por: props.mantenimiento.realizado_por || '',
    costo: props.mantenimiento.costo || null,
    descripcion: props.mantenimiento.descripcion || '',
    observaciones: props.mantenimiento.observaciones || ''
  }
})

async function handleSubmit() {
  try {
    loading.value = true
    
    await mantenimientosAPI.update(props.mantenimiento.id, form.value)
    showSuccess('Mantenimiento actualizado exitosamente')
    emit('updated')
    emit('close')
  } catch (error) {
    console.error('Error actualizando mantenimiento:', error)
    showError(error.response?.data?.message || 'Error al actualizar mantenimiento')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-container {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from { 
    opacity: 0;
    transform: translateY(20px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  padding: 20px 25px;
  border-bottom: 2px solid #e0e0e0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(90deg, rgba(0, 102, 51, 0.05) 0%, transparent 100%);
}

.modal-header h3 {
  margin: 0;
  color: #006633;
  font-size: 20px;
  font-weight: 700;
}

.btn-close {
  background: none;
  border: none;
  font-size: 24px;
  color: #616161;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.btn-close:hover {
  background: rgba(0, 0, 0, 0.1);
  color: #212121;
}

.modal-body {
  padding: 25px;
  overflow-y: auto;
  flex: 1;
}

.form-group {
  margin-bottom: 20px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px;
}

.form-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #212121;
  font-size: 14px;
}

.form-label.required::after {
  content: ' *';
  color: #f44336;
}

.form-control {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #c0c0c0;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.2s;
  background: #f9f9f9;
}

.form-control:focus {
  outline: none;
  border-color: #006633;
  background: white;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.form-control:disabled {
  background: #e8e8e8;
  color: #616161;
  cursor: not-allowed;
}

textarea.form-control {
  resize: vertical;
  font-family: inherit;
}

.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 25px;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.btn-primary {
  background: #006633;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #2d5016;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.2);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-secondary:hover {
  background: #d0d0d0;
}
</style>
