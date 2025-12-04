<script setup>
/**
 * Inventario.vue
 * Gestión de inventario de equipos con composables y modales externos
 */
import { ref, onMounted } from 'vue'
import { equiposService, trasladosService, mantenimientosService } from '@/services'
import { 
  useFormatting, 
  usePagination, 
  useCatalogos, 
  useFilters, 
  useModal 
} from '@/composables'
import ModalCrearEquipo from './modals/inventario/ModalCrearEquipo.vue'
import ModalEditarEquipo from './modals/inventario/ModalEditarEquipo.vue'
import ModalEliminar from './modals/inventario/ModalEliminar.vue'

// ===== COMPOSABLES =====
const { formatFecha, getRiesgoBadgeClass, getEstadoBadgeClass, formatEstado, formatUbicacion } = useFormatting()
const { sedes, ubicaciones, responsables } = useCatalogos()

// ===== ESTADO PRINCIPAL =====
const equipos = ref([])
const loading = ref(true)
const error = ref(null)

// ===== FILTROS Y PAGINACIÓN =====
const filters = useFilters(equipos, {
  searchFields: ['nombre_equipo', 'codigo_interno', 'marca', 'modelo', 'serie'],
  defaultSort: 'codigo-asc'
})

const pagination = usePagination(filters.filteredItems, 10)

// ===== MODALES =====
const createModal = useModal()
const editModal = useModal()
const deleteModal = useModal()

// ===== DETALLE EXPANDIBLE =====
const expandedEquipoId = ref(null)
const selectedEquipo = ref(null)
const activeTab = ref('info')
const detailLoading = ref(false)

// Cache para historial
const trasladosCache = ref(new Map())
const mantenimientosCache = ref(new Map())
const trasladosLoading = ref(false)
const mantenimientosLoading = ref(false)

// ===== FUNCIONES DE FETCH =====
async function fetchEquipos() {
  loading.value = true
  error.value = null
  try {
    equipos.value = await equiposService.getAll()
  } catch (err) {
    error.value = err.message || 'Error al cargar equipos'
    console.error('Error fetching equipos:', err)
  } finally {
    loading.value = false
  }
}

async function fetchTraslados(equipoId) {
  if (trasladosCache.value.has(equipoId)) return
  
  trasladosLoading.value = true
  try {
    const data = await trasladosService.getByEquipo(equipoId)
    trasladosCache.value.set(equipoId, data)
  } catch (err) {
    console.error('Error fetching traslados:', err)
  } finally {
    trasladosLoading.value = false
  }
}

async function fetchMantenimientos(equipoId) {
  if (mantenimientosCache.value.has(equipoId)) return
  
  mantenimientosLoading.value = true
  try {
    const data = await mantenimientosService.getByEquipo(equipoId)
    mantenimientosCache.value.set(equipoId, data)
  } catch (err) {
    console.error('Error fetching mantenimientos:', err)
  } finally {
    mantenimientosLoading.value = false
  }
}

// ===== DETALLE FUNCTIONS =====
async function toggleDetalle(id) {
  if (expandedEquipoId.value === id) {
    expandedEquipoId.value = null
    selectedEquipo.value = null
  } else {
    expandedEquipoId.value = id
    activeTab.value = 'info'
    detailLoading.value = true
    try {
      // Fetch full details from API
      selectedEquipo.value = await equiposService.getById(id)
    } catch (err) {
      console.error('Error fetching equipo details:', err)
      // Fallback to local data if fetch fails
      selectedEquipo.value = equipos.value.find(e => e.id === id)
    } finally {
      detailLoading.value = false
    }
  }
}

function setActiveTab(tab) {
  activeTab.value = tab
  
  // Lazy loading para tabs de historial
  if (tab === 'traslados' && expandedEquipoId.value) {
    fetchTraslados(expandedEquipoId.value)
  } else if (tab === 'mantenimientos' && expandedEquipoId.value) {
    fetchMantenimientos(expandedEquipoId.value)
  }
}

// ===== CRUD OPERATIONS =====
async function handleCreateEquipo(equipoData) {
  try {
    await equiposService.create(equipoData)
    await fetchEquipos()
    createModal.close()
  } catch (err) {
    console.error('Error creating equipo:', err)
    throw err
  }
}

async function handleEditEquipo(equipoData) {
  try {
    await equiposService.update(equipoData.id, equipoData)
    await fetchEquipos()
    
    // Si el equipo editado está expandido, actualizar su detalle
    if (expandedEquipoId.value === equipoData.id) {
      selectedEquipo.value = equipos.value.find(e => e.id === equipoData.id)
    }
    
    editModal.close()
  } catch (err) {
    console.error('Error updating equipo:', err)
    throw err
  }
}

async function handleDeleteEquipo(data) {
  try {
    // data contains { motivo, password }
    // In a real implementation, you would include this in the delete request
    const equipoId = deleteModal.data.value.id
    await equiposService.delete(equipoId)
    await fetchEquipos()
    deleteModal.close()
  } catch (err) {
    console.error('Error deleting equipo:', err)
    throw err
  }
}

// ===== FILTER HELPERS =====
function toggleSedeFilter(sede) {
  filters.toggleArrayFilter(filters.filtros.value.sedes, sede, 'id')
  pagination.resetPage()
}

function toggleUbicacionFilter(ubicacion) {
  filters.toggleArrayFilter(filters.filtros.value.ubicaciones, ubicacion, 'id')
  pagination.resetPage()
}

function toggleRiesgoFilter(riesgo) {
  filters.toggleArrayFilter(filters.filtros.value.riesgos, riesgo, null)
  pagination.resetPage()
}

function toggleEstadoFilter(estado) {
  filters.toggleArrayFilter(filters.filtros.value.estados, estado, null)
  pagination.resetPage()
}

function toggleResponsableFilter(responsable) {
  filters.toggleArrayFilter(filters.filtros.value.responsables, responsable, null)
  pagination.resetPage()
}

function borrarTodosFiltros() {
  filters.borrarTodosFiltros()
  pagination.resetPage()
}

// ===== LIFECYCLE =====
onMounted(() => {
  fetchEquipos()
})
</script>

<template>
  <div id="equipos-page">
    <!-- Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Inventario de Equipos</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Equipos / Lista</div>
      </div>
      <button class="btn btn-primary" @click="createModal.open()"><AppIcon name="plus" size="16" /> Nuevo Equipo</button>
    </div>

    <!-- Card Principal -->
    <div class="content-card">
      <!-- Barra de búsqueda y filtros -->
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            class="search-input" 
            placeholder="Buscar por código, nombre, marca, modelo o serie..." 
            v-model="filters.searchQuery.value"
          >
          <button 
            v-if="filters.searchQuery.value" 
            @click="filters.searchQuery.value = ''" 
            class="clear-search-btn"
            title="Limpiar búsqueda"
          >
            <AppIcon name="close" size="16" />
          </button>
        </div>
        <button class="filter-button" @click="filters.toggleFilterPanel()">
          <AppIcon name="menu" size="16" /> Filtrar y Ordenar
          <span v-if="filters.filtrosActivos.value > 0" class="filter-badge">{{ filters.filtrosActivos.value }}</span>
        </button>
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
              <th style="width: 12%;">Responsable</th>
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
      
      <!-- Tabla de Equipos -->
      <table v-else id="equiposTable">
        <thead>
          <tr>
            <th style="width: 7%;">Código</th>
            <th style="width: 19%;">Equipo</th>
            <th style="width: 18%;">Registro Invima</th>
            <th style="width: 6%; text-align: center;">Riesgo</th>
            <th style="width: 10%;">Sede / Ubicación</th>
            <th style="width: 12%;">Responsable</th>
            <th style="width: 10%; text-align: center;">Estado</th>
            <th style="width: 18%;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="equipo in pagination.paginatedItems.value" :key="equipo.id">
            <!-- Fila Principal -->
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
                <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(equipo.ubicacion?.nombre) }}</div>
              </td>
              <td>{{ equipo.responsable_nombre || 'N/A' }}</td>
              <td style="text-align: center;">
                <span class="estado-badge" :class="getEstadoBadgeClass(equipo.estado)">
                  {{ formatEstado(equipo.estado) }}
                </span>
              </td>
              <td @click.stop>
                <div class="actions-container">
                  <button 
                    class="btn btn-info btn-sm btn-ver" 
                    :class="{ 'btn-ver-active': expandedEquipoId === equipo.id }"
                    @click="toggleDetalle(equipo.id)"
                  ><AppIcon name="eye" size="16" /></button>
                  <button class="btn btn-secondary btn-sm" @click="editModal.open(equipo)"><AppIcon name="edit" size="16" /></button>
                  <button class="btn btn-danger btn-sm" @click="deleteModal.open(equipo)"><AppIcon name="trash" size="16" /></button>
                </div>
              </td>
            </tr>

            <!-- Fila Expandible de Detalle -->
            <tr v-if="expandedEquipoId === equipo.id" class="detalle-row active">
              <td colspan="8" class="detalle-cell">
                <div class="detalle-container">
                  <div v-if="detailLoading" style="padding: 40px; text-align: center;">
                    Cargando detalles...
                  </div>
                  <div v-else-if="selectedEquipo">
                    <!-- Header del Detalle -->
                    <div class="detalle-header">
                      <div class="detalle-title"><AppIcon name="file" size="16" /> Detalle del Equipo - {{ selectedEquipo.nombre_equipo }} ({{ selectedEquipo.codigo_interno }})</div>
                      <button class="btn btn-secondary btn-sm" @click="toggleDetalle(equipo.id)"><AppIcon name="close" size="16" /> Cerrar</button>
                    </div>

                    <!-- Tabs -->
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
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'anotaciones' }"
                        @click="setActiveTab('anotaciones')"
                      >Anotaciones</div>
                    </div>

                    <!-- Tab Content: Información General -->
                    <div v-show="activeTab === 'info'" class="detalle-content active">
                      <div class="detalle-grid">
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">A. Información General</h4>
                          <div class="detalle-item"><span class="detalle-label">Proceso:</span><span class="detalle-value">{{ selectedEquipo.proceso || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Código Interno:</span><span class="detalle-value"><strong>{{ selectedEquipo.codigo_interno }}</strong></span></div>
                          <div class="detalle-item"><span class="detalle-label">Código IPS:</span><span class="detalle-value">{{ selectedEquipo.codigo_ips || 'Pendiente' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Código ECRI:</span><span class="detalle-value">{{ selectedEquipo.codigo_ecri || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Responsable:</span><span class="detalle-value">{{ selectedEquipo.responsable_nombre || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Sede:</span><span class="detalle-value">{{ selectedEquipo.sede?.nombre || selectedEquipo.sede_info?.nombre || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Ubicación:</span><span class="detalle-value">{{ formatUbicacion(selectedEquipo.ubicacion?.nombre || selectedEquipo.ubicacion_info?.nombre) }}</span></div>
                        </div>
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">B. Información del Equipo</h4>
                          <div class="detalle-item"><span class="detalle-label">Nombre:</span><span class="detalle-value">{{ selectedEquipo.nombre_equipo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Marca:</span><span class="detalle-value">{{ selectedEquipo.marca }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Modelo:</span><span class="detalle-value">{{ selectedEquipo.modelo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Serie:</span><span class="detalle-value">{{ selectedEquipo.serie }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Clasif. Misional:</span><span class="detalle-value">{{ Array.isArray(selectedEquipo.clasificacion_misional) ? selectedEquipo.clasificacion_misional.join(', ') : selectedEquipo.clasificacion_misional || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Clasif. IPS:</span><span class="detalle-value">{{ selectedEquipo.clasificacion_ips }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Vida Útil:</span><span class="detalle-value">{{ selectedEquipo.tiempo_vida_util ? selectedEquipo.tiempo_vida_util + ' años' : 'N/A' }}</span></div>
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
                          <div class="detalle-item"><span class="detalle-label">Requiere Calificación:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.requiere_calificacion ? '✅ Sí' : 'No' }}</span></div>
                        </div>
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">F. Info Metrológica Técnica</h4>
                          <div class="detalle-item"><span class="detalle-label">Magnitud:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.magnitud }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Rango del Equipo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.rango_equipo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Rango de Trabajo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.rango_trabajo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Resolución:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.resolucion }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Error Máximo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.error_maximo }}</span></div>
                        </div>
                        
                        <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">G. Condiciones de Funcionamiento</h4>
                          <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px;">
                            <div class="detalle-item"><span class="detalle-label">Voltaje:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.voltaje || 'N/A' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Corriente:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.corriente || 'N/A' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Humedad Relativa:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.humedad_relativa || 'N/A' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Temperatura:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.temperatura || 'N/A' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Dimensiones:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.dimensiones || 'N/A' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Peso:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.peso || 'N/A' }}</span></div>
                            <div class="detalle-item" style="grid-column: span 2;"><span class="detalle-label">Otros:</span><span class="detalle-value">{{ selectedEquipo.condiciones_funcionamiento?.otros || 'N/A' }}</span></div>
                          </div>
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
                                <td>{{ formatFecha(traslado.fecha_traslado) }}</td>
                                <td style="text-align: left;">
                                  <div style="font-weight: 600; font-size: 14px;">{{ traslado.sede_origen_nombre }}</div>
                                  <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(traslado.ubicacion_origen_nombre) }}</div>
                                </td>
                                <td style="text-align: left;">
                                  <div style="font-weight: 600; font-size: 14px;">{{ traslado.sede_destino_nombre }}</div>
                                  <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(traslado.ubicacion_destino_nombre) }}</div>
                                </td>
                                <td>{{ traslado.justificacion }}</td>
                                <td>{{ traslado.responsable_nombre || 'N/A' }}</td>
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

                    <!-- Tab Content: Anotaciones -->
                    <div v-show="activeTab === 'anotaciones'" class="detalle-content active">
                      <div class="detalle-section" style="width: 100%;">
                        <h4 class="detalle-section-title">H. Anotaciones y Observaciones</h4>
                        <div class="detalle-item" style="display: block;">
                          <div class="detalle-value" style="white-space: pre-wrap; background: #f9f9f9; padding: 15px; border-radius: 8px; border: 1px solid #eee; min-height: 100px;">{{ selectedEquipo.anotaciones || 'Sin anotaciones registradas para este equipo.' }}</div>
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
          <select v-model="pagination.itemsPerPage.value" class="page-select">
            <option v-for="opt in pagination.itemsPerPageOptions" :key="opt" :value="opt">{{ opt }}</option>
          </select>
          <span>registros</span>
        </div>
        <div class="page-navigation">
          <button class="page-btn" :disabled="pagination.currentPage.value === 1" @click="pagination.changePage(pagination.currentPage.value - 1)">Anterior</button>
          <span class="page-info">
            Página 
            <input type="number" v-model="pagination.currentPage.value" min="1" :max="pagination.totalPages.value" class="page-input" @change="pagination.changePage(pagination.currentPage.value)">
            de {{ pagination.totalPages.value }}
          </span>
          <button class="page-btn" :disabled="pagination.currentPage.value === pagination.totalPages.value" @click="pagination.changePage(pagination.currentPage.value + 1)">Siguiente</button>
        </div>
      </div>
    </div>

    <!-- Modales -->
    <!-- Modal Crear/Editar Equipo (Unificado) -->
    <!-- Modal Crear Equipo -->
    <ModalCrearEquipo 
      :show="createModal.isOpen.value"
      :sedes="sedes"
      :ubicaciones="ubicaciones"
      :responsables="responsables"
      @close="createModal.close()"
      @save="handleCreateEquipo"
    />

    <!-- Modal Editar Equipo -->
    <ModalEditarEquipo 
      :show="editModal.isOpen.value"
      :equipo="editModal.data.value"
      :sedes="sedes"
      :ubicaciones="ubicaciones"
      :responsables="responsables"
      @close="editModal.close()"
      @save="handleEditEquipo"
    />

    <!-- Modal Eliminar -->
    <ModalEliminar
      :show="deleteModal.isOpen.value"
      :equipo="deleteModal.data.value"
      @close="deleteModal.close()"
      @confirm="handleDeleteEquipo"
    />

    <!-- Panel de Filtros (Sidebar) -->
    <div class="filter-panel" :class="{ active: filters.showFilterPanel.value }">
      <div class="filter-panel-header">
        <h3>Filtrar y Ordenar</h3>
        <button class="close-filter-btn" @click="filters.toggleFilterPanel()"><AppIcon name="close" size="16" /></button>
      </div>

      <div class="filter-panel-content">
        <!-- Ordenamiento -->
        <div class="filter-section">
          <h4>Ordenar por</h4>
          <select v-model="filters.ordenamiento.value" class="filter-select">
            <option value="codigo-asc">Código (A-Z)</option>
            <option value="codigo-desc">Código (Z-A)</option>
            <option value="nombre-asc">Nombre (A-Z)</option>
            <option value="nombre-desc">Nombre (Z-A)</option>
            <option value="riesgo-mayor">Mayor Riesgo Primero</option>
          </select>
        </div>

        <!-- Filtro por Sedes -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.sedes.length > 0">
          <h4>Sedes</h4>
          <div class="checkbox-list">
            <label v-for="sede in filters.valoresUnicos.value.sedes" :key="sede.id" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.sedes.some(s => s.id === sede.id)"
                @change="toggleSedeFilter(sede)"
              >
              <span>{{ sede.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Ubicaciones -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.ubicaciones.length > 0">
          <h4>Ubicaciones</h4>
          <div class="checkbox-list">
            <label v-for="ub in filters.valoresUnicos.value.ubicaciones" :key="ub.id" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.ubicaciones.some(u => u.id === ub.id)"
                @change="toggleUbicacionFilter(ub)"
              >
              <span>{{ ub.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Riesgo -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.riesgos.length > 0">
          <h4>Clasificación de Riesgo</h4>
          <div class="checkbox-list">
            <label v-for="riesgo in filters.valoresUnicos.value.riesgos" :key="riesgo" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.riesgos.includes(riesgo)"
                @change="toggleRiesgoFilter(riesgo)"
              >
              <span>Clase {{ riesgo }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Estado -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.estados.length > 0">
          <h4>Estado del Equipo</h4>
          <div class="checkbox-list">
            <label v-for="estado in filters.valoresUnicos.value.estados" :key="estado" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.estados.includes(estado)"
                @change="toggleEstadoFilter(estado)"
              >
              <span>{{ estado }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Responsable -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.responsables.length > 0">
          <h4>Responsable</h4>
          <div class="checkbox-list">
            <label v-for="resp in filters.valoresUnicos.value.responsables" :key="resp" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.responsables.includes(resp)"
                @change="toggleResponsableFilter(resp)"
              >
              <span>{{ resp }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por INVIMA -->
        <div class="filter-section">
          <h4>Registro INVIMA</h4>
          <div class="radio-list">
            <label class="radio-label">
              <input 
                type="radio" 
                :checked="filters.filtros.value.tiene_invima === null"
                @change="filters.filtros.value.tiene_invima = null"
              >
              <span>Todos</span>
            </label>
            <label class="radio-label">
              <input 
                type="radio" 
                :checked="filters.filtros.value.tiene_invima === 'si'"
                @change="filters.filtros.value.tiene_invima = 'si'"
              >
              <span>Con INVIMA</span>
            </label>
            <label class="radio-label">
              <input 
                type="radio" 
                :checked="filters.filtros.value.tiene_invima === 'no'"
                @change="filters.filtros.value.tiene_invima = 'no'"
              >
              <span>Sin INVIMA</span>
            </label>
          </div>
        </div>

        <!-- Botón Limpiar Filtros -->
        <button class="btn btn-secondary btn-block" @click="borrarTodosFiltros()">
          Limpiar Todos los Filtros
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '@/assets/styles/components.css';
</style>
