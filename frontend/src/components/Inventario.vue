<script setup>
import { ref, onMounted, computed } from 'vue'
import { fetchEquipos, fetchEquipoDetalle, deleteEquipo } from '../services/api/equiposApi'
import EquipoCreateModal from './equipos/EquipoCreateModal.vue'
import EquipoEditModal from './equipos/EquipoEditModal.vue'

// State
const equipos = ref([])
const loading = ref(true)
const detailLoading = ref(false)
const error = ref(null)
const searchQuery = ref('')
const expandedEquipoId = ref(null)
const selectedEquipo = ref(null)
const activeTab = ref('info')

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [10, 20, 50, 100]

// Modal States
const showCreateModal = ref(false)
const showEditModal = ref(false)
const selectedEquipoForEdit = ref(null)

// Tabs for detail view
const tabs = {
  info: 'Información General',
  document os: 'Documentos',
  metrologia: 'Metrología',
  traslados: 'Historial Traslados',
  mantenimientos: 'Mantenimientos'
}

// ===== COMPUTED PROPERTIES =====
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

const totalPages = computed(() => Math.ceil(filteredEquipos.value.length / itemsPerPage.value))

const paginatedEquipos = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredEquipos.value.slice(start, end)
})

// ===== DATA FETCHING =====
const loadEquipos = async () => {
  loading.value = true
  error.value = null
  try {
    equipos.value = await fetchEquipos()
  } catch (err) {
    error.value = err.message
    console.error('Error fetching equipos:', err)
  } finally {
    loading.value = false
  }
}

const loadEquipoDetalle = async (id) => {
  detailLoading.value = true
  selectedEquipo.value = null
  try {
    selectedEquipo.value = await fetchEquipoDetalle(id)
  } catch (err) {
    console.error('Error fetching equipo detalle:', err)
    // Fallback to list item if fetch fails
    selectedEquipo.value = equipos.value.find(e => e.id === id)
  } finally {
    detailLoading.value = false
  }
}

// ===== UI HANDLERS =====
const toggleDetalle = (id) => {
  if (expandedEquipoId.value === id) {
    expandedEquipoId.value = null
    selectedEquipo.value = null
  } else {
    expandedEquipoId.value = id
    activeTab.value = 'info'
    loadEquipoDetalle(id)
  }
}

const setActiveTab = (tab) => {
  activeTab.value = tab
}

// Pagination
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

// ===== MODAL HANDLERS =====
const openCreateModal = () => {
  showCreateModal.value = true
}

const closeCreateModal = () => {
  showCreateModal.value = false
}

const handleCreateSuccess = () => {
  loadEquipos()
}

const openEditModal = (equipo) => {
  selectedEquipoForEdit.value = equipo
  showEditModal.value = true
}

const closeEditModal = () => {
  showEditModal.value = false
  selectedEquipoForEdit.value = null
}

const handleEditSuccess = () => {
  loadEquipos()
  // Refresh detail if currently viewing this equipo
  if (expandedEquipoId.value) {
    loadEquipoDetalle(expandedEquipoId.value)
  }
}

const handleDelete = async (equipo) => {
  if (!confirm(`¿Está seguro que desea eliminar el equipo "${equipo.nombre_equipo}"?`)) {
    return
  }
  
  try {
    await deleteEquipo(equipo.id)
    await loadEquipos()
    if (expandedEquipoId.value === equipo.id) {
      expandedEquipoId.value = null
      selectedEquipo.value = null
    }
  } catch (err) {
    console.error('Error deleting equipo:', err)
    alert('Error al eliminar el equipo. Puede que tenga relaciones activas.')
  }
}

// ===== UTILITY FUNCTIONS (EXACTAS DEL ORIGINAL) =====
const getRiesgoBadgeClass = (riesgo) => {
  if (!riesgo) return 'risk-box-secondary'
  if (riesgo === 'III' || riesgo === 'IIb') return 'risk-box-danger'
  if (riesgo === 'IIa') return 'risk-box-warning'
  return 'risk-box-success'
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

// Initialize
onMounted(() => {
  loadEquipos()
})
</script>

<template>
  <div id="equipos-page">
    <!-- Page Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Inventario de Equipos</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Equipos / Lista</div>
      </div>
      <button class="btn btn-primary" @click="openCreateModal">➕ Nuevo Equipo</button>
    </div>

    <!-- Main Content Card -->
    <div class="content-card">
      <!-- Search Bar -->
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
              <th style="width: 10%;">Sede / Servicio</th>
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

      <!-- Error State -->
      <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>

      <!-- Equipment Table -->
      <table v-else id="equiposTable">
        <thead>
          <tr>
            <th style="width: 7%;">Código</th>
            <th style="width: 19%;">Equipo</th>
            <th style="width: 18%;">Registro Invima</th>
            <th style="width: 6%; text-align: center;">Riesgo</th>
            <th style="width: 10%;">Sede / Servicio</th>
            <th style="width: 12%;">Encargado</th>
            <th style="width: 10%; text-align: center;">Estado</th>
            <th style="width: 18%;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="equipo in paginatedEquipos" :key="equipo.id">
            <!-- Main Row -->
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
                  <button class="btn btn-danger btn-sm" @click="handleDelete(equipo)">🗑️</button>
                </div>
              </td>
            </tr>

            <!-- Detail Row -->
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

                    <!-- Detail Tabs -->
                    <div class="detalle-tabs">
                      <div 
                        v-for="(label, key) in tabs" 
                        :key="key"
                        class="detalle-tab" 
                        :class="{ active: activeTab === key }"
                        @click="setActiveTab(key)"
                      >
                        {{ label }}
                      </div>
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
                          <div class="detalle-item"><span class="detalle-label">Servicio:</span><span class="detalle-value">{{ selectedEquipo.servicio_info?.nombre }}</span></div>
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
                      </div>
                    </div>

                    <!-- Tab Content: Traslados -->
                    <div v-show="activeTab === 'traslados'" class="detalle-content active">
                      <p v-if="!selectedEquipo.historial_traslados || selectedEquipo.historial_traslados.length === 0">
                        No hay historial de traslados disponible
                      </p>
                      <div v-else>
                        <!-- Display traslados here -->
                      </div>
                    </div>

                    <!-- Tab Content: Mantenimientos -->
                    <div v-show="activeTab === 'mantenimientos'" class="detalle-content active">
                      <p v-if="!selectedEquipo.historial_mantenimientos || selectedEquipo.historial_mantenimientos.length === 0">
                        No hay historial de mantenimientos disponible
                      </p>
                      <div v-else>
                        <!-- Display mantenimientos here -->
                      </div>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>

      <!-- Empty State -->
      <div v-if="!loading && filteredEquipos.length === 0" style="text-align: center; padding: 40px; color: #616161;">
        No se encontraron equipos
      </div>

      <!-- Pagination Footer -->
      <div v-if="!loading && filteredEquipos.length > 0" class="pagination-footer">
        <div class="items-per-page">
          <span>Mostrar</span>
          <select v-model.number="itemsPerPage" @change="currentPage = 1" class="page-select">
            <option v-for="option in itemsPerPageOptions" :key="option" :value="option">
              {{ option }}
            </option>
          </select>
          <span>registros</span>
        </div>
        
        <div class="page-navigation">
          <button class="page-btn" :disabled="currentPage === 1" @click="changePage(currentPage - 1)">Anterior</button>
          <span class="page-info">
            Página 
            <input type="number" v-model.number="currentPage" min="1" :max="totalPages" class="page-input" @change="changePage(currentPage)">
            de {{ totalPages }}
          </span>
          <button class="page-btn" :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">Siguiente</button>
        </div>
      </div>
    </div>

    <!-- Modals -->
    <EquipoCreateModal 
      :show="showCreateModal"
      @close="closeCreateModal"
      @success="handleCreateSuccess"
    />

    <EquipoEditModal 
      :show="showEditModal"
      :equipo="selectedEquipoForEdit"
      @close="closeEditModal"
      @success="handleEditSuccess"
    />
  </div>
</template>

<style scoped>
/* EXACT COPY OF ORIGINAL STYLES */
#equipos-page {
  padding: 30px;
  background: #f8f9fa;
  min-height: 100vh;
}

.page-title {
  color: #2c3e50;
  font-weight: 700;
  font-size: 28px;
}

.content-card {
  background: white;
  border-radius: 10px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

/* Search Section */
.search-filter-container {
  display: flex;
  gap: 20px;
  margin-bottom: 25px;
  align-items: center;
}

.search-section {
  position: relative;
  flex: 1;
}

.search-input {
  width: 100%;
  padding: 14px 18px;
  padding-right: 40px;
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
}

.clear-search-btn:hover {
  color: #006633;
  background: rgba(0, 102, 51, 0.1);
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

/* Table Styles */
table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}

thead {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
}

th {
  padding: 15px;
  text-align: left;
  font-size: 13px;
  text-transform: uppercase;
  font-weight: bold;
}

td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
}

tbody tr {
  cursor: pointer;
  transition: all 0.2s;
  background: white;
}

tbody tr:hover {
  background: rgba(0, 102, 51, 0.08);
}

tbody tr.row-active {
  background: rgba(0, 102, 51, 0.12);
}

/* INVIMA Badge */
.invima-badge {
  background: rgba(0, 102, 51, 0.1);
  color: #006633;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
}

/* Risk Box - EXACT ORIGINAL */
.risk-box {
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  display: inline-block;
  min-width: 35px;
  text-align: center;
}

.risk-box-danger {
  background: rgba(255, 0, 0, 0.1);
  color: #d32f2f;
  border: 2px solid rgba(255, 0, 0, 0.3);
}

.risk-box-warning {
  background: rgba(255, 165, 0, 0.1);
  color: #e65100;
  border: 2px solid rgba(255, 165, 0, 0.3);
}

.risk-box-success {
  background: rgba(76, 175, 80, 0.1);
  color: #2e7d32;
  border: 2px solid rgba(76, 175, 80, 0.3);
}

.risk-box-secondary {
  background: rgba(158, 158, 158, 0.1);
  color: #757575;
  border: 2px solid rgba(158, 158, 158, 0.3);
}

/* Estado Badge - EXACT ORIGINAL */
.estado-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  display: inline-block;
}

.estado-activo {
  background: rgba(76, 175, 80, 0.15);
  color: #2e7d32;
}

.estado-mantenimiento {
  background: rgba(255, 152, 0, 0.15);
  color: #e65100;
}

.estado-baja {
  background: rgba(244, 67, 54, 0.15);
  color: #d32f2f;
}

.estado-inactivo {
  background: rgba(158, 158, 158, 0.15);
  color: #757575;
}

/* Buttons */
.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
  font-size: 14px;
}

.btn-primary {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 102, 51, 0.3);
}

.btn-sm {
  padding: 8px 12px;
  font-size: 13px;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-secondary:hover {
  background: #d5d5d5;
}

.btn-danger {
  background: #f44336;
  color: white;
}

.btn-danger:hover {
  background: #d32f2f;
}

.btn-info {
  background: #2196f3;
  color: white;
}

.btn-ver {
  transition: all 0.3s;
}

.btn-ver-active {
  background: #006633;
  transform: scale(1.1);
}

/* Skeleton Loading */
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

.skeleton-badge {
  width: 60%;
  height: 24px;
}

.skeleton-small {
  width: 40px;
  height: 24px;
}

.skeleton-buttons {
  width: 120px;
  height: 32px;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* Detalle Row */
.detalle-row {
  background: #f9f9f9 !important;
}

.detalle-row:hover {
  background: #f9f9f9 !important;
}

.detalle-cell {
  padding: 0 !important;
}

.detalle-container {
  padding: 20px;
}

.detalle-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #e0e0e0;
}

.detalle-title {
  font-size: 18px;
  font-weight: 600;
  color: #006633;
}

.detalle-tabs {
  display: flex;
  gap: 5px;
  margin-bottom: 20px;
  border-bottom: 2px solid #e0e0e0;
}

.detalle-tab {
  padding: 12px 20px;
  background: transparent;
  border: none;
  color: #616161;
  cursor: pointer;
  font-weight: 500;
  font-size: 14px;
  border-bottom: 3px solid transparent;
  transition: all 0.2s;
}

.detalle-tab.active {
  color: #006633;
  border-bottom-color: #006633;
  font-weight: 600;
}

.detalle-tab:hover:not(.active) {
  background: rgba(0, 102, 51, 0.05);
}

.detalle-content {
  padding: 20px 0;
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.detalle-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.detalle-section {
  background: white;
  padding: 15px;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
}

.detalle-section-title {
  color: #006633;
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 15px 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #e0e0e0;
}

.detalle-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.detalle-label {
  font-weight: 600;
  color: #616161;
  font-size: 14px;
}

.detalle-value {
  color: #2c3e50;
  font-size: 14px;
  text-align: right;
}

.documentos-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  margin-top: 15px;
}

.documento-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px;
  background: white;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
  font-size: 14px;
}

.check-icon {
  color: #4caf50;
}

.x-icon {
  color: #f44336;
}

/* Pagination */
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
  padding: 6px;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  cursor: pointer;
}

.page-navigation {
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-btn {
  padding: 8px 16px;
  background: white;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s;
}

.page-btn:hover:not(:disabled) {
  background: #f5f5f5;
  border-color: #006633;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #616161;
}

.page-input {
  width: 50px;
  padding: 4px 8px;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  text-align: center;
}
</style>
