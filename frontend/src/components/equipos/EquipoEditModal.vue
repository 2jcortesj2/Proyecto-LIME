<template>
  <div v-if="show" class="modal-overlay" @click.self="closeModal">
    <div class="modal-content modal-large">
      <div class="modal-header">
        <h2>Editar Equipo Biomédico</h2>
        <button class="modal-close" @click="closeModal">×</button>
      </div>

      <div class="modal-tabs">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          class="modal-tab" 
          :class="{ active: form.activeTab === tab.id }"
          @click="form.activeTab = tab.id"
        >
          {{tab.label}}
        </button>
      </div>

      <div class="modal-body">
        <div v-if="form.successMessage" class="success-message">{{ form.successMessage }}</div>
        <div v-if="form.formErrors.submit" class="error-message">{{ form.formErrors.submit }}</div>

        <form @submit.prevent="handleSubmit">
          <!-- TAB 1: Información General -->
          <div v-show="form.activeTab === 1" class="tab-content">
            <h3 class="tab-title">A. Información General</h3>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Sede</label>
                <select v-model="form.form.sede" class="form-input" :class="{ 'input-error': form.formErrors.sede }">
                  <option value="">Seleccione...</option>
                  <option v-for="sede in form.sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
                </select>
                <span v-if="form.formErrors.sede" class="error-text">{{ form.formErrors.sede }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Servicio</label>
                <select v-model="form.form.servicio" class="form-input" :class="{ 'input-error': form.formErrors.servicio }">
                  <option value="">Seleccione...</option>
                  <option v-for="servicio in form.serviciosFiltrados" :key="servicio.id" :value="servicio.id">{{ servicio.nombre }}</option>
                </select>
                <span v-if="form.formErrors.servicio" class="error-text">{{ form.formErrors.servicio }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Nombre del Equipo</label>
                <input type="text" v-model="form.form.nombre_equipo" class="form-input" :class="{ 'input-error': form.formErrors.nombre_equipo }">
                <span v-if="form.formErrors.nombre_equipo" class="error-text">{{ form.formErrors.nombre_equipo }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Código Interno</label>
                <input type="text" v-model="form.form.codigo_interno" class="form-input" :class="{ 'input-error': form.formErrors.codigo_interno }">
                <span v-if="form.formErrors.codigo_interno" class="error-text">{{ form.formErrors.codigo_interno }}</span>
              </div>

              <div class="form-group">
                <label class="form-label">Código IPS</label>
                <input type="text" v-model="form.form.codigo_ips" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label">Código ECRI</label>
                <input type="text" v-model="form.form.codigo_ecri" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label required">Responsable</label>
                <select v-model="form.form.responsable" class="form-input" :class="{ 'input-error': form.formErrors.responsable }">
                  <option value="">Seleccione...</option>
                  <option v-for="resp in form.responsables" :key="resp.id" :value="resp.id">{{ resp.nombre_completo }}</option>
                </select>
                <span v-if="form.formErrors.responsable" class="error-text">{{ form.formErrors.responsable }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Ubicación Física</label>
                <input type="text" v-model="form.form.ubicacion_fisica" class="form-input" :class="{ 'input-error': form.formErrors.ubicacion_fisica }">
                <span v-if="form.formErrors.ubicacion_fisica" class="error-text">{{ form.formErrors.ubicacion_fisica }}</span>
              </div>
            </div>
          </div>

          <!-- TAB 2: Datos del Equipo -->
          <div v-show="form.activeTab === 2" class="tab-content">
            <h3 class="tab-title">B. Información del Equipo</h3>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Marca</label>
                <input type="text" v-model="form.form.marca" class="form-input" :class="{ 'input-error': form.formErrors.marca }">
                <span v-if="form.formErrors.marca" class="error-text">{{ form.formErrors.marca }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Modelo</label>
                <input type="text" v-model="form.form.modelo" class="form-input" :class="{ 'input-error': form.formErrors.modelo }">
                <span v-if="form.formErrors.modelo" class="error-text">{{ form.formErrors.modelo }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Serie</label>
                <input type="text" v-model="form.form.serie" class="form-input" :class="{ 'input-error': form.formErrors.serie }">
                <span v-if="form.formErrors.serie" class="error-text">{{ form.formErrors.serie }}</span>
              </div>

              <div class="form-group">
                <label class="form-label">Clasificación IPS</label>
                <select v-model="form.form.clasificacion_ips" class="form-input">
                  <option value="">Seleccione...</option>
                  <option value="IND">IND</option>
                  <option value="BIO">BIO</option>
                  <option value="GASES">GASES</option>
                </select>
              </div>

              <div class="form-group">
                <label class="form-label">Clasificación de Riesgo</label>
                <select v-model="form.form.clasificacion_riesgo" class="form-input">
                  <option value="">Seleccione...</option>
                  <option value="I">Clase I</option>
                  <option value="IIa">Clase IIa</option>
                  <option value="IIb">Clase IIb</option>
                  <option value="III">Clase III</option>
                </select>
              </div>

              <div class="form-group">
                <label class="form-label">Registro INVIMA</label>
                <input type="text" v-model="form.form.registro_invima" class="form-input">
              </div>

              <div class="form-group" style="grid-column: span 2;">
                <label class="form-label">Clasificación Misional</label>
                <div style="display: flex; gap: 20px; margin-top: 8px;">
                  <label class="checkbox-label">
                    <input type="checkbox" value="Docencia" v-model="form.form.clasificacion_misional">
                    Docencia
                  </label>
                  <label class="checkbox-label">
                    <input type="checkbox" value="Investigación" v-model="form.form.clasificacion_misional">
                    Investigación
                  </label>
                  <label class="checkbox-label">
                    <input type="checkbox" value="Extensión" v-model="form.form.clasificacion_misional">
                    Extensión
                  </label>
                </div>
              </div>
            </div>
          </div>

          <!-- TAB 3: Registro Histórico -->
          <div v-show="form.activeTab === 3" class="tab-content">
            <h3 class="tab-title">C. Registro Histórico</h3>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Tiempo Vida Útil (años)</label>
                <input type="number" v-model="form.form.tiempo_vida_util" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label required">Fecha de Adquisición</label>
                <input type="date" v-model="form.form.fecha_adquisicion" class="form-input" :class="{ 'input-error': form.formErrors.fecha_adquisicion }">
                <span v-if="form.formErrors.fecha_adquisicion" class="error-text">{{ form.formErrors.fecha_adquisicion }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Propietario</label>
                <input type="text" v-model="form.form.propietario" class="form-input" :class="{ 'input-error': form.formErrors.propietario }">
                <span v-if="form.formErrors.propietario" class="error-text">{{ form.formErrors.propietario }}</span>
              </div>

              <div class="form-group">
                <label class="form-label">Fecha de Fabricación</label>
                <input type="date" v-model="form.form.fecha_fabricacion" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label required">NIT Proveedor</label>
                <input type="text" v-model="form.form.nit_proveedor" class="form-input" :class="{ 'input-error': form.formErrors.nit_proveedor }">
                <span v-if="form.formErrors.nit_proveedor" class="error-text">{{ form.formErrors.nit_proveedor }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Nombre Proveedor</label>
                <input type="text" v-model="form.form.nombre_proveedor" class="form-input" :class="{ 'input-error': form.formErrors.nombre_proveedor }">
                <span v-if="form.formErrors.nombre_proveedor" class="error-text">{{ form.formErrors.nombre_proveedor }}</span>
              </div>

              <div class="form-group">
                <label class="checkbox-label">
                  <input type="checkbox" v-model="form.form.en_garantia">
                  En Garantía
                </label>
              </div>

              <div class="form-group" v-if="form.form.en_garantia">
                <label class="form-label">Fecha Fin Garantía</label>
                <input type="date" v-model="form.form.fecha_finalizacion_garantia" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label required">Forma de Adquisición</label>
                <select v-model="form.form.forma_adquisicion" class="form-input" :class="{ 'input-error': form.formErrors.forma_adquisicion }">
                  <option value="">Seleccione...</option>
                  <option value="Compra">Compra</option>
                  <option value="Apoyo Tecnológico">Apoyo Tecnológico</option>
                  <option value="Donación">Donación</option>
                  <option value="Convenio">Convenio</option>
                </select>
                <span v-if="form.formErrors.forma_adquisicion" class="error-text">{{ form.formErrors.forma_adquisicion }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Tipo de Documento</label>
                <input type="text" v-model="form.form.tipo_documento" class="form-input" :class="{ 'input-error': form.formErrors.tipo_documento }">
                <span v-if="form.formErrors.tipo_documento" class="error-text">{{ form.formErrors.tipo_documento }}</span>
              </div>

              <div class="form-group">
                <label class="form-label required">Número de Documento</label>
                <input type="text" v-model="form.form.numero_documento" class="form-input" :class="{ 'input-error': form.formErrors.numero_documento }">
                <span v-if="form.formErrors.numero_documento" class="error-text">{{ form.formErrors.numero_documento }}</span>
              </div>

              <div class="form-group">
                <label class="form-label">Valor de Compra</label>
                <input type="number" v-model="form.form.valor_compra" class="form-input">
              </div>
            </div>
          </div>

          <!-- TAB 4: Documentos -->
          <div v-show="form.activeTab === 4" class="tab-content">
            <h3 class="tab-title">D. Inventario de Documentos</h3>
            <div class="documentos-grid">
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.hoja_vida">
                Hoja de Vida
              </label>
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.registro_importacion">
                Registro de Importación
              </label>
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.manual_operacion">
                Manual de Operación
              </label>
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.manual_servicio">
                Manual de Servicio
              </label>
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.guia_rapida">
                Guía Rápida
              </label>
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.instructivo_manejo">
                Instructivo de Manejo
              </label>
              <label class="checkbox-label">
                <input type="checkbox" v-model="form.form.protocolo_mto_preventivo">
                Protocolo Mto. Preventivo
              </label>
            </div>
          </div>

          <!-- TAB 5: Información Metrológica -->
          <div v-show="form.activeTab === 5" class="tab-content">
            <h3 class="tab-title">E. Información Metrológica</h3>
            <div class="form-grid">
              <div class="form-group">
                <label class="checkbox-label">
                  <input type="checkbox" v-model="form.form.requiere_mantenimiento">
                  Requiere Mantenimiento
                </label>
              </div>

              <div class="form-group" v-if="form.form.requiere_mantenimiento">
                <label class="form-label">Frecuencia de Mantenimiento</label>
                <input type="text" v-model="form.form.frecuencia_mantenimiento" class="form-input">
              </div>

              <div class="form-group" v-if="form.form.requiere_mantenimiento">
                <label class="form-label">Último Mantenimiento</label>
                <input type="date" v-model="form.form.ultimo_mantenimiento" class="form-input">
              </div>

              <div class="form-group">
                <label class="checkbox-label">
                  <input type="checkbox" v-model="form.form.requiere_calibracion">
                  Requiere Calibración
                </label>
              </div>

              <div class="form-group" v-if="form.form.requiere_calibracion">
                <label class="form-label">Magnitud</label>
                <input type="text" v-model="form.form.magnitud" class="form-input">
              </div>

              <div class="form-group" v-if="form.form.requiere_calibracion">
                <label class="form-label">Rango del Equipo</label>
                <input type="text" v-model="form.form.rango_equipo" class="form-input">
              </div>

              <div class="form-group" v-if="form.form.requiere_calibracion">
                <label class="form-label">Rango de Trabajo</label>
                <input type="text" v-model="form.form.rango_trabajo" class="form-input">
              </div>

              <div class="form-group" v-if="form.form.requiere_calibracion">
                <label class="form-label">Resolución</label>
                <input type="text" v-model="form.form.resolucion" class="form-input">
              </div>

              <div class="form-group" v-if="form.form.requiere_calibracion">
                <label class="form-label">Error Máximo</label>
                <input type="text" v-model="form.form.error_maximo" class="form-input">
              </div>
            </div>
          </div>

          <!-- TAB 6: Condiciones de Funcionamiento -->
          <div v-show="form.activeTab === 6" class="tab-content">
            <h3 class="tab-title">F. Condiciones de Funcionamiento</h3>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Voltaje</label>
                <input type="text" v-model="form.form.voltaje" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label">Corriente</label>
                <input type="text" v-model="form.form.corriente" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label">Potencia</label>
                <input type="text" v-model="form.form.potencia" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label">Presión</label>
                <input type="text" v-model="form.form.presion" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label">Dimensiones</label>
                <input type="text" v-model="form.form.dimensiones" class="form-input">
              </div>

              <div class="form-group">
                <label class="form-label">Peso</label>
                <input type="text" v-model="form.form.peso" class="form-input">
              </div>

              <div class="form-group" style="grid-column: span 2;">
                <label class="form-label">Otros</label>
                <textarea v-model="form.form.otros" class="form-input" rows="3"></textarea>
              </div>
            </div>
          </div>

          <!-- Navigation Buttons -->
          <div class="modal-footer">
            <div class="tab-navigation">
              <button 
                type="button" 
                class="btn-secondary" 
                @click="previousTab" 
                :disabled="form.activeTab === 1"
              >
                ← Anterior
              </button>
              <span class="tab-indicator">Pestaña {{ form.activeTab }} de 6</span>
              <button 
                type="button" 
                class="btn-secondary" 
                @click="nextTab" 
                :disabled="form.activeTab === 6"
              >
                Siguiente →
              </button>
            </div>

            <div class="form-actions">
              <button type="button" class="btn-secondary" @click="closeModal" :disabled="form.submitLoading">
                Cancelar
              </button>
              <button type="submit" class="btn-primary" :disabled="form.submitLoading">
                {{ form.submitLoading ? 'Actualizando...' : 'Guardar Cambios' }}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { watch, onMounted } from 'vue'
import { useEquipoForm } from '../../composables/useEquipoForm'

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  equipo: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['close', 'success'])

const form = useEquipoForm('edit')

const tabs = [
  { id: 1, label: 'Información General' },
  { id: 2, label: 'Datos del Equipo' },
  { id: 3, label: 'Registro Histórico' },
  { id: 4, label: 'Documentos' },
  { id: 5, label: 'Metrología' },
  { id: 6, label: 'Condiciones' }
]

// Load catalogs and equipo data when modal opens or equipo changes
watch(() => [props.show, props.equipo], async ([newShow, newEquipo]) => {
  if (newShow && newEquipo) {
    await form.loadCatalogs()
    form.loadEquipoData(newEquipo)
  }
}, { immediate: true })

function closeModal() {
  emit('close')
  form.resetForm()
}

async function handleSubmit() {
  const result = await form.submitForm()
  if (result.success) {
    setTimeout(() => {
      emit('success')
      closeModal()
    }, 1500)
  }
}

function nextTab() {
  if (form.activeTab < 6) {
    form.activeTab++
  }
}

function previousTab() {
  if (form.activeTab > 1) {
    form.activeTab--
  }
}

onMounted(() => {
  // Optionally pre-load catalogs
  form.loadCatalogs()
})
</script>

<style scoped>
/* Reuse exact same styles as CreateModal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(3px);
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 900px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.modal-large {
  max-width: 1000px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #e0e0e0;
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
  border-radius: 12px 12px 0 0;
  position: sticky;
  top: 0;
  z-index: 10;
}

.modal-header h2 {
  margin: 0;
  font-size: 22px;
  font-weight: 600;
}

.modal-close {
  background: none;
  border: none;
  font-size: 32px;
  color: white;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: all 0.2s;
}

.modal-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

.modal-tabs {
  display: flex;
  background: #f5f5f5;
  border-bottom: 2px solid #e0e0e0;
  overflow-x: auto;
  position: sticky;
  top: 70px;
  z-index: 9;
}

.modal-tab {
  padding: 12px 20px;
  background: transparent;
  border: none;
  color: #616161;
  cursor: pointer;
  font-weight: 500;
  font-size: 14px;
  border-bottom: 3px solid transparent;
  transition: all 0.2s;
  white-space: nowrap;
}

.modal-tab.active {
  color: #006633;
  border-bottom-color: #006633;
  background: white;
  font-weight: 600;
}

.modal-tab:hover:not(.active) {
  background: rgba(0, 102, 51, 0.05);
}

.modal-body {
  padding: 24px;
}

.tab-content {
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.tab-title {
  color: #006633;
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 2px solid #e0e0e0;
}

/* Form Styles */
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #424242;
  font-size: 14px;
}

.form-label.required::after {
  content: ' *';
  color: #f44336;
}

.form-input, select.form-input, textarea.form-input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.2s;
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.form-input.input-error {
  border-color: #f44336;
}

.error-text {
  display: block;
  color: #f44336;
  font-size: 12px;
  margin-top: 4px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #424242;
  cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.documentos-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

/* Messages */
.success-message {
  background: #e8f5e9;
  color: #2e7d32;
  padding: 12px 16px;
  border-radius: 6px;
  margin-bottom: 16px;
  border-left: 4px solid #4caf50;
}

.error-message {
  background: #ffebee;
  color: #c62828;
  padding: 12px 16px;
  border-radius: 6px;
  margin-bottom: 16px;
  border-left: 4px solid #f44336;
}

/* Footer */
.modal-footer {
  border-top: 1px solid #e0e0e0;
  padding-top: 20px;
  margin-top: 30px;
}

.tab-navigation {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.tab-indicator {
  font-size: 14px;
  color: #616161;
  font-weight: 500;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.btn-primary, .btn-secondary {
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  border: none;
}

.btn-primary {
  background: #006633;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #2d5016;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.3);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-secondary:hover:not(:disabled) {
  background: #d5d5d5;
}

.btn-secondary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
