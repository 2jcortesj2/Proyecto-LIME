<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content">
      <div class="modal-header">
        <div class="modal-title">✏️ Editar Equipo - {{ equipo?.nombre_equipo }} ({{ equipo?.codigo_interno }})</div>
        <button class="close-btn" @click="close">&times;</button>
      </div>
      <div class="modal-body">
        <div class="edit-note">
          ℹ️ <strong>Campos protegidos:</strong> Los campos con fondo amarillo 🔒 requieren contraseña de administrador.
        </div>

        <div class="tabs">
          <div class="tab" :class="{ active: activeTab === 1 }" @click="activeTab = 1">1. Información General</div>
          <div class="tab" :class="{ active: activeTab === 2 }" @click="activeTab = 2">2. Datos del Equipo</div>
          <div class="tab" :class="{ active: activeTab === 3 }" @click="activeTab = 3">3. Registro Histórico</div>
          <div class="tab" :class="{ active: activeTab === 4 }" @click="activeTab = 4">4. Documentos</div>
          <div class="tab" :class="{ active: activeTab === 5 }" @click="activeTab = 5">5. Metrología</div>
          <div class="tab" :class="{ active: activeTab === 6 }" @click="activeTab = 6">6. Condiciones</div>
        </div>

        <!-- TAB 1: INFO GENERAL -->
        <div v-show="activeTab === 1" class="tab-content active">
          <h4 class="section-title">📝 A. Información General</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede</label>
              <select class="form-select" v-model="formData.sede">
                <option value="">Seleccione una sede</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Proceso</label>
              <select class="form-select" v-model="formData.ubicacion">
                <option value="">Seleccione una ubicación</option>
                <option v-for="ub in ubicacionesFiltradas" :key="ub.id" :value="ub.id">{{ ub.nombre }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Nombre del Equipo</label>
              <input type="text" class="form-input" v-model="formData.nombre_equipo">
            </div>
            <div class="form-group">
              <label class="form-label required">Código Interno <span class="lock-icon">🔒</span></label>
              <input type="text" class="form-input locked" v-model="formData.codigo_interno" @click="openProtectedField('codigo_interno')" readonly>
            </div>
            <div class="form-group">
              <label class="form-label">Código IPS</label>
              <input type="text" class="form-input" v-model="formData.codigo_ips">
            </div>
            <div class="form-group">
              <label class="form-label">Código ECRI</label>
              <input type="text" class="form-input" v-model="formData.codigo_ecri">
            </div>
            <div class="form-group">
              <label class="form-label required">Responsable</label>
              <select class="form-select" v-model="formData.responsable">
                <option value="">Seleccione</option>
                <option v-for="resp in responsables" :key="resp.id" :value="resp.id">{{ resp.nombre_completo }}</option>
              </select>
            </div>
            <div class="form-group full-width">
              <label class="form-label required">Ubicación Física</label>
              <input type="text" class="form-input" v-model="formData.ubicacion_fisica">
            </div>
          </div>
        </div>

        <!-- TAB 2: DATOS DEL EQUIPO -->
        <div v-show="activeTab === 2" class="tab-content active">
          <h4 class="section-title">🔧 B. Información del Equipo</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Marca</label>
              <input type="text" class="form-input" v-model="formData.marca">
            </div>
            <div class="form-group">
              <label class="form-label required">Modelo</label>
              <input type="text" class="form-input" v-model="formData.modelo">
            </div>
            <div class="form-group">
              <label class="form-label required">Número de Serie <span class="lock-icon">🔒</span></label>
              <input type="text" class="form-input locked" v-model="formData.serie" @click="openProtectedField('serie')" readonly>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación Eje Misional <span style="font-size: 12px; color: #616161;">(Varios)</span></label>
              <div class="checkbox-group" style="flex-wrap: wrap; gap: 15px;">
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="edit-misional-docencia" value="Docencia" v-model="formData.clasificacion_misional">
                  <label for="edit-misional-docencia" style="font-size: 13px; cursor: pointer;">Docencia</label>
                </div>
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="edit-misional-investigacion" value="Investigación" v-model="formData.clasificacion_misional">
                  <label for="edit-misional-investigacion" style="font-size: 13px; cursor: pointer;">Investigación</label>
                </div>
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="edit-misional-extension" value="Extensión" v-model="formData.clasificacion_misional">
                  <label for="edit-misional-extension" style="font-size: 13px; cursor: pointer;">Extensión</label>
                </div>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación IPS</label>
              <select class="form-select" v-model="formData.clasificacion_ips">
                <option value="">Seleccione</option>
                <option value="IND">IND - Industrial</option>
                <option value="BIO">BIO - Biomédico</option>
                <option value="Gases">Gases Medicinales</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación por Riesgo</label>
              <select class="form-select" v-model="formData.clasificacion_riesgo">
                <option value="">Seleccione</option>
                <option value="I">Clase I</option>
                <option value="IIa">Clase IIa</option>
                <option value="IIb">Clase IIb</option>
                <option value="III">Clase III</option>
                <option value="N/A">N/A</option>
              </select>
            </div>
            <div class="form-group full-width">
              <label class="form-label">Registro INVIMA</label>
              <input type="text" class="form-input" v-model="formData.registro_invima">
            </div>
            <div class="form-group full-width">
              <label class="form-label">Estado del Equipo</label>
              <select class="form-select" v-model="formData.estado">
                <option value="Activo">Activo</option>
                <option value="En Mantenimiento">En Mantenimiento</option>
                <option value="Baja">Baja</option>
                <option value="Inactivo">Inactivo</option>
              </select>
            </div>
          </div>
        </div>

        <!-- TAB 3: REGISTRO HISTÓRICO -->
        <div v-show="activeTab === 3" class="tab-content active">
          <h4 class="section-title">📅 C. Registro Histórico</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Tiempo de Vida Útil</label>
              <input type="text" class="form-input" v-model="formData.tiempo_vida_util">
            </div>
            <div class="form-group">
              <label class="form-label required">Fecha de Adquisición <span class="lock-icon">🔒</span></label>
              <input type="date" class="form-input locked" v-model="formData.fecha_adquisicion" @click="openProtectedField('fecha_adquisicion')" readonly>
            </div>
            <div class="form-group">
              <label class="form-label required">Propietario <span class="lock-icon">🔒</span></label>
              <input type="text" class="form-input locked" v-model="formData.propietario" @click="openProtectedField('propietario')" readonly>
            </div>
            <div class="form-group">
              <label class="form-label">Fecha de Fabricación</label>
              <input type="text" class="form-input" v-model="formData.fecha_fabricacion">
            </div>
            <div class="form-group">
              <label class="form-label required">NIT Proveedor <span class="lock-icon">🔒</span></label>
              <input type="text" class="form-input locked" v-model="formData.nit_proveedor" @click="openProtectedField('nit_proveedor')" readonly>
            </div>
            <div class="form-group full-width">
              <label class="form-label required">Proveedor <span class="lock-icon">🔒</span></label>
              <textarea class="form-textarea locked" v-model="formData.nombre_proveedor" @click="openProtectedField('nombre_proveedor')" readonly></textarea>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-garantia" v-model="formData.en_garantia">
                <label for="edit-garantia" class="form-label" style="margin: 0;">¿En Garantía?</label>
              </div>
            </div>
            <div class="form-group" v-if="formData.en_garantia">
              <label class="form-label">Fecha Fin Garantía</label>
              <input type="date" class="form-input" v-model="formData.fecha_finalizacion_garantia">
            </div>
            <div class="form-group">
              <label class="form-label required">Forma Adquisición <span class="lock-icon">🔒</span></label>
              <select class="form-select locked" v-model="formData.forma_adquisicion" @click="openProtectedField('forma_adquisicion')" disabled>
                <option value="">Seleccione</option>
                <option value="Compra">Compra</option>
                <option value="Donación">Donación</option>
                <option value="Comodato">Comodato</option>
                <option value="Arrendamiento">Arrendamiento</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Tipo Documento <span class="lock-icon">🔒</span></label>
              <input type="text" class="form-input locked" v-model="formData.tipo_documento" @click="openProtectedField('tipo_documento')" readonly>
            </div>
            <div class="form-group">
              <label class="form-label required">Número Documento <span class="lock-icon">🔒</span></label>
              <input type="text" class="form-input locked" v-model="formData.numero_documento" @click="openProtectedField('numero_documento')" readonly>
            </div>
            <div class="form-group">
              <label class="form-label">Valor de Compra</label>
              <input type="number" class="form-input" v-model="formData.valor_compra">
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
                <input type="checkbox" class="checkbox-input" id="edit-doc1" v-model="formData.hoja_vida">
                <label for="edit-doc1" class="form-label" style="margin: 0;">Hoja de Vida</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-doc2" v-model="formData.registro_importacion">
                <label for="edit-doc2" class="form-label" style="margin: 0;">Registro de Importación</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-doc3" v-model="formData.manual_operacion">
                <label for="edit-doc3" class="form-label" style="margin: 0;">Manual de Operación</label>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Idioma del Manual</label>
              <select class="form-select" v-model="formData.idioma_manual">
                <option value="">Seleccione</option>
                <option value="Español">Español</option>
                <option value="Inglés">Inglés</option>
                <option value="Otro">Otro</option>
              </select>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-doc4" v-model="formData.manual_servicio">
                <label for="edit-doc4" class="form-label" style="margin: 0;">Manual Servicio/Mto</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-doc5" v-model="formData.guia_rapida">
                <label for="edit-doc5" class="form-label" style="margin: 0;">Guía Rápida</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-doc6" v-model="formData.instructivo_manejo">
                <label for="edit-doc6" class="form-label" style="margin: 0;">Instructivo Manejo</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-doc7" v-model="formData.protocolo_mto_preventivo">
                <label for="edit-doc7" class="form-label" style="margin: 0;">Protocolo Mto Preventivo</label>
              </div>
            </div>
            <div class="form-group full-width">
              <label class="form-label">Observaciones Documentos</label>
              <textarea class="form-textarea" v-model="formData.observaciones_documentos"></textarea>
            </div>
          </div>
        </div>

        <!-- TAB 5: METROLOGÍA -->
        <div v-show="activeTab === 5" class="tab-content active">
          <h4 class="section-title">🔬 E & F. Información Metrológica</h4>
          <div class="info-box">
            <div class="info-box-title">Información Metrológica Administrativa</div>
            <p style="font-size: 13px; color: #616161;">Configure los parámetros de mantenimiento y calibración.</p>
          </div>
          <div class="form-grid">
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-reqMto" v-model="formData.requiere_mantenimiento">
                <label for="edit-reqMto" class="form-label" style="margin: 0;">Requiere Mantenimiento</label>
              </div>
            </div>
            <div class="form-group" v-if="formData.requiere_mantenimiento">
              <label class="form-label">Frecuencia Anual Mantenimiento</label>
              <input type="number" class="form-input" v-model="formData.frecuencia_mantenimiento" min="0">
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="edit-reqCal" v-model="formData.requiere_calibracion">
                <label for="edit-reqCal" class="form-label" style="margin: 0;">Requiere Calibración</label>
              </div>
            </div>
            <div class="form-group" v-if="formData.requiere_calibracion">
              <label class="form-label">Frecuencia Anual Calibración</label>
              <input type="number" class="form-input" v-model="formData.frecuencia_calibracion" min="0">
            </div>
            <div class="form-group" v-if="formData.requiere_calibracion">
              <label class="form-label">Tipo de Calibración</label>
              <input type="text" class="form-input" v-model="formData.tipo_calibracion">
            </div>
          </div>
          <div class="section-divider"></div>
          <div class="info-box">
            <div class="info-box-title">Información Metrológica Técnica</div>
            <p style="font-size: 13px; color: #616161;">Especificaciones técnicas del equipo.</p>
          </div>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Magnitud</label>
              <input type="text" class="form-input" v-model="formData.magnitud">
            </div>
            <div class="form-group">
              <label class="form-label">Rango del Equipo</label>
              <input type="text" class="form-input" v-model="formData.rango_equipo">
            </div>
            <div class="form-group">
              <label class="form-label">Resolución</label>
              <input type="text" class="form-input" v-model="formData.resolucion">
            </div>
            <div class="form-group">
              <label class="form-label">Rango de Trabajo</label>
              <input type="text" class="form-input" v-model="formData.rango_trabajo">
            </div>
            <div class="form-group">
              <label class="form-label">Error Máximo Permitido</label>
              <input type="text" class="form-input" v-model="formData.error_maximo">
            </div>
          </div>
        </div>

        <!-- TAB 6: CONDICIONES -->
        <div v-show="activeTab === 6" class="tab-content active">
          <h4 class="section-title">⚙️ G. Condiciones de Funcionamiento</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Voltaje</label>
              <input type="text" class="form-input" v-model="formData.voltaje">
            </div>
            <div class="form-group">
              <label class="form-label">Corriente</label>
              <input type="text" class="form-input" v-model="formData.corriente">
            </div>
            <div class="form-group">
              <label class="form-label">Humedad Relativa</label>
              <input type="text" class="form-input" v-model="formData.humedad">
            </div>
            <div class="form-group">
              <label class="form-label">Temperatura Funcionamiento</label>
              <input type="text" class="form-input" v-model="formData.temperatura">
            </div>
            <div class="form-group">
              <label class="form-label">Dimensiones</label>
              <input type="text" class="form-input" v-model="formData.dimensiones">
            </div>
            <div class="form-group">
              <label class="form-label">Peso</label>
              <input type="text" class="form-input" v-model="formData.peso">
            </div>
            <div class="form-group full-width">
              <label class="form-label">Otras Condiciones</label>
              <textarea class="form-textarea" v-model="formData.otros"></textarea>
            </div>
          </div>
        </div>

        <div v-if="errors.submit" class="alert alert-warning">{{ errors.submit }}</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="close" :disabled="loading">Cancelar</button>
        <button class="btn btn-primary" @click="save" :disabled="loading">
          {{ loading ? 'Guardando...' : '💾 Guardar Cambios' }}
        </button>
      </div>
    </div>
  </div>

  <ModalPassword
    :show="passwordModal.isOpen.value"
    :field-name="passwordModal.data.value?.fieldName || ''"
    @close="passwordModal.close()"
    @confirm="unlockField"
  />
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useModal } from '@/composables'
import ModalPassword from './ModalPassword.vue'

const props = defineProps({
  show: Boolean,
  equipo: Object,
  sedes: Array,
  ubicaciones: Array,
  responsables: Array
})

const emit = defineEmits(['close', 'save'])

// Composables
const passwordModal = useModal()

// State
const activeTab = ref(1)
const loading = ref(false)
const errors = ref({})
const formData = ref({})
const unlockedFields = ref(new Set())

// Computed
const ubicacionesFiltradas = computed(() => {
  if (!formData.value.sede) return props.ubicaciones
  return props.ubicaciones.filter(u => u.sede === formData.value.sede)
})

// Watch equipo para cargar datos
watch(() => props.equipo, (equipo) => {
  if (equipo) {
    formData.value = {
      id: equipo.id,
      sede: equipo.sede?.id || null,
      ubicacion: equipo.ubicacion?.id || null,
      nombre_equipo: equipo.nombre_equipo || '',
      codigo_interno: equipo.codigo_interno || '',
      codigo_ips: equipo.codigo_ips || '',
      codigo_ecri: equipo.codigo_ecri || '',
      responsable: equipo.responsable || null,
      ubicacion_fisica: equipo.ubicacion_fisica || '',
      marca: equipo.marca || '',
      modelo: equipo.modelo || '',
      serie: equipo.serie || '',
      clasificacion_misional: equipo.clasificacion_misional?.split(',') || [],
      clasificacion_ips: equipo.clasificacion_ips || '',
      clasificacion_riesgo: equipo.clasificacion_riesgo || '',
      registro_invima: equipo.registro_invima || '',
      estado: equipo.estado || 'Activo',
      tiempo_vida_util: equipo.tiempo_vida_util || '',
      fecha_adquisicion: equipo.registro_adquisicion?.fecha_adquisicion || null,
      propietario: equipo.registro_adquisicion?.propietario || '',
      fecha_fabricacion: equipo.fecha_fabricacion || '',
      nit_proveedor: equipo.registro_adquisicion?.nit_proveedor || '',
      nombre_proveedor: equipo.registro_adquisicion?.nombre_proveedor || '',
      en_garantia: equipo.registro_adquisicion?.en_garantia || false,
      fecha_finalizacion_garantia: equipo.registro_adquisicion?.fecha_finalizacion_garantia || null,
      forma_adquisicion: equipo.registro_adquisicion?.forma_adquisicion || '',
      tipo_documento: equipo.registro_adquisicion?.tipo_documento || '',
      numero_documento: equipo.registro_adquisicion?.numero_documento || '',
      valor_compra: equipo.registro_adquisicion?.valor_compra || null,
      hoja_vida: equipo.documentacion?.hoja_vida || false,
      registro_importacion: equipo.documentacion?.registro_importacion || false,
      manual_operacion: equipo.documentacion?.manual_operacion || false,
      idioma_manual: equipo.documentacion?.idioma_manual || '',
      manual_servicio: equipo.documentacion?.manual_servicio || false,
      guia_rapida: equipo.documentacion?.guia_rapida || false,
      instructivo_manejo: equipo.documentacion?.instructivo_manejo || false,
      protocolo_mto_preventivo: equipo.documentacion?.protocolo_mto_preventivo || false,
      observaciones_documentos: equipo.documentacion?.observaciones_documentos || '',
      requiere_mantenimiento: equipo.informacion_metrologica?.requiere_mantenimiento || false,
      frecuencia_mantenimiento: equipo.informacion_metrologica?.frecuencia_mantenimiento || null,
      requiere_calibracion: equipo.informacion_metrologica?.requiere_calibracion || false,
      frecuencia_calibracion: equipo.informacion_metrologica?.frecuencia_calibracion || null,
      tipo_calibracion: equipo.informacion_metrologica?.tipo_calibracion || '',
      magnitud: equipo.informacion_metrologica?.magnitud || '',
      rango_equipo: equipo.informacion_metrologica?.rango_equipo || '',
      resolucion: equipo.informacion_metrologica?.resolucion || '',
      rango_trabajo: equipo.informacion_metrologica?.rango_trabajo || '',
      error_maximo: equipo.informacion_metrologica?.error_maximo || '',
      voltaje: equipo.condiciones_funcionamiento?.voltaje || '',
      corriente: equipo.condiciones_funcionamiento?.corriente || '',
      humedad: equipo.condiciones_funcionamiento?.humedad || '',
      temperatura: equipo.condiciones_funcionamiento?.temperatura || '',
      dimensiones: equipo.condiciones_funcionamiento?.dimensiones || '',
      peso: equipo.condiciones_funcionamiento?.peso || '',
      otros: equipo.condiciones_funcionamiento?.otros || ''
    }
  }
}, { immediate: true })

// Methods
function openProtectedField(fieldKey) {
  if (unlockedFields.value.has(fieldKey)) return
  passwordModal.open({ fieldName: fieldKey })
}

function unlockField(password) {
  // TODO: Validar password con backend
  console.log('Password verified:', password)
  const fieldKey = passwordModal.data.value.fieldName
  unlockedFields.value.add(fieldKey)
  passwordModal.close()
  
  // Desbloquear campo en DOM
  setTimeout(() => {
    const input = document.querySelector(`[v-model="formData.${fieldKey}"]`)
    if (input) {
      input.readOnly = false
      input.classList.remove('locked')
      input.focus()
    }
  }, 100)
}

function save() {
  loading.value = true
  const payload = {
    ...formData.value,
    clasificacion_misional: formData.value.clasificacion_misional.join(',')
  }
  emit('save', payload)
}

function close() {
  activeTab.value = 1
  unlockedFields.value.clear()
  loading.value = false
  errors.value = {}
  emit('close')
}

watch(() => props.show, (show) => {
  if (!show) loading.value = false
})
</script>

<style scoped>
@import './modal-styles.css';

.edit-note {
  background: rgba(255, 193, 7, 0.1);
  border-left: 4px solid #ffc107;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
  font-size: 13px;
  color: #856404;
}

.form-input.locked,
.form-select.locked,
.form-textarea.locked {
  background: #fff9e6 !important;
  border-color: #ffc107 !important;
  cursor: pointer !important;
}

.lock-icon {
  font-size: 14px;
  margin-left: 4px;
}
</style>