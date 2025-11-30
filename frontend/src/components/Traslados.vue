<script setup>
import { ref, onMounted, computed } from 'vue'

const traslados = ref([])
const loading = ref(true)
const error = ref(null)
const searchQuery = ref('')

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [10, 20, 50, 100]

// Filter Panel State
const showFilterPanel = ref(false)

// Filter State
const filtros = ref({
  sedes_origen: [],
  sedes_destino: [],
  servicios_origen: [],
  servicios_destino: [],
  usuarios: [],
  fecha_desde: '',
  fecha_hasta: ''
})

const ordenamiento = ref('fecha-desc')


// Modal state
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const selectedTraslado = ref(null)
const editForm = ref({
  equipo: null,
  fecha_traslado: '',
  sede_origen: null,
  servicio_origen: null,
  sede_destino: null,
  servicio_destino: null,
  justificacion: '',
  usuario_registro: ''
})

// Catalogs
const equipos = ref([])
const sedes = ref([])
const ubicaciones = ref([])

const fetchTraslados = async () => {
  loading.value = true
  try {
    const response = await fetch('http://127.0.0.1:8000/api/traslados/')
    if (!response.ok) throw new Error('Error al cargar el historial de traslados')
    traslados.value = await response.json()
  } catch (err) {
    error.value = err.message
    console.error(err)
  } finally {
    loading.value = false
  }
}

const fetchCatalogs = async () => {
  try {
    const [equiposRes, sedesRes, ubicacionesRes] = await Promise.all([
      fetch('http://127.0.0.1:8000/api/equipos/'),
      fetch('http://127.0.0.1:8000/api/sedes/'),
      fetch('http://127.0.0.1:8000/api/ubicaciones/')
    ])
    
    if (equiposRes.ok) equipos.value = await equiposRes.json()
    if (sedesRes.ok) sedes.value = await sedesRes.json()
    if (ubicacionesRes.ok) ubicaciones.value = await ubicacionesRes.json()
  } catch (err) {
    console.error('Error cargando catálogos:', err)
  }
}


// Get unique values for filters
const sedesOrigenUnicas = computed(() => {
  const sedesOrigen = traslados.value
    .map(t => ({ id: t.sede_origen, nombre: t.sede_origen_nombre }))
    .filter((sede, index, self) => sede.id && sede.nombre && 
      self.findIndex(s => s.id === sede.id) === index)
  return sedesOrigen.sort((a, b) => a.nombre.localeCompare(b.nombre))
})

const sedesDestinoUnicas = computed(() => {
  const sedesDestino = traslados.value
    .map(t => ({ id: t.sede_destino, nombre: t.sede_destino_nombre }))
    .filter((sede, index, self) => sede.id && sede.nombre && 
      self.findIndex(s => s.id === sede.id) === index)
  return sedesDestino.sort((a, b) => a.nombre.localeCompare(b.nombre))
})

const serviciosOrigenUnicos = computed(() => {
  const serviciosOrigen = traslados.value
    .map(t => ({ id: t.servicio_origen, nombre: t.servicio_origen_nombre }))
    .filter((servicio, index, self) => servicio.id && servicio.nombre && 
      self.findIndex(s => s.id === servicio.id) === index)
  return serviciosOrigen.sort((a, b) => a.nombre.localeCompare(b.nombre))
})

const serviciosDestinoUnicos = computed(() => {
  const serviciosDestino = traslados.value
    .map(t => ({ id: t.servicio_destino, nombre: t.servicio_destino_nombre }))
    .filter((servicio, index, self) => servicio.id && servicio.nombre && 
      self.findIndex(s => s.id === servicio.id) === index)
  return serviciosDestino.sort((a, b) => a.nombre.localeCompare(b.nombre))
})

const usuariosUnicos = computed(() => {
  const usuarios = [...new Set(traslados.value.map(t => t.usuario_registro))].filter(Boolean)
  return usuarios.sort()
})

const filteredTraslados = computed(() => {
  let result = traslados.value

  // Filtro por búsqueda
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(t => 
      (t.equipo_codigo && t.equipo_codigo.toLowerCase().includes(query)) ||
      (t.equipo_nombre && t.equipo_nombre.toLowerCase().includes(query)) ||
      (t.equipo_marca && t.equipo_marca.toLowerCase().includes(query)) ||
      (t.equipo_modelo && t.equipo_modelo.toLowerCase().includes(query))
    )
  }

  // Filtro por sedes origen
  if (filtros.value.sedes_origen.length > 0) {
    result = result.filter(t => filtros.value.sedes_origen.some(s => s.id === t.sede_origen))
  }

  // Filtro por sedes destino
  if (filtros.value.sedes_destino.length > 0) {
    result = result.filter(t => filtros.value.sedes_destino.some(s => s.id === t.sede_destino))
  }

  // Filtro por servicios origen
  if (filtros.value.servicios_origen.length > 0) {
    result = result.filter(t => filtros.value.servicios_origen.some(s => s.id === t.servicio_origen))
  }

  // Filtro por servicios destino
  if (filtros.value.servicios_destino.length > 0) {
    result = result.filter(t => filtros.value.servicios_destino.some(s => s.id === t.servicio_destino))
  }

  // Filtro por usuarios
  if (filtros.value.usuarios.length > 0) {
    result = result.filter(t => filtros.value.usuarios.includes(t.usuario_registro))
  }

  // Filtro por rango de fechas
  if (filtros.value.fecha_desde) {
    result = result.filter(t => t.fecha_traslado >= filtros.value.fecha_desde)
  }
  if (filtros.value.fecha_hasta) {
    result = result.filter(t => t.fecha_traslado <= filtros.value.fecha_hasta)
  }

  // Ordenamiento
  switch (ordenamiento.value) {
    case 'fecha-desc':
      result.sort((a, b) => new Date(b.fecha_traslado) - new Date(a.fecha_traslado))
      break
    case 'fecha-asc':
      result.sort((a, b) => new Date(a.fecha_traslado) - new Date(b.fecha_traslado))
      break
    case 'equipo-asc':
      result.sort((a, b) => (a.equipo_nombre || '').localeCompare(b.equipo_nombre || ''))
      break
    case 'equipo-desc':
      result.sort((a, b) => (b.equipo_nombre || '').localeCompare(a.equipo_nombre || ''))
      break
  }

  return result
})

// Pagination computed properties
const totalPages = computed(() => Math.ceil(filteredTraslados.value.length / itemsPerPage.value))

const paginatedTraslados = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredTraslados.value.slice(start, end)
})

// Pagination methods
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}


// Filter methods
function toggleFilterPanel() {
  showFilterPanel.value = !showFilterPanel.value
}

function toggleSedeOrigenFilter(sede) {
  const index = filtros.value.sedes_origen.findIndex(s => s.id === sede.id)
  if (index > -1) {
    filtros.value.sedes_origen.splice(index, 1)
  } else {
    filtros.value.sedes_origen.push(sede)
  }
  currentPage.value = 1
}

function toggleSedeDestinoFilter(sede) {
  const index = filtros.value.sedes_destino.findIndex(s => s.id === sede.id)
  if (index > -1) {
    filtros.value.sedes_destino.splice(index, 1)
  } else {
    filtros.value.sedes_destino.push(sede)
  }
  currentPage.value = 1
}

function toggleServicioOrigenFilter(servicio) {
  const index = filtros.value.servicios_origen.findIndex(s => s.id === servicio.id)
  if (index > -1) {
    filtros.value.servicios_origen.splice(index, 1)
  } else {
    filtros.value.servicios_origen.push(servicio)
  }
  currentPage.value = 1
}

function toggleServicioDestinoFilter(servicio) {
  const index = filtros.value.servicios_destino.findIndex(s => s.id === servicio.id)
  if (index > -1) {
    filtros.value.servicios_destino.splice(index, 1)
  } else {
    filtros.value.servicios_destino.push(servicio)
  }
  currentPage.value = 1
}

function toggleUsuarioFilter(usuario) {
  const index = filtros.value.usuarios.indexOf(usuario)
  if (index > -1) {
    filtros.value.usuarios.splice(index, 1)
  } else {
    filtros.value.usuarios.push(usuario)
  }
  currentPage.value = 1
}

function borrarTodosFiltros() {
  filtros.value.sedes_origen = []
  filtros.value.sedes_destino = []
  filtros.value.servicios_origen = []
  filtros.value.servicios_destino = []
  filtros.value.usuarios = []
  filtros.value.fecha_desde = ''
  filtros.value.fecha_hasta = ''
  ordenamiento.value = 'fecha-desc'
  currentPage.value = 1
}

const filtrosActivos = computed(() => {
  let count = filtros.value.sedes_origen.length + filtros.value.sedes_destino.length + 
              filtros.value.servicios_origen.length + filtros.value.servicios_destino.length +
              filtros.value.usuarios.length
  if (filtros.value.fecha_desde) count++
  if (filtros.value.fecha_hasta) count++
  return count
})

const formatFecha = (fecha) => {
  if (!fecha) return 'N/A'
  const date = new Date(fecha)
  return date.toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric' })
}

// Modal methods
// Modal methods
const showCreateModal = ref(false)
const createForm = ref({
  equipo: null,
  fecha_traslado: new Date().toISOString().split('T')[0],
  sede_origen: null,
  servicio_origen: null,
  sede_destino: null,
  servicio_destino: null,
  justificacion: '',
  usuario_registro: ''
})

// Search state
const equipoSearchTerm = ref('')
const equiposFound = ref([])
const showEquipoDropdown = ref(false)
const isSearching = ref(false)
let searchTimeout = null

const searchEquipos = async () => {
  isSearching.value = true
  showEquipoDropdown.value = true

  if (searchTimeout) clearTimeout(searchTimeout)

  searchTimeout = setTimeout(async () => {
    try {
      const query = equipoSearchTerm.value || ''
      const response = await fetch(`http://127.0.0.1:8000/api/equipos/?busqueda=${encodeURIComponent(query)}`)
      if (response.ok) {
        equiposFound.value = await response.json()
      }
    } catch (err) {
      console.error('Error buscando equipos:', err)
    } finally {
      isSearching.value = false
    }
  }, 300) // Debounce 300ms
}

const toggleDropdown = () => {
  if (showEquipoDropdown.value) {
    showEquipoDropdown.value = false
  } else {
    searchEquipos()
  }
}

const selectEquipo = (equipo) => {
  createForm.value.equipo = equipo.id
  equipoSearchTerm.value = `${equipo.nombre_equipo} - ${equipo.codigo_interno}`
  showEquipoDropdown.value = false
  
  // Auto-fill origin if available (optional enhancement)
  if (equipo.sede) createForm.value.sede_origen = equipo.sede
  if (equipo.servicio) createForm.value.servicio_origen = equipo.servicio
}

const openCreateModal = () => {
  createForm.value = {
    equipo: null,
    fecha_traslado: new Date().toISOString().split('T')[0],
    sede_origen: null,
    servicio_origen: null,
    sede_destino: null,
    servicio_destino: null,
    justificacion: '',
    usuario_registro: ''
  }
  equipoSearchTerm.value = ''
  equiposFound.value = []
  showEquipoDropdown.value = false
  showCreateModal.value = true
}

const closeCreateModal = () => {
  showCreateModal.value = false
}

const submitCreateForm = async () => {
  // Implement create logic here
  console.log('Create form submitted', createForm.value)
  closeCreateModal()
}

const openEditModal = (traslado) => {
  selectedTraslado.value = traslado
  editForm.value = { ...traslado }
  showEditModal.value = true
}

const closeEditModal = () => {
  showEditModal.value = false
  selectedTraslado.value = null
  editForm.value = {
    equipo: null,
    fecha_traslado: '',
    sede_origen: null,
    servicio_origen: null,
    sede_destino: null,
    servicio_destino: null,
    justificacion: '',
    usuario_registro: ''
  }
}

const submitEditForm = async () => {
  // Implement edit logic here
  console.log('Edit form submitted', editForm.value)
  closeEditModal()
}

const openDeleteModal = (traslado) => {
  selectedTraslado.value = traslado
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  selectedTraslado.value = null
}

const confirmDelete = async () => {
  // Implement delete logic here
  console.log('Delete confirmed for', selectedTraslado.value)
  closeDeleteModal()
}

onMounted(() => {
  fetchTraslados()
  fetchCatalogs()
})
</script>

<template>
  <div id="traslados-page">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Historial de Traslados</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Traslados / Historial</div>
      </div>
      <button class="btn btn-primary" @click="openCreateModal">➕ Nuevo Traslado</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            class="search-input" 
            placeholder="🔍 Buscar por código, nombre, marca o modelo..." 
            v-model="searchQuery"
          >
        </div>
        <button class="filter-button" @click="toggleFilterPanel">
          ☰ Filtrar y Ordenar
          <span v-if="filtrosActivos > 0" class="filter-badge">{{ filtrosActivos }}</span>
        </button>
      </div>

      <!-- Skeleton Loader -->
      <div v-if="loading" class="skeleton-table">
        <table>
          <thead>
            <tr>
              <th style="width: 10%; text-align: center;">Código</th>
              <th style="width: 15%; text-align: center;">Equipo</th>
              <th style="width: 12%; text-align: center;">Origen</th>
              <th style="width: 3%; text-align: center;"></th>
              <th style="width: 12%; text-align: center;">Destino</th>
              <th style="width: 18%; text-align: center;">Justificación</th>
              <th style="width: 10%; text-align: center;">Fecha</th>
              <th style="width: 10%; text-align: center;">Responsable</th>
              <th style="width: 10%; text-align: center;">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="i in 8" :key="i">
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text skeleton-buttons"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>
      
      <table v-else id="trasladosTable">
        <thead>
          <tr>
            <th style="width: 10%; text-align: center;">Código</th>
            <th style="width: 15%; text-align: center;">Equipo</th>
            <th style="width: 12%; text-align: center;">Origen</th>
            <th style="width: 3%; text-align: center;"></th>
            <th style="width: 12%; text-align: center;">Destino</th>
            <th style="width: 18%; text-align: center;">Justificación</th>
            <th style="width: 10%; text-align: center;">Fecha</th>
            <th style="width: 10%; text-align: center;">Responsable</th>
            <th style="width: 10%; text-align: center;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="traslado in paginatedTraslados" :key="traslado.id">
            <td><strong>{{ traslado.equipo_codigo }}</strong></td>
            <td>
              <div style="font-weight: 600; color: #212121;">{{ traslado.equipo_nombre }}</div>
              <div style="font-size: 11px; color: #616161;">{{ traslado.equipo_marca }} - {{ traslado.equipo_modelo }}</div>
            </td>
            <td>
              <div style="font-weight: 600; font-size: 14px; color: #212121;">{{ traslado.sede_origen_nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ traslado.servicio_origen_nombre || 'N/A' }}</div>
            </td>
            <td style="text-align: center; color: #006633; font-size: 20px;">
              ➝
            </td>
            <td>
              <div style="font-weight: 600; font-size: 14px; color: #212121;">{{ traslado.sede_destino_nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ traslado.servicio_destino_nombre || 'N/A' }}</div>
            </td>
            <td>{{ traslado.justificacion }}</td>
            <td>{{ formatFecha(traslado.fecha_traslado) }}</td>
            <td style="text-align: center;">
              <div style="font-weight: 600; color: #006633;">{{ traslado.usuario_registro || 'N/A' }}</div>
            </td>
            <td>
              <div style="display: flex; gap: 5px; justify-content: center;">
                <button class="btn btn-secondary btn-sm" title="Editar" @click="openEditModal(traslado)">✏️</button>
                <button class="btn btn-danger btn-sm" title="Eliminar" @click="openDeleteModal(traslado)">🗑️</button>
              </div>
            </td>
          </tr>
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

    <!-- MODAL: CREAR TRASLADO -->
    <div class="modal" :class="{ active: showCreateModal }">
      <div class="modal-content" style="max-width: 600px;">
        <div class="modal-header">
          <h3 class="modal-title">➕ Registrar Nuevo Traslado</h3>
          <button class="close-btn" @click="closeCreateModal">×</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="submitCreateForm">
            <div class="form-group" style="position: relative;">
              <label class="form-label required">Equipo a Trasladar</label>
              <input 
                type="text" 
                v-model="equipoSearchTerm" 
                @input="searchEquipos"
                @click="toggleDropdown"
                class="form-input" 
                placeholder="Escribe nombre o código del equipo..."
              >
              
              <!-- Dropdown de resultados -->
              <div v-if="showEquipoDropdown" class="dropdown-results">
                <div v-if="isSearching" class="dropdown-item info">Buscando...</div>
                <div v-else-if="equiposFound.length === 0" class="dropdown-item info">No se encontraron equipos</div>
                <ul v-else class="dropdown-list">
                  <li 
                    v-for="equipo in equiposFound" 
                    :key="equipo.id" 
                    @click="selectEquipo(equipo)"
                    class="dropdown-item"
                  >
                    <strong>{{ equipo.nombre_equipo }}</strong> - {{ equipo.codigo_interno }}
                    <div style="font-size: 11px; color: #666;">{{ equipo.marca }} {{ equipo.modelo }}</div>
                  </li>
                </ul>
              </div>
            </div>

            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Fecha del Traslado</label>
                <input type="date" v-model="createForm.fecha_traslado" class="form-input">
              </div>
              <div class="form-group">
                <label class="form-label required">Responsable</label>
                <input type="text" v-model="createForm.usuario_registro" class="form-input" placeholder="Nombre del responsable">
              </div>
            </div>

            <div class="section-divider"></div>
            <h4 class="section-title">Origen</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Sede Origen</label>
                <select v-model="createForm.sede_origen" class="form-select">
                  <option :value="null" disabled>Seleccione sede...</option>
                  <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label required">Ubicación Origen</label>
                <select v-model="createForm.servicio_origen" class="form-select">
                  <option :value="null" disabled>Seleccione ubicación...</option>
                  <option v-for="ubicacion in ubicaciones" :key="ubicacion.id" :value="ubicacion.id">{{ ubicacion.nombre }}</option>
                </select>
              </div>
            </div>

            <div class="section-divider"></div>
            <h4 class="section-title">Destino</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label required">Sede Destino</label>
                <select v-model="createForm.sede_destino" class="form-select">
                  <option :value="null" disabled>Seleccione sede...</option>
                  <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label required">Ubicación Destino</label>
                <select v-model="createForm.servicio_destino" class="form-select">
                  <option :value="null" disabled>Seleccione ubicación...</option>
                  <option v-for="ubicacion in ubicaciones" :key="ubicacion.id" :value="ubicacion.id">{{ ubicacion.nombre }}</option>
                </select>
              </div>
            </div>

            <div class="form-group full-width" style="margin-top: 15px;">
              <label class="form-label required">Justificación</label>
              <textarea v-model="createForm.justificacion" class="form-textarea" rows="3" placeholder="Motivo del traslado..."></textarea>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeCreateModal">Cancelar</button>
          <button class="btn btn-primary" @click="submitCreateForm">Registrar Traslado</button>
        </div>
      </div>
    </div>

    <!-- MODAL: EDITAR TRASLADO -->
    <div class="modal" :class="{ active: showEditModal }">
      <div class="modal-content" style="max-width: 600px;">
        <div class="modal-header">
          <h3 class="modal-title">✏️ Editar Traslado</h3>
          <button class="close-btn" @click="closeEditModal">×</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="submitEditForm">
            <div class="form-group">
              <label class="form-label">Equipo</label>
              <input type="text" class="form-input locked" :value="selectedTraslado?.equipo_nombre" disabled>
            </div>

            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Fecha del Traslado</label>
                <input type="date" v-model="editForm.fecha_traslado" class="form-input">
              </div>
              <div class="form-group">
                <label class="form-label">Responsable</label>
                <input type="text" v-model="editForm.usuario_registro" class="form-input">
              </div>
            </div>

            <div class="section-divider"></div>
            <h4 class="section-title">Origen</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Sede Origen</label>
                <select v-model="editForm.sede_origen" class="form-select">
                  <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Ubicación Origen</label>
                <select v-model="editForm.servicio_origen" class="form-select">
                  <option v-for="ubicacion in ubicaciones" :key="ubicacion.id" :value="ubicacion.id">{{ ubicacion.nombre }}</option>
                </select>
              </div>
            </div>

            <div class="section-divider"></div>
            <h4 class="section-title">Destino</h4>
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Sede Destino</label>
                <select v-model="editForm.sede_destino" class="form-select">
                  <option v-for="sede in sedes" :key="sede.id" :value="sede.id">{{ sede.nombre }}</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Ubicación Destino</label>
                <select v-model="editForm.servicio_destino" class="form-select">
                  <option v-for="ubicacion in ubicaciones" :key="ubicacion.id" :value="ubicacion.id">{{ ubicacion.nombre }}</option>
                </select>
              </div>
            </div>

            <div class="form-group full-width" style="margin-top: 15px;">
              <label class="form-label">Justificación</label>
              <textarea v-model="editForm.justificacion" class="form-textarea" rows="3"></textarea>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeEditModal">Cancelar</button>
          <button class="btn btn-primary" @click="submitEditForm">Guardar Cambios</button>
        </div>
      </div>
    </div>

    <!-- MODAL: ELIMINAR TRASLADO -->
    <div class="modal" :class="{ active: showDeleteModal }">
      <div class="modal-content" style="max-width: 400px;">
        <div class="modal-header" style="background: #ffebee;">
          <h3 class="modal-title" style="color: #d32f2f;">🗑️ Eliminar Traslado</h3>
          <button class="close-btn" @click="closeDeleteModal">×</button>
        </div>
        <div class="modal-body" style="text-align: center; padding: 30px;">
          <p style="font-size: 16px; color: #616161; margin-bottom: 20px;">
            ¿Estás seguro de que deseas eliminar este registro de traslado?
          </p>
          <div style="background: #f5f5f5; padding: 15px; border-radius: 8px; text-align: left;">
            <div style="font-weight: 600; color: #212121;">{{ selectedTraslado?.equipo_nombre }}</div>
            <div style="font-size: 13px; color: #616161;">{{ formatFecha(selectedTraslado?.fecha_traslado) }}</div>
          </div>
          <p style="font-size: 13px; color: #f44336; margin-top: 20px;">
            ⚠️ Esta acción no se puede deshacer.
          </p>
        </div>
        <div class="modal-footer" style="justify-content: center;">
          <button class="btn btn-secondary" @click="closeDeleteModal">Cancelar</button>
          <button class="btn btn-danger" @click="confirmDelete">Sí, Eliminar</button>
        </div>
      </div>
    </div>
  </div>

    <!-- FILTER PANEL -->
    <div class="filtro-overlay" :class="{ active: showFilterPanel }" @click="showFilterPanel = false"></div>
    <div class="filtro-panel" :class="{ active: showFilterPanel }">
      <div class="filtro-header">
        <h3>FILTRAR Y ORDENAR</h3>
        <button class="borrar-todo" @click="borrarTodosFiltros">Borrar todo</button>
      </div>

      <div class="filtro-body">
        <!-- Ordenar por -->
        <div class="filtro-section">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Ordenar por
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="fecha-desc">
              <span>Fecha (Más reciente)</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="fecha-asc">
              <span>Fecha (Más antiguo)</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="equipo-asc">
              <span>Equipo (A-Z)</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="equipo-desc">
              <span>Equipo (Z-A)</span>
            </label>
          </div>
        </div>

        <!-- Sede Origen -->
        <div class="filtro-section" v-if="sedesOrigenUnicas.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Sede Origen
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="sede in sedesOrigenUnicas" :key="sede.id">
              <input 
                type="checkbox" 
                :checked="filtros.sedes_origen.some(s => s.id === sede.id)"
                @change="toggleSedeOrigenFilter(sede)"
              >
              <span>{{ sede.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Sede Destino -->
        <div class="filtro-section" v-if="sedesDestinoUnicas.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Sede Destino
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="sede in sedesDestinoUnicas" :key="sede.id">
              <input 
                type="checkbox" 
                :checked="filtros.sedes_destino.some(s => s.id === sede.id)"
                @change="toggleSedeDestinoFilter(sede)"
              >
              <span>{{ sede.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Servicio Origen -->
        <div class="filtro-section" v-if="serviciosOrigenUnicos.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Servicio Origen
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="servicio in serviciosOrigenUnicos" :key="servicio.id">
              <input 
                type="checkbox" 
                :checked="filtros.servicios_origen.some(s => s.id === servicio.id)"
                @change="toggleServicioOrigenFilter(servicio)"
              >
              <span>{{ servicio.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Servicio Destino -->
        <div class="filtro-section" v-if="serviciosDestinoUnicos.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Servicio Destino
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="servicio in serviciosDestinoUnicos" :key="servicio.id">
              <input 
                type="checkbox" 
                :checked="filtros.servicios_destino.some(s => s.id === servicio.id)"
                @change="toggleServicioDestinoFilter(servicio)"
              >
              <span>{{ servicio.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Usuario que Registró -->
        <div class="filtro-section" v-if="usuariosUnicos.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Registrado Por
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="usuario in usuariosUnicos" :key="usuario">
              <input 
                type="checkbox" 
                :checked="filtros.usuarios.includes(usuario)"
                @change="toggleUsuarioFilter(usuario)"
              >
              <span>{{ usuario }}</span>
            </label>
          </div>
        </div>

        <!-- Rango de Fechas -->
        <div class="filtro-section">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Rango de Fechas
            <span class="arrow">▼</span>
          </button>
          <div class="filtro-content">
            <div class="form-group" style="margin-bottom: 10px;">
              <label style="font-size: 13px; color: #616161; margin-bottom: 5px; display: block;">Desde:</label>
              <input type="date" v-model="filtros.fecha_desde" class="form-input" style="font-size: 13px;">
            </div>
            <div class="form-group">
              <label style="font-size: 13px; color: #616161; margin-bottom: 5px; display: block;">Hasta:</label>
              <input type="date" v-model="filtros.fecha_hasta" class="form-input" style="font-size: 13px;">
            </div>
          </div>
        </div>
      </div>

      <div class="filtro-footer">
        <p>{{ filteredTraslados.length }} traslados encontrados</p>
      </div>
    </div>
</template>

<style scoped>
.content-card {
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
  padding: 25px;
}

.search-filter-container {
  display: flex;
  justify-content: space-between;
  margin-bottom: 25px;
  gap: 15px;
}

.search-section {
  flex: 1;
  position: relative;
}

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
  background: white;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

/* Button Styles */
.page-title { font-size: 28px; color: #006633; font-weight: 700; margin-bottom: 30px; }
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-sm { padding: 6px 10px; font-size: 13px; }
.btn-secondary { background: #e0e0e0; }
.btn-secondary:hover { background: #d0d0d0; }
.btn-danger { background: #f44336; color: white; }
.btn-danger:hover { background: #d32f2f; }

table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}

th {
  text-align: left;
  padding: 15px;
  color: white;
  font-weight: 600;
  border-bottom: 2px solid #f0f0f0;
  font-size: 13px;
  text-transform: uppercase;
  background: #006633;
}

td {
  padding: 15px;
  border-bottom: 1px solid #f0f0f0;
  vertical-align: middle;
  color: #333;
  font-size: 14px;
  word-wrap: break-word;
}

tr:hover {
  background-color: #f9f9f9;
}

/* Pagination Styles */
.pagination-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.items-per-page {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #616161;
  font-size: 14px;
}

.page-select {
  padding: 5px 10px;
  border: 1px solid #e0e0e0;
  border-radius: 5px;
  color: #333;
}

.page-navigation {
  display: flex;
  align-items: center;
  gap: 15px;
}

.page-btn {
  padding: 8px 15px;
  border: 1px solid #e0e0e0;
  background: white;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.2s;
  color: #616161;
}

.page-btn:hover:not(:disabled) {
  background: #f5f5f5;
  color: #006633;
  border-color: #006633;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  color: #616161;
  font-size: 14px;
}

.page-input {
  width: 40px;
  padding: 5px;
  border: 1px solid #e0e0e0;
  border-radius: 5px;
  text-align: center;
}

/* Skeleton Styles */
.skeleton-table {
  width: 100%;
}

.skeleton-text {
  height: 15px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 4px;
}

.skeleton-buttons {
  width: 70%;
  height: 32px;
  margin: 0 auto;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
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

/* Dropdown Styles */
.dropdown-results {
  position: absolute;
  top: 100%;
  left: 0;
  width: 100%;
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 0 0 6px 6px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  z-index: 100;
  max-height: 200px;
  overflow-y: auto;
}

.dropdown-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.dropdown-item {
  padding: 10px 15px;
  cursor: pointer;
  border-bottom: 1px solid #f0f0f0;
  transition: background 0.2s;
}

.dropdown-item:last-child {
  border-bottom: none;
}

.dropdown-item:hover {
  background: #f5f5f5;
  color: #006633;
}

.dropdown-item.info {
  color: #666;
  font-style: italic;
  cursor: default;
  text-align: center;
}

/* FILTER PANEL STYLES */
.search-filter-container { 
  display: flex; 
  gap: 20px; 
  margin-bottom: 25px; 
  align-items: center; 
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
  position: relative;
}

.filter-button:hover { 
  background: #006633; 
  color: white; 
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.2);
}

.filter-badge {
  background: #006633;
  color: white;
  border-radius: 50%;
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
}

.filter-button:hover .filter-badge {
  background: white;
  color: #006633;
}

.filtro-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  z-index: 998;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
}

.filtro-overlay.active {
  opacity: 1;
  visibility: visible;
}

.filtro-panel {
  position: fixed;
  top: 0;
  right: -400px;
  width: 400px;
  height: 100vh;
  background: white;
  box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
  z-index: 999;
  transition: right 0.3s ease;
  display: flex;
  flex-direction: column;
}

.filtro-panel.active {
  right: 0;
}

.filtro-header {
  padding: 25px;
  border-bottom: 2px solid #e0e0e0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(90deg, rgba(0, 102, 51, 0.05) 0%, transparent 100%);
}

.filtro-header h3 {
  font-size: 18px;
  color: #006633;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.borrar-todo {
  background: none;
  border: none;
  color: #f44336;
  font-weight: 600;
  cursor: pointer;
  font-size: 14px;
  text-decoration: underline;
  padding: 5px 10px;
  border-radius: 4px;
  transition: all 0.2s;
}

.borrar-todo:hover {
  background: rgba(244, 67, 54, 0.1);
}

.filtro-body {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.filtro-section {
  margin-bottom: 20px;
  border-bottom: 1px solid #e0e0e0;
  padding-bottom: 15px;
}

.filtro-section:last-child {
  border-bottom: none;
}

.filtro-section-title {
  width: 100%;
  text-align: left;
  background: none;
  border: none;
  font-size: 15px;
  font-weight: 700;
  color: #212121;
  padding: 12px 0;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.filtro-section-title .arrow {
  transition: transform 0.3s;
  color: #006633;
  font-size: 12px;
}

.filtro-section-title.collapsed .arrow {
  transform: rotate(-90deg);
}

.filtro-section-title.collapsed + .filtro-content {
  display: none;
}

.filtro-content {
  padding-top: 10px;
}

.filtro-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  cursor: pointer;
  transition: background 0.2s;
  border-radius: 4px;
  padding-left: 10px;
}

.filtro-item:hover {
  background: rgba(0, 102, 51, 0.05);
}

.filtro-item input[type="checkbox"],
.filtro-item input[type="radio"] {
  margin-right: 12px;
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: #006633;
}

.filtro-item span {
  font-size: 14px;
  color: #424242;
}

.filtro-footer {
  padding: 20px 25px;
  border-top: 2px solid #e0e0e0;
  background: #f5f5f5;
}

.filtro-footer p {
  font-size: 14px;
  color: #616161;
  font-weight: 600;
  text-align: center;
}
</style>