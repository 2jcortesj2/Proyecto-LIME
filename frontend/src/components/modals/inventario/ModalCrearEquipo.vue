<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content">
      <div class="modal-header">
        <div class="modal-title">
          <AppIcon :name="isEdit ? 'edit' : 'plus'" size="16" />
          {{ isEdit ? ' Editar Equipo' : ' Crear Nuevo Equipo' }}
        </div>
        <button class="close-btn" @click="handleClose">&times;</button>
      </div>
      <div class="modal-body">
        <div class="tabs">
          <div class="tab" :class="{ active: activeTab === 1 }" @click="activeTab = 1">1. Información General</div>
          <div class="tab" :class="{ active: activeTab === 2 }" @click="activeTab = 2">2. Datos del Equipo</div>
          <div class="tab" :class="{ active: activeTab === 3 }" @click="activeTab = 3">3. Registro Histórico</div>
          <div class="tab" :class="{ active: activeTab === 4 }" @click="activeTab = 4">4. Documentos</div>
          <div class="tab" :class="{ active: activeTab === 5 }" @click="activeTab = 5">5. Metrología</div>
          <div class="tab" :class="{ active: activeTab === 6 }" @click="activeTab = 6">6. Condiciones</div>
          <div class="tab" :class="{ active: activeTab === 7 }" @click="activeTab = 7">7. Anotaciones</div>
        </div>

        <!-- TAB 1: INFO GENERAL -->
        <div v-show="activeTab === 1" class="tab-content active">
          <h4 class="section-title"><AppIcon name="file" size="16" /> A. Información General</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Sede</label>
              <select class="form-select" v-model="form.sede">
                <option value="">Seleccione una sede</option>
                <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
              </select>
              <span v-if="errors.sede" class="error-message">{{ errors.sede }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Ubicación Física</label>
              <input type="text" class="form-input" v-model="form.ubicacion_fisica" placeholder="Ej: Procesamiento Sección C">
              <span v-if="errors.ubicacion_fisica" class="error-message">{{ errors.ubicacion_fisica }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Nombre del Equipo</label>
              <input type="text" class="form-input" v-model="form.nombre_equipo" placeholder="Ej: Congelador, Agregómetro">
              <span v-if="errors.nombre_equipo" class="error-message">{{ errors.nombre_equipo }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Código de Inventario Interno</label>
              <input type="text" class="form-input" v-model="form.codigo_interno" placeholder="Ej: 135306">
              <span v-if="errors.codigo_interno" class="error-message">{{ errors.codigo_interno }}</span>
            </div>
            <div class="form-group">
              <label class="form-label">Código IPS</label>
              <input type="text" class="form-input" v-model="form.codigo_ips" placeholder="Ej: BIO-12183">
            </div>
            <div class="form-group">
              <label class="form-label">Código ECRI</label>
              <input type="text" class="form-input" v-model="form.codigo_ecri" placeholder="Ej: 15 - 583">
            </div>
            <div class="form-group">
              <label class="form-label required">Responsable del Equipo</label>
              <select class="form-select" v-model="form.responsable">
                <option value="">Seleccione un responsable</option>
                <option v-for="resp in responsables" :key="resp.id" :value="resp.id">{{ resp.nombre_completo }}</option>
              </select>
              <span v-if="errors.responsable" class="error-message">{{ errors.responsable }}</span>
            </div>

          </div>
        </div>

        <!-- TAB 2: DATOS DEL EQUIPO -->
        <div v-show="activeTab === 2" class="tab-content active">
          <h4 class="section-title"><AppIcon name="maintenance" size="16" /> B. Información del Equipo</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label required">Marca</label>
              <input type="text" class="form-input" v-model="form.marca" placeholder="Ej: Challenger, Helena Laboratories">
              <span v-if="errors.marca" class="error-message">{{ errors.marca }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Modelo</label>
              <input type="text" class="form-input" v-model="form.modelo" placeholder="Ej: CV430, AGGRAM">
              <span v-if="errors.modelo" class="error-message">{{ errors.modelo }}</span>
            </div>
            <div class="form-group">
              <label class="form-label required">Número de Serie</label>
              <input type="text" class="form-input" v-model="form.serie" placeholder="Ej: 9053127">
              <span v-if="errors.serie" class="error-message">{{ errors.serie }}</span>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación Eje Misional <span style="font-size: 12px; color: #616161;">(Puede seleccionar varios)</span></label>
              <div class="checkbox-group" style="flex-wrap: wrap; gap: 15px;">
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="misional-docencia" value="Docencia" v-model="form.clasificacion_misional">
                  <label for="misional-docencia" style="font-size: 13px; cursor: pointer;">Docencia</label>
                </div>
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="misional-investigacion" value="Investigación" v-model="form.clasificacion_misional">
                  <label for="misional-investigacion" style="font-size: 13px; cursor: pointer;">Investigación</label>
                </div>
                <div style="display: flex; align-items: center; gap: 5px;">
                  <input type="checkbox" id="misional-extension" value="Extensión" v-model="form.clasificacion_misional">
                  <label for="misional-extension" style="font-size: 13px; cursor: pointer;">Extensión</label>
                </div>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación IPS</label>
              <select class="form-select" v-model="form.clasificacion_ips">
                <option value="">Seleccione</option>
                <option value="IND">IND - Industrial</option>
                <option value="BIO">BIO - Biomédico</option>
                <option value="Gases">Gases Medicinales</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Clasificación por Riesgo</label>
              <select class="form-select" v-model="form.clasificacion_riesgo">
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
              <input type="text" class="form-input" v-model="form.registro_invima" placeholder="Ej: INVIMA 2019DM-0019614 o N/A">
            </div>
            <div class="form-group full-width">
              <label class="form-label">Estado del Equipo</label>
              <select class="form-select" v-model="form.estado">
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
          <h4 class="section-title"><AppIcon name="calendar" size="16" /> C. Registro Histórico</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Tiempo de Vida Útil</label>
              <input type="text" class="form-input" v-model="form.tiempo_vida_util" placeholder="Ej: 10 años">
            </div>
            <div class="form-group">
              <label class="form-label required">Fecha de Adquisición</label>
              <input type="date" class="form-input" v-model="form.fecha_adquisicion">
            </div>
            <div class="form-group">
              <label class="form-label required">Propietario del Equipo</label>
              <input type="text" class="form-input" v-model="form.propietario" placeholder="Ej: UdeA, Hospital">
            </div>
            <div class="form-group">
              <label class="form-label">Fecha de Fabricación</label>
              <input type="text" class="form-input" v-model="form.fecha_fabricacion" placeholder="Año (Ej: 2008) o NI">
            </div>
            <div class="form-group">
              <label class="form-label required">NIT del Proveedor</label>
              <input type="text" class="form-input" v-model="form.nit_proveedor" placeholder="Ej: 890.934.939-8">
            </div>
            <div class="form-group full-width">
              <label class="form-label required">Proveedor del Equipo</label>
              <textarea class="form-textarea" v-model="form.nombre_proveedor" placeholder="Nombre completo del proveedor"></textarea>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="enGarantia" v-model="form.en_garantia">
                <label for="enGarantia" class="form-label" style="margin: 0;">¿Está en Garantía?</label>
              </div>
            </div>
            <div class="form-group" v-if="form.en_garantia">
              <label class="form-label">Fecha Finalización Garantía</label>
              <input type="date" class="form-input" v-model="form.fecha_finalizacion_garantia">
            </div>
            <div class="form-group">
              <label class="form-label required">Forma de Adquisición</label>
              <select class="form-select" v-model="form.forma_adquisicion">
                <option value="">Seleccione</option>
                <option value="Compra">Compra</option>
                <option value="Donación">Donación</option>
                <option value="Comodato">Comodato</option>
                <option value="Arrendamiento">Arrendamiento</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label required">Tipo de Documento</label>
              <input type="text" class="form-input" v-model="form.tipo_documento" placeholder="Ej: Factura, Acta">
            </div>
            <div class="form-group">
              <label class="form-label required">Número de Documento</label>
              <input type="text" class="form-input" v-model="form.numero_documento" placeholder="Ej: 47736">
            </div>
            <div class="form-group">
              <label class="form-label">Valor de Compra</label>
              <input type="number" class="form-input" v-model="form.valor_compra" placeholder="Ej: 5000000">
            </div>
          </div>
        </div>

        <!-- TAB 4: DOCUMENTOS -->
        <div v-show="activeTab === 4" class="tab-content active">
          <h4 class="section-title"><AppIcon name="file" size="16" /> D. Inventario de Documentos</h4>
          <p style="color: #616161; margin-bottom: 20px; font-size: 14px;">Marque los documentos que posee el equipo:</p>
          <div class="form-grid">
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc1" v-model="form.hoja_vida">
                <label for="doc1" class="form-label" style="margin: 0;">Hoja de Vida</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc2" v-model="form.registro_importacion">
                <label for="doc2" class="form-label" style="margin: 0;">Registro de Importación</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc3" v-model="form.manual_operacion">
                <label for="doc3" class="form-label" style="margin: 0;">Manual de Operación</label>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Idioma del Manual</label>
              <select class="form-select" v-model="form.idioma_manual">
                <option value="">Seleccione</option>
                <option value="Español">Español</option>
                <option value="Inglés">Inglés</option>
                <option value="Otro">Otro</option>
              </select>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc4" v-model="form.manual_servicio">
                <label for="doc4" class="form-label" style="margin: 0;">Manual Servicio/Mto</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc5" v-model="form.guia_rapida">
                <label for="doc5" class="form-label" style="margin: 0;">Guía Rápida</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc6" v-model="form.instructivo_manejo">
                <label for="doc6" class="form-label" style="margin: 0;">Instructivo Manejo</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc7" v-model="form.protocolo_mto_preventivo">
                <label for="doc7" class="form-label" style="margin: 0;">Protocolo Mto Preventivo</label>
              </div>
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="doc8" v-model="form.frecuencia_metrologica_doc">
                <label for="doc8" class="form-label" style="margin: 0;">Frecuencia Metrológica</label>
              </div>
            </div>
            <div class="form-group full-width">
              <label class="form-label">Observaciones Documentos</label>
              <textarea class="form-textarea" v-model="form.observaciones_documentos" placeholder="Ej: Carta de proveedor de no entrega de manual"></textarea>
            </div>
          </div>
        </div>

        <!-- TAB 5: METROLOGÍA -->
        <div v-show="activeTab === 5" class="tab-content active">
          <h4 class="section-title"><AppIcon name="package" size="16" /> E & F. Información Metrológica</h4>
          <div class="info-box">
            <div class="info-box-title">Información Metrológica Administrativa</div>
            <p style="font-size: 13px; color: #616161;">Configure los parámetros de mantenimiento y calibración del equipo.</p>
          </div>
          <div class="form-grid">
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="reqMto" v-model="form.requiere_mantenimiento">
                <label for="reqMto" class="form-label" style="margin: 0;">Requiere Mantenimiento</label>
              </div>
            </div>
            <div class="form-group" v-if="form.requiere_mantenimiento">
              <label class="form-label">Frecuencia Anual Mantenimiento</label>
              <input type="number" class="form-input" v-model="form.frecuencia_mantenimiento" placeholder="Ej: 1, 2, 4" min="0">
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="reqCal" v-model="form.requiere_calibracion">
                <label for="reqCal" class="form-label" style="margin: 0;">Requiere Calibración</label>
              </div>
            </div>
            <div class="form-group" v-if="form.requiere_calibracion">
              <label class="form-label">Frecuencia Anual Calibración</label>
              <input type="number" class="form-input" v-model="form.frecuencia_calibracion" placeholder="Ej: 1, 2, 4" min="0">
            </div>
            <div class="form-group" v-if="form.requiere_calibracion">
              <label class="form-label">Última Calibración</label>
              <input type="date" class="form-input" v-model="form.ultima_calibracion">
            </div>
            <div class="form-group" v-if="form.requiere_calibracion">
              <label class="form-label">Próxima Calibración</label>
              <input type="date" class="form-input" v-model="form.proxima_calibracion">
            </div>
            <div class="form-group">
              <div class="checkbox-group">
                <input type="checkbox" class="checkbox-input" id="reqCalif" v-model="form.requiere_calificacion">
                <label for="reqCalif" class="form-label" style="margin: 0;">Requiere Calificación</label>
              </div>
            </div>
            <div class="form-group" v-if="form.requiere_calificacion">
              <label class="form-label">Frecuencia Anual Calificación</label>
              <input type="number" class="form-input" v-model="form.frecuencia_calificacion" placeholder="Ej: 1, 2, 4" min="0">
            </div>
            <div class="form-group" v-if="form.requiere_calificacion">
              <label class="form-label">Última Calificación</label>
              <input type="date" class="form-input" v-model="form.ultima_calificacion">
            </div>
            <div class="form-group" v-if="form.requiere_calificacion">
              <label class="form-label">Próxima Calificación</label>
              <input type="date" class="form-input" v-model="form.proxima_calificacion">
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
              <input type="text" class="form-input" v-model="form.magnitud" placeholder="Ej: Temperatura, Absorbancia">
            </div>
            <div class="form-group">
              <label class="form-label">Rango del Equipo</label>
              <input type="text" class="form-input" v-model="form.rango_equipo" placeholder="Ej: T -18, 0-100°C">
            </div>
            <div class="form-group">
              <label class="form-label">Resolución</label>
              <input type="text" class="form-input" v-model="form.resolucion" placeholder="Ej: 0.1°C, NI">
            </div>
            <div class="form-group">
              <label class="form-label">Rango de Trabajo</label>
              <input type="text" class="form-input" v-model="form.rango_trabajo" placeholder="Ej: 0 a -33°C">
            </div>
            <div class="form-group">
              <label class="form-label">Error Máximo Permitido</label>
              <input type="text" class="form-input" v-model="form.error_maximo" placeholder="Ej: ±0.5°C, NI">
            </div>
          </div>
        </div>

        <!-- TAB 6: CONDICIONES -->
        <div v-show="activeTab === 6" class="tab-content active">
          <h4 class="section-title"><AppIcon name="settings" size="16" /> G. Condiciones de Funcionamiento</h4>
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Voltaje</label>
              <input type="text" class="form-input" v-model="form.voltaje" placeholder="Ej: 115 VAC, 200-240V">
            </div>
            <div class="form-group">
              <label class="form-label">Corriente</label>
              <input type="text" class="form-input" v-model="form.corriente" placeholder="Ej: 4A, NI">
            </div>
            <div class="form-group">
              <label class="form-label">Humedad Relativa</label>
              <input type="text" class="form-input" v-model="form.presion" placeholder="Ej: 30-90%, NI">
            </div>
            <div class="form-group">
              <label class="form-label">Temperatura Funcionamiento</label>
              <input type="text" class="form-input" v-model="form.potencia" placeholder="Ej: Max 38°C">
            </div>
            <div class="form-group">
              <label class="form-label">Dimensiones</label>
              <input type="text" class="form-input" v-model="form.dimensiones" placeholder="Ej: 53.5 x 53 x 142 cm">
            </div>
            <div class="form-group">
              <label class="form-label">Peso</label>
              <input type="text" class="form-input" v-model="form.peso" placeholder="Ej: 55.5 kg">
            </div>
            <div class="form-group full-width">
              <label class="form-label">Otras Condiciones</label>
              <textarea class="form-textarea" v-model="form.otros" placeholder="Ej: Frecuencia eléctrica, presión, etc."></textarea>
            </div>
          </div>
        </div>

        <!-- TAB 7: ANOTACIONES -->
        <div v-show="activeTab === 7" class="tab-content active">
          <h4 class="section-title"><AppIcon name="file-text" size="16" /> H. Anotaciones y Observaciones</h4>
          <div class="form-grid">
            <div class="form-group full-width">
              <label class="form-label">Anotaciones Generales</label>
              <textarea class="form-textarea" v-model="form.anotaciones" placeholder="Ingrese aquí cualquier observación adicional sobre el equipo..." style="min-height: 150px;"></textarea>
            </div>
          </div>
        </div>

        <div v-if="successMessage" class="alert alert-success" style="margin-top: 20px;">
          {{ successMessage }}
        </div>
        <div v-if="errors.submit" class="alert alert-warning" style="margin-top: 20px;">
          {{ errors.submit }}
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" @click="handleClose" :disabled="loading">Cancelar</button>
        <button class="btn btn-primary" @click="handleSave" :disabled="loading">
          <span v-if="loading">Guardando...</span>
          <span v-else><AppIcon name="save" size="16" /> {{ isEdit ? 'Actualizar' : 'Guardar' }} Equipo</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  equipoData: {
    type: Object,
    default: null
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
  }
})

const emit = defineEmits(['close', 'save'])

const activeTab = ref(1)
const loading = ref(false)
const errors = ref({})
const successMessage = ref('')

// Determine if editing
const isEdit = computed(() => !!props.equipoData)

// Form data factory
const createEmptyForm = () => ({
  // Tab 1 - Info General
  proceso: 'LIME',
  nombre_equipo: '',
  codigo_interno: '',
  codigo_ips: '',
  codigo_ecri: '',
  responsable: null,
  ubicacion_fisica: '',
  sede: null,
  ubicacion: null,
  
  // Tab 2 - Datos Equipo
  marca: '',
  modelo: '',
  serie: '',
  clasificacion_misional: [],
  clasificacion_ips: '',
  clasificacion_riesgo: '',
  registro_invima: '',
  estado: 'Activo',
  
  // Tab 3 - Registro Histórico
  tiempo_vida_util: '',
  fecha_adquisicion: null,
  propietario: '',
  fecha_fabricacion: '',
  nit_proveedor: '',
  nombre_proveedor: '',
  en_garantia: false,
  fecha_finalizacion_garantia: null,
  forma_adquisicion: '',
  tipo_documento: '',
  numero_documento: '',
  valor_compra: null,
  
  // Tab 4 - Documentos
  hoja_vida: false,
  registro_importacion: false,
  manual_operacion: false,
  idioma_manual: '',
  manual_servicio: false,
  guia_rapida: false,
  instructivo_manejo: false,
  protocolo_mto_preventivo: false,
  frecuencia_metrologica_doc: false,
  observaciones_documentos: '',
  
  // Tab 5 - Metrología
  requiere_mantenimiento: false,
  frecuencia_mantenimiento: null,
  requiere_calibracion: false,
  frecuencia_calibracion: null,
  requiere_calificacion: false,
  frecuencia_calificacion: null,
  ultima_calibracion: null,
  proxima_calibracion: null,
  ultima_calificacion: null,
  proxima_calificacion: null,

  magnitud: '',
  rango_equipo: '',
  resolucion: '',
  rango_trabajo: '',
  error_maximo: '',
  
  // Tab 6 - Condiciones
  voltaje: '',
  corriente: '',
  presion: '',
  potencia: '',
  dimensiones: '',
  peso: '',
  otros: '',

  // Tab 7 - Anotaciones
  anotaciones: ''
})

const form = ref(createEmptyForm())

// Ubicaciones filtradas por sede usando composable pattern
const ubicacionesFiltradas = computed(() => {
  if (!form.value.sede) return props.ubicaciones
  return props.ubicaciones.filter(u => u.sede === form.value.sede)
})

// Watch para cargar datos en modo edición
watch(() => props.equipoData, (newData) => {
  if (newData) {
    form.value = {
      ...createEmptyForm(),
      ...newData,
      sede: newData.sede?.id || null,
      ubicacion: newData.ubicacion?.id || null,
      responsable: newData.responsable || null,
      clasificacion_misional: newData.clasificacion_misional ? 
        newData.clasificacion_misional.split(',').map(s => s.trim()) : []
    }
  } else {
    form.value = createEmptyForm()
  }
}, { immediate: true })

// Validation
function validate() {
  errors.value = {}
  
  // Tab 1
  if (!form.value.nombre_equipo?.trim()) errors.value.nombre_equipo = 'Requerido'
  if (!form.value.codigo_interno?.trim()) errors.value.codigo_interno = 'Requerido'
  if (!form.value.responsable) errors.value.responsable = 'Requerido'
  if (!form.value.ubicacion_fisica?.trim()) errors.value.ubicacion_fisica = 'Requerido'
  if (!form.value.sede) errors.value.sede = 'Requerido'
  if (!form.value.ubicacion) errors.value.ubicacion = 'Requerido'
  
  // Tab 2
  if (!form.value.marca?.trim()) errors.value.marca = 'Requerido'
  if (!form.value.modelo?.trim()) errors.value.modelo = 'Requerido'
  if (!form.value.serie?.trim()) errors.value.serie = 'Requerido'
  
  return Object.keys(errors.value).length === 0
}

async function handleSave() {
  if (!validate()) {
    // Ir al primer tab con errores
    const errorTab1 = ['nombre_equipo', 'codigo_interno', 'responsable', 'ubicacion_fisica', 'sede', 'ubicacion']
    const errorTab2 = ['marca', 'modelo', 'serie']
    
    if (errorTab1.some(field => errors.value[field])) activeTab.value = 1
    else if (errorTab2.some(field => errors.value[field])) activeTab.value = 2
    return
  }
  
  loading.value = true
  errors.value = {}
  
  try {
    // Preparar payload
    const payload = {
      ...form.value,
      clasificacion_misional: form.value.clasificacion_misional.join(',')
    }
    
    emit('save', payload)
    // No cerramos aquí, el padre decide cuándo cerrar
  } catch (err) {
    errors.value.submit = err.message || 'Error al guardar'
    loading.value = false
  }
}

function handleClose() {
  form.value = createEmptyForm()
  errors.value = {}
  successMessage.value = ''
  activeTab.value = 1
  loading.value = false
  emit('close')
}

// Reset loading cuando el modal se cierra desde el padre
watch(() => props.show, (newShow) => {
  if (!newShow) {
    loading.value = false
  }
})
</script>

<style scoped>
@import './modal-styles.css';
</style>
