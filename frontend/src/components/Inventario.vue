<script setup>
import { ref, onMounted, computed } from 'vue'

const equipos = ref([])
const loading = ref(true)
const detailLoading = ref(false)
const error = ref(null)
const searchQuery = ref('')
const expandedEquipoId = ref(null)
const selectedEquipo = ref(null)
const activeTab = ref('info') // 'info', 'metrologia', 'traslados', 'mantenimientos'

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [10, 20, 50, 100]

// Mapeo de pestañas
const tabs = {
  info: 'Información General',
  metrologia: 'Metrología',
  traslados: 'Historial Traslados',
  mantenimientos: 'Mantenimientos'
}

const trasladosCache = ref(new Map())
const mantenimientosCache = ref(new Map())
const trasladosLoading = ref(false)
const mantenimientosLoading = ref(false)

const fetchEquipos = async () => {
  loading.value = true
  try {
    const response = await fetch('http://127.0.0.1:8000/api/equipos/')
    if (!response.ok) throw new Error('Error al cargar equipos')
    equipos.value = await response.json()
  } catch (err) {
    error.value = err.message
    console.error(err)
  } finally {
    loading.value = false
  }
}

// Ya no necesitamos fetchEquipoDetalle para la vista básica porque el listado trae todo
// Solo lo usaríamos si necesitáramos recargar datos frescos de un solo equipo
const fetchEquipoDetalle = async (id) => {
  // Esta función se mantiene por compatibilidad pero ya no se llama automáticamente al expandir
  detailLoading.value = true
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/equipos/${id}/`)
    if (!response.ok) throw new Error('Error al cargar detalle del equipo')
    const data = await response.json()
    
    // Actualizar el equipo en la lista local
    const index = equipos.value.findIndex(e => e.id === id)
    if (index !== -1) {
      equipos.value[index] = { ...equipos.value[index], ...data }
    }
    selectedEquipo.value = data
  } catch (err) {
    console.error(err)
  } finally {
    detailLoading.value = false
  }
}

const fetchTraslados = async (equipoId) => {
  if (trasladosCache.value.has(equipoId)) return
  
  trasladosLoading.value = true
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/traslados/?equipo_id=${equipoId}`)
    if (response.ok) {
      const data = await response.json()
      trasladosCache.value.set(equipoId, data)
    }
  } catch (err) {
    console.error('Error fetching traslados:', err)
  } finally {
    trasladosLoading.value = false
  }
}

const fetchMantenimientos = async (equipoId) => {
  if (mantenimientosCache.value.has(equipoId)) return
  
  mantenimientosLoading.value = true
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/mantenimientos/?equipo_id=${equipoId}`)
    if (response.ok) {
      const data = await response.json()
      mantenimientosCache.value.set(equipoId, data)
    }
  } catch (err) {
    console.error('Error fetching mantenimientos:', err)
  } finally {
    mantenimientosLoading.value = false
  }
}

const filteredEquipos = computed(() => {
  if (!searchQuery.value) return equipos.value
  const query = searchQuery.value.toLowerCase()
  return equipos.value.filter(eq => 
    (eq.nombre_equipo && eq.nombre_equipo.toLowerCase().includes(query)) ||
    (eq.codigo_interno && eq.codigo_interno.toLowerCase().includes(query)) ||
    (eq.marca && eq.marca.toLowerCase().includes(query)) ||
    (eq.modelo && eq.modelo.toLowerCase().includes(query)) ||
    (eq.serie && eq.serie.toLowerCase().includes(query))
  )
})

// Pagination computed properties
const totalPages = computed(() => Math.ceil(filteredEquipos.value.length / itemsPerPage.value))

const paginatedEquipos = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredEquipos.value.slice(start, end)
})

// Pagination methods
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

const toggleDetalle = (id) => {
  if (expandedEquipoId.value === id) {
    expandedEquipoId.value = null
    selectedEquipo.value = null
  } else {
    expandedEquipoId.value = id
    activeTab.value = 'info' // Reset tab
    // OPTIMIZACIÓN: Usar datos locales en lugar de hacer fetch
    selectedEquipo.value = equipos.value.find(e => e.id === id)
  }
}

const setActiveTab = (tab) => {
  activeTab.value = tab
  
  // Lazy loading para pestañas de historial
  if (tab === 'traslados' && expandedEquipoId.value) {
    fetchTraslados(expandedEquipoId.value)
  } else if (tab === 'mantenimientos' && expandedEquipoId.value) {
    fetchMantenimientos(expandedEquipoId.value)
  }
}

const getRiesgoBadgeClass = (riesgo) => {
  if (!riesgo) return 'badge-secondary'
  if (riesgo === 'III' || riesgo === 'IIb') return 'badge-danger'
  if (riesgo === 'IIa') return 'badge-warning'
  return 'badge-success'
}

const getEstadoBadgeClass = (estado) => {
  if (!estado) return 'estado-inactivo'
  if (estado === 'Activo') return 'estado-activo'
  if (estado === 'En Mantenimiento' || estado === 'Mantenimiento') return 'estado-mantenimiento'
  if (estado === 'Baja') return 'estado-baja'
  return 'estado-inactivo'
}

const formatFecha = (fecha) => {
  if (!fecha) return 'N/A'
  const date = new Date(fecha)
  const meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ]
  return `${meses[date.getMonth()]} ${date.getFullYear()}`
}

const formatEstado = (estado) => {
  if (!estado) return 'N/A'
  if (estado === 'En Mantenimiento') return 'Mantenimiento'
  return estado
}

// Modal State
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const showPasswordModal = ref(false)
const showConfirmModal = ref(false)

const activeTabCreate = ref(1)
const activeTabEdit = ref(1)
const campoProtegido = ref('')
const selectedEquipoForAction = ref(null)

// Catalogs for dropdowns
const sedes = ref([])
const ubicaciones = ref([])
const responsables = ref([])
const ubicacionesFiltradas = computed(() => {
  if (!createForm.value.sede) return ubicaciones.value
  return ubicaciones.value.filter(s => s.sede === createForm.value.sede)
})
const ubicacionesFiltradasEdit = computed(() => {
  if (!editForm.value.sede) return ubicaciones.value
  return ubicaciones.value.filter(s => s.sede === editForm.value.sede)
})

// Form state and loading
const submitLoading = ref(false)
const formErrors = ref({})
const successMessage = ref('')

// Create Form State
const createForm = ref({
  // A. Información General
  proceso: 'LIME',
  nombre_equipo: '',
  codigo_interno: '',
  codigo_ips: '',
  codigo_ecri: '',
  responsable: null,
  ubicacion_fisica: '',
  sede: null,
  servicio: null,
  
  // B. Información del Equipo
  marca: '',
  modelo: '',
  serie: '',
  clasificacion_misional: [],
  clasificacion_ips: '',
  clasificacion_riesgo: '',
  registro_invima: '',
  
  // C. Registro Histórico
  tiempo_vida_util: '',
  fecha_adquisicion: '',
  propietario: '',
  fecha_fabricacion: '',
  nit_proveedor: '',
  nombre_proveedor: '',
  en_garantia: false,
  fecha_finalizacion_garantia: '',
  forma_adquisicion: '',
  tipo_documento: '',
  numero_documento: '',
  valor_compra: '',
  
  // D. Documentos
  hoja_vida: false,
  registro_importacion: false,
  manual_operacion: false,
  idioma_manual: '',
  manual_servicio: false,
  guia_rapida: false,
  instructivo_manejo: false,
  protocolo_mto_preventivo: false,
  frecuencia_metrologica_doc: false,
  
  // E. Información Metrológica
  requiere_mantenimiento: false,
  frecuencia_mantenimiento: '',
  ultimo_mantenimiento: '',
  requiere_calibracion: false,
  magnitud: '',
  rango_equipo: '',
  rango_trabajo: '',
  resolucion: '',
  error_maximo: '',
  
  // F. Condiciones de Funcionamiento
  voltaje: '',
  corriente: '',
  potencia: '',
  presion: '',
  dimensiones: '',
  peso: '',
  otros: ''
})

// Edit Form State  
const editForm = ref({
  id: null,
  // A. Información General
  proceso: 'LIME',
  nombre_equipo: '',
  codigo_interno: '',
  codigo_ips: '',
  codigo_ecri: '',
  responsable: null,
  ubicacion_fisica: '',
  sede: null,
  servicio: null,
  
  // B. Información del Equipo
  marca: '',
  modelo: '',
  serie: '',
  clasificacion_misional: [],
  clasificacion_ips: '',
  clasificacion_riesgo: '',
  registro_invima: '',
  
  // C. Registro Histórico
  tiempo_vida_util: '',
  fecha_adquisicion: '',
  propietario: '',
  fecha_fabricacion: '',
  nit_proveedor: '',
  nombre_proveedor: '',
  en_garantia: false,
  fecha_finalizacion_garantia: '',
  forma_adquisicion: '',
  tipo_documento: '',
  numero_documento: '',
  valor_compra: '',
  
  // D. Documentos
  hoja_vida: false,
  registro_importacion: false,
  manual_operacion: false,
  idioma_manual: '',
  manual_servicio: false,
  guia_rapida: false,
  instructivo_manejo: false,
  protocolo_mto_preventivo: false,
  frecuencia_metrologica_doc: false,
  
  // E. Información Metrológica
  requiere_mantenimiento: false,
  frecuencia_mantenimiento: '',
  ultimo_mantenimiento: '',
  requiere_calibracion: false,
  magnitud: '',
  rango_equipo: '',
  rango_trabajo: '',
  resolucion: '',
  error_maximo: '',
  
  // F. Condiciones de Funcionamiento
  voltaje: '',
  corriente: '',
  potencia: '',
  presion: '',
  dimensiones: '',
  peso: '',
  otros: ''
})

// ===== CATALOG LOADING FUNCTIONS =====
const fetchSedes = async () => {
  try {
    const response = await fetch('http://127.0.0.1:8000/api/sedes/')
    if (!response.ok) throw new Error('Error al cargar sedes')
    sedes.value = await response.json()
  } catch (err) {
    console.error('Error fetching sedes:', err)
  }
}

const fetchUbicaciones = async () => {
  try {
    const response = await fetch('http://127.0.0.1:8000/api/ubicaciones/')
    if (!response.ok) throw new Error('Error al cargar ubicaciones')
    ubicaciones.value = await response.json()
  } catch (err) {
    console.error('Error fetching ubicaciones:', err)
  }
}

const fetchResponsables = async () => {
  try {
    const response = await fetch('http://127.0.0.1:8000/api/responsables/')
    if (!response.ok) throw new Error('Error al cargar responsables')
    responsables.value = await response.json()
  } catch (err) {
    console.error('Error fetching responsables:', err)
  }
}

// ===== VALIDATION FUNCTIONS =====
const validateCreateForm = () => {
  const errors = {}
  
  // Tab 1 - Información General
  if (!createForm.value.nombre_equipo?.trim()) {
    errors.nombre_equipo = 'El nombre del equipo es requerido'
  }
  if (!createForm.value.codigo_interno?.trim()) {
    errors.codigo_interno = 'El código interno es requerido'
  }
  if (!createForm.value.responsable) {
    errors.responsable = 'El responsable es requerido'
  }
  if (!createForm.value.ubicacion_fisica?.trim()) {
    errors.ubicacion_fisica = 'La ubicación física es requerida'
  }
  if (!createForm.value.sede) {
    errors.sede = 'La sede es requerida'
  }
  if (!createForm.value.servicio) {
    errors.servicio = 'El servicio es requerido'
  }
  
  // Tab 2 - Datos del Equipo
  if (!createForm.value.marca?.trim()) {
    errors.marca = 'La marca es requerida'
  }
  if (!createForm.value.modelo?.trim()) {
    errors.modelo = 'El modelo es requerido'
  }
  if (!createForm.value.serie?.trim()) {
    errors.serie = 'El número de serie es requerido'
  }
  
  // Tab 3 - Registro Histórico
  if (!createForm.value.fecha_adquisicion) {
    errors.fecha_adquisicion = 'La fecha de adquisición es requerida'
  }
  if (!createForm.value.propietario?.trim()) {
    errors.propietario = 'El propietario es requerido'
  }
  if (!createForm.value.nit_proveedor?.trim()) {
    errors.nit_proveedor = 'El NIT del proveedor es requerido'
  }
  if (!createForm.value.nombre_proveedor?.trim()) {
    errors.nombre_proveedor = 'El nombre del proveedor es requerido'
  }
  if (!createForm.value.forma_adquisicion?.trim()) {
    errors.forma_adquisicion = 'La forma de adquisición es requerida'
  }
  if (!createForm.value.tipo_documento?.trim()) {
    errors.tipo_documento = 'El tipo de documento es requerido'
  }
  if (!createForm.value.numero_documento?.trim()) {
    errors.numero_documento = 'El número de documento es requerido'
  }
  
  formErrors.value = errors
  return Object.keys(errors).length === 0
}

const validateEditForm = () => {
  const errors = {}
  
  if (!editForm.value.nombre_equipo?.trim()) {
    errors.nombre_equipo = 'El nombre del equipo es requerido'
  }
  if (!editForm.value.codigo_interno?.trim()) {
    errors.codigo_interno = 'El código interno es requerido'
  }
  if (!editForm.value.marca?.trim()) {
    errors.marca = 'La marca es requerida'
  }
  if (!editForm.value.modelo?.trim()) {
    errors.modelo = 'El modelo es requerido'
  }
  if (!editForm.value.serie?.trim()) {
    errors.serie = 'El número de serie es requerido'
  }
  
  formErrors.value = errors
  return Object.keys(errors).length === 0
}

// ===== CREATE EQUIPMENT FUNCTIONS =====
const resetCreateForm = () => {
  createForm.value = {
    proceso: 'LIME',
    nombre_equipo: '',
    codigo_interno: '',
    codigo_ips: '',
    codigo_ecri: '',
    responsable: null,
    ubicacion_fisica: '',
    sede: null,
    servicio: null,
    marca: '',
    modelo: '',
    serie: '',
    clasificacion_misional: [],
    clasificacion_ips: '',
    clasificacion_riesgo: '',
    registro_invima: '',
    tiempo_vida_util: '',
    fecha_adquisicion: '',
    propietario: '',
    fecha_fabricacion: '',
    nit_proveedor: '',
    nombre_proveedor: '',
    en_garantia: false,
    fecha_finalizacion_garantia: '',
    forma_adquisicion: '',
    tipo_documento: '',
    numero_documento: '',
    valor_compra: '',
    hoja_vida: false,
    registro_importacion: false,
    manual_operacion: false,
    idioma_manual: '',
    manual_servicio: false,
    guia_rapida: false,
    instructivo_manejo: false,
    protocolo_mto_preventivo: false,
    frecuencia_metrologica_doc: false,
    requiere_mantenimiento: false,
    frecuencia_mantenimiento: '',
    ultimo_mantenimiento: '',
    requiere_calibracion: false,
    magnitud: '',
    rango_equipo: '',
    rango_trabajo: '',
    resolucion: '',
    error_maximo: '',
    voltaje: '',
    corriente: '',
    potencia: '',
    presion: '',
    dimensiones: '',
    peso: '',
    otros: ''
  }
  formErrors.value = {}
}

const submitCreateForm = async () => {
  if (!validateCreateForm()) {
    successMessage.value = ''
    // Find first tab with errors
    const errorFields = Object.keys(formErrors.value)
    if (errorFields.length > 0) {
      const firstError = errorFields[0]
      // Map fields to tabs
      const tab1Fields = ['nombre_equipo', 'codigo_interno', 'responsable', 'ubicacion_fisica', 'sede', 'servicio']
      const tab2Fields = ['marca', 'modelo', 'serie']
      const tab3Fields = ['fecha_adquisicion', 'propietario', 'nit_proveedor', 'nombre_proveedor', 'forma_adquisicion', 'tipo_documento', 'numero_documento']
      
      if (tab1Fields.includes(firstError)) activeTabCreate.value = 1
      else if (tab2Fields.includes(firstError)) activeTabCreate.value = 2
      else if (tab3Fields.includes(firstError)) activeTabCreate.value = 3
    }
    return
  }
  
  submitLoading.value = true
  successMessage.value = ''
  
  try {
    // Prepare payload
    const payload = {
      // Main equipment fields
      proceso: createForm.value.proceso,
      nombre_equipo: createForm.value.nombre_equipo,
      codigo_interno: createForm.value.codigo_interno,
      codigo_ips: createForm.value.codigo_ips || null,
      codigo_ecri: createForm.value.codigo_ecri || null,
      responsable: createForm.value.responsable,
      ubicacion_fisica: createForm.value.ubicacion_fisica,
      sede: createForm.value.sede,
      servicio: createForm.value.servicio,
      marca: createForm.value.marca,
      modelo: createForm.value.modelo,
      serie: createForm.value.serie,
      clasificacion_misional: createForm.value.clasificacion_misional.join(','),
      clasificacion_ips: createForm.value.clasificacion_ips || null,
      clasificacion_riesgo: createForm.value.clasificacion_riesgo || null,
      registro_invima: createForm.value.registro_invima || null,
      estado: 'Activo',
      
      // Registro Adquisición (nested )
      registro_adquisicion: {
        tiempo_vida_util: createForm.value.tiempo_vida_util || null,
        fecha_adquisicion: createForm.value.fecha_adquisicion || null,
        propietario: createForm.value.propietario || null,
        fecha_fabricacion: createForm.value.fecha_fabricacion || null,
        nit_proveedor: createForm.value.nit_proveedor || null,
        nombre_proveedor: createForm.value.nombre_proveedor || null,
        en_garantia: createForm.value.en_garantia,
        fecha_finalizacion_garantia: createForm.value.fecha_finalizacion_garantia || null,
        forma_adquisicion: createForm.value.forma_adquisicion || null,
        tipo_documento: createForm.value.tipo_documento || null,
        numero_documento: createForm.value.numero_documento || null,
        valor_compra: createForm.value.valor_compra || null
      },
      
      // Documentación
      documentacion: {
        hoja_vida: createForm.value.hoja_vida,
        registro_importacion: createForm.value.registro_importacion,
        manual_operacion: createForm.value.manual_operacion,
        idioma_manual: createForm.value.idioma_manual || null,
        manual_servicio: createForm.value.manual_servicio,
        guia_rapida: createForm.value.guia_rapida,
        protocolo_mto_preventivo: createForm.value.protocolo_mto_preventivo,
        frecuencia_metrologica: createForm.value.frecuencia_metrologica_doc || null
      },
      
      // Información Metrológica
      informacion_metrologica: {
        requiere_mantenimiento: createForm.value.requiere_mantenimiento,
        frecuencia_mantenimiento: createForm.value.frecuencia_mantenimiento || null,
        ultimo_mantenimiento: createForm.value.ultimo_mantenimiento || null,
        requiere_calibracion: createForm.value.requiere_calibracion,
        magnitud: createForm.value.magnitud || null,
        rango_equipo: createForm.value.rango_equipo || null,
        rango_trabajo: createForm.value.rango_trabajo || null,
        resolucion: createForm.value.resolucion || null,
        error_maximo: createForm.value.error_maximo || null
      },
      
      // Condiciones de Funcionamiento
      condiciones_funcionamiento: {
        voltaje: createForm.value.voltaje || null,
        corriente: createForm.value.corriente || null,
        potencia: createForm.value.potencia || null,
        presion: createForm.value.presion || null,
        dimensiones: createForm.value.dimensiones || null,
        peso: createForm.value.peso || null,
        otros: createForm.value.otros || null
      }
    }
    
    const response = await fetch('http://127.0.0.1:8000/api/equipos/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload)
    })
    
    if (!response.ok) {
      const errorData = await response.json()
      console.error('Error response:', errorData)
      throw new Error(errorData.detail || 'Error al crear el equipo')
    }
    
    const newEquipo = await response.json()
    successMessage.value = '✅ Equipo creado exitosamente'
    
    // Refresh equipment list
    await fetchEquipos()
    
    // Close modal after short delay
    setTimeout(() => {
      closeCreateModal()
      resetCreateForm()
      successMessage.value = ''
    }, 2000)
    
  } catch (err) {
    console.error('Error creating equipo:', err)
    formErrors.value = { submit: err.message || 'Error al crear el equipo. Por favor, intente nuevamente.' }
  } finally {
    submitLoading.value = false
  }
}

// ===== EDIT EQUIPMENT FUNCTIONS =====
const loadEquipoDataIntoEditForm = (equipo) => {
  editForm.value = {
    id: equipo.id,
    proceso: equipo.proceso || 'LIME',
    nombre_equipo: equipo.nombre_equipo || '',
    codigo_interno: equipo.codigo_interno || '',
    codigo_ips: equipo.codigo_ips || '',
    codigo_ecri: equipo.codigo_ecri || '',
    responsable: equipo.responsable || null,
    ubicacion_fisica: equipo.ubicacion_fisica || '',
    sede: equipo.sede?.id || null,
    servicio: equipo.servicio?.id || null,
    marca: equipo.marca || '',
    modelo: equipo.modelo || '',
    serie: equipo.serie || '',
    clasificacion_misional: equipo.clasificacion_misional ? equipo.clasificacion_misional.split(',') : [],
    clasificacion_ips: equipo.clasificacion_ips || '',
    clasificacion_riesgo: equipo.clasificacion_riesgo || '',
    registro_invima: equipo.registro_invima || '',
    tiempo_vida_util: equipo.registro_adquisicion?.tiempo_vida_util || '',
    fecha_adquisicion: equipo.registro_adquisicion?.fecha_adquisicion || '',
    propietario: equipo.registro_adquisicion?.propietario || '',
    fecha_fabricacion: equipo.registro_adquisicion?.fecha_fabricacion || '',
    nit_proveedor: equipo.registro_adquisicion?.nit_proveedor || '',
    nombre_proveedor: equipo.registro_adquisicion?.nombre_proveedor || '',
    en_garantia: equipo.registro_adquisicion?.en_garantia || false,
    fecha_finalizacion_garantia: equipo.registro_adquisicion?.fecha_finalizacion_garantia || '',
    forma_adquisicion: equipo.registro_adquisicion?.forma_adquisicion || '',
    tipo_documento: equipo.registro_adquisicion?.tipo_documento || '',
    numero_documento: equipo.registro_adquisicion?.numero_documento || '',
    valor_compra: equipo.registro_adquisicion?.valor_compra || '',
    hoja_vida: equipo.documentacion?.hoja_vida || false,
    registro_importacion: equipo.documentacion?.registro_importacion || false,
    manual_operacion: equipo.documentacion?.manual_operacion || false,
    idioma_manual: equipo.documentacion?.idioma_manual || '',
    manual_servicio: equipo.documentacion?.manual_servicio || false,
    guia_rapida: equipo.documentacion?.guia_rapida || false,
    instructivo_manejo: equipo.documentacion?.instructivo_manejo || false,
    protocolo_mto_preventivo: equipo.documentacion?.protocolo_mto_preventivo || false,
    frecuencia_metrologica_doc: equipo.documentacion?.frecuencia_metrologica || false,
    requiere_mantenimiento: equipo.informacion_metrologica?.requiere_mantenimiento || false,
    frecuencia_mantenimiento: equipo.informacion_metrologica?.frecuencia_mantenimiento || '',
    ultimo_mantenimiento: equipo.informacion_metrologica?.ultimo_mantenimiento || '',
    requiere_calibracion: equipo.informacion_metrologica?.requiere_calibracion || false,
    magnitud: equipo.informacion_metrologica?.magnitud || '',
    rango_equipo: equipo.informacion_metrologica?.rango_equipo || '',
    rango_trabajo: equipo.informacion_metrologica?.rango_trabajo || '',
    resolucion: equipo.informacion_metrologica?.resolucion || '',
    error_maximo: equipo.informacion_metrologica?.error_maximo || '',
    voltaje: equipo.condiciones_funcionamiento?.voltaje || '',
    corriente: equipo.condiciones_funcionamiento?.corriente || '',
    potencia: equipo.condiciones_funcionamiento?.potencia || '',
    presion: equipo.condiciones_funcionamiento?.presion || '',
    dimensiones: equipo.condiciones_funcionamiento?.dimensiones || '',
    peso: equipo.condiciones_funcionamiento?.peso || '',
    otros: equipo.condiciones_funcionamiento?.otros || ''
  }
}

const submitEditForm = async () => {
  if (!validateEditForm()) {
    successMessage.value = ''
    return
  }
  
  submitLoading.value = true
  successMessage.value = ''
  
  try {
    const payload = {
      proceso: editForm.value.proceso,
      nombre_equipo: editForm.value.nombre_equipo,
      codigo_interno: editForm.value.codigo_interno,
      codigo_ips: editForm.value.codigo_ips || null,
      codigo_ecri: editForm.value.codigo_ecri || null,
      responsable: editForm.value.responsable,
      ubicacion_fisica: editForm.value.ubicacion_fisica,
      sede: editForm.value.sede,
      servicio: editForm.value.servicio,
      marca: editForm.value.marca,
      modelo: editForm.value.modelo,
      serie: editForm.value.serie,
      clasificacion_misional: editForm.value.clasificacion_misional.join(','),
      clasificacion_ips: editForm.value.clasificacion_ips || null,
      clasificacion_riesgo: editForm.value.clasificacion_riesgo || null,
      registro_invima: editForm.value.registro_invima || null,
      
      registro_adquisicion: {
        tiempo_vida_util: editForm.value.tiempo_vida_util || null,
        fecha_adquisicion: editForm.value.fecha_adquisicion || null,
        propietario: editForm.value.propietario || null,
        fecha_fabricacion: editForm.value.fecha_fabricacion || null,
        nit_proveedor: editForm.value.nit_proveedor || null,
        nombre_proveedor: editForm.value.nombre_proveedor || null,
        en_garantia: editForm.value.en_garantia,
        fecha_finalizacion_garantia: editForm.value.fecha_finalizacion_garantia || null,
        forma_adquisicion: editForm.value.forma_adquisicion || null,
        tipo_documento: editForm.value.tipo_documento || null,
        numero_documento: editForm.value.numero_documento || null,
        valor_compra: editForm.value.valor_compra || null
      },
      
      documentacion: {
        hoja_vida: editForm.value.hoja_vida,
        registro_importacion: editForm.value.registro_importacion,
        manual_operacion: editForm.value.manual_operacion,
        idioma_manual: editForm.value.idioma_manual || null,
        manual_servicio: editForm.value.manual_servicio,
        guia_rapida: editForm.value.guia_rapida,
        protocolo_mto_preventivo: editForm.value.protocolo_mto_preventivo,
        frecuencia_metrologica: editForm.value.frecuencia_metrologica_doc || null
      },
      
      informacion_metrologica: {
        requiere_mantenimiento: editForm.value.requiere_mantenimiento,
        frecuencia_mantenimiento: editForm.value.frecuencia_mantenimiento || null,
        ultimo_mantenimiento: editForm.value.ultimo_mantenimiento || null,
        requiere_calibracion: editForm.value.requiere_calibracion,
        magnitud: editForm.value.magnitud || null,
        rango_equipo: editForm.value.rango_equipo || null,
        rango_trabajo: editForm.value.rango_trabajo || null,
        resolucion: editForm.value.resolucion || null,
        error_maximo: editForm.value.error_maximo || null
      },
      
      condiciones_funcionamiento: {
        voltaje: editForm.value.voltaje || null,
        corriente: editForm.value.corriente || null,
        potencia: editForm.value.potencia || null,
        presion: editForm.value.presion || null,
        dimensiones: editForm.value.dimensiones || null,
        peso: editForm.value.peso || null,
        otros: editForm.value.otros || null
      }
    }
    
    const response = await fetch(`http://127.0.0.1:8000/api/equipos/${editForm.value.id}/`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload)
    })
    
    if (!response.ok) {
      const errorData = await response.json()
      console.error('Error response:', errorData)
      throw new Error(errorData.detail || 'Error al actualizar el equipo')
    }
    
    const updatedEquipo = await response.json()
    successMessage.value = '✅ Equipo actualizado exitosamente'
    
    // Refresh equipment list
    await fetchEquipos()
    
    // If the edited equipment is expanded, refresh its detail
    if (expandedEquipoId.value === editForm.value.id) {
      await fetchEquipoDetalle(editForm.value.id)
    }
    
    // Close modal after short delay
    setTimeout(() => {
      closeEditModal()
      successMessage.value = ''
    }, 2000)
    
  } catch (err) {
    console.error('Error updating equipo:', err)
    formErrors.value = { submit: err.message || 'Error al actualizar el equipo. Por favor, intente nuevamente.' }
  } finally {
    submitLoading.value = false
  }
}

// ===== MODAL METHODS =====
const openCreateModal = async () => {
  resetCreateForm()
  // Load catalogs if not already loaded
  if (sedes.value.length === 0) await fetchSedes()
  if (ubicaciones.value.length === 0) await fetchUbicaciones()
  if (responsables.value.length === 0) await fetchResponsables()
  
  showCreateModal.value = true
  activeTabCreate.value = 1
}

const closeCreateModal = () => {
  showCreateModal.value = false
  resetCreateForm()
}

const setActiveTabCreate = (tab) => {
  activeTabCreate.value = tab
}

const openEditModal = async (equipo) => {
  // Load catalogs if not already loaded
  if (sedes.value.length === 0) await fetchSedes()
  if (ubicaciones.value.length === 0) await fetchUbicaciones()
  if (responsables.value.length === 0) await fetchResponsables()

  loadEquipoDataIntoEditForm(equipo)
  showEditModal.value = true
  activeTabEdit.value = 1
}

const closeEditModal = () => {
  showEditModal.value = false
  selectedEquipoForAction.value = null
  formErrors.value = {}
}

const setActiveTabEdit = (tab) => {
  activeTabEdit.value = tab
}

const openDeleteModal = (equipo) => {
  // In a real app, we would set the equipment to delete
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
}

const openPasswordModal = (campo) => {
  campoProtegido.value = campo
  showPasswordModal.value = true
}

const closePasswordModal = () => {
  showPasswordModal.value = false
}

const closeConfirmModal = () => {
  showConfirmModal.value = false
}

onMounted(() => {
  fetchEquipos()
})
</script>

<template>
  <div id="equipos-page">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Inventario de Equipos</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Equipos / Lista</div>
      </div>
      <button class="btn btn-primary" @click="openCreateModal">➕ Nuevo Equipo</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            class="search-input" 
            placeholder="🔍 Buscar por código, nombre, marca, modelo o serie..." 
            v-model="searchQuery"
          >
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''" 
            class="clear-search-btn"
            title="Limpiar búsqueda"
          >
            ✕
          </button>
        </div>
        <button class="filter-button">☰ Filtrar y Ordenar</button>
      </div>

      <!-- Skeleton Loader -->
      <div v-if="loading" class="skeleton-table">
        <table>
          <thead>
            <tr>
              <th style="width: 7%;">Código</th>
              <th style="width: 19%;">Equipo</th>
              <th style="width: 18%;">Registro Invima</th>
              <th style="width: 6%; text-align: center;">Riesgo</th>
              <th style="width: 10%;">Sede / Ubicación</th>
              <th style="width: 12%;">Encargado</th>
              <th style="width: 10%;">Estado</th>
              <th style="width: 18%;">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="i in 8" :key="i">
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text skeleton-badge"></div></td>
              <td style="text-align: center;"><div class="skeleton-text skeleton-small" style="margin: 0 auto;"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text skeleton-badge"></div></td>
              <td><div class="skeleton-text skeleton-buttons"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>
      
      <table v-else id="equiposTable">
        <thead>
          <tr>
            <th style="width: 7%;">Código</th>
            <th style="width: 19%;">Equipo</th>
            <th style="width: 18%;">Registro Invima</th>
            <th style="width: 6%; text-align: center;">Riesgo</th>
            <th style="width: 10%;">Sede / Ubicación</th>
            <th style="width: 12%;">Encargado</th>
            <th style="width: 10%; text-align: center;">Estado</th>
            <th style="width: 18%;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="equipo in paginatedEquipos" :key="equipo.id">
            <tr :data-equipo="equipo.id" @click="toggleDetalle(equipo.id)" :class="{ 'row-active': expandedEquipoId === equipo.id }">
              <td><strong>{{ equipo.codigo_interno }}</strong></td>
              <td>
                <div style="font-weight: 600;">{{ equipo.nombre_equipo }}</div>
                <div style="font-size: 11px; color: #616161;">{{ equipo.marca }} - {{ equipo.modelo }}</div>
              </td>
              <td>
                <span v-if="equipo.registro_invima" class="invima-badge">{{ equipo.registro_invima }}</span>
                <span v-else class="invima-badge" style="background: rgba(158, 158, 158, 0.1); color: #9e9e9e;">N/A</span>
              </td>
              <td style="text-align: center;">
                <span class="risk-box" :class="getRiesgoBadgeClass(equipo.clasificacion_riesgo)">
                  {{ equipo.clasificacion_riesgo || 'N/A' }}
                </span>
              </td>
              <td>
                <div style="font-weight: 600; font-size: 14px;">{{ equipo.sede?.nombre || 'N/A' }}</div>
                <div style="font-size: 12px; color: #616161;">{{ equipo.servicio?.nombre || 'N/A' }}</div>
              </td>
              <td>{{ equipo.responsable_nombre || 'N/A' }}</td>
              <td style="text-align: center;">
                <span class="estado-badge" :class="getEstadoBadgeClass(equipo.estado)">
                  {{ formatEstado(equipo.estado) }}
                </span>
              </td>
              <td @click.stop>
                <div style="display: flex; gap: 6px;">
                  <button 
                    class="btn btn-info btn-sm btn-ver" 
                    :class="{ 'btn-ver-active': expandedEquipoId === equipo.id }"
                    @click="toggleDetalle(equipo.id)"
                  >👁️</button>
                  <button class="btn btn-secondary btn-sm" @click="openEditModal(equipo)">✏️</button>
                  <button class="btn btn-danger btn-sm" @click="openDeleteModal(equipo)">🗑️</button>
                </div>
              </td>
            </tr>

            <!-- Detalle Row -->
            <tr v-if="expandedEquipoId === equipo.id" class="detalle-row active">
              <td colspan="8" class="detalle-cell">
                <div class="detalle-container">
                  <div v-if="detailLoading" style="padding: 40px; text-align: center;">
                    Cargando detalles...
                  </div>
                  <div v-else-if="selectedEquipo">
                    <div class="detalle-header">
                      <div class="detalle-title">📋 Detalle del Equipo - {{ selectedEquipo.nombre_equipo }} ({{ selectedEquipo.codigo_interno }})</div>
                      <button class="btn btn-secondary btn-sm" @click="toggleDetalle(equipo.id)">✕ Cerrar</button>
                    </div>

                    <div class="detalle-tabs">
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'info' }"
                        @click="setActiveTab('info')"
                      >Información General</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'documentos' }"
                        @click="setActiveTab('documentos')"
                      >Documentos</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'metrologia' }"
                        @click="setActiveTab('metrologia')"
                      >Metrología</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'traslados' }"
                        @click="setActiveTab('traslados')"
                      >Historial Traslados</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'mantenimientos' }"
                        @click="setActiveTab('mantenimientos')"
                      >Mantenimientos</div>
                    </div>

                    <!-- Tab Content: Información General -->
                    <div v-show="activeTab === 'info'" class="detalle-content active">
                      <div class="detalle-grid">
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">A. Información General</h4>
                          <div class="detalle-item"><span class="detalle-label">Proceso:</span><span class="detalle-value">LIME</span></div>
                          <div class="detalle-item"><span class="detalle-label">Código Interno:</span><span class="detalle-value"><strong>{{ selectedEquipo.codigo_interno }}</strong></span></div>
                          <div class="detalle-item"><span class="detalle-label">Código IPS:</span><span class="detalle-value">{{ selectedEquipo.codigo_ips || 'Pendiente' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Responsable:</span><span class="detalle-value">{{ selectedEquipo.responsable_nombre || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Ubicación:</span><span class="detalle-value">{{ selectedEquipo.ubicacion_fisica }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Sede:</span><span class="detalle-value">{{ selectedEquipo.sede_info?.nombre }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Proceso:</span><span class="detalle-value">{{ selectedEquipo.servicio_info?.nombre }}</span></div>
                        </div>
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">B. Información del Equipo</h4>
                          <div class="detalle-item"><span class="detalle-label">Nombre:</span><span class="detalle-value">{{ selectedEquipo.nombre_equipo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Marca:</span><span class="detalle-value">{{ selectedEquipo.marca }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Modelo:</span><span class="detalle-value">{{ selectedEquipo.modelo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Serie:</span><span class="detalle-value">{{ selectedEquipo.serie }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Clasif. IPS:</span><span class="detalle-value">{{ selectedEquipo.clasificacion_ips }}</span></div>
                          <div class="detalle-item">
                            <span class="detalle-label">Registro INVIMA:</span>
                            <span class="detalle-value">
                              <span v-if="selectedEquipo.registro_invima" class="invima-badge">{{ selectedEquipo.registro_invima }}</span>
                              <span v-else style="color: #999;">N/A</span>
                            </span>
                          </div>
                        </div>
                        <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">C. Registro Histórico</h4>
                          <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                            <div class="detalle-item"><span class="detalle-label">Fecha Adquisición:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.fecha_adquisicion }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Propietario:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.propietario }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Forma Adquisición:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.forma_adquisicion }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Proveedor:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.nombre_proveedor }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">En Garantía:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.en_garantia ? 'Sí' : 'No' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Documento:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.tipo_documento }} #{{ selectedEquipo.registro_adquisicion?.numero_documento }}</span></div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Tab Content: Documentos -->
                    <div v-show="activeTab === 'documentos'" class="detalle-content active">
                      <div class="detalle-section" style="grid-column: 1 / -1;">
                        <h4 class="detalle-section-title">D. Inventario de Documentos</h4>
                        <div class="documentos-grid">
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.hoja_vida ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.hoja_vida ? '✅' : '❌' }}</span>
                            <span>Hoja de Vida</span>
                          </div>
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.registro_importacion ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.registro_importacion ? '✅' : '❌' }}</span>
                            <span>Registro Importación</span>
                          </div>
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.manual_operacion ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.manual_operacion ? '✅' : '❌' }}</span>
                            <span>Manual Operación (Esp)</span>
                          </div>
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.manual_servicio ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.manual_servicio ? '✅' : '❌' }}</span>
                            <span>Manual Servicio</span>
                          </div>
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.guia_rapida ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.guia_rapida ? '✅' : '❌' }}</span>
                            <span>Guía Rápida</span>
                          </div>
                          <div class="documento-item">
                            <span class="x-icon">❌</span>
                            <span>Instructivo Manejo</span>
                          </div>
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.protocolo_mto_preventivo ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.protocolo_mto_preventivo ? '✅' : '❌' }}</span>
                            <span>Protocolo Mto Prev</span>
                          </div>
                          <div class="documento-item">
                            <span :class="selectedEquipo.documentacion?.frecuencia_metrologica ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.frecuencia_metrologica ? '✅' : '❌' }}</span>
                            <span>Frecuencia Metrológica</span>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Tab Content: Metrología -->
                    <div v-show="activeTab === 'metrologia'" class="detalle-content active">
                      <div class="detalle-grid">
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">E. Info Metrológica Administrativa</h4>
                          <div class="detalle-item"><span class="detalle-label">Requiere Mantenimiento:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.requiere_mantenimiento ? '✅ Sí' : 'No' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Frecuencia:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.frecuencia_mantenimiento }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Último Mantenimiento:</span><span class="detalle-value">{{ formatFecha(selectedEquipo.informacion_metrologica?.ultimo_mantenimiento) }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Próximo Mantenimiento:</span><span class="detalle-value">{{ formatFecha(selectedEquipo.informacion_metrologica?.fecha_proximo_mantenimiento_calculada) }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Estado Mantenimiento:</span><span class="detalle-value"><strong>{{ selectedEquipo.informacion_metrologica?.estado_mantenimiento || 'N/A' }}</strong></span></div>
                          <div class="detalle-item"><span class="detalle-label">Requiere Calibración:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.requiere_calibracion ? '✅ Sí' : 'No' }}</span></div>
                        </div>
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">F. Info Metrológica Técnica</h4>
                          <div class="detalle-item"><span class="detalle-label">Magnitud:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.magnitud }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Rango del Equipo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.rango_equipo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Rango de Trabajo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.rango_trabajo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Resolución:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.resolucion }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Error Máximo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.error_maximo }}</span></div>
                        </div>
                      </div>
                    </div>

                    <!-- Tab Content: Traslados -->
                    <div v-show="activeTab === 'traslados'" class="detalle-content active">
                      <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">Historial de Traslados</h4>
                          
                          <div v-if="trasladosLoading" style="text-align: center; padding: 20px;">
                            <div class="spinner" style="display: inline-block; width: 30px; height: 30px; border: 3px solid #f3f3f3; border-top: 3px solid #006633; border-radius: 50%; animation: spin 1s linear infinite;"></div>
                            <p style="color: #666; font-size: 13px; margin-top: 10px;">Cargando historial...</p>
                          </div>
                          
                          <div v-else>
                            <table v-if="trasladosCache.get(equipo.id) && trasladosCache.get(equipo.id).length > 0" class="tabla-mantenimientos">
                              <thead>
                                <tr>
                                  <th>Fecha</th>
                                  <th>Origen</th>
                                  <th>Destino</th>
                                  <th>Justificación</th>
                                  <th>Usuario</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr v-for="traslado in trasladosCache.get(equipo.id)" :key="traslado.id">
                                  <td>{{ traslado.fecha_display }}</td>
                                  <td>{{ traslado.sede_origen_nombre }} / {{ traslado.servicio_origen_nombre }}</td>
                                  <td>{{ traslado.sede_destino_nombre }} / {{ traslado.servicio_destino_nombre }}</td>
                                  <td>{{ traslado.justificacion }}</td>
                                  <td>{{ traslado.usuario_registro }}</td>
                                </tr>
                              </tbody>
                            </table>
                            <p v-else style="padding: 20px; color: #666;">No hay traslados registrados.</p>
                          </div>
                      </div>
                    </div>

                    <!-- Tab Content: Mantenimientos -->
                    <div v-show="activeTab === 'mantenimientos'" class="detalle-content active">
                      <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">Historial de Mantenimientos</h4>
                          
                          <div v-if="mantenimientosLoading" style="text-align: center; padding: 20px;">
                            <div class="spinner" style="display: inline-block; width: 30px; height: 30px; border: 3px solid #f3f3f3; border-top: 3px solid #006633; border-radius: 50%; animation: spin 1s linear infinite;"></div>
                            <p style="color: #666; font-size: 13px; margin-top: 10px;">Cargando historial...</p>
                          </div>
                          
                          <div v-else>
                            <table v-if="mantenimientosCache.get(equipo.id) && mantenimientosCache.get(equipo.id).length > 0" class="tabla-mantenimientos">
                              <thead>
                                <tr>
                                  <th>Fecha</th>
                                  <th>Tipo</th>
                                  <th>Realizado Por</th>
                                  <th>Costo</th>
                                  <th>Descripción</th>
                                  <th>Observaciones</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr v-for="mant in mantenimientosCache.get(equipo.id)" :key="mant.id">
                                  <td>{{ mant.fecha_display }}</td>
                                  <td style="text-transform: capitalize;">{{ mant.tipo_mantenimiento }}</td>
                                  <td>{{ mant.realizado_por }}</td>
                                  <td>${{ mant.costo }}</td>
                                  <td>{{ mant.descripcion }}</td>
                                  <td>{{ mant.observaciones || 'N/A' }}</td>
                                </tr>
                              </tbody>
                            </table>
                            <p v-else style="padding: 20px; color: #666;">No hay mantenimientos registrados.</p>
                          </div>
                      </div>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>

      <!-- Pagination Footer -->
      <div class="pagination-footer">
        <div class="items-per-page">
          <span>Mostrar</span>
          <select v-model="itemsPerPage" class="page-select">
            <option v-for="opt in itemsPerPageOptions" :key="opt" :value="opt">{{ opt }}</option>
          </select>
          <span>registros</span>
        </div>
        <div class="page-navigation">
          <button class="page-btn" :disabled="currentPage === 1" @click="changePage(currentPage - 1)">Anterior</button>
          <span class="page-info">
            Página 
            <input type="number" v-model="currentPage" min="1" :max="totalPages" class="page-input" @change="changePage(currentPage)">
            de {{ totalPages }}
          </span>
          <button class="page-btn" :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">Siguiente</button>
        </div>
      </div>
    </div>

    <!-- MODAL: CREAR NUEVO EQUIPO -->
    <div class="modal" :class="{ active: showCreateModal }">
      <div class="modal-content">
        <div class="modal-header">
          <div class="modal-title">➕ Crear Nuevo Equipo</div>
          <button class="close-btn" @click="closeCreateModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="tabs">
            <div class="tab" :class="{ active: activeTabCreate === 1 }" @click="setActiveTabCreate(1)">1. Información General</div>
            <div class="tab" :class="{ active: activeTabCreate === 2 }" @click="setActiveTabCreate(2)">2. Datos del Equipo</div>
            <div class="tab" :class="{ active: activeTabCreate === 3 }" @click="setActiveTabCreate(3)">3. Registro Histórico</div>
            <div class="tab" :class="{ active: activeTabCreate === 4 }" @click="setActiveTabCreate(4)">4. Documentos</div>
            <div class="tab" :class="{ active: activeTabCreate === 5 }" @click="setActiveTabCreate(5)">5. Metrología</div>
            <div class="tab" :class="{ active: activeTabCreate === 6 }" @click="setActiveTabCreate(6)">6. Condiciones</div>
          </div>

          <!-- TAB 1: INFO GENERAL -->
          <div v-show="activeTabCreate === 1" class="tab-content active">
            <h4 class="section-title">📝 A. Información General</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Sede</label>
                <select class="form-select">
                  <option value="">Seleccione una sede</option>
                  <option value="1">Prado</option>
                  <option value="2">Sede 2</option>
                  <option value="3">Sede 3</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label required">Proceso</label>
                <select class="form-select">
                  <option value="">Seleccione un servicio</option>
                  <option value="1">LIME Central</option>
                  <option value="2">Fotodermatología</option>
                  <option value="3">Resonador</option>
                  <option value="4">Oftalmología</option>
                  <option value="5">Hematología</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label required">Nombre del Equipo</label>
                <input type="text" class="form-input" placeholder="Ej: Congelador, Agregómetro">
              </div>
              <div class="form-group">
                <label class="form-label required">Código de Inventario Interno</label>
                <input type="text" class="form-input" placeholder="Ej: 135306">
              </div>
              <div class="form-group">
                <label class="form-label">Código IPS</label>
                <input type="text" class="form-input" placeholder="Ej: BIO-12183">
              </div>
              <div class="form-group">
                <label class="form-label">Código ECRI</label>
                <input type="text" class="form-input" placeholder="Ej: 15 - 583">
              </div>
              <div class="form-group">
                <label class="form-label required">Responsable del Equipo</label>
                <input type="text" class="form-input" placeholder="Nombre completo">
              </div>
              <div class="form-group full-width">
                <label class="form-label required">Ubicación Física</label>
                <input type="text" class="form-input" placeholder="Ej: Procesamiento Sección C">
              </div>
            </div>
          </div>

          <!-- TAB 2: DATOS DEL EQUIPO -->
          <div v-show="activeTabCreate === 2" class="tab-content active">
            <h4 class="section-title">🔧 B. Información del Equipo</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Marca</label>
                <input type="text" class="form-input" placeholder="Ej: Challenger, Helena Laboratories">
              </div>
              <div class="form-group">
                <label class="form-label required">Modelo</label>
                <input type="text" class="form-input" placeholder="Ej: CV430, AGGRAM">
              </div>
              <div class="form-group">
                <label class="form-label required">Número de Serie</label>
                <input type="text" class="form-input" placeholder="Ej: 9053127">
              </div>
              <div class="form-group">
                <label class="form-label">Clasificación Eje Misional <span style="font-size: 12px; color: #616161;">(Puede seleccionar varios)</span></label>
                <div class="checkbox-group" style="flex-wrap: wrap; gap: 15px;">
                  <div style="display: flex; align-items: center; gap: 5px;">
                    <input type="checkbox" id="create-misional-docencia" value="Docencia" v-model="editForm.clasificacion_misional">
                    <label for="create-misional-docencia" style="font-size: 13px; cursor: pointer;">Docencia</label>
                  </div>
                  <div style="display: flex; align-items: center; gap: 5px;">
                    <input type="checkbox" id="create-misional-investigacion" value="Investigación" v-model="editForm.clasificacion_misional">
                    <label for="create-misional-investigacion" style="font-size: 13px; cursor: pointer;">Investigación</label>
                  </div>
                  <div style="display: flex; align-items: center; gap: 5px;">
                    <input type="checkbox" id="create-misional-extension" value="Extensión" v-model="editForm.clasificacion_misional">
                    <label for="create-misional-extension" style="font-size: 13px; cursor: pointer;">Extensión</label>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Clasificación IPS</label>
                <select class="form-select">
                  <option value="">Seleccione</option>
                  <option value="IND">IND - Industrial</option>
                  <option value="BIO">BIO - Biomédico</option>
                  <option value="Gases">Gases Medicinales</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Clasificación por Riesgo</label>
                <select class="form-select">
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
                <input type="text" class="form-input" placeholder="Ej: INVIMA 2019DM-0019614 o N/A">
              </div>
            </div>
          </div>

          <!-- TAB 3: REGISTRO HISTÓRICO -->
          <div v-show="activeTabCreate === 3" class="tab-content active">
            <h4 class="section-title">📅 C. Registro Histórico</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Tiempo de Vida Útil</label>
                <input type="text" class="form-input" placeholder="Ej: 10 años">
              </div>
              <div class="form-group">
                <label class="form-label required">Fecha de Adquisición</label>
                <input type="date" class="form-input">
              </div>
              <div class="form-group">
                <label class="form-label required">Propietario del Equipo</label>
                <input type="text" class="form-input" placeholder="Ej: UdeA, Hospital">
              </div>
              <div class="form-group">
                <label class="form-label">Fecha de Fabricación</label>
                <input type="text" class="form-input" placeholder="Año (Ej: 2008) o NI">
              </div>
              <div class="form-group">
                <label class="form-label required">NIT del Proveedor</label>
                <input type="text" class="form-input" placeholder="Ej: 890.934.939-8">
              </div>
              <div class="form-group full-width">
                <label class="form-label required">Proveedor del Equipo</label>
                <textarea class="form-textarea" placeholder="Nombre completo del proveedor"></textarea>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="enGarantia" v-model="editForm.en_garantia">
                  <label for="enGarantia" class="form-label" style="margin: 0;">¿Está en Garantía?</label>
                </div>
              </div>
              <div class="form-group" v-if="editForm.en_garantia">
                <label class="form-label">Fecha Finalización Garantía</label>
                <input type="date" class="form-input">
              </div>
              <div class="form-group">
                <label class="form-label required">Forma de Adquisición</label>
                <select class="form-select">
                  <option value="">Seleccione</option>
                  <option value="Compra">Compra</option>
                  <option value="Donación">Donación</option>
                  <option value="Comodato">Comodato</option>
                  <option value="Arrendamiento">Arrendamiento</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label required">Tipo de Documento</label>
                <input type="text" class="form-input" placeholder="Ej: Factura, Acta">
              </div>
              <div class="form-group">
                <label class="form-label required">Número de Documento</label>
                <input type="text" class="form-input" placeholder="Ej: 47736">
              </div>
            </div>
          </div>

          <!-- TAB 4: DOCUMENTOS -->
          <div v-show="activeTabCreate === 4" class="tab-content active">
            <h4 class="section-title">📄 D. Inventario de Documentos</h4>
            <p style="color: #616161; margin-bottom: 20px; font-size: 14px;">Marque los documentos que posee el equipo:</p>
            <div class="form-grid">
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc1">
                  <label for="doc1" class="form-label" style="margin: 0;">Hoja de Vida</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc2">
                  <label for="doc2" class="form-label" style="margin: 0;">Registro de Importación</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc3">
                  <label for="doc3" class="form-label" style="margin: 0;">Manual de Operación</label>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Idioma del Manual</label>
                <select class="form-select">
                  <option value="">Seleccione</option>
                  <option value="Español">Español</option>
                  <option value="Inglés">Inglés</option>
                  <option value="Otro">Otro</option>
                </select>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc4">
                  <label for="doc4" class="form-label" style="margin: 0;">Manual Servicio/Mto</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc5">
                  <label for="doc5" class="form-label" style="margin: 0;">Guía Rápida</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc6">
                  <label for="doc6" class="form-label" style="margin: 0;">Instructivo Manejo</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc7">
                  <label for="doc7" class="form-label" style="margin: 0;">Protocolo Mto Preventivo</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="doc8">
                  <label for="doc8" class="form-label" style="margin: 0;">Frecuencia Metrológica</label>
                </div>
              </div>
              <div class="form-group full-width">
                <label class="form-label">Observaciones Documentos</label>
                <textarea class="form-textarea" placeholder="Ej: Carta de proveedor de no entrega de manual"></textarea>
              </div>
            </div>
          </div>

          <!-- TAB 5: METROLOGÍA -->
          <div v-show="activeTabCreate === 5" class="tab-content active">
            <h4 class="section-title">🔬 E & F. Información Metrológica</h4>
            <div class="info-box">
              <div class="info-box-title">Información Metrológica Administrativa</div>
              <p style="font-size: 13px; color: #616161;">Configure los parámetros de mantenimiento y calibración del equipo.</p>
            </div>
            <div class="form-grid">
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="reqMto" v-model="editForm.requiere_mantenimiento">
                  <label for="reqMto" class="form-label" style="margin: 0;">Requiere Mantenimiento</label>
                </div>
              </div>
              <div class="form-group" v-if="editForm.requiere_mantenimiento">
                <label class="form-label">Frecuencia Anual Mantenimiento</label>
                <input type="number" class="form-input" placeholder="Ej: 1, 2, 4" min="0">
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="reqCal" v-model="editForm.requiere_calibracion">
                  <label for="reqCal" class="form-label" style="margin: 0;">Requiere Calibración</label>
                </div>
              </div>
              <div class="form-group" v-if="editForm.requiere_calibracion">
                <label class="form-label">Frecuencia Anual Calibración</label>
                <input type="number" class="form-input" placeholder="Ej: 1, 2, 4" min="0">
              </div>
              <div class="form-group" v-if="editForm.requiere_calibracion">
                <label class="form-label">Tipo de Calibración</label>
                <input type="text" class="form-input" placeholder="Ej: Calificación, Verificación">
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
                <input type="text" class="form-input" placeholder="Ej: Temperatura, Absorbancia">
              </div>
              <div class="form-group">
                <label class="form-label">Rango del Equipo</label>
                <input type="text" class="form-input" placeholder="Ej: T -18, 0-100°C">
              </div>
              <div class="form-group">
                <label class="form-label">Resolución</label>
                <input type="text" class="form-input" placeholder="Ej: 0.1°C, NI">
              </div>
              <div class="form-group">
                <label class="form-label">Rango de Trabajo</label>
                <input type="text" class="form-input" placeholder="Ej: 0 a -33°C">
              </div>
              <div class="form-group">
                <label class="form-label">Error Máximo Permitido</label>
                <input type="text" class="form-input" placeholder="Ej: ±0.5°C, NI">
              </div>
            </div>
          </div>

          <!-- TAB 6: CONDICIONES -->
          <div v-show="activeTabCreate === 6" class="tab-content active">
            <h4 class="section-title">⚙️ G. Condiciones de Funcionamiento</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Voltaje</label>
                <input type="text" class="form-input" placeholder="Ej: 115 VAC, 200-240V">
              </div>
              <div class="form-group">
                <label class="form-label">Corriente</label>
                <input type="text" class="form-input" placeholder="Ej: 4A, NI">
              </div>
              <div class="form-group">
                <label class="form-label">Humedad Relativa</label>
                <input type="text" class="form-input" placeholder="Ej: 30-90%, NI">
              </div>
              <div class="form-group">
                <label class="form-label">Temperatura Funcionamiento</label>
                <input type="text" class="form-input" placeholder="Ej: Max 38°C">
              </div>
              <div class="form-group">
                <label class="form-label">Dimensiones</label>
                <input type="text" class="form-input" placeholder="Ej: 53.5 x 53 x 142 cm">
              </div>
              <div class="form-group">
                <label class="form-label">Peso</label>
                <input type="text" class="form-input" placeholder="Ej: 55.5 kg">
              </div>
              <div class="form-group full-width">
                <label class="form-label">Otras Condiciones</label>
                <textarea class="form-textarea" placeholder="Ej: Frecuencia eléctrica, presión, etc."></textarea>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeCreateModal">Cancelar</button>
          <button class="btn btn-primary" @click="closeCreateModal">💾 Guardar Equipo</button>
        </div>
      </div>
    </div>

    <!-- MODAL: EDITAR EQUIPO -->
    <div class="modal" :class="{ active: showEditModal }">
      <div class="modal-content">
        <div class="modal-header">
          <div class="modal-title">✏️ Editar Equipo - <span id="edit-equipo-nombre">Congelador</span> (<span id="edit-equipo-codigo">135306</span>)</div>
          <button class="close-btn" @click="closeEditModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="edit-note">
            ℹ️ <strong>Campos protegidos:</strong> Los campos con fondo amarillo 🔒 son críticos y requieren contraseña de administrador para modificarse. Los demás campos pueden editarse libremente.
          </div>

          <div class="tabs">
            <div class="tab" :class="{ active: activeTabEdit === 1 }" @click="setActiveTabEdit(1)">1. Información General</div>
            <div class="tab" :class="{ active: activeTabEdit === 2 }" @click="setActiveTabEdit(2)">2. Datos del Equipo</div>
            <div class="tab" :class="{ active: activeTabEdit === 3 }" @click="setActiveTabEdit(3)">3. Registro Histórico</div>
            <div class="tab" :class="{ active: activeTabEdit === 4 }" @click="setActiveTabEdit(4)">4. Documentos</div>
            <div class="tab" :class="{ active: activeTabEdit === 5 }" @click="setActiveTabEdit(5)">5. Metrología</div>
            <div class="tab" :class="{ active: activeTabEdit === 6 }" @click="setActiveTabEdit(6)">6. Condiciones</div>
          </div>

          <!-- TAB 1: INFO GENERAL -->
          <div v-show="activeTabEdit === 1" class="tab-content active">
            <h4 class="section-title">📝 A. Información General</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Sede</label>
                <select class="form-select" v-model="editForm.sede">
                  <option value="" disabled>Seleccione una sede</option>
                  <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
                </select>
                <span v-if="formErrors.sede" class="error-message">{{ formErrors.sede }}</span>
              </div>
              <div class="form-group">
                <label class="form-label required">Proceso</label>
                <select class="form-select" v-model="editForm.servicio">
                  <option value="" disabled>Seleccione un servicio</option>
                  <option v-for="ubicacion in ubicacionesFiltradasEdit" :key="ubicacion.id" :value="ubicacion.id">{{ ubicacion.nombre }}</option>
                </select>
                <span v-if="formErrors.servicio" class="error-message">{{ formErrors.servicio }}</span>
              </div>
              <div class="form-group">
                <label class="form-label required">Nombre del Equipo</label>
                <input type="text" class="form-input" v-model="editForm.nombre_equipo" placeholder="Ej: Congelador, Agregador">
                <span v-if="formErrors.nombre_equipo" class="error-message">{{ formErrors.nombre_equipo }}</span>
              </div>
              <div class="form-group">
                <label class="form-label required">Código de Inventario Interno <span class="lock-icon">🔒</span></label>
                <input type="text" class="form-input locked" v-model="editForm.codigo_interno" @click="openPasswordModal('codigo')">
                <span v-if="formErrors.codigo_interno" class="error-message">{{ formErrors.codigo_interno }}</span>
              </div>
              <div class="form-group">
                <label class="form-label">Código IPS</label>
                <input type="text" class="form-input" v-model="editForm.codigo_ips" placeholder="Ej: BIO-12183">
              </div>
              <div class="form-group">
                <label class="form-label">Código ECRI</label>
                <input type="text" class="form-input" v-model="editForm.codigo_ecri" placeholder="Ej: 15 - 583">
              </div>
              <div class="form-group">
                <label class="form-label required">Responsable del Equipo</label>
                <select class="form-select" v-model="editForm.responsable">
                  <option value="" disabled>Seleccione un responsable</option>
                  <option v-for="resp in responsables" :key="resp.id" :value="resp.id">{{ resp.nombre_completo }}</option>
                </select>
                <span v-if="formErrors.responsable" class="error-message">{{ formErrors.responsable }}</span>
              </div>
              <div class="form-group full-width">
                <label class="form-label required">Ubicación Física</label>
                <input type="text" class="form-input" v-model="editForm.ubicacion_fisica" placeholder="Ej: Procesamiento Sección C">
                <span v-if="formErrors.ubicacion_fisica" class="error-message">{{ formErrors.ubicacion_fisica }}</span>
              </div>
            </div>
          </div>

          <!-- TAB 2: DATOS DEL EQUIPO -->
          <div v-show="activeTabEdit === 2" class="tab-content active">
            <h4 class="section-title">🔧 B. Información del Equipo</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Marca</label>
                <input type="text" class="form-input" value="Challenger">
              </div>
              <div class="form-group">
                <label class="form-label required">Modelo</label>
                <input type="text" class="form-input" value="CV430">
              </div>
              <div class="form-group">
                <label class="form-label required">Número de Serie<span class="lock-icon">🔒</span></label>
                <input type="text" class="form-input locked" value="9053127" @click="openPasswordModal('serie')">
              </div>
              <div class="form-group">
                <label class="form-label">Clasificación Eje Misional <span style="font-size: 12px; color: #616161;">(Puede seleccionar varios)</span></label>
                <div class="checkbox-group" style="flex-wrap: wrap; gap: 15px;">
                  <div style="display: flex; align-items: center; gap: 5px;">
                    <input type="checkbox" id="misional-docencia" value="Docencia" v-model="editForm.clasificacion_misional">
                    <label for="misional-docencia" style="font-size: 13px; cursor: pointer;">Docencia</label>
                  </div>
                  <div style="display: flex; align-items: center; gap: 5px;">
                    <input type="checkbox" id="misional-investigacion" value="Investigación" v-model="editForm.clasificacion_misional">
                    <label for="misional-investigacion" style="font-size: 13px; cursor: pointer;">Investigación</label>
                  </div>
                  <div style="display: flex; align-items: center; gap: 5px;">
                    <input type="checkbox" id="misional-extension" value="Extensión" v-model="editForm.clasificacion_misional">
                    <label for="misional-extension" style="font-size: 13px; cursor: pointer;">Extensión</label>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Clasificación IPS</label>
                <select class="form-select">
                  <option value="IND" selected>IND - Industrial</option>
                  <option value="BIO">BIO - Biomédico</option>
                  <option value="Gases">Gases Medicinales</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Clasificación por Riesgo</label>
                <select class="form-select">
                  <option value="I">Clase I</option>
                  <option value="IIa">Clase IIa</option>
                  <option value="IIb">Clase IIb</option>
                  <option value="III">Clase III</option>
                  <option value="N/A" selected>N/A</option>
                </select>
              </div>
              <div class="form-group full-width">
                <label class="form-label">Registro INVIMA / Permiso Comercialización</label>
                <input type="text" class="form-input" value="N/A">
              </div>
            </div>
          </div>

          <!-- TAB 3: REGISTRO HISTÓRICO -->
          <div v-show="activeTabEdit === 3" class="tab-content active">
            <h4 class="section-title">📅 C. Registro Histórico</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Tiempo de Vida Útil</label>
                <input type="text" class="form-input" value="">
              </div>
              <div class="form-group">
                <label class="form-label required">Fecha de Adquisición<span class="lock-icon">🔒</span></label>
                <input type="date" class="form-input locked" value="2009-12-10" @click="openPasswordModal('fecha-adq')">
              </div>
              <div class="form-group">
                <label class="form-label required">Propietario del Equipo<span class="lock-icon">🔒</span></label>
                <input type="text" class="form-input locked" value="UdeA" @click="openPasswordModal('propietario')">
              </div>
              <div class="form-group">
                <label class="form-label">Fecha de Fabricación</label>
                <input type="text" class="form-input" value="NI">
              </div>
              <div class="form-group">
                <label class="form-label required">NIT del Proveedor<span class="lock-icon">🔒</span></label>
                <input type="text" class="form-input locked" value="890.934.939-8" @click="openPasswordModal('nit')">
              </div>
              <div class="form-group full-width">
                <label class="form-label required">Proveedor del Equipo<span class="lock-icon">🔒</span></label>
                <textarea class="form-textarea locked" @click="openPasswordModal('proveedor')">Almacén Navarro Ospina S.A.</textarea>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-garantia" v-model="editForm.en_garantia">
                  <label for="edit-garantia" class="form-label" style="margin: 0;">¿Está en Garantía?</label>
                </div>
              </div>
              <div class="form-group" v-if="editForm.en_garantia">
                <label class="form-label">Fecha Finalización Garantía</label>
                <input type="date" class="form-input">
              </div>
              <div class="form-group">
                <label class="form-label required">Forma de Adquisición<span class="lock-icon">🔒</span></label>
                <select class="form-select locked" @click="openPasswordModal('forma-adq')">
                  <option value="Compra" selected>Compra</option>
                  <option value="Donación">Donación</option>
                  <option value="Comodato">Comodato</option>
                  <option value="Arrendamiento">Arrendamiento</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label required">Tipo de Documento<span class="lock-icon">🔒</span></label>
                <input type="text" class="form-input locked" value="Factura" @click="openPasswordModal('tipo-doc')">
              </div>
              <div class="form-group">
                <label class="form-label required">Número de Documento<span class="lock-icon">🔒</span></label>
                <input type="text" class="form-input locked" value="47736" @click="openPasswordModal('num-doc')">
              </div>
            </div>
          </div>

          <!-- TAB 4: DOCUMENTOS -->
          <div v-show="activeTabEdit === 4" class="tab-content active">
            <h4 class="section-title">📄 D. Inventario de Documentos</h4>
            <p style="color: #616161; margin-bottom: 20px; font-size: 14px;">Marque los documentos que posee el equipo:</p>
            <div class="form-grid">
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-doc1" checked>
                  <label for="edit-doc1" class="form-label" style="margin: 0;">Hoja de Vida</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-doc2">
                  <label for="edit-doc2" class="form-label" style="margin: 0;">Registro de Importación</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-doc3" checked>
                  <label for="edit-doc3" class="form-label" style="margin: 0;">Manual de Operación</label>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Idioma del Manual</label>
                <select class="form-select">
                  <option value="">Seleccione</option>
                  <option value="Español" selected>Español</option>
                  <option value="Inglés">Inglés</option>
                  <option value="Otro">Otro</option>
                </select>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-doc4">
                  <label for="edit-doc4" class="form-label" style="margin: 0;">Manual Servicio/Mto</label>
                </div>
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-doc5">
                  <label for="edit-doc5" class="form-label" style="margin: 0;">Guía Rápida</label>
                </div>
              </div>
              <div class="form-group full-width">
                <label class="form-label">Observaciones Documentos</label>
                <textarea class="form-textarea" placeholder="Ej: Carta de proveedor de no entrega de manual"></textarea>
              </div>
            </div>
          </div>

          <!-- TAB 5: METROLOGÍA -->
          <div v-show="activeTabEdit === 5" class="tab-content active">
            <h4 class="section-title">🔬 E & F. Información Metrológica</h4>
            <div class="info-box">
              <div class="info-box-title">Información Metrológica Administrativa</div>
              <p style="font-size: 13px; color: #616161;">Configure los parámetros de mantenimiento y calibración del equipo.</p>
            </div>
            <div class="form-grid">
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-reqMto" v-model="editForm.requiere_mantenimiento">
                  <label for="edit-reqMto" class="form-label" style="margin: 0;">Requiere Mantenimiento</label>
                </div>
              </div>
              <div class="form-group" v-if="editForm.requiere_mantenimiento">
                <label class="form-label">Frecuencia Anual Mantenimiento</label>
                <input type="number" class="form-input" value="1" min="0">
              </div>
              <div class="form-group">
                <div class="checkbox-group">
                  <input type="checkbox" class="checkbox-input" id="edit-reqCal" v-model="editForm.requiere_calibracion">
                  <label for="edit-reqCal" class="form-label" style="margin: 0;">Requiere Calibración</label>
                </div>
              </div>
              <div class="form-group" v-if="editForm.requiere_calibracion">
                <label class="form-label">Frecuencia Anual Calibración</label>
                <input type="number" class="form-input" value="1" min="0">
              </div>
              <div class="form-group" v-if="editForm.requiere_calibracion">
                <label class="form-label">Tipo de Calibración</label>
                <input type="text" class="form-input" value="Calificación">
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
                <input type="text" class="form-input" value="Temperatura">
              </div>
              <div class="form-group">
                <label class="form-label">Rango del Equipo</label>
                <input type="text" class="form-input" value="T -18">
              </div>
              <div class="form-group">
                <label class="form-label">Resolución</label>
                <input type="text" class="form-input" value="NI">
              </div>
              <div class="form-group">
                <label class="form-label">Rango de Trabajo</label>
                <input type="text" class="form-input" value="0 a -33°C">
              </div>
              <div class="form-group">
                <label class="form-label">Error Máximo Permitido</label>
                <input type="text" class="form-input" value="NI">
              </div>
            </div>
          </div>

          <!-- TAB 6: CONDICIONES -->
          <div v-show="activeTabEdit === 6" class="tab-content active">
            <h4 class="section-title">⚙️ G. Condiciones de Funcionamiento</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Voltaje</label>
                <input type="text" class="form-input" value="115 VAC">
              </div>
              <div class="form-group">
                <label class="form-label">Corriente</label>
                <input type="text" class="form-input" value="">
              </div>
              <div class="form-group">
                <label class="form-label">Humedad Relativa</label>
                <input type="text" class="form-input" value="">
              </div>
              <div class="form-group">
                <label class="form-label">Temperatura Funcionamiento</label>
                <input type="text" class="form-input" value="Max 38°C">
              </div>
              <div class="form-group">
                <label class="form-label">Dimensiones</label>
                <input type="text" class="form-input" value="53,5 x 53 x 142 cm">
              </div>
              <div class="form-group">
                <label class="form-label">Peso</label>
                <input type="text" class="form-input" value="55,5 kg">
              </div>
              <div class="form-group full-width">
                <label class="form-label">Otras Condiciones</label>
                <textarea class="form-textarea"></textarea>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeEditModal">Cancelar</button>
          <button class="btn btn-primary" @click="closeEditModal">💾 Guardar Cambios</button>
        </div>
      </div>
    </div>

    <!-- MODAL: DAR DE BAJA EQUIPO -->
    <div class="modal" :class="{ active: showDeleteModal }">
      <div class="modal-content" style="max-width: 600px;">
        <div class="modal-header">
          <div class="modal-title">⚠️ Dar de Baja Equipo</div>
          <button class="close-btn" @click="closeDeleteModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="alert alert-warning">
            <span style="font-size: 20px;">⚠️</span>
            <div><strong>Advertencia:</strong> Esta acción desactivará el equipo del inventario activo. El equipo quedará registrado en el historial pero no aparecerá en los reportes de equipos activos.</div>
          </div>

          <div class="info-box">
            <div class="info-box-title">Equipo a dar de baja</div>
            <p style="margin-top: 10px;"><strong>Código:</strong> <span id="baja-codigo">135306</span></p>
            <p><strong>Nombre:</strong> <span id="baja-nombre">Congelador</span></p>
            <p><strong>Marca/Modelo:</strong> <span id="baja-marca">Challenger CV430</span></p>
          </div>

          <div class="form-group full-width">
            <label class="form-label required">Motivo de la Baja</label>
            <textarea class="form-textarea" placeholder="Describa el motivo de la baja del equipo..." style="min-height: 120px;"></textarea>
          </div>

          <div class="password-group">
            <div style="font-weight: 600; color: #f44336; margin-bottom: 10px;">🔒 Autorización Requerida</div>
            <p style="font-size: 13px; color: #616161; margin-bottom: 15px;">Para confirmar esta acción, ingrese su contraseña:</p>
            <input type="password" class="form-input" placeholder="Contraseña">
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeDeleteModal">Cancelar</button>
          <button class="btn btn-danger" @click="closeDeleteModal">🗑️ Confirmar Baja</button>
        </div>
      </div>
    </div>

    <!-- MODAL: VALIDACIÓN DE CONTRASEÑA -->
    <div class="modal" :class="{ active: showPasswordModal }">
      <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
          <div class="modal-title">🔐 Verificación de Seguridad</div>
          <button class="close-btn" @click="closePasswordModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="password-group">
            <p style="margin-bottom: 15px; color: #616161; font-size: 14px;">
              Este campo es <strong>crítico para la integridad del sistema</strong>. Para modificarlo, ingrese su contraseña de administrador:
            </p>
            <div class="form-group">
              <label class="form-label required">Campo a modificar:</label>
              <input type="text" class="form-input" disabled :value="campoProtegido">
            </div>
            <div class="form-group">
              <label class="form-label required">Contraseña de Administrador:</label>
              <input type="password" class="form-input" placeholder="Ingrese su contraseña">
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closePasswordModal">Cancelar</button>
          <button class="btn btn-danger" @click="closePasswordModal">🔓 Desbloquear Campo</button>
        </div>
      </div>
    </div>

    <!-- MODAL: CONFIRMACIÓN -->
    <div class="modal" :class="{ active: showConfirmModal }">
      <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
          <div class="modal-title">✅ Operación Exitosa</div>
          <button class="close-btn" @click="closeConfirmModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="alert alert-success" style="cursor: default;">
            <span style="font-size: 48px;">✅</span>
            <div style="font-size: 16px;">La operación se completó correctamente.</div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-primary" @click="closeConfirmModal">Aceptar</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Estilos copiados y adaptados del Mockup */
.content-card { background: white; border-radius: 10px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 25px; }

/* Search Section */
.search-section {
  position: relative;
  flex: 1;
}

.search-input {
  width: 100%;
  padding: 14px 18px;
  padding-right: 40px; /* Make room for clear button */
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #f5f5f5;
}

.search-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
  background: white;
}

.clear-search-btn {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #999;
  font-size: 18px;
  cursor: pointer;
  padding: 5px 8px;
  border-radius: 4px;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.clear-search-btn:hover {
  color: #006633;
  background: rgba(0, 102, 51, 0.1);
}
.search-filter-container { display: flex; gap: 20px; margin-bottom: 25px; align-items: center; }
.search-section { flex: 1; }
.search-input { 
  width: 100%; 
  padding: 14px 18px; 
  border: 2px solid #e0e0e0; 
  border-radius: 8px; 
  font-size: 14px;
  transition: all 0.3s ease;
  background: #f5f5f5;
}
.search-input:focus { 
  outline: none; 
  border-color: #006633; 
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
  background: white;
}
.filter-button { 
  padding: 14px 24px; 
  background: white; 
  border: 2px solid #006633; 
  color: #006633; 
  border-radius: 8px; 
  cursor: pointer; 
  font-weight: 600; 
  font-size: 14px;
  display: flex; 
  align-items: center; 
  gap: 8px; 
  transition: all 0.3s ease;
  white-space: nowrap;
}
.filter-button:hover { 
  background: #006633; 
  color: white; 
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.2);
}

/* Button Styles */
.page-title { font-size: 28px; color: #006633; font-weight: 600; margin-bottom: 30px; }
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-sm { padding: 8px 16px; font-size: 13px; }
.btn-info { background: #00a99d; color: white; }
.btn-secondary { background: #e0e0e0; }
.btn-danger { background: #f44336; color: white; }
.btn-success { background: #4CAF50; color: white; }
.btn-warning { background: #ff9800; color: white; }

.btn-ver {
  background: #00a99d;
  transition: all 0.3s ease;
}

.btn-ver:hover {
  background: #008f85;
}

.btn-ver-active {
  background: #006633 !important;
  color: white !important;
}

.btn-ver-active:hover {
  background: #005028 !important;
}

table { 
  width: 100%; 
  border-collapse: collapse; 
  table-layout: fixed;
}
thead { background: linear-gradient(135deg, #006633 0%, #2d5016 100%); color: white; }

th { 
  padding: 15px; 
  text-align: center; 
  font-size: 13px; 
  text-transform: uppercase;
  white-space: nowrap;
}

td { 
  padding: 15px; 
  border-bottom: 1px solid #e0e0e0; 
  font-size: 14px; 
}

tbody tr {
  background: white;
  transition: all 0.2s;
}

tbody tr:hover { 
  background: rgba(0, 102, 51, 0.08); 
}

tbody tr[data-equipo] { cursor: pointer; transition: all 0.2s; position: relative; }
tbody tr[data-equipo]:hover td:first-child { font-weight: 600; }
tbody tr.row-active { background: rgba(0,102,51,0.12); border-left: 4px solid #006633; }

/* INVIMA Badge Styling - Copied from EquiposPendientes */
.invima-badge {
  font-size: 11px;
  padding: 3px 8px;
  background: rgba(0, 102, 51, 0.1);
  color: #006633;
  border-radius: 20px;
  font-weight: 600;
  display: block;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.invima-box-detail {
  font-size: 11px;
  padding: 3px 8px;
  background: rgba(0, 102, 51, 0.1);
  color: #006633;
  border-radius: 20px;
  font-weight: 600;
  min-width: 120px;
  display: inline-block;
  text-align: center;
}

/* Risk Box Styling */
.risk-box {
  display: inline-block;
  padding: 4px 12px;
  background: #e8e8e8;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  color: #333;
}

.risk-box.badge-danger { background: #ffe0e0; color: #d32f2f; }
.risk-box.badge-warning { background: #fff3e0; color: #f57c00; }
.risk-box.badge-success { background: #e8f5e9; color: #388e3c; }
.risk-box.badge-secondary { background: #e8e8e8; color: #666; }

/* Estado Badge Styling */
.estado-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 11px;
  font-weight: 600;
  text-align: center;
  min-width: 100px;
}

.estado-activo {
  background: rgba(76, 175, 80, 0.15);
  color: #2e7d32;
}

.estado-mantenimiento {
  background: rgba(244, 67, 54, 0.15);
  color: #c62828;
}

.estado-baja {
  background: rgba(158, 158, 158, 0.15);
  color: #616161;
}

.estado-inactivo {
  background: rgba(255, 152, 0, 0.15);
  color: #e65100;
}

.badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
.badge-success { background: rgba(76, 175, 80, 0.1); color: #4CAF50; }
.badge-danger { background: rgba(244, 67, 54, 0.1); color: #f44336; }
.badge-warning { background: rgba(255, 152, 0, 0.1); color: #ff9800; }
.badge-secondary { background: rgba(158, 158, 158, 0.1); color: #666; }

/* Skeleton Loader - Table Style */
.skeleton-table table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}

.skeleton-table thead {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
}

.skeleton-table th {
  padding: 15px;
  text-align: center;
  font-size: 13px;
  text-transform: uppercase;
  white-space: nowrap;
}

.skeleton-table td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
}

.skeleton-text {
  height: 16px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 4px;
  width: 80%;
  margin: 0 auto;
}

.skeleton-badge {
  width: 60%;
  height: 24px;
  border-radius: 20px;
}

.skeleton-small {
  width: 40%;
}

.skeleton-buttons {
  width: 70%;
  height: 32px;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* Document Inventory Grid */
.documentos-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px 20px;
  margin-top: 15px;
}

.documento-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.check-icon {
  font-size: 16px;
  flex-shrink: 0;
}

.x-icon {
  font-size: 16px;
  flex-shrink: 0;
}

/* Detalle Row Styles */
.detalle-row { display: none; }
.detalle-row.active { display: table-row; }
.detalle-cell { padding: 0 !important; background: #f9f9f9; border-bottom: 3px solid #006633 !important; }
.detalle-container { padding: 30px; animation: slideDown 0.3s ease; position: relative; }
@keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
.detalle-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #e0e0e0; }
.detalle-title { font-size: 20px; color: #006633; font-weight: 600; }
.detalle-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #e0e0e0; padding-bottom: 0; }
.detalle-tab { padding: 12px 20px; cursor: pointer; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: all 0.3s; font-weight: 500; background: white; border-radius: 8px 8px 0 0; }
.detalle-tab:hover { background: #f5f5f5; color: #006633; }
.detalle-tab.active { color: #006633; border-bottom-color: #006633; font-weight: 600; background: #f9f9f9; }
.detalle-content { display: none; }
.detalle-content.active { display: block; }
.detalle-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
.detalle-section { background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #006633; }
.detalle-section-title { font-size: 16px; color: #006633; font-weight: 600; margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px; }
.detalle-item { display: flex; margin-bottom: 10px; font-size: 14px; }
.detalle-label { font-weight: 600; color: #616161; min-width: 180px; }
.detalle-value { color: #212121; }

/* Pagination Styles */
.pagination-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.items-per-page {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: #616161;
}

.page-select {
  padding: 5px;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  background: #f5f5f5;
  color: #212121;
  font-weight: 500;
}

.page-select:hover {
  background: #e8e8e8;
  border-color: #a0a0a0;
}

.page-navigation {
  display: flex;
  align-items: center;
  gap: 15px;
}

.page-btn {
  padding: 6px 12px;
  border: 1px solid #c0c0c0;
  background: #e8e8e8;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  color: #212121;
  font-weight: 500;
  transition: all 0.2s;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background: #f0f0f0;
}

.page-btn:not(:disabled):hover {
  background: #d0d0d0;
  border-color: #006633;
  color: #006633;
}

.page-info {
  font-size: 14px;
  color: #616161;
  display: flex;
  align-items: center;
  gap: 8px;
}

.page-input {
  width: 50px;
  padding: 4px;
  text-align: center;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  background: #f5f5f5;
  color: #212121;
  font-weight: 600;
}

.page-input:focus {
  outline: none;
  border-color: #006633;
  background: white;
}

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

/* Form Styles */
.form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.form-group { margin-bottom: 12px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-label { display: block; margin-bottom: 4px; font-weight: 600; font-size: 13px; color: #212121; }
.form-label.required::after { content: " *"; color: #f44336; }
.form-input, .form-select, .form-textarea { width: 100%; padding: 8px 12px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-family: inherit; transition: border-color 0.3s; }
.form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: #006633; box-shadow: 0 0 0 3px rgba(0,102,51,0.1); }
.form-input:disabled, .form-select:disabled, .form-textarea:disabled { background: #f5f5f5; color: #616161; cursor: not-allowed; }
.form-input.locked { background: #fff9e6; border-color: #ff9800; }
.form-input.locked::placeholder { color: #ff9800; }
.form-textarea { resize: vertical; min-height: 80px; }
.checkbox-group { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
.checkbox-input { width: 18px; height: 18px; cursor: pointer; }

/* Other Styles */
.section-divider { margin: 15px 0; padding-top: 15px; border-top: 2px solid #e0e0e0; }
.section-title { font-size: 18px; color: #006633; font-weight: 600; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; }
.info-box { background: rgba(0,102,51,0.05); border-left: 4px solid #006633; padding: 15px; border-radius: 4px; margin-bottom: 12px; }
.info-box-title { font-weight: 600; color: #006633; margin-bottom: 8px; }
.edit-note { background: rgba(0,169,157,0.1); padding: 10px 15px; border-radius: 6px; border-left: 3px solid #00a99d; margin-bottom: 20px; font-size: 13px; color: #616161; }
.lock-icon { display: inline-block; margin-left: 5px; color: #ff9800; font-size: 12px; }
.password-group { background: rgba(244,67,54,0.05); padding: 20px; border-radius: 8px; border: 2px solid #f44336; margin-top: 15px; }
.alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; cursor: pointer; transition: all 0.3s; }
.alert-warning { background: rgba(255, 152, 0, 0.1); color: #ff9800; border-left: 4px solid #ff9800; }
.alert-success { background: rgba(76, 175, 80, 0.1); color: #4CAF50; border-left: 4px solid #4CAF50; }

/* Tabla de Mantenimientos */
.tabla-mantenimientos {
  width: 100%;
  margin-top: 10px;
  border-collapse: collapse;
}

.tabla-mantenimientos thead tr th {
  background: #006633 !important;
  color: white !important;
}

.tabla-mantenimientos th {
  padding: 15px !important;
  text-align: center !important;
  font-size: 13px !important;
  text-transform: uppercase !important;
  color: white !important;
}

.tabla-mantenimientos td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
  text-align: center;
}

.tabla-mantenimientos tbody tr {
  background: white;
  transition: all 0.2s;
}

.tabla-mantenimientos tbody tr:hover {
  background: rgba(0, 102, 51, 0.08);
}
</style>
