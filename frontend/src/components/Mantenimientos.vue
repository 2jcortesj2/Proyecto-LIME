<script setup>
import { ref, onMounted, computed } from 'vue'
import { mantenimientosAPI } from '../services/api'

// Data de mantenimientos
const mantenimientos = ref([])
const loading = ref(true)
const error = ref(null)

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [5, 10, 20, 50]

// Accordion state
const expandedRows = ref(new Set())

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

// Pagination Logic
const totalPages = computed(() => Math.ceil(mantenimientos.value.length / itemsPerPage.value))

const paginatedMantenimientos = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return mantenimientos.value.slice(start, end)
})

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

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
  // Aquí se implementaría la lógica para crear un nuevo mantenimiento
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
          <input type="text" class="search-input" placeholder="🔍 Buscar por código, equipo, tipo o proveedor...">
        </div>
        <button class="filter-button">☰ Filtrar y Ordenar</button>
      </div>

      <table v-if="mantenimientos.length > 0">
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
                      <span class="detail-label">Registrado Por:</span>
                      <span class="detail-value">{{ mant.usuario_registro }}</span>
                    </div>
                    <div class="detail-item-horizontal">
                      <span class="detail-label">Descripción:</span>
                      <span class="detail-value">{{ mant.descripcion }}</span>
                    </div>
                  </div>

                  <!-- Observaciones Section - Will include edit history in the future -->
                  <div class="observaciones-section" v-if="mant.observaciones">
                    <h4 class="observaciones-title">💬 Observaciones</h4>
                    <div class="observaciones-content">
                      {{ mant.observaciones }}
                    </div>
                    <!-- Future: Automatic edit history will be appended here -->
                    <!-- Example: "Editado el 23/11/2024 10:30 por Admin LIME - Motivo: Corrección de costo" -->
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
      <p v-else style="text-align: center; color: #616161; padding: 40px;">
        No hay mantenimientos registrados
      </p>

      <!-- Pagination Footer -->
      <div class="pagination-footer" v-if="mantenimientos.length > 0">
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
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  color: #616161;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-button:hover {
  background: #f5f5f5;
  color: #006633;
  border-color: #006633;
}

table {
  width: 100%;
  border-collapse: collapse;
  table-layout: auto;
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
  white-space: nowrap;
  font-weight: 600;
}

td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
  vertical-align: middle;
}

tbody tr {
  cursor: pointer;
  transition: all 0.2s;
  position: relative;
}

tbody tr:hover {
  background: rgba(0, 102, 51, 0.08);
}

tbody tr:hover td:first-child {
  font-weight: 600;
}

tbody tr td:last-child {
  cursor: default;
}

.btn {
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 500;
}

.btn-primary {
  background: #006633;
  color: white;
  padding: 10px 20px;
}

.btn-primary:hover {
  background: #2d5016;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.2);
}

.btn-sm {
  padding: 8px 16px;
  font-size: 13px;
}

.btn-info {
  background: #00a99d;
  color: white;
}

.btn-info:hover {
  opacity: 0.9;
}

.btn-secondary {
  background: #d0d0d0;
  color: #212121;
}

.btn-secondary:hover {
  background: #c0c0c0;
}

.btn-close {
  background: #b0b0b0;
  color: #212121;
  font-weight: 600;
}

.btn-close:hover {
  background: #a0a0a0;
}

.btn-danger {
  background: #f44336;
  color: white;
}

.btn-danger:hover {
  opacity: 0.9;
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
tbody tr.row-active {
  background: rgba(0, 102, 51, 0.12) !important;
  border-left: 4px solid #006633;
}

.accordion-details-row {
  display: none;
}

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

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 25px;
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

.detail-section {
  background: white;
  padding: 20px;
  border-radius: 8px;
  border-left: 4px solid #006633;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.detail-section-title {
  font-size: 14px;
  color: #006633;
  font-weight: 700;
  margin-bottom: 15px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid #f0f0f0;
  padding-bottom: 8px;
}

.detail-item {
  display: flex;
  margin-bottom: 12px;
  font-size: 14px;
  line-height: 1.5;
}

.detail-label {
  font-weight: 600;
  color: #616161;
  min-width: 140px;
}

.detail-value {
  color: #212121;
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

