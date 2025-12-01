<script setup>
/**
 * Traslados.vue - Refactorizado
 * Gestión de historial de traslados con composables y modales externos
 */
import { ref, onMounted } from 'vue'
import { trasladosService } from '@/services'
import { 
  useFormatting, 
  usePagination, 
  useCatalogos, 
  useFilters, 
  useModal,
  useNotifications 
} from '@/composables'
import ModalCrearTraslado from './modals/traslados/ModalCrearTraslado.vue'
import ModalEditarTraslado from './modals/traslados/ModalEditarTraslado.vue'
import ModalEliminarTraslado from './modals/traslados/ModalEliminarTraslado.vue'

// ===== COMPOSABLES =====
const { formatFecha, formatUbicacion } = useFormatting()
const { sedes, ubicaciones, responsables } = useCatalogos()
const notifications = useNotifications()

// ===== ESTADO PRINCIPAL =====
const traslados = ref([])
const loading = ref(true)
const error = ref(null)

// ===== FILTROS Y PAGINACIÓN =====
const filters = useFilters(traslados, {
  searchFields: ['equipo_codigo', 'equipo_nombre', 'equipo_marca', 'equipo_modelo'],
  defaultSort: 'fecha-desc',
  customFilters: {
    sedes_origen: [],
    sedes_destino: [],
    ubicaciones_origen: [],
    ubicaciones_destino: [],
    responsables: [],
    fecha_desde: '',
    fecha_hasta: ''
  }
})

const pagination = usePagination(filters.filteredItems, 10)

// ===== MODALES =====
const createModal = useModal()
const editModal = useModal()
const deleteModal = useModal()

// ===== FUNCIONES DE FETCH =====
async function fetchTraslados() {
  loading.value = true
  error.value = null
  try {
    traslados.value = await trasladosService.getAll()
  } catch (err) {
    error.value = err.message || 'Error al cargar traslados'
    console.error('Error fetching traslados:', err)
    notifications.error('❌ Error al cargar traslados')
  } finally {
    loading.value = false
  }
}

// ===== CRUD OPERATIONS =====
async function handleCreateTraslado(trasladoData) {
  try {
    await trasladosService.create(trasladoData)
    await fetchTraslados()
    createModal.close()
    notifications.success('✅ Traslado creado exitosamente')
  } catch (err) {
    console.error('Error creating traslado:', err)
    notifications.error('❌ Error al crear el traslado: ' + (err.message || 'Error desconocido'))
    throw err
  }
}

async function handleEditTraslado(trasladoData) {
  try {
    await trasladosService.update(trasladoData.id, trasladoData)
    await fetchTraslados()
    editModal.close()
    notifications.success('✅ Traslado actualizado exitosamente')
  } catch (err) {
    console.error('Error updating traslado:', err)
    notifications.error('❌ Error al actualizar el traslado: ' + (err.message || 'Error desconocido'))
    throw err
  }
}

async function handleDeleteTraslado() {
  try {
    const trasladoId = deleteModal.data.value.id
    await trasladosService.delete(trasladoId)
    await fetchTraslados()
    deleteModal.close()
    notifications.success('✅ Traslado eliminado exitosamente')
  } catch (err) {
    console.error('Error deleting traslado:', err)
    notifications.error('❌ Error al eliminar el traslado: ' + (err.message || 'Error desconocido'))
    throw err
  }
}

// ===== FILTER HELPERS =====
function toggleSedeOrigenFilter(sede) {
  filters.toggleArrayFilter(filters.filtros.value.sedes_origen, sede, 'id')
  pagination.resetPage()
}

function toggleSedeDestinoFilter(sede) {
  filters.toggleArrayFilter(filters.filtros.value.sedes_destino, sede, 'id')
  pagination.resetPage()
}

function toggleUbicacionOrigenFilter(ubicacion) {
  filters.toggleArrayFilter(filters.filtros.value.ubicaciones_origen, ubicacion, 'id')
  pagination.resetPage()
}

function toggleUbicacionDestinoFilter(ubicacion) {
  filters.toggleArrayFilter(filters.filtros.value.ubicaciones_destino, ubicacion, 'id')
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
  fetchTraslados()
})
</script>

<template>
  <div id="traslados-page">
    <!-- Notifications Toast Container -->
    <div class="notifications-container">
      <div 
        v-for="notification in notifications.notifications.value" 
        :key="notification.id"
        class="notification-toast"
        :class="`notification-${notification.type}`"
      >
        {{ notification.message }}
      </div>
    </div>

    <!-- Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Historial de Traslados</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Traslados / Historial</div>
      </div>
      <button class="btn btn-primary" @click="createModal.open()">➕ Nuevo Traslado</button>
    </div>

    <!-- Card Principal -->
    <div class="content-card">
      <!-- Barra de búsqueda y filtros -->
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            class="search-input" 
            placeholder="🔍 Buscar por código, nombre, marca o modelo..." 
            v-model="filters.searchQuery.value"
          >
          <button 
            v-if="filters.searchQuery.value" 
            @click="filters.searchQuery.value = ''" 
            class="clear-search-btn"
            title="Limpiar búsqueda"
          >
            ✕
          </button>
        </div>
        <button class="filter-button" @click="filters.toggleFilterPanel()">
          ☰ Filtrar y Ordenar
          <span v-if="filters.filtrosActivos.value > 0" class="filter-badge">{{ filters.filtrosActivos.value }}</span>
        </button>
      </div>

      <!-- Skeleton Loader -->
      <div v-if="loading" class="skeleton-table">
        <table>
          <thead>
            <tr>
              <th style="width: 10%;">Código</th>
              <th style="width: 15%;">Equipo</th>
              <th style="width: 12%;">Origen</th>
              <th style="width: 3%;"></th>
              <th style="width: 12%;">Destino</th>
              <th style="width: 18%;">Justificación</th>
              <th style="width: 10%;">Fecha</th>
              <th style="width: 10%;">Responsable</th>
              <th style="width: 10%;">Acciones</th>
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

      <!-- Error State -->
      <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>
      
      <!-- Tabla de Traslados -->
      <table v-else id="trasladosTable">
        <thead>
          <tr>
            <th style="width: 10%;">Código</th>
            <th style="width: 15%;">Equipo</th>
            <th style="width: 12%;">Origen</th>
            <th style="width: 3%;"></th>
            <th style="width: 12%;">Destino</th>
            <th style="width: 18%;">Justificación</th>
            <th style="width: 10%;">Fecha</th>
            <th style="width: 10%;">Responsable</th>
            <th style="width: 10%;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="traslado in pagination.paginatedItems.value" :key="traslado.id">
            <td><strong>{{ traslado.equipo_codigo }}</strong></td>
            <td>
              <div style="font-weight: 600; color: #212121;">{{ traslado.equipo_nombre }}</div>
              <div style="font-size: 11px; color: #616161;">{{ traslado.equipo_marca }} - {{ traslado.equipo_modelo }}</div>
            </td>
            <td>
              <div style="font-weight: 600; font-size: 14px; color: #212121;">{{ traslado.sede_origen_nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(traslado.ubicacion_origen_nombre) }}</div>
            </td>
            <td style="text-align: center; color: #006633; font-size: 20px;">
              ➝
            </td>
            <td>
              <div style="font-weight: 600; font-size: 14px; color: #212121;">{{ traslado.sede_destino_nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(traslado.ubicacion_destino_nombre) }}</div>
            </td>
            <td>{{ traslado.justificacion }}</td>
            <td>{{ formatFecha(traslado.fecha_traslado) }}</td>
            <td style="text-align: center;">
              <div style="font-weight: 600; color: #006633;">{{ traslado.responsable_nombre || 'N/A' }}</div>
            </td>
            <td>
              <div class="actions-container">
                <button class="btn btn-secondary btn-sm" title="Editar" @click="editModal.open(traslado)">✏️</button>
                <button class="btn btn-danger btn-sm" title="Eliminar" @click="deleteModal.open(traslado)">🗑️</button>
              </div>
            </td>
          </tr>
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
    <ModalCrearTraslado 
      :show="createModal.isOpen.value"
      :sedes="sedes"
      :ubicaciones="ubicaciones"
      :responsables="responsables"
      @close="createModal.close()"
      @save="handleCreateTraslado"
    />

    <ModalEditarTraslado 
      :show="editModal.isOpen.value"
      :traslado="editModal.data.value"
      :sedes="sedes"
      :ubicaciones="ubicaciones"
      :responsables="responsables"
      @close="editModal.close()"
      @save="handleEditTraslado"
    />

    <ModalEliminarTraslado
      :show="deleteModal.isOpen.value"
      :traslado="deleteModal.data.value"
      @close="deleteModal.close()"
      @confirm="handleDeleteTraslado"
    />

    <!-- Panel de Filtros (Sidebar) -->
    <div class="filter-panel" :class="{ active: filters.showFilterPanel.value }">
      <div class="filter-panel-header">
        <h3>Filtrar y Ordenar</h3>
        <button class="close-filter-btn" @click="filters.toggleFilterPanel()">✕</button>
      </div>

      <div class="filter-panel-content">
        <!-- Ordenamiento -->
        <div class="filter-section">
          <h4>Ordenar por</h4>
          <select v-model="filters.ordenamiento.value" class="filter-select">
            <option value="fecha-desc">Fecha (Más reciente)</option>
            <option value="fecha-asc">Fecha (Más antiguo)</option>
            <option value="equipo-asc">Equipo (A-Z)</option>
            <option value="equipo-desc">Equipo (Z-A)</option>
          </select>
        </div>

        <!-- Filtro por Sedes Origen -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.sedes_origen?.length > 0">
          <h4>Sede Origen</h4>
          <div class="checkbox-list">
            <label v-for="sede in filters.valoresUnicos.value.sedes_origen" :key="sede.id" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.sedes_origen.some(s => s.id === sede.id)"
                @change="toggleSedeOrigenFilter(sede)"
              >
              <span>{{ sede.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Sedes Destino -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.sedes_destino?.length > 0">
          <h4>Sede Destino</h4>
          <div class="checkbox-list">
            <label v-for="sede in filters.valoresUnicos.value.sedes_destino" :key="sede.id" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.sedes_destino.some(s => s.id === sede.id)"
                @change="toggleSedeDestinoFilter(sede)"
              >
              <span>{{ sede.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Ubicaciones Origen -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.ubicaciones_origen?.length > 0">
          <h4>Ubicación Origen</h4>
          <div class="checkbox-list">
            <label v-for="ub in filters.valoresUnicos.value.ubicaciones_origen" :key="ub.id" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.ubicaciones_origen.some(u => u.id === ub.id)"
                @change="toggleUbicacionOrigenFilter(ub)"
              >
              <span>{{ ub.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Ubicaciones Destino -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.ubicaciones_destino?.length > 0">
          <h4>Ubicación Destino</h4>
          <div class="checkbox-list">
            <label v-for="ub in filters.valoresUnicos.value.ubicaciones_destino" :key="ub.id" class="checkbox-label">
              <input 
                type="checkbox" 
                :checked="filters.filtros.value.ubicaciones_destino.some(u => u.id === ub.id)"
                @change="toggleUbicacionDestinoFilter(ub)"
              >
              <span>{{ ub.nombre }}</span>
            </label>
          </div>
        </div>

        <!-- Filtro por Responsable -->
        <div class="filter-section" v-if="filters.valoresUnicos.value.responsables?.length > 0">
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

        <!-- Filtro por Rango de Fechas -->
        <div class="filter-section">
          <h4>Rango de Fechas</h4>
          <div style="display: flex; flex-direction: column; gap: 10px;">
            <div>
              <label style="font-size: 12px; color: #616161; display: block; margin-bottom: 5px;">Desde</label>
              <input 
                type="date" 
                v-model="filters.filtros.value.fecha_desde" 
                class="filter-select"
              >
            </div>
            <div>
              <label style="font-size: 12px; color: #616161; display: block; margin-bottom: 5px;">Hasta</label>
              <input 
                type="date" 
                v-model="filters.filtros.value.fecha_hasta" 
                class="filter-select"
              >
            </div>
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

/* Notifications Toast */
.notifications-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notification-toast {
  padding: 15px 20px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  font-weight: 500;
  min-width: 300px;
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    transform: translateX(400px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.notification-success {
  background: #4caf50;
  color: white;
}

.notification-error {
  background: #f44336;
  color: white;
}

.notification-warning {
  background: #ff9800;
  color: white;
}

.notification-info {
  background: #2196f3;
  color: white;
}
</style>