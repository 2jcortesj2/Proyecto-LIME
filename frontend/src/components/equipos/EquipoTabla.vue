<template>
  <div class="equipos-table-container">
    <!-- Search Bar -->
    <div class="search-filter-container">
      <div class="search-section">
        <input 
          type="text" 
          v-model="localSearchQuery" 
          placeholder="🔍 Buscar por código, nombre, marca, modelo o serie..." 
          class="search-input"
        >
        <button 
          v-if="localSearchQuery" 
          @click="localSearchQuery = ''" 
          class="clear-search-btn"
          title="Limpiar búsqueda"
        >
          ✕
        </button>
      </div>
      <button class="filter-button">☰ Filtrar y Ordenar</button>
    </div>

    <!-- Skeleton Loading -->
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
          <tr 
            :data-equipo="equipo.id" 
            @click="$emit('toggleDetail', equipo.id)" 
            :class="{ 'row-active': expandedEquipoId === equipo.id }"
            style="cursor: pointer;"
          >
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
                  @click="$emit('toggleDetail', equipo.id)"
                  title="Ver Detalle"
                >👁️</button>
                <button class="btn btn-secondary btn-sm" @click="$emit('edit', equipo)" title="Editar">✏️</button>
                <button class="btn btn-danger btn-sm" @click="$emit('delete', equipo)" title="Eliminar">🗑️</button>
              </div>
            </td>
          </tr>

          <!-- Expanded Detail Row (slot for parent to provide content) -->
          <tr v-if="expandedEquipoId === equipo.id" class="detalle-row active">
            <td colspan="8" class="detalle-cell">
              <slot name="detail" :equipo="equipo"></slot>
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
        <select v-model.number="localItemsPerPage" @change="$emit('update:itemsPerPage', localItemsPerPage); currentPageLocal = 1" class="page-select">
          <option v-for="option in itemsPerPageOptions" :key="option" :value="option">
            {{ option }}
          </option>
        </select>
        <span>registros</span>
      </div>
      
      <div class="page-navigation">
        <button class="page-btn" :disabled="currentPageLocal === 1" @click="changePage(currentPageLocal - 1)">Anterior</button>
        <span class="page-info">
          Página 
          <input type="number" v-model.number="currentPageLocal" min="1" :max="totalPages" class="page-input" @change="changePage(currentPageLocal)">
          de {{ totalPages }}
        </span>
        <button class="page-btn" :disabled="currentPageLocal === totalPages" @click="changePage(currentPageLocal + 1)">Siguiente</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  equipos: {
    type: Array,
    required: true
  },
  loading: {
    type: Boolean,
    default: false
  },
  error: {
    type: String,
    default: null
  },
  searchQuery: {
    type: String,
    default: ''
  },
  itemsPerPage: {
    type: Number,
    default: 10
  },
  expandedEquipoId: {
    type: Number,
    default: null
  }
})

const emit = defineEmits(['update:searchQuery', 'update:itemsPerPage', 'toggleDetail', 'edit', 'delete'])

// Local state for v-model
const localSearchQuery = ref(props.searchQuery)
const localItemsPerPage = ref(props.itemsPerPage)
const currentPageLocal = ref(1)

const itemsPerPageOptions = [10, 20, 50, 100]

// Sync with parent
watch(() => props.searchQuery, (newVal) => {
  localSearchQuery.value = newVal
})

watch(localSearchQuery, (newVal) => {
  emit('update:searchQuery', newVal)
  currentPageLocal.value = 1
})

// Filter equipos based on search
const filteredEquipos = computed(() => {
  if (!localSearchQuery.value) return props.equipos
  const query = localSearchQuery.value.toLowerCase()
  return props.equipos.filter(eq => 
    (eq.nombre_equipo && eq.nombre_equipo.toLowerCase().includes(query)) ||
    (eq.codigo_interno && eq.codigo_interno.toLowerCase().includes(query)) ||
    (eq.marca && eq.marca.toLowerCase().includes(query)) ||
    (eq.modelo && eq.modelo.toLowerCase().includes(query)) ||
    (eq.serie && eq.serie.toLowerCase().includes(query))
  )
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredEquipos.value.length / localItemsPerPage.value))

const paginatedEquipos = computed(() => {
  const start = (currentPageLocal.value - 1) * localItemsPerPage.value
  const end = start + localItemsPerPage.value
  return filteredEquipos.value.slice(start, end)
})

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPageLocal.value = page
  }
}

// Helper Functions
function getRiesgoBadgeClass(riesgo) {
  if (!riesgo) return 'risk-box-secondary'
  if (riesgo === 'III' || riesgo === 'IIb') return 'risk-box-danger'
  if (riesgo === 'IIa') return 'risk-box-warning'
  return 'risk-box-success'
}

function getEstadoBadgeClass(estado) {
  if (!estado) return 'estado-inactivo'
  if (estado === 'Activo') return 'estado-activo'
  if (estado === 'En Mantenimiento' || estado === 'Mantenimiento') return 'estado-mantenimiento'
  if (estado === 'Baja') return 'estado-baja'
  return 'estado-inactivo'
}

function formatEstado(estado) {
  if (!estado) return 'N/A'
  if (estado === 'En Mantenimiento') return 'Mantenimiento'
  return estado
}
</script>

<style scoped>
.equipos-table-container {
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
  white-space: nowrap;
}

td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
  vertical-align: middle;
}

tbody tr {
  background: white;
  transition: all 0.2s;
}

tbody tr:hover {
  background: rgba(0, 102, 51, 0.08);
}

.row-active {
  background: rgba(0, 102, 51, 0.05) !important;
  border-left: 4px solid #006633;
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

/* Badges */
.invima-badge {
  background: #e3f2fd;
  color: #1565c0;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 600;
  display: inline-block;
  border: 1px solid #bbdefb;
}

.risk-box {
  padding: 4px 8px;
  border-radius: 6px;
  font-size: 12px;
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
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
  font-size: 13px;
}

.btn-sm {
  padding: 6px 12px;
  font-size: 12px;
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
  margin: 0 auto;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
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
