<script setup>
import { ref, computed, onMounted } from 'vue'
import { equiposAPI } from '../services/api'
import { filterEquiposBySearch } from '../utils/searchUtils'
import { useFormatting } from '../composables/useFormatting'
import { useDateCalculations } from '../composables/useDateCalculations'
import { useModal } from '../composables/useModal'
import { useNotifications } from '../composables/useNotifications'
import { OPCIONES_FILTRO_MESES } from '../constants/mantenimiento'
import ModalReprogramarMantenimiento from './modals/mantenimientos/ModalReprogramarMantenimiento.vue'

// Composables
const { formatFecha, formatUbicacion } = useFormatting()
const { isDateUpcoming, isDateOverdue } = useDateCalculations()
const reprogramarModal = useModal()
const { success, error: showError } = useNotifications()

// Data
const equipos = ref([])
const loading = ref(true)
const error = ref(null)
const searchQuery = ref('')

// Filters
const monthsFilter = ref(3)

// Pagination
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [5, 10, 20, 50]

// Fetch equipment
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

// Computed: Equipos próximos a vencer
const equiposProximos = computed(() => {
  let filtered = equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    
    const fechaProxima = eq.informacion_metrologica?.fecha_proximo_mantenimiento_calculada
    if (!fechaProxima) return false
    
    // Parse the date
    const [year, month, day] = fechaProxima.split('T')[0].split('-').map(Number)
    const fechaDate = new Date(year, month - 1, day)
    const hoy = new Date()
    hoy.setHours(0, 0, 0, 0)
    
    // Exclude current month (should appear in "Realizar Revisión")
    if (fechaDate.getFullYear() === hoy.getFullYear() && fechaDate.getMonth() === hoy.getMonth()) {
      return false
    }
    
    // Exclude overdue dates
    if (fechaDate < hoy) return false
    
    // Check if within selected months range
    const limite = new Date(hoy)
    limite.setMonth(limite.getMonth() + monthsFilter.value)
    
    return fechaDate <= limite
  })
  
  // Apply search filter
  filtered = filterEquiposBySearch(filtered, searchQuery.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})

// Pagination
const totalPages = computed(() => Math.ceil(equiposProximos.value.length / itemsPerPage.value))

const paginatedEquipos = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return equiposProximos.value.slice(start, end)
})

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) currentPage.value = page
}

// Modal handlers
function reprogramarMantenimiento(equipo) {
  reprogramarModal.open(equipo)
}

async function handleReprogramarSubmit({ equipoId, nuevaFecha }) {
  try {
    await equiposAPI.reprogramar(equipoId, nuevaFecha)
    reprogramarModal.close()
    await fetchEquipos()
    success('Mantenimiento reprogramado exitosamente')
  } catch (err) {
    console.error('Error al reprogramar:', err)
    showError('Error al reprogramar el mantenimiento')
  }
}

function getProximoMantenimientoDisplay(equipo) {
  const fecha = equipo.informacion_metrologica?.fecha_proximo_mantenimiento_calculada
  return formatFecha(fecha)
}
</script>

<template>
  <div class="equipos-proximos-container">
    <div class="page-header">
      <div>
        <h2 class="page-title"><AppIcon name="clock" size="16" /> Próximos de Revisión</h2>
        <div class="breadcrumb">Inicio / Mantenimientos / Próximos de Revisión</div>
      </div>
    </div>

    <!-- Loading Skeleton -->
    <div v-if="loading" class="content-card skeleton-table">
      <div class="skeleton-block" style="width: 40%; height: 28px; margin-bottom: 20px;"></div>
      <div class="skeleton-block" style="width: 100%; height: 50px; margin-bottom: 20px;"></div>
      <table>
        <thead>
          <tr>
            <th>Código</th>
            <th>Equipo</th>
            <th>Registro INVIMA</th>
            <th>Riesgo</th>
            <th>Sede / Ubicación</th>
            <th>Último Mant.</th>
            <th>Próximo Mant.</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="i in 3" :key="'skeleton-'+i">
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text skeleton-badge"></div></td>
            <td><div class="skeleton-text skeleton-badge"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text skeleton-buttons"></div></td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>

    <!-- Content -->
    <div v-else class="content-card">
      <div class="section-header proximo">
        <h3><AppIcon name="clock" size="16" /> Equipos Próximos a Revisión ({{ equiposProximos.length }})</h3>
        <p>Equipos que requieren mantenimiento en los próximos {{ monthsFilter }} meses</p>
      </div>

      <!-- Filter Controls -->
      <div class="filter-controls">
        <div class="month-filter">
          <label for="months-filter">Mostrar equipos:</label>
          <select id="months-filter" v-model="monthsFilter" class="filter-select">
            <option v-for="opt in OPCIONES_FILTRO_MESES" :key="opt.value" :value="opt.value">
              {{ opt.label }}
            </option>
          </select>
        </div>
        <div class="search-container-inline">
          <input 
            v-model="searchQuery" 
            type="text" 
            class="search-input" 
            placeholder="Buscar por código, nombre, marca, modelo, sede o ubicación..."
          >
        </div>
      </div>

      <!-- Table -->
      <table v-if="equiposProximos.length > 0">
        <thead>
          <tr>
            <th>Código</th>
            <th>Equipo</th>
            <th>Registro INVIMA</th>
            <th>Riesgo</th>
            <th>Sede / Ubicación</th>
            <th>Último Mant.</th>
            <th>Próximo Mant.</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="eq in paginatedEquipos" :key="eq.id" class="row-proximo">
            <td><strong>{{ eq.codigo_interno }}</strong></td>
            <td>
              <div style="font-weight: 600;">{{ eq.nombre_equipo }}</div>
              <div style="font-size: 12px; color: #616161;">{{ eq.marca }} - {{ eq.modelo }}</div>
            </td>
            <td><span class="invima-badge">{{ eq.registro_invima || 'N/A' }}</span></td>
            <td><span class="riesgo-badge" :class="'riesgo-' + (eq.clasificacion_riesgo || 'na')">{{ eq.clasificacion_riesgo || 'N/A' }}</span></td>
            <td>
              <div style="font-weight: 600;">{{ eq.sede?.nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(eq.ubicacion?.nombre) }}</div>
            </td>
            <td>{{ formatFecha(eq.informacion_metrologica?.ultimo_mantenimiento) }}</td>
            <td><strong style="color: #ff9800;">{{ getProximoMantenimientoDisplay(eq) }}</strong></td>
            <td>
              <button class="btn-action btn-reprogramar" @click="reprogramarMantenimiento(eq)" title="Reprogramar mantenimiento">
                Reprogramar
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Empty state -->
      <div v-else class="empty-state">
        <div class="empty-state-content">
          <div class="empty-icon"><AppIcon name="check" size="16" /></div>
          <h3>No hay equipos próximos a revisión</h3>
          <p>No hay equipos que requieran mantenimiento en los próximos {{ monthsFilter }} meses.</p>
          <p class="empty-hint">Intenta aumentar el rango de meses usando el filtro arriba.</p>
        </div>
      </div>

      <!-- Pagination -->
      <div class="pagination-footer" v-if="equiposProximos.length > 0">
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

    <!-- Modal -->
    <ModalReprogramarMantenimiento
      :show="reprogramarModal.isOpen.value"
      :equipo="reprogramarModal.data.value"
      @close="reprogramarModal.close()"
      @submit="handleReprogramarSubmit"
    />
  </div>
</template>

<style scoped>
@import '../assets/styles/components.css';

/* Estilos específicos para filter-select si es diferente del archivo general */
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
</style>
