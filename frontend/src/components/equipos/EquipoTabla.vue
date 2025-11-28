<template>
  <div class="equipos-table-container">
    <!-- Search Bar -->
    <div class="search-filter-container">
      <div class="search-section">
        <input 
          type="text" 
          v-model="localSearchQuery" 
          placeholder="🔍 Buscar por nombre, código, marca, modelo o serie..." 
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
            <th style="width: 20%;">Código Interno</th>
            <th style="width: 25%;">Nombre</th>
            <th style="width: 15%;">Marca</th>
            <th style="width: 15%;">Modelo</th>
            <th style="width: 15%;">Riesgo</th>
            <th style="width: 10%; text-align: center;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="i in 8" :key="i">
            <td><div class="skeleton-text"></div></td>
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

    <!-- Equipment Table -->
    <table v-else id="equiposTable">
      <thead>
        <tr>
          <th style="width: 20%;">Código Interno</th>
          <th style="width: 25%;">Nombre</th>
          <th style="width: 15%;">Marca</th>
          <th style="width: 15%;">Modelo</th>
          <th style="width: 15%;">Riesgo</th>
          <th style="width: 10%; text-align: center;">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <template v-for="equipo in paginatedEquipos" :key="equipo.id">
          <!-- Main Row -->
          <tr @click="$emit('toggleDetail', equipo.id)" style="cursor: pointer;">
            <td>
              <div style="font-weight: 600; color: #006633;">{{ equipo.codigo_interno }}</div>
            </td>
            <td>
              <div style="font-weight: 600;">{{ equipo.nombre_equipo }}</div>
              <div style="font-size: 12px; color: #9e9e9e;">{{ equipo.serie }}</div>
            </td>
            <td>
              <div style="font-size: 14px; color: #616161;">{{ equipo.marca || 'N/A' }}</div>
            </td>
            <td>
              <div style="font-size: 14px; color: #616161;">{{ equipo.modelo || 'N/A' }}</div>
            </td>
            <td>
              <span :class="['badge', getRiesgoBadgeClass(equipo.clasificacion_riesgo)]">
                {{ equipo.clasificacion_riesgo || 'N/A' }}
              </span>
            </td>
            <td @click.stop>
              <div style="display: flex; gap: 6px; justify-content: center;">
                <button class="btn btn-secondary btn-sm" @click="$emit('edit', equipo)" title="Editar">
                  ✏️
                </button>
                <button class="btn btn-danger btn-sm" @click="$emit('delete', equipo)" title="Eliminar">
                  🗑️
                </button>
              </div>
            </td>
          </tr>

          <!-- Expanded Detail Row (slot for parent to provide content) -->
          <tr v-if="expandedEquipoId === equipo.id" class="detail-row">
            <td colspan="6">
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

function getRiesgoBadgeClass(riesgo) {
  if (!riesgo) return 'badge-secondary'
  if (riesgo === 'III' || riesgo === 'IIb') return 'badge-danger'
  if (riesgo === 'IIa') return 'badge-warning'
  return 'badge-success'
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
  text-align: center;
  font-size: 13px;
  text-transform: uppercase;
  font-weight: bold;
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

.detail-row {
  background: #f9f9f9 !important;
}

.detail-row:hover {
  background: #f9f9f9 !important;
}

/* Badges */
.badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
}

.badge-danger {
  background: #ffebee;
  color: #c62828;
}

.badge-warning {
  background: #fff3e0;
  color: #e65100;
}

.badge-success {
  background: #e8f5e9;
  color: #2e7d32;
}

.badge-secondary {
  background: #f5f5f5;
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

.skeleton-buttons {
  width: 70%;
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
