<script setup>
import { ref, onMounted, computed } from 'vue'
import { mantenimientosAPI } from '../services/api'

// Data de mantenimientos
const mantenimientos = ref([])
const loading = ref(true)
const error = ref(null)
const searchQuery = ref('')

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [5, 10, 20, 50]

// Accordion state
const expandedRows = ref(new Set())

// Filter Panel State
const showFilterPanel = ref(false)

// Filter State
const filtros = ref({
  tipos: [],
  proveedores: [],
  anios: [],
  meses: []
})

const ordenamiento = ref('reciente')

const mesesNombres = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

// Fetch mantenimientos from backend
async function fetchMantenimientos() {
  try {
    loading.value = true
    const response = await mantenimientosAPI.getAll()
    mantenimientos.value = response.data
  } catch (err) {
    console.error('Error fetching mantenimientos:', err)
    error.value = 'Error al cargar mantenimientos'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchMantenimientos()
})

// Get unique values for filters
const tiposUnicos = computed(() => {
  const tipos = [...new Set(mantenimientos.value.map(m => m.tipo_mantenimiento))].filter(Boolean)
  return tipos.sort()
})

const proveedoresUnicos = computed(() => {
  const proveedores = [...new Set(mantenimientos.value.map(m => m.realizado_por))].filter(Boolean)
  return proveedores.sort()
})

const aniosUnicos = computed(() => {
  const anios = [...new Set(mantenimientos.value.map(m => m.anio_mantenimiento))].filter(Boolean)
  return anios.sort((a, b) => b - a) // Más reciente primero
})

// Filtered mantenimientos
const filteredMantenimientos = computed(() => {
  let result = mantenimientos.value

  // Filtro por búsqueda
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(mant => 
      (mant.equipo?.codigo_interno && mant.equipo.codigo_interno.toLowerCase().includes(query)) ||
      (mant.equipo?.nombre_equipo && mant.equipo.nombre_equipo.toLowerCase().includes(query)) ||
      (mant.tipo_mantenimiento && mant.tipo_mantenimiento.toLowerCase().includes(query)) ||
      (mant.realizado_por && mant.realizado_por.toLowerCase().includes(query))
    )
  }

  // Filtro por tipos
  if (filtros.value.tipos.length > 0) {
    result = result.filter(mant => filtros.value.tipos.includes(mant.tipo_mantenimiento))
  }

  // Filtro por proveedores
  if (filtros.value.proveedores.length > 0) {
    result = result.filter(mant => filtros.value.proveedores.includes(mant.realizado_por))
  }

  // Filtro por años
  if (filtros.value.anios.length > 0) {
    result = result.filter(mant => filtros.value.anios.includes(mant.anio_mantenimiento))
  }

  // Filtro por meses
  if (filtros.value.meses.length > 0) {
    result = result.filter(mant => filtros.value.meses.includes(mant.mes_mantenimiento))
  }

  // Ordenamiento
  switch (ordenamiento.value) {
    case 'reciente':
      result.sort((a, b) => {
        if (b.anio_mantenimiento !== a.anio_mantenimiento) {
          return b.anio_mantenimiento - a.anio_mantenimiento
        }
        return b.mes_mantenimiento - a.mes_mantenimiento
      })
      break
    case 'antiguo':
      result.sort((a, b) => {
        if (a.anio_mantenimiento !== b.anio_mantenimiento) {
          return a.anio_mantenimiento - b.anio_mantenimiento
        }
        return a.mes_mantenimiento - b.mes_mantenimiento
      })
      break
    case 'costo-mayor':
      result.sort((a, b) => (b.costo || 0) - (a.costo || 0))
      break
    case 'costo-menor':
      result.sort((a, b) => (a.costo || 0) - (b.costo || 0))
      break
    case 'equipo-asc':
      result.sort((a, b) => (a.equipo?.nombre_equipo || '').localeCompare(b.equipo?.nombre_equipo || ''))
      break
  }

  return result
})

// Pagination Logic
const totalPages = computed(() => Math.ceil(filteredMantenimientos.value.length / itemsPerPage.value))

const paginatedMantenimientos = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredMantenimientos.value.slice(start, end)
})

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

// Filter methods
function toggleFilterPanel() {
  showFilterPanel.value = !showFilterPanel.value
}

function toggleTipoFilter(tipo) {
  const index = filtros.value.tipos.indexOf(tipo)
  if (index > -1) {
    filtros.value.tipos.splice(index, 1)
  } else {
    filtros.value.tipos.push(tipo)
  }
  currentPage.value = 1
}

function toggleProveedorFilter(proveedor) {
  const index = filtros.value.proveedores.indexOf(proveedor)
  if (index > -1) {
    filtros.value.proveedores.splice(index, 1)
  } else {
    filtros.value.proveedores.push(proveedor)
  }
  currentPage.value = 1
}

function toggleAnioFilter(anio) {
  const index = filtros.value.anios.indexOf(anio)
  if (index > -1) {
    filtros.value.anios.splice(index, 1)
  } else {
    filtros.value.anios.push(anio)
  }
  currentPage.value = 1
}

function toggleMesFilter(mes) {
  const index = filtros.value.meses.indexOf(mes)
  if (index > -1) {
    filtros.value.meses.splice(index, 1)
  } else {
    filtros.value.meses.push(mes)
  }
  currentPage.value = 1
}

function borrarTodosFiltros() {
  filtros.value.tipos = []
  filtros.value.proveedores = []
  filtros.value.anios = []
  filtros.value.meses = []
  ordenamiento.value = 'reciente'
  currentPage.value = 1
}

const filtrosActivos = computed(() => {
  return filtros.value.tipos.length + filtros.value.proveedores.length + 
         filtros.value.anios.length + filtros.value.meses.length
})

// Accordion Logic
function toggleRow(id) {
  if (expandedRows.value.has(id)) {
    expandedRows.value.delete(id)
  } else {
    expandedRows.value.add(id)
  }
}

function formatMes(mes, anio) {
  return `${mesesNombres[mes - 1]} ${anio}`
}

function formatCosto(costo) {
  if (!costo) return 'N/A'
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP' }).format(costo)
}

function getTipoLabel(tipo) {
  const labels = {
    'preventivo': 'Preventivo',
    'correctivo': 'Correctivo',
    'calibracion': 'Calibración',
    'calificacion': 'Calificación',
    'verificacion': 'Verificación'
  }
  return labels[tipo] || tipo
}

function getTipoBadgeClass(tipo) {
  const classes = {
    'preventivo': 'badge-success',
    'correctivo': 'badge-danger',
    'calibracion': 'badge-info',
    'calificacion': 'badge-warning',
    'verificacion': 'badge-secondary'
  }
  return classes[tipo] || 'badge-secondary'
}

function abrirNuevoMantenimiento() {
  alert('Funcionalidad en desarrollo')
}
</script>

<template>
  <div class="mantenimientos-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Historial de Mantenimientos</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Mantenimientos / Historial Completo</div>
      </div>
      <button class="btn btn-primary" @click="abrirNuevoMantenimiento">➕ Nuevo Mantenimiento</button>
    </div>

    <!-- Loading Skeleton -->
    <div v-if="loading" class="content-card skeleton">
      <div class="search-filter-container">
        <div class="skeleton-line" style="width: 70%; height: 45px; border-radius: 8px;"></div>
        <div class="skeleton-line" style="width: 25%; height: 45px; border-radius: 8px;"></div>
      </div>
      <div class="skeleton-line" style="width: 100%; height: 60px; margin-bottom: 10px;"></div>
      <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
      <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
      <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
      <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
      <div class="skeleton-line" style="width: 100%; height: 50px;"></div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>

    <!-- Content -->
    <div v-else class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            v-model="searchQuery"
            class="search-input" 
            placeholder="🔍 Buscar por código, equipo, tipo o proveedor..."
          >
        </div>
        <button class="filter-button" @click="toggleFilterPanel">
          ☰ Filtrar y Ordenar
          <span v-if="filtrosActivos > 0" class="filter-badge">{{ filtrosActivos }}</span>
        </button>
      </div>

      <table v-if="filteredMantenimientos.length > 0">
        <thead>
          <tr>
            <th>Código Equipo</th>
            <th>Equipo</th>
            <th>Tipo</th>
            <th>Mes/Año</th>
            <th>Realizado Por</th>
            <th>Costo</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="mant in paginatedMantenimientos" :key="mant.id">
            <tr 
              :class="{ 'row-active': expandedRows.has(mant.id) }" 
              @click="toggleRow(mant.id)"
              style="cursor: pointer;"
            >
              <td class="col-codigo"><strong>{{ mant.equipo?.codigo_interno || 'N/A' }}</strong></td>
              <td>
                <div style="font-weight: 600;">{{ mant.equipo?.nombre_equipo || 'N/A' }}</div>
                <div style="font-size: 12px; color: #616161;">{{ mant.equipo?.marca }} - {{ mant.equipo?.modelo }}</div>
              </td>
              <td>
                <span class="badge" :class="getTipoBadgeClass(mant.tipo_mantenimiento)">
                  {{ getTipoLabel(mant.tipo_mantenimiento) }}
                </span>
              </td>
              <td>
                <span :style="{ fontWeight: expandedRows.has(mant.id) ? 'bold' : 'normal' }">
                  {{ formatMes(mant.mes_mantenimiento, mant.anio_mantenimiento) }}
                </span>
              </td>
              <td>{{ mant.realizado_por }}</td>
              <td>{{ formatCosto(mant.costo) }}</td>
              <td @click.stop>
                <div style="display: flex; gap: 10px;">
                  <button class="btn btn-info btn-sm" @click="toggleRow(mant.id)">👁️</button>
                  <button class="btn btn-secondary btn-sm">✏️</button>
                  <button class="btn btn-danger btn-sm">🗑️</button>
                </div>
              </td>
            </tr>
            <!-- Accordion Content -->
            <tr v-if="expandedRows.has(mant.id)" class="accordion-details-row">
              <td colspan="7" class="detalle-cell">
                <div class="accordion-details">
                  <div class="detalle-header">
                    <div class="detalle-title">📋 Detalle del Mantenimiento</div>
                    <button class="btn btn-secondary btn-sm btn-close" @click="toggleRow(mant.id)">✕ Cerrar</button>
                  </div>
                  
                  <div class="detail-grid-horizontal">
                    <div class="detail-item-horizontal">
                      <span class="detail-label">Responsable Registro:</span>
                      <span class="detail-value">{{ mant.usuario_registro }}</span>
                    </div>
                    <div class="detail-item-horizontal">
                      <span class="detail-label">Descripción:</span>
                      <span class="detail-value">{{ mant.descripcion }}</span>
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
      <p v-else style="text-align: center; color: #616161; padding: 40px;">
        No se encontraron mantenimientos
      </p>

      <!-- Pagination Footer -->
      <div class="pagination-footer" v-if="filteredMantenimientos.length > 0">
        <div class="items-per-page">
          <span>Mostrar</span>
          <select v-model.number="itemsPerPage" @change="currentPage = 1" class="page-select">
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
            <span class="arrow">▼</span>
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
            <span class="arrow">▼</span>
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
            <span class="arrow">▼</span>
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
            <span class="arrow">▼</span>
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
  </div>
</template>

<style scoped>
.mantenimientos-container {
  width: 100%;
  max-width: 100%;
  overflow-x: hidden;
}

.page-title {
  font-size: 28px;
  color: #006633;
  font-weight: 600;
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

.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
  font-size: 14px;
}

.btn-primary {
  background: #006633;
  color: white;
}

.btn-primary:hover {
  background: #2d5016;
  transform: translateY(-2px);
}

.btn-sm {
  padding: 6px 12px;
  font-size: 12px;
}

.btn-info {
  background: #00a99d;
  color: white;
}

.btn-secondary {
  background: #e0e0e0;
  color: #424242;
}

.btn-danger {
  background: #f44336;
  color: white;
}

.btn-close {
  position: absolute;
  top: 25px;
  right: 25px;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 800px;
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
  font-weight: 600;
}

td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
}

.col-codigo {
  width: 120px;
}

tbody tr {
  background: white;
  transition: all 0.2s;
}

tbody tr:hover {
  background: rgba(0, 102, 51, 0.04);
}

tbody tr.row-active {
  background: rgba(0, 102, 51, 0.12) !important;
  border-left: 4px solid #006633;
}

.badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
}

.badge-success {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}

.badge-danger {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
}

.badge-warning {
  background: rgba(255, 152, 0, 0.1);
  color: #ff9800;
}

.badge-info {
  background: rgba(0, 169, 157, 0.1);
  color: #00a99d;
}

.badge-secondary {
  background: rgba(97, 97, 97, 0.1);
  color: #616161;
}

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
  display: flex;
  align-items: center;
  gap: 10px;
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

.detail-item-horizontal .detail-label {
  display: block;
  font-weight: 700;
  color: #006633;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
}

.detail-item-horizontal .detail-value {
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
  letter-spacing: 0.5px;
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
  transition: all 0.2s;
  color: #212121;
  font-weight: 500;
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
  color: #212121;
  font-weight: 600;
}

.page-input:focus {
  outline: none;
  border-color: #006633;
  background: white;
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