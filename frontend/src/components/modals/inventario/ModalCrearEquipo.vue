<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content">
      <div class="modal-header">
        <div class="modal-title">➕ Crear Nuevo Equipo</div>
        <button class="close-btn" @click="$emit('close')">&times;</button>
      </div>
      <div class="modal-body">
        <div class="tabs">
          <div class="tab" :class="{ active: activeTab === 1 }" @click="$emit('update:activeTab', 1)">1. Información General</div>
          <div class="tab" :class="{ active: activeTab === 2 }" @click="$emit('update:activeTab', 2)">2. Datos del Equipo</div>
          <div class="tab" :class="{ active: activeTab === 3 }" @click="$emit('update:activeTab', 3)">3. Registro Histórico</div>
          <div class="tab" :class="{ active: activeTab === 4 }" @click="$emit('update:activeTab', 4)">4. Documentos</div>
          <div class="tab" :class="{ active: activeTab === 5 }" @click="$emit('update:activeTab', 5)">5. Metrología</div>
          <div class="tab" :class="{ active: activeTab === 6 }" @click="$emit('update:activeTab', 6)">6. Condiciones</div>
        </div>

        <!-- TAB 1: INFO GENERAL -->
        <div v-show="activeTab === 1" class="tab-content active">
          <h4 class="section-title">📝 A. Información General</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede</label>
              <select class="form-select" v-model="localForm.sede">
                <option value="" disabled>Seleccione una sede</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
              <span v-if="formErrors.sede" class="error-message">{{ formErrors.sede }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Ubicación</label>
              <select class="form-select" v-model="localForm.servicio">
                <option value="" disabled>Seleccione un servicio</option>
                <option v-for="ubicacion in ubicacionesFiltrados" :key="ubicacion.id" :value="ubicacion.id">{{ ubicacion.nombre }}</option>
              </select>
              <span v-if="formErrors.ubicacion" class="error-message">{{ formErrors.ubicacion }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Nombre del Equipo</label>
              <input type="text" class="form-input" v-model="localForm.nombre_equipo" placeholder="Ej: Congelador, Agregómetro">
              <span v-if="formErrors.nombre_equipo" class="error-message">{{ formErrors.nombre_equipo }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Código de Inventario Interno</label>
              <input type="text" class="form-input" v-model="localForm.codigo_interno" placeholder="Ej: 135306">
              <span v-if="formErrors.codigo_interno" class="error-message">{{ formErrors.codigo_interno }}</span>
            </div>
            <div class="form-group">
              <label class="form-label">Código IPS</label>
              <input type="text" class="form-input" v-model="localForm.codigo_ips" placeholder="Ej: BIO-12183">
            </div>
            <div class="form-group">
              <label class="form-label">Código ECRI</label>
              <input type="text" class="form-input" v-model="localForm.codigo_ecri" placeholder="Ej: 15 - 583">
            </div>
            <div class="form-group">
              <label class="form-label required">Responsable del Equipo</label>
              <select class="form-select" v-model="localForm.responsable">
                <option value="" disabled>Seleccione un responsable</option>
                <option v-for="resp in responsables" :key="resp.id" :value="resp.id">{{ resp.nombre_completo }}</option>
              </select>
              <span v-if="formErrors.responsable" class="error-message">{{ formErrors.responsable }}</span>
            </div>
            <div class="form-group full-width">
              <label class="form-label required">Ubicación Física</label>
              <input type="text" class="form-input" v-model="localForm.ubicacion_fisica" placeholder="Ej: Procesamiento Sección C">
              <span v-if="formErrors.ubicacion_fisica" class="error-message">{{ formErrors.ubicacion_fisica }}</span>
            </div>
          </div>
        </div>

        <!-- TAB 2: DATOS DEL EQUIPO -->
        <div v-show="activeTab === 2" class="tab-content active">
          <h4 class="section-title">🔧 B. Información del Equipo</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Marca</label>
              <input type="text" class="form-input" v-model="localForm.marca" placeholder="Ej: Challenger, Helena Laboratories">
              <span v-if="formErrors.marca" class="error-message">{{ formErrors.marca }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Modelo</label>
              <input type="text" class="form-input" v-model="localForm.modelo" placeholder="Ej: CV430, AGGRAM">
              <span v-if="formErrors.modelo" class="error-message">{{ formErrors.modelo }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Número de Serie</label>
              <input type="text" class="form-input" v-model="localForm.serie" placeholder="Ej: 9053127">
              <span v-if="formErrors.serie" class="error-message">{{ formErrors.serie }}</span>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación Eje Misional <span style="font-size: 12px; color: #616161;">(Puede seleccionar varios)</span></label>
              <div class="checkbox-group" style="flex-wrap: wrap; gap: 15px;">
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="create-misional-docencia" value="Docencia" v-model="localForm.clasificacion_misional">
                  <label for="create-misional-docencia" style="font-size: 13px; cursor: pointer;">Docencia</label>
                </div>
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="create-misional-investigacion" value="Investigación" v-model="localForm.clasificacion_misional">
                  <label for="create-misional-investigacion" style="font-size: 13px; cursor: pointer;">Investigación</label>
                </div>
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="create-misional-extension" value="Extensión" v-model="localForm.clasificacion_misional">
                  <label for="create-misional-extension" style="font-size: 13px; cursor: pointer;">Extensión</label>
                </div>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación IPS</label>
              <select class="form-select" v-model="localForm.clasificacion_ips">
                <option value="">Seleccione</option>
                <option value="IND">IND - Industrial</option>
                <option value="BIO">BIO - Biomédico</option>
                <option value="Gases">Gases Medicinales</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación por Riesgo</label>
              <select class="form-select" v-model="localForm.clasificacion_riesgo">
                <option value="">Seleccione</option>
                <option value="I">Clase I</option>
                <option value="IIa">Clase IIa</option>
                <option value="IIb">Clase IIb</option>
                <option value="III">Clase III</option>
                <option value="N/A">N/A</option>
              </select>
            </div>
            <div class="form-group full-width">
              <label class="form-label">Registro INVIMA / Permiso Comercialización</label>
              <input type="text" class="form-input" v-model="localForm.registro_invima" placeholder="Ej: INVIMA 2019DM-0019614 o N/A">
            </div>
          </div>
        </div>

        <!-- TAB 3: REGISTRO HISTÓRICO -->
        <div v-show="activeTab === 3" class="tab-content active">
          <h4 class="section-title">📅 C. Registro Histórico</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Tiempo de Vida Útil</label>
              <input type="text" class="form-input" v-model="localForm.tiempo_vida_util" placeholder="Ej: 10 años">
            </div>
            <div class="form-group">
              <label class="form-label required">Fecha de Adquisición</label>
              <input type="date" class="form-input" v-model="localForm.fecha_adquisicion">
              <span v-if="formErrors.fecha_adquisicion" class="error-message">{{ formErrors.fecha_adquisicion }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Propietario del Equipo</label>
              <input type="text" class="form-input" v-model="localForm.propietario" placeholder="Ej: UdeA, Hospital">
              <span v-if="formErrors.propietario" class="error-message">{{ formErrors.propietario }}</span>
            </div>
            <div class="form-group">
              <label class="form-label">Fecha de Fabricación</label>
              <input type="text" class="form-input" v-model="localForm.fecha_fabricacion" placeholder="Año (Ej: 2008) o NI">
            </div>
            <div class="form-group">
              <label class="form-label required">NIT del Proveedor</label>
              <input type="text" class="form-input" v-model="localForm.nit_proveedor" placeholder="Ej: 890.934.939-8">
              <span v-if="formErrors.nit_proveedor" class="error-message">{{ formErrors.nit_proveedor }}</span>
            </div>
            <div class="form-group full-width">
              <label class="form-label required">Proveedor del Equipo</label>
              <textarea class="form-textarea" v-model="localForm.nombre_proveedor" placeholder="Nombre completo del proveedor"></textarea>
              <span v-if="formErrors.nombre_proveedor" class="error-message">{{ formErrors.nombre_proveedor }}</span>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="enGarantiaCreate" v-model="localForm.en_garantia">
                <label for="enGarantiaCreate" class="form-label" style="margin: 0;">¿Está en Garantía?</label>
              </div>
            </div>
            <div class="form-group" v-if="localForm.en_garantia">
              <label class="form-label">Fecha Finalización Garantía</label>
              <input type="date" class="form-input" v-model="localForm.fecha_finalizacion_garantia">
            </div>
            <div class="form-group">
              <label class="form-label required">Forma de Adquisición</label>
              <select class="form-select" v-model="localForm.forma_adquisicion">
                <option value="">Seleccione</option>
                <option value="Compra">Compra</option>
                <option value="Donación">Donación</option>
                <option value="Comodato">Comodato</option>
                <option value="Arrendamiento">Arrendamiento</option>
              </select>
              <span v-if="formErrors.forma_adquisicion" class="error-message">{{ formErrors.forma_adquisicion }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Tipo de Documento</label>
              <input type="text" class="form-input" v-model="localForm.tipo_documento" placeholder="Ej: Factura, Acta">
              <span v-if="formErrors.tipo_documento" class="error-message">{{ formErrors.tipo_documento }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Número de Documento</label>
              <input type="text" class="form-input" v-model="localForm.numero_documento" placeholder="Ej: 47736">
              <span v-if="formErrors.numero_documento" class="error-message">{{ formErrors.numero_documento }}</span>
            </div>
            <div class="form-group">
              <label class="form-label">Valor de Compra</label>
              <input type="text" class="form-input" v-model="localForm.valor_compra" placeholder="Ej: $5,000,000">
            </div>
          </div>
        </div>

        <!-- TAB 4: DOCUMENTOS -->
        <div v-show="activeTab === 4" class="tab-content active">
          <h4 class="section-title">📄 D. Inventario de Documentos</h4>
          <p style="color: #616161; margin-bottom: 20px; font-size: 14px;">Marque los documentos que posee el equipo:</p>
          <div class="form-grid">
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc1-create" v-model="localForm.hoja_vida">
                <label for="doc1-create" class="form-label" style="margin: 0;">Hoja de Vida</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc2-create" v-model="localForm.registro_importacion">
                <label for="doc2-create" class="form-label" style="margin: 0;">Registro de Importación</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc3-create" v-model="localForm.manual_operacion">
                <label for="doc3-create" class="form-label" style="margin: 0;">Manual de Operación</label>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Idioma del Manual</label>
              <select class="form-select" v-model="localForm.idioma_manual">
                <option value="">Seleccione</option>
                <option value="Español">Español</option>
                <option value="Inglés">Inglés</option>
                <option value="Otro">Otro</option>
              </select>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc4-create" v-model="localForm.manual_servicio">
                <label for="doc4-create" class="form-label" style="margin: 0;">Manual Servicio/Mto</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc5-create" v-model="localForm.guia_rapida">
                <label for="doc5-create" class="form-label" style="margin: 0;">Guía Rápida</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc6-create" v-model="localForm.instructivo_manejo">
                <label for="doc6-create" class="form-label" style="margin: 0;">Instructivo Manejo</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc7-create" v-model="localForm.protocolo_mto_preventivo">
                <label for="doc7-create" class="form-label" style="margin: 0;">Protocolo Mto Preventivo</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc8-create" v-model="localForm.frecuencia_metrologica_doc">
                <label for="doc8-create" class="form-label" style="margin: 0;">Frecuencia Metrológica</label>
              </div>
            </div>
            <div class="form-group full-width">
              <label class="form-label">Observaciones Documentos</label>
              <textarea class="form-textarea" v-model="localForm.observaciones_documentos" placeholder="Ej: Cart de proveedor de no entrega de manual"></textarea>
            </div>
          </div>
        </div>

        <!-- TAB 5: METROLOGÍA -->
        <div v-show="activeTab === 5" class="tab-content active">
          <h4 class="section-title">🔬 E & F. Información Metrológica</h4>
          <div class="info-box">
            <div class="info-box-title">Información Metrológica Administrativa</div>
            <p style="font-size: 13px; color: #616161;">Configure los parámetros de mantenimiento y calibración del equipo.</p>
          </div>
          <div class="form-grid">
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="reqMtoCreate" v-model="localForm.requiere_mantenimiento">
                <label for="reqMtoCreate" class="form-label" style="margin: 0;">Requiere Mantenimiento</label>
              </div>
            </div>
            <div class="form-group" v-if="localForm.requiere_mantenimiento">
              <label class="form-label">Frecuencia Anual Mantenimiento</label>
              <input type="number" class="form-input" v-model="localForm.frecuencia_mantenimiento" placeholder="Ej: 1, 2, 4" min="0">
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="reqCalCreate" v-model="localForm.requiere_calibracion">
                <label for="reqCalCreate" class="form-label" style="margin: 0;">Requiere Calibración</label>
              </div>
            </div>
            <div class="form-group" v-if="localForm.requiere_calibracion">
              <label class="form-label">Frecuencia Anual Calibración</label>
              <input type="number" class="form-input" v-model="localForm.frecuencia_calibracion" placeholder="Ej: 1, 2, 4" min="0">
            </div>
            <div class="form-group" v-if="localForm.requiere_calibracion">
              <label class="form-label">Tipo de Calibración</label>
              <input type="text" class="form-input" v-model="localForm.tipo_calibracion" placeholder="Ej: Calificación, Verificación">
            </div>
          </div>

          <div class="section-divider"></div>

          <div class="info-box">
            <div class="info-box-title">Información Metrológica Técnica</div>
            <p style="font-size: 13px; color: #616161;">Especificaciones técnicas del equipo para su operación.</p>
          </div>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Magnitud</label>
              <input type="text" class="form-input" v-model="localForm.magnitud" placeholder="Ej: Temperatura, Absorbancia">
            </div>
            <div class="form-group">
              <label class="form-label">Rango del Equipo</label>
              <input type="text" class="form-input" v-model="localForm.rango_equipo" placeholder="Ej: T -18, 0-100°C">
            </div>
            <div class="form-group">
              <label class="form-label">Resolución</label>
              <input type="text" class="form-input" v-model="localForm.resolucion" placeholder="Ej: 0.1°C, NI">
            </div>
            <div class="form-group">
              <label class="form-label">Rango de Trabajo</label>
              <input type="text" class="form-input" v-model="localForm.rango_trabajo" placeholder="Ej: 0 a -33°C">
            </div>
            <div class="form-group">
              <label class="form-label">Error Máximo Permitido</label>
              <input type="text" class="form-input" v-model="localForm.error_maximo" placeholder="Ej: ±0.5°C, NI">
            </div>
          </div>
        </div>

        <!-- TAB 6: CONDICIONES -->
        <div v-show="activeTab === 6" class="tab-content active">
          <h4 class="section-title">⚙️ G. Condiciones de Funcionamiento</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Voltaje</label>
              <input type="text" class="form-input" v-model="localForm.voltaje" placeholder="Ej: 115 VAC, 200-240V">
            </div>
            <div class="form-group">
              <label class="form-label">Corriente</label>
              <input type="text" class="form-input" v-model="localForm.corriente" placeholder="Ej: 4A, NI">
            </div>
            <div class="form-group">
              <label class="form-label">Humedad Relativa</label>
              <input type="text" class="form-input" v-model="localForm.presion" placeholder="Ej: 30-90%, NI">
            </div>
            <div class="form-group">
              <label class="form-label">Temperatura Funcionamiento</label>
              <input type="text" class="form-input" v-model="localForm.potencia" placeholder="Ej: Max 38°C">
            </div>
            <div class="form-group">
              <label class="form-label">Dimensiones</label>
              <input type="text" class="form-input" v-model="localForm.dimensiones" placeholder="Ej: 53.5 x 53 x 142 cm">
            </div>
            <div class="form-group">
              <label class="form-label">Peso</label>
              <input type="text" class="form-input" v-model="localForm.peso" placeholder="Ej: 55.5 kg">
            </div>
            <div class="form-group full-width">
              <label class="form-label">Otras Condiciones</label>
              <textarea class="form-textarea" v-model="localForm.otros" placeholder="Ej: Frecuencia eléctrica, presión, etc."></textarea>
            </div>
          </div>
        </div>

        <div v-if="successMessage" class="alert alert-success" style="margin-top: 20px;">
          {{ successMessage }}
        </div>
        <div v-if="formErrors.submit" class="alert alert-warning" style="margin-top: 20px;">
          {{ formErrors.submit }}
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')" :disabled="submitLoading">Cancelar</button>
        <button class="btn btn-primary" @click="$emit('submit')" :disabled="submitLoading">
          <span v-if="submitLoading">Guardando...</span>
          <span v-else>💾 Guardar Equipo</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, watch } from 'vue'

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  activeTab: {
    type: Number,
    default: 1
  },
  formData: {
    type: Object,
    required: true
  },
  sedes: {
    type: Array,
    default: () => []
  },
  ubicaciones: {
    type: Array,
    default: () => []
  },
  responsables: {
    type: Array,
    default: () => []
  },
  formErrors: {
    type: Object,
    default: () => ({})
  },
  successMessage: {
    type: String,
    default: ''
  },
  submitLoading: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['close', 'submit', 'update:activeTab', 'update:formData'])

const localForm = computed({
  get: () => props.formData,
  set: (value) => emit('update:formData', value)
})

const ubicacionesFiltrados = computed(() => {
  if (!localForm.value.sede) return props.ubicaciones
  return props.ubicaciones.filter(s => s.sede === localForm.value.sede)
})

// Watch for changes to propagate to parent
watch(localForm, (newValue) => {
  emit('update:formData', newValue)
}, { deep: true })
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

/* Tabs inside Modal */
.tabs { display: flex; border-bottom: 2px solid #e0e0e0; margin-bottom: 25px; flex-shrink: 0; flex-wrap: wrap; }
.tab { padding: 12px 20px; cursor: pointer; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: all 0.3s; font-weight: 500; white-space: nowrap; }
.tab:hover { color: #006633; }
.tab.active { color: #006633; border-bottom-color: #006633; font-weight: 600; }
.tab-content { display: none; }
.tab-content.active { display: block; }

/* Button Styles */
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }
.btn-secondary { background: #e0e0e0; }

/* Form Styles */
.form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.form-group { margin-bottom: 12px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-label { display: block; margin-bottom: 4px; font-weight: 600; font-size: 13px; color: #212121; }
.form-label.required::after { content: " *"; color: #f44336; }
.form-input, .form-select, .form-textarea { width: 100%; padding: 8px 12px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-family: inherit; transition: border-color 0.3s; }
.form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: #006633; box-shadow: 0 0 0 3px rgba(0,102,51,0.1); }
.form-textarea { resize: vertical; min-height: 80px; }
.checkbox-group { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
.checkbox-input { width: 18px; height: 18px; cursor: pointer; }

.section-divider { margin: 15px 0; padding-top: 15px; border-top: 2px solid #e0e0e0; }
.section-title { font-size: 18px; color: #006633; font-weight: 600; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; }
.info-box { background: rgba(0,102,51,0.05); border-left: 4px solid #006633; padding: 15px; border-radius: 4px; margin-bottom: 12px; }
.info-box-title { font-weight: 600; color: #006633; margin-bottom: 8px; }

.error-message { color: #f44336; font-size: 12px; display: block; margin-top: 4px; }
.alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; transition: all 0.3s; }
.alert-warning { background: rgba(255, 152, 0, 0.1); color: #ff9800; border-left: 4px solid #ff9800; }
.alert-success { background: rgba(76, 175, 80, 0.1); color: #4CAF50; border-left: 4px solid #4CAF50; }
</style>
