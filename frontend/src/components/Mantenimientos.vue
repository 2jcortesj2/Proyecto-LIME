<script setup>
import { ref, onMounted, watch } from 'vue'
import { mantenimientosAPI } from '../services/api'
import { useNotifications } from '../composables/useNotifications'
import { useMantenimientosFilters } from '../composables/useMantenimientosFilters'
import { usePagination } from '../composables/usePagination'
import { useMantenimientosFormatters } from '../composables/useMantenimientosFormatters'
import { useAccordion } from '../composables/useAccordion'

// Modals
import ModalEditarMantenimiento from './modals/mantenimientos/ModalEditarMantenimiento.vue'
import ModalEliminarMantenimiento from './modals/mantenimientos/ModalEliminarMantenimiento.vue'

// Estado global
const loading = ref(true)
const error = ref(null)
const mantenimientos = ref([])
const { showError } = useNotifications()

// Composables
const {
  searchQuery,
  filtros,
  ordenamiento,
  mesesNombres,
  tiposUnicos,
  proveedoresUnicos,
  aniosUnicos,
  filteredMantenimientos,
  filtrosActivos,
  toggleTipoFilter,
  toggleProveedorFilter,
  toggleAnioFilter,
  toggleMesFilter,
  borrarTodosFiltros
} = useMantenimientosFilters(mantenimientos)

const {
  currentPage,
  itemsPerPage,
  itemsPerPageOptions,
  totalPages,
  paginatedItems: paginatedMantenimientos,
  changePage
} = usePagination(filteredMantenimientos)

const {
  formatMes,
  formatCosto,
  getTipoLabel,
  getTipoBadgeClass
} = useMantenimientosFormatters()

const {
  expandedRows,
  toggleRow
} = useAccordion()

// Estado de Modals
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const selectedMantenimiento = ref(null)
const showFilterPanel = ref(false)

// Fetch Data
async function fetchMantenimientos() {
  try {
    loading.value = true
    const response = await mantenimientosAPI.getAll()
    
    if (response.data.results) {
      mantenimientos.value = response.data.results
    } else {
      mantenimientos.value = response.data
    }
  } catch (err) {
    console.error('Error fetching mantenimientos:', err)
    error.value = 'Error al cargar el historial de mantenimientos'
    showError('Error al cargar datos')
  } finally {
    loading.value = false
  }
}

// Handlers para Modals
function openEditModal(mantenimiento) {
  selectedMantenimiento.value = mantenimiento
  showEditModal.value = true
}

function openDeleteModal(mantenimiento) {
  selectedMantenimiento.value = mantenimiento
  showDeleteModal.value = true
}

function handleUpdated() {
  fetchMantenimientos()
}

function handleDeleted() {
  fetchMantenimientos()
}

// Watchers
watch(filteredMantenimientos, () => {
  currentPage.value = 1
})

onMounted(() => {
  fetchMantenimientos()
})
</script>

<template>
  <div class="mantenimientos-container">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title">Historial de Mantenimientos</h2>
        <div class="breadcrumb">Inicio / Mantenimientos / Historial Completo</div>
      </div>
    </div>

    <!-- Info Box: Instrucciones para nuevo mantenimiento -->
    <div class="info-box">
      <div class="info-icon">ℹ️</div>
      <div class="info-content">
        <strong>¿Cómo registrar un nuevo mantenimiento?</strong>
        <p>Para programar o registrar un mantenimiento, vaya a <strong>Inventario de Equipos</strong>, seleccione el equipo deseado y cambie su estado a <em>"En Mantenimiento"</em> asignando la fecha correspondiente.</p>
      </div>
    </div>

    <!-- Loading Skeleton -->
    <div v-if="loading" class="content-card skeleton">
      <div class="search-filter-container">
        <div class="skeleton-line" style="width: 70%; height: 45px;"></div>
        <div class="skeleton-line" style="width: 25%; height: 45px;"></div>
      </div>
      <div v-for="i in 5" :key="i" class="skeleton-line" style="width: 100%; height: 60px; margin-bottom: 10px;"></div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>

    <!-- Content -->
    <div v-else class="content-card">
      <!-- Search & Filter Bar -->
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            v-model="searchQuery"
            class="search-input" 
            placeholder="Buscar por código, equipo, tipo o proveedor..."
          >
        </div>
        <button class="filter-button" @click="showFilterPanel = !showFilterPanel">
          <AppIcon name="menu" size="16" /> Filtrar y Ordenar
          <span v-if="filtrosActivos > 0" class="filter-badge">{{ filtrosActivos }}</span>
        </button>
      </div>

      <!-- Table -->
      <table v-if="paginatedMantenimientos.length > 0">
        <thead>
          <tr>
            <th class="col-codigo">Código Equipo</th>
            <th class="col-equipo">Equipo</th>
            <th class="col-tipo">Tipo</th>
            <th class="col-fecha">Mes/Año</th>
            <th class="col-proveedor">Registrado por</th>
            <th class="col-costo">Costo</th>
            <th class="col-acciones">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="mant in paginatedMantenimientos" :key="mant.id">
            <tr 
              :class="{ 'row-active': expandedRows.has(mant.id) }" 
              @click="toggleRow(mant.id)"
              class="clickable-row"
            >
              <td class="col-codigo"><strong>{{ mant.equipo?.codigo_interno || 'N/A' }}</strong></td>
              <td class="col-equipo">
                <div class="equipo-nombre">{{ mant.equipo?.nombre_equipo || 'N/A' }}</div>
                <div class="equipo-meta">{{ mant.equipo?.marca }} - {{ mant.equipo?.modelo }}</div>
              </td>
              <td class="col-tipo">
                <span class="badge" :class="getTipoBadgeClass(mant.tipo_mantenimiento)">
                  {{ getTipoLabel(mant.tipo_mantenimiento) }}
                </span>
              </td>
              <td class="col-fecha">
                <span :class="{ 'font-bold': expandedRows.has(mant.id) }">
                  {{ formatMes(mant.mes_mantenimiento, mant.anio_mantenimiento) }}
                </span>
              </td>
              <td class="col-proveedor">{{ mant.realizado_por }}</td>
              <td class="col-costo">{{ formatCosto(mant.costo) }}</td>
              <td class="col-acciones" @click.stop>
                <div class="action-buttons">
                  <button class="btn btn-info btn-sm" @click="toggleRow(mant.id)" title="Ver detalles">
                    <AppIcon name="eye" size="16" />
                  </button>
                  <button class="btn btn-secondary btn-sm" @click="openEditModal(mant)" title="Editar">
                    <AppIcon name="edit" size="16" />
                  </button>
                  <button class="btn btn-danger btn-sm" @click="openDeleteModal(mant)" title="Eliminar">
                    <AppIcon name="trash" size="16" />
                  </button>
                </div>
              </td>
            </tr>
            
            <!-- Accordion Content -->
            <tr v-if="expandedRows.has(mant.id)" class="accordion-details-row">
              <td colspan="7" class="detalle-cell">
                <div class="accordion-details">
                  <div class="detalle-header">
                    <div class="detalle-title"><AppIcon name="file" size="16" /> Detalle del Mantenimiento</div>
                    <button class="btn btn-secondary btn-sm btn-close-detail" @click="toggleRow(mant.id)">
                      <AppIcon name="close" size="16" /> Cerrar
                    </button>
                  </div>
                  
                  <div class="detail-grid-horizontal">
                    <div class="detail-item-horizontal">
                      <span class="detail-label">Responsable Registro:</span>
                      <span class="detail-value">{{ mant.usuario_registro || 'Sistema' }}</span>
                    </div>
                    <div class="detail-item-horizontal">
                      <span class="detail-label">Descripción:</span>
                      <span class="detail-value">{{ mant.descripcion || 'Sin descripción' }}</span>
                    </div>
                  </div>

                  <!-- Observaciones Section -->
                  <div class="observaciones-section" v-if="mant.observaciones">
                    <h4 class="observaciones-title">💬 Observaciones</h4>
                    <div class="observaciones-content">
                      {{ mant.observaciones }}
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
      
      <!-- Empty State -->
      <div v-else class="empty-state">
        <p>No se encontraron mantenimientos</p>
      </div>

      <!-- Pagination Footer -->
      <div class="pagination-footer" v-if="filteredMantenimientos.length > 0">
        <div class="items-per-page">
          <span>Mostrar</span>
          <select v-model.number="itemsPerPage" class="page-select">
            <option v-for="opt in itemsPerPageOptions" :key="opt" :value="opt">{{ opt }}</option>
          </select>
          <span>registros</span>
        </div>
        
        <div class="page-navigation">
          <button class="page-btn" :disabled="currentPage === 1" @click="changePage(currentPage - 1)">
            Anterior
          </button>
          <span class="page-info">
            Página 
            <input 
              type="number" 
              v-model="currentPage" 
              min="1" 
              :max="totalPages" 
              class="page-input" 
              @change="changePage(currentPage)"
            >
            de {{ totalPages }}
          </span>
          <button class="page-btn" :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">
            Siguiente
          </button>
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
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="reciente">
              <span>Más recientes</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="antiguo">
              <span>Más antiguos</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="costo-mayor">
              <span>Costo (Mayor a Menor)</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="costo-menor">
              <span>Costo (Menor a Mayor)</span>
            </label>
            <label class="filtro-item">
              <input type="radio" v-model="ordenamiento" value="equipo-asc">
              <span>Equipo (A-Z)</span>
            </label>
          </div>
        </div>

        <!-- Tipo de Mantenimiento -->
        <div class="filtro-section" v-if="tiposUnicos.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Tipo de Mantenimiento
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="tipo in tiposUnicos" :key="tipo">
              <input 
                type="checkbox" 
                :checked="filtros.tipos.includes(tipo)"
                @change="toggleTipoFilter(tipo)"
              >
              <span>{{ getTipoLabel(tipo) }}</span>
            </label>
          </div>
        </div>

        <!-- Año -->
        <div class="filtro-section" v-if="aniosUnicos.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Año
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="anio in aniosUnicos" :key="anio">
              <input 
                type="checkbox" 
                :checked="filtros.anios.includes(anio)"
                @change="toggleAnioFilter(anio)"
              >
              <span>{{ anio }}</span>
            </label>
          </div>
        </div>

        <!-- Mes -->
        <div class="filtro-section">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Mes
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="(mes, index) in mesesNombres" :key="index">
              <input 
                type="checkbox" 
                :checked="filtros.meses.includes(index + 1)"
                @change="toggleMesFilter(index + 1)"
              >
              <span>{{ mes }}</span>
            </label>
          </div>
        </div>

        <!-- Realizado Por -->
        <div class="filtro-section" v-if="proveedoresUnicos.length > 0">
          <button class="filtro-section-title" @click="e => e.target.classList.toggle('collapsed')">
            Realizado Por
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="proveedor in proveedoresUnicos" :key="proveedor">
              <input 
                type="checkbox" 
                :checked="filtros.proveedores.includes(proveedor)"
                @change="toggleProveedorFilter(proveedor)"
              >
              <span>{{ proveedor }}</span>
            </label>
          </div>
        </div>
      </div>

      <div class="filtro-footer">
        <p>{{ filteredMantenimientos.length }} mantenimientos encontrados</p>
      </div>
    </div>

    <!-- MODALS -->
    <ModalEditarMantenimiento 
      v-if="showEditModal" 
      :mantenimiento="selectedMantenimiento"
      @close="showEditModal = false"
      @updated="handleUpdated"
    />

    <ModalEliminarMantenimiento 
      v-if="showDeleteModal" 
      :mantenimiento="selectedMantenimiento"
      @close="showDeleteModal = false"
      @deleted="handleDeleted"
    />
  </div>
</template>

<style scoped>
/* Estilos específicos del componente */
.mantenimientos-container {
  width: 100%;
  max-width: 100%;
  overflow-x: hidden;
}

.page-title {
  font-size: 28px;
  color: #006633;
  font-weight: 600;
  margin: 0;
}

.info-box {
  background: rgba(0, 102, 51, 0.08);
  border-left: 4px solid #006633;
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 25px;
  display: flex;
  align-items: flex-start;
  gap: 15px;
}

.info-icon {
  font-size: 24px;
}

.info-content strong {
  display: block;
  color: #006633;
  margin-bottom: 5px;
  font-size: 15px;
}

.info-content p {
  margin: 0;
  color: #424242;
  font-size: 14px;
  line-height: 1.5;
}

.content-card {
  background: white;
  border-radius: 10px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 25px;
  overflow-x: auto;
}

.search-filter-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  gap: 15px;
  flex-wrap: wrap;
}

.search-section {
  flex: 1;
  min-width: 300px;
}

.search-input {
  width: 100%;
  padding: 10px 15px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s;
  background: #f9f9f9;
}

.search-input:focus {
  outline: none;
  border-color: #006633;
  background: white;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.filter-button {
  padding: 10px 20px;
  background: white;
  border: 2px solid #006633;
  border-radius: 8px;
  color: #006633;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 8px;
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

.action-buttons {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: nowrap;
}

.clickable-row {
  cursor: pointer;
  background: white;
  transition: all 0.2s;
}

.clickable-row:hover {
  background: rgba(0, 102, 51, 0.04);
}

.row-active {
  background: rgba(0, 102, 51, 0.12) !important;
  border-left: 4px solid #006633;
}

.equipo-nombre { font-weight: 600; }
.equipo-meta { font-size: 12px; color: #616161; }

.alert {
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.alert-danger {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
  border-left: 4px solid #f44336;
}

.empty-state {
  text-align: center;
  color: #616161;
  padding: 40px;
}

/* Accordion Styles */
.accordion-details-row {
  display: table-row;
}

.detalle-cell {
  padding: 0 !important;
  background: #f9f9f9;
  border-bottom: 3px solid #006633 !important;
}

.accordion-details {
  padding: 30px;
  position: relative;
  animation: slideDown 0.3s ease;
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
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
  color: #006633;
  font-weight: 600;
}

.detail-grid-horizontal {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.detail-item-horizontal {
  background: white;
  padding: 15px;
  border-radius: 8px;
  border-left: 4px solid #006633;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.detail-label {
  display: block;
  font-weight: 700;
  color: #006633;
  font-size: 12px;
  text-transform: uppercase;
  margin-bottom: 8px;
}

.detail-value {
  display: block;
  color: #212121;
  font-size: 14px;
  font-weight: 500;
}

.observaciones-section {
  background: rgba(0, 169, 157, 0.05);
  border-left: 4px solid #00a99d;
  padding: 20px;
  border-radius: 8px;
  margin-top: 20px;
}

.observaciones-title {
  font-size: 14px;
  color: #00a99d;
  font-weight: 700;
  margin-bottom: 12px;
  text-transform: uppercase;
}

.observaciones-content {
  color: #212121;
  font-size: 14px;
  line-height: 1.6;
  white-space: pre-wrap;
}

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
  padding: 6px;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  background: #f5f5f5;
  cursor: pointer;
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
  width: 40px;
  padding: 4px;
  text-align: center;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  background: #f5f5f5;
}

/* FILTER PANEL STYLES */
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
}

.borrar-todo {
  background: none;
  border: none;
  color: #f44336;
  font-weight: 600;
  cursor: pointer;
  font-size: 14px;
  text-decoration: underline;
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
}

.filtro-section-title .arrow {
  transition: transform 0.3s;
  color: #006633;
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

/* Skeleton Loading Styles */
.skeleton {
  animation: skeleton-loading 1s linear infinite alternate;
}

.skeleton-line {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: skeleton-loading 1.5s ease-in-out infinite;
  border-radius: 4px;
}

@keyframes skeleton-loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}
</style>