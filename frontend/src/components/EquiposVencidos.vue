<script setup>
import { ref, computed, onMounted } from 'vue'
import { equiposAPI } from '../services/api'
import { filterEquiposBySearch } from '../utils/searchUtils'
import { useFormatting } from '../composables/useFormatting'
import { useModal } from '../composables/useModal'
import { useNotifications } from '../composables/useNotifications'
import ModalReprogramarMantenimiento from './modals/mantenimientos/ModalReprogramarMantenimiento.vue'
import ModalCompletarMantenimiento from './modals/mantenimientos/ModalCompletarMantenimiento.vue'

// Composables
const { formatFecha, formatUbicacion } = useFormatting()
const reprogramarModal = useModal()
const completarModal = useModal()
const { success, error: showError } = useNotifications()

// Data
const equipos = ref([])
const loading = ref(true)
const error = ref(null)
const searchQuery = ref('')

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

// Computed: Equipos vencidos
const equiposVencidos = computed(() => {
  let filtered = equipos.value.filter(eq => 
    eq.informacion_metrologica?.estado_mantenimiento === 'Vencido'
  )
  
  // Apply search filter
  filtered = filterEquiposBySearch(filtered, searchQuery.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})

// Pagination
const totalPages = computed(() => Math.ceil(equiposVencidos.value.length / itemsPerPage.value))

const paginatedEquipos = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return equiposVencidos.value.slice(start, end)
})

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) currentPage.value = page
}

// Modal handlers
function reprogramarMantenimiento(equipo) {
  reprogramarModal.open(equipo)
}

function completarMantenimiento(equipo) {
  completarModal.open(equipo)
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

async function handleCompletarSubmit(data) {
  try {
    const { mantenimientosAPI } = await import('../services/api')
    await mantenimientosAPI.create(data)
    completarModal.close()
    await fetchEquipos()
    success('Mantenimiento registrado exitosamente')
  } catch (err) {
    console.error('Error al completar mantenimiento:', err)
    showError('Error al registrar el mantenimiento')
  }
}

function getProximoMantenimientoDisplay(equipo) {
  const fecha = equipo.informacion_metrologica?.fecha_proximo_mantenimiento_calculada
  return formatFecha(fecha)
}
</script>

<template>
  <div class="equipos-vencidos-container">
    <div class="page-header">
      <div>
        <h2 class="page-title"><AppIcon name="alert" size="16" /> Realizar Revisión</h2>
        <div class="breadcrumb">Inicio / Mantenimientos / Realizar Revisión</div>
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
      <div class="section-header vencido">
        <h3><AppIcon name="alert" size="16" /> Equipos que Requieren Atención Inmediata ({{ equiposVencidos.length }})</h3>
        <p>Estos equipos tienen mantenimiento vencido y deben ser atendidos lo antes posible</p>
      </div>

      <!-- Search -->
      <div class="search-container">
        <input 
          v-model="searchQuery" 
          type="text" 
          class="search-input" 
          placeholder="Buscar por código, nombre, marca, modelo, sede o ubicación..."
        >
      </div>

      <!-- Table -->
      <table v-if="equiposVencidos.length > 0">
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
          <tr v-for="eq in paginatedEquipos" :key="eq.id" class="row-vencido">
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

      <!-- Empty state -->
      <div v-else class="empty-state">
        <div class="empty-state-content">
          <div class="empty-icon"><AppIcon name="check" size="16" /></div>
          <h3>¡Excelente! No hay equipos que requieran revisión inmediata</h3>
          <p>Todos los equipos están al día con su mantenimiento programado.</p>
        </div>
      </div>

      <!-- Pagination -->
      <div class="pagination-footer" v-if="equiposVencidos.length > 0">
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

    <!-- Modals -->
    <ModalReprogramarMantenimiento
      :show="reprogramarModal.isOpen.value"
      :equipo="reprogramarModal.data.value"
      @close="reprogramarModal.close()"
      @submit="handleReprogramarSubmit"
    />

    <ModalCompletarMantenimiento
      :show="completarModal.isOpen.value"
      :equipo="completarModal.data.value"
      @close="completarModal.close()"
      @submit="handleCompletarSubmit"
    />
  </div>
</template>

<style scoped>
@import '../assets/styles/components.css';

/* Separación entre barra de búsqueda y tabla */
.search-container {
  margin-bottom: 25px;
}
</style>
