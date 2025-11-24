<script setup>
import { ref, computed, onMounted, defineProps } from 'vue'
import { equiposAPI } from '../services/api'
import { filterEquiposBySearch } from '../utils/searchUtils'

const props = defineProps({
  viewMode: {
    type: String,
    default: 'all' // 'all', 'vencidos', 'proximos'
  }
})

// Reactive data
const equipos = ref([])
const loading = ref(true)
const error = ref(null)

// Pagination state
const itemsPerPage = ref(5)
const itemsPerPageOptions = [5, 10, 20, 50]

const pageVencidos = ref(1)
const pageProximos = ref(1)
const pageNormales = ref(1)

// Search state
const searchVencidos = ref('')
const searchProximos = ref('')
const searchNormales = ref('')

// Month filter for Próximos
const monthsFilter = ref(3)
const monthsOptions = [
  { value: 3, label: 'Próximos 3 meses' },
  { value: 6, label: 'Próximos 6 meses' },
  { value: 12, label: 'Próximos 12 meses' }
]

// Fetch equipment with maintenance info
async function fetchEquipos() {
  try {
    loading.value = true
    const response = await equiposAPI.getAll()
    
    // Filter only equipment that requires maintenance AND is active
    equipos.value = response.data.filter(eq => 
      eq.informacion_metrologica?.requiere_mantenimiento &&
      eq.estado === 'Activo'
    )
  } catch (err) {
    console.error('Error fetching equipment:', err)
    error.value = 'Error al cargar equipos'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchEquipos()
})

// Computed properties para clasificar equipos usando la lógica del backend
const equiposVencidos = computed(() => {
  let filtered = equipos.value.filter(eq => 
    eq.informacion_metrologica?.estado_mantenimiento === 'Vencido'
  )
  
  // Apply search filter using centralized function
  filtered = filterEquiposBySearch(filtered, searchVencidos.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})

const equiposProximosVencer = computed(() => {
  const hoy = new Date()
  const limite = new Date()
  limite.setMonth(hoy.getMonth() + monthsFilter.value)
  
  // Filter equipment that:
  // 1. Requires maintenance
  // 2. Next maintenance date is in the future (not overdue)
  // 3. Next maintenance date is within selected months range
  let filtered = equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    
    const fechaProxima = new Date(eq.informacion_metrologica?.fecha_proximo_mantenimiento_calculada)
    if (!fechaProxima || isNaN(fechaProxima.getTime())) return false
    
    // Must be in the future (not overdue)
    if (fechaProxima < hoy) return false
    
    // Must be within selected months range
    return fechaProxima <= limite
  })
  
  // Apply search filter using centralized function
  filtered = filterEquiposBySearch(filtered, searchProximos.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})

const equiposNormales = computed(() => {
  let filtered = equipos.value.filter(eq => 
    eq.informacion_metrologica?.estado_mantenimiento === 'Normal'
  )
  
  // Apply search filter using centralized function
  filtered = filterEquiposBySearch(filtered, searchNormales.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})

// Total counts before filtering (for v-if display logic)
const totalVencidosBeforeFilter = computed(() => 
  equipos.value.filter(eq => eq.informacion_metrologica?.estado_mantenimiento === 'Vencido').length
)

const totalProximosBeforeFilter = computed(() => {
  // Count all equipment with upcoming maintenance within any reasonable timeframe
  const hoy = new Date()
  return equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    const fechaProxima = new Date(eq.informacion_metrologica?.fecha_proximo_mantenimiento_calculada)
    if (!fechaProxima || isNaN(fechaProxima.getTime())) return false
    return fechaProxima >= hoy // Any future maintenance
  }).length  
})

const totalNormalesBeforeFilter = computed(() => 
  equipos.value.filter(eq => eq.informacion_metrologica?.estado_mantenimiento === 'Normal').length
)

// Pagination Computed Properties
const totalPagesVencidos = computed(() => Math.ceil(equiposVencidos.value.length / itemsPerPage.value))
const paginatedVencidos = computed(() => {
  const start = (pageVencidos.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return equiposVencidos.value.slice(start, end)
})

const totalPagesProximos = computed(() => Math.ceil(equiposProximosVencer.value.length / itemsPerPage.value))
const paginatedProximos = computed(() => {
  const start = (pageProximos.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return equiposProximosVencer.value.slice(start, end)
})

const totalPagesNormales = computed(() => Math.ceil(equiposNormales.value.length / itemsPerPage.value))
const paginatedNormales = computed(() => {
  const start = (pageNormales.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return equiposNormales.value.slice(start, end)
})

// Pagination Methods
function changePageVencidos(page) {
  if (page >= 1 && page <= totalPagesVencidos.value) pageVencidos.value = page
}

function changePageProximos(page) {
  if (page >= 1 && page <= totalPagesProximos.value) pageProximos.value = page
}

function changePageNormales(page) {
  if (page >= 1 && page <= totalPagesNormales.value) pageNormales.value = page
}

function formatFecha(fecha) {
  if (!fecha) return 'N/A'
  const date = new Date(fecha)
  const meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ]
  return `${meses[date.getMonth()]} ${date.getFullYear()}`
}

function getProximoMantenimientoDisplay(equipo) {
  const fecha = equipo.informacion_metrologica?.fecha_proximo_mantenimiento_calculada
  return formatFecha(fecha)
}

function reprogramarMantenimiento(equipo) {
  // TODO: Implementar modal de reprogramación
  alert(`Reprogramar mantenimiento para: ${equipo.nombre_equipo}`)
}

function completarMantenimiento(equipo) {
  // TODO: Implementar modal de completar mantenimiento
  alert(`Completar mantenimiento para: ${equipo.nombre_equipo}`)
}
</script>

<template>
  <div class="equipos-pendientes-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">
          {{ viewMode === 'vencidos' ? 'Realizar Mantenimiento' : 
             viewMode === 'proximos' ? 'Próximos de Revisión' : 
             'Equipos Pendientes de Mantenimiento' }}
        </h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">
          Inicio / Mantenimientos / {{ viewMode === 'vencidos' ? 'Realizar Mantenimiento' : viewMode === 'proximos' ? 'Próximos de Revisión' : 'Equipos Pendientes' }}
        </div>
      </div>
    </div>

    <!-- Loading Skeleton -->
    <div v-if="loading">
      <div class="content-card skeleton">
        <div class="skeleton-line" style="width: 40%; height: 24px; margin-bottom: 20px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 60px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px;"></div>
      </div>
      
      <div class="content-card skeleton" style="margin-top: 20px;">
        <div class="skeleton-line" style="width: 40%; height: 24px; margin-bottom: 20px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 60px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px;"></div>
      </div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>

    <!-- Content -->
    <div v-else>
      <!-- Equipos Vencidos -->
      <div class="content-card" v-if="(viewMode === 'all' || viewMode === 'vencidos') && equiposVencidos.length > 0">
        <div class="section-header vencido">
          <h3>⚠️ Realizar Mantenimiento ({{ equiposVencidos.length }})</h3>
          <p>Equipos que requieren atención inmediata</p>
        </div>
        <table>
          <thead>
            <tr>
              <th>Código</th>
              <th>Equipo</th>
              <th>Registro INVIMA</th>
              <th>Riesgo</th>
              <th>Sede / Servicio</th>
              <th>Último Mant.</th>
              <th>Próximo Mant.</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="eq in paginatedVencidos" :key="eq.id" class="row-vencido">
              <td><strong>{{ eq.codigo_interno }}</strong></td>
              <td>
                <div style="font-weight: 600;">{{ eq.nombre_equipo }}</div>
                <div style="font-size: 12px; color: #616161;">{{ eq.marca }} - {{ eq.modelo }}</div>
              </td>
              <td><span class="invima-badge">{{ eq.registro_invima || 'N/A' }}</span></td>
              <td><span class="riesgo-badge" :class="'riesgo-' + (eq.clasificacion_riesgo || 'na')">{{ eq.clasificacion_riesgo || 'N/A' }}</span></td>
              <td>
                <div style="font-weight: 600;">{{ eq.sede?.nombre || 'N/A' }}</div>
                <div style="font-size: 12px; color: #616161;">{{ eq.servicio?.nombre || 'N/A' }}</div>
              </td>
              <td>{{ formatFecha(eq.informacion_metrologica?.ultimo_mantenimiento) }}</td>
              <td><strong style="color: #f44336;">{{ getProximoMantenimientoDisplay(eq) }}</strong></td>
              <td>
                <div style="display: flex; gap: 10px;">
                  <button class="btn-action btn-completar" @click="completarMantenimiento(eq)" title="Marcar como completado">
                    Completar
                  </button>
                  <button class="btn-action btn-reprogramar" @click="reprogramarMantenimiento(eq)" title="Reprogramar mantenimiento">
                    Reprogramar
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- Pagination Footer Vencidos -->
        <div class="pagination-footer">
          <div class="items-per-page">
            <span>Mostrar</span>
            <select v-model="itemsPerPage" class="page-select">
              <option v-for="opt in itemsPerPageOptions" :key="opt" :value="opt">{{ opt }}</option>
            </select>
            <span>registros</span>
          </div>
          <div class="page-navigation">
            <button class="page-btn" :disabled="pageVencidos === 1" @click="changePageVencidos(pageVencidos - 1)">Anterior</button>
            <span class="page-info">
              Página 
              <input type="number" v-model="pageVencidos" min="1" :max="totalPagesVencidos" class="page-input" @change="changePageVencidos(pageVencidos)">
              de {{ totalPagesVencidos }}
            </span>
            <button class="page-btn" :disabled="pageVencidos === totalPagesVencidos" @click="changePageVencidos(pageVencidos + 1)">Siguiente</button>
          </div>
        </div>
      </div>

      <!-- Equipos Próximos a Vencer -->
      <div class="content-card" v-if="(viewMode === 'all' || viewMode === 'proximos') && totalProximosBeforeFilter > 0">
        <div class="section-header proximo">
          <h3>⏰ Próximos a Revisión ({{ equiposProximosVencer.length }})</h3>
          <p>Equipos que requieren mantenimiento en los próximos {{ monthsFilter }} meses</p>
        </div>
        
        <!-- Filter Controls -->
        <div class="filter-controls">
          <div class="month-filter">
            <label for="months-filter">Mostrar equipos:</label>
            <select id="months-filter" v-model="monthsFilter" class="filter-select">
              <option v-for="opt in monthsOptions" :key="opt.value" :value="opt.value">
                {{ opt.label }}
              </option>
            </select>
          </div>
          <div class="search-container-inline">
            <input 
              v-model="searchProximos" 
              type="text" 
              class="search-input" 
              placeholder="🔍 Buscar por código, nombre, marca, modelo, sede o servicio..."
            >
          </div>
        </div>
        
        <table>
          <thead>
            <tr>
              <th>Código</th>
              <th>Equipo</th>
              <th>Registro INVIMA</th>
              <th>Riesgo</th>
              <th>Sede / Servicio</th>
              <th>Último Mant.</th>
              <th>Próximo Mant.</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="eq in paginatedProximos" :key="eq.id" class="row-proximo">
              <td><strong>{{ eq.codigo_interno }}</strong></td>
              <td>
                <div style="font-weight: 600;">{{ eq.nombre_equipo }}</div>
                <div style="font-size: 12px; color: #616161;">{{ eq.marca }} - {{ eq.modelo }}</div>
              </td>
              <td><span class="invima-badge">{{ eq.registro_invima || 'N/A' }}</span></td>
              <td><span class="riesgo-badge" :class="'riesgo-' + (eq.clasificacion_riesgo || 'na')">{{ eq.clasificacion_riesgo || 'N/A' }}</span></td>
              <td>
                <div style="font-weight: 600;">{{ eq.sede?.nombre || 'N/A' }}</div>
                <div style="font-size: 12px; color: #616161;">{{ eq.servicio?.nombre || 'N/A' }}</div>
              </td>
              <td>{{ formatFecha(eq.informacion_metrologica?.ultimo_mantenimiento) }}</td>
              <td><strong style="color: #ff9800;">{{ getProximoMantenimientoDisplay(eq) }}</strong></td>
              <td>
                <div style="display: flex; gap: 10px;">
                  <button class="btn-action btn-reprogramar" @click="reprogramarMantenimiento(eq)" title="Reprogramar mantenimiento">
                    Reprogramar
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- No Results Message -->
        <div v-if="equiposProximosVencer.length === 0" class="no-results">
          🔍 No se encontraron equipos que coincidan con tu búsqueda
        </div>

        <!-- Pagination Footer Proximos -->
        <div class="pagination-footer">
          <div class="items-per-page">
            <span>Mostrar</span>
            <select v-model="itemsPerPage" class="page-select">
              <option v-for="opt in itemsPerPageOptions" :key="opt" :value="opt">{{ opt }}</option>
            </select>
            <span>registros</span>
          </div>
          <div class="page-navigation">
            <button class="page-btn" :disabled="pageProximos === 1" @click="changePageProximos(pageProximos - 1)">Anterior</button>
            <span class="page-info">
              Página 
              <input type="number" v-model="pageProximos" min="1" :max="totalPagesProximos" class="page-input" @change="changePageProximos(pageProximos)">
              de {{ totalPagesProximos }}
            </span>
            <button class="page-btn" :disabled="pageProximos === totalPagesProximos" @click="changePageProximos(pageProximos + 1)">Siguiente</button>
          </div>
        </div>
      </div>

      <!-- Equipos Normales -->
      <div class="content-card" v-if="viewMode === 'all' && equiposNormales.length > 0">
        <div class="section-header normal">
          <h3>✅ Mantenimiento Programado ({{ equiposNormales.length }})</h3>
          <p>Equipos con mantenimiento programado a más de 3 meses</p>
        </div>
        <table>
          <thead>
            <tr>
              <th>Código</th>
              <th>Equipo</th>
              <th>Registro INVIMA</th>
              <th>Riesgo</th>
              <th>Sede / Servicio</th>
              <th>Último Mant.</th>
              <th>Próximo Mant.</th>
              <th>Frecuencia</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="eq in paginatedNormales" :key="eq.id">
              <td><strong>{{ eq.codigo_interno }}</strong></td>
              <td>
                <div style="font-weight: 600;">{{ eq.nombre_equipo }}</div>
                <div style="font-size: 12px; color: #616161;">{{ eq.marca }} - {{ eq.modelo }}</div>
              </td>
              <td><span class="invima-badge">{{ eq.registro_invima || 'N/A' }}</span></td>
              <td><span class="riesgo-badge" :class="'riesgo-' + (eq.clasificacion_riesgo || 'na')">{{ eq.clasificacion_riesgo || 'N/A' }}</span></td>
              <td>
                <div style="font-weight: 600;">{{ eq.sede?.nombre || 'N/A' }}</div>
                <div style="font-size: 12px; color: #616161;">{{ eq.servicio?.nombre || 'N/A' }}</div>
              </td>
              <td>{{ formatFecha(eq.informacion_metrologica?.ultimo_mantenimiento) }}</td>
              <td>{{ getProximoMantenimientoDisplay(eq) }}</td>
              <td>{{ eq.informacion_metrologica?.frecuencia_mantenimiento || 'N/A' }}</td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination Footer Normales -->
        <div class="pagination-footer">
          <div class="items-per-page">
            <span>Mostrar</span>
            <select v-model="itemsPerPage" class="page-select">
              <option v-for="opt in itemsPerPageOptions" :key="opt" :value="opt">{{ opt }}</option>
            </select>
            <span>registros</span>
          </div>
          <div class="page-navigation">
            <button class="page-btn" :disabled="pageNormales === 1" @click="changePageNormales(pageNormales - 1)">Anterior</button>
            <span class="page-info">
              Página 
              <input type="number" v-model="pageNormales" min="1" :max="totalPagesNormales" class="page-input" @change="changePageNormales(pageNormales)">
              de {{ totalPagesNormales }}
            </span>
            <button class="page-btn" :disabled="pageNormales === totalPagesNormales" @click="changePageNormales(pageNormales + 1)">Siguiente</button>
          </div>
        </div>
      </div>

      <!-- No data message -->
      <div v-if="equiposVencidos.length === 0 && equiposProximosVencer.length === 0 && equiposNormales.length === 0" class="content-card" style="text-align: center; padding: 40px;">
        <p style="color: #616161;">No hay equipos con mantenimiento programado</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.equipos-pendientes-container {
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
  max-width: 100%;
}

.section-header {
  margin-bottom: 20px;
  padding: 15px;
  border-radius: 8px;
  border-left: 4px solid;
}

.section-header h3 {
  margin: 0 0 5px 0;
  font-size: 18px;
}

.section-header p {
  margin: 0;
  font-size: 14px;
  opacity: 0.8;
}

.section-header.vencido {
  background: rgba(244, 67, 54, 0.1);
  border-left-color: #f44336;
  color: #f44336;
}

.section-header.proximo {
  background: rgba(255, 152, 0, 0.1);
  border-left-color: #ff9800;
  color: #ff9800;
}

.section-header.normal {
  background: rgba(76, 175, 80, 0.1);
  border-left-color: #4CAF50;
  color: #4CAF50;
}

.search-container {
  margin-bottom: 20px;
}

.filter-controls {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
  align-items: center;
  flex-wrap: wrap;
}

.month-filter {
  display: flex;
  align-items: center;
  gap: 10px;
}

.month-filter label {
  font-weight: 600;
  font-size: 14px;
  color: #212121;
  white-space: nowrap;
}

.filter-select {
  padding: 10px 14px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  background: white;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 500;
}

.filter-select:hover {
  border-color: #006633;
}

.filter-select:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.search-container-inline {
  flex: 1;
  min-width: 300px;
}

.search-input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s;
}

.search-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.no-results {
  text-align: center;
  padding: 40px 20px;
  color: #616161;
  font-size: 14px;
  background: rgba(0, 102, 51, 0.02);
  border-radius: 8px;
  margin-top: 20px;
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

.row-vencido {
  background: white;
}

.row-vencido:hover {
  background: rgba(0, 102, 51, 0.08) !important;
}

.row-proximo {
  background: white;
}

.row-proximo:hover {
  background: rgba(255, 152, 0, 0.1) !important;
}

.badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
}

.badge-danger {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
}

.badge-warning {
  background: rgba(255, 152, 0, 0.1);
  color: #ff9800;
}

.invima-badge {
  font-size: 11px;
  padding: 3px 8px;
  background: rgba(0, 102, 51, 0.1);
  color: #006633;
  border-radius: 4px;
  font-weight: 600;
}

.riesgo-badge {
  font-size: 11px;
  padding: 3px 8px;
  border-radius: 4px;
  font-weight: 600;
  display: inline-block;
  min-width: 40px;
  text-align: center;
}

.riesgo-I {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}

.riesgo-IIa {
  background: rgba(255, 152, 0, 0.1);
  color: #ff9800;
}

.riesgo-IIb {
  background: rgba(255, 87, 34, 0.1);
  color: #ff5722;
}

.riesgo-III {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
}

.riesgo-na {
  background: rgba(158, 158, 158, 0.1);
  color: #9e9e9e;
}

.btn-action {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 600;
  font-size: 12px;
  transition: all 0.2s;
  white-space: nowrap;
}

.btn-action:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.btn-completar {
  background: #4CAF50;
  color: white;
}

.btn-completar:hover {
  background: #45a049;
}

.btn-reprogramar {
  background: #ff9800;
  color: white;
}

.btn-reprogramar:hover {
  background: #fb8c00;
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


