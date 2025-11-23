<script setup>
import { ref, onMounted, defineEmits } from 'vue'
import { dashboardAPI, equiposAPI } from '../services/api'

const emit = defineEmits(['changePage'])

// Reactive data
const stats = ref({
  total_equipos: 0,
  mantenimientos_pendientes: 0,
  calibraciones_proximas: 0
})

const equiposRecientes = ref([])
const loading = ref(true)
const error = ref(null)

// Helper function to calculate next maintenance date (same as EquiposPendientes)
function calcularProximoMantenimiento(equipo) {
  if (!equipo.registro_adquisicion?.fecha_adquisicion) return null
  if (!equipo.informacion_metrologica?.frecuencia_mantenimiento) return null
  
  const fechaIngreso = new Date(equipo.registro_adquisicion.fecha_adquisicion)
  const frecuencia = equipo.informacion_metrologica.frecuencia_mantenimiento.toLowerCase()
  
  if (equipo.informacion_metrologica.proximo_mantenimiento) {
    return new Date(equipo.informacion_metrologica.proximo_mantenimiento)
  }
  
  const fechaProxima = new Date(fechaIngreso)
  
  if (frecuencia.includes('anual') || frecuencia.includes('1')) {
    fechaProxima.setFullYear(fechaProxima.getFullYear() + 1)
  } else if (frecuencia.includes('semestral') || frecuencia.includes('6')) {
    fechaProxima.setMonth(fechaProxima.getMonth() + 6)
  } else if (frecuencia.includes('trimestral') || frecuencia.includes('3')) {
    fechaProxima.setMonth(fechaProxima.getMonth() + 3)
  } else if (frecuencia.includes('mensual')) {
    fechaProxima.setMonth(fechaProxima.getMonth() + 1)
  } else {
    fechaProxima.setFullYear(fechaProxima.getFullYear() + 1)
  }
  
  return fechaProxima
}

// Calculate dashboard stats from equipment data
async function fetchDashboardStats() {
  try {
    const response = await equiposAPI.getAll()
    const todosEquipos = response.data
    
    stats.value.total_equipos = todosEquipos.length
    
    // Calculate maintenance counts using same logic as EquiposPendientes
    const hoy = new Date()
    const mesActual = hoy.getMonth() + 1
    const anioActual = hoy.getFullYear()
    
    let mesLimite = mesActual + 3
    let anioLimite = anioActual
    if (mesLimite > 12) {
      mesLimite -= 12
      anioLimite += 1
    }
    
    let vencidos = 0
    let proximos = 0
    let calibraciones = 0
    
    todosEquipos.forEach(eq => {
      if (!eq.informacion_metrologica?.requiere_mantenimiento) return
      
      const fechaProxima = calcularProximoMantenimiento(eq)
      if (!fechaProxima) return
      
      const mesProximo = fechaProxima.getMonth() + 1
      const anioProximo = fechaProxima.getFullYear()
      
      // Vencidos
      if ((anioProximo < anioActual) || (anioProximo === anioActual && mesProximo < mesActual)) {
        vencidos++
      }
      // Próximos (dentro de 3 meses pero no vencidos)
      else if ((anioProximo < anioLimite) || (anioProximo === anioLimite && mesProximo <= mesLimite)) {
        proximos++
      }
      
      // Calibraciones próximas
      if (eq.informacion_metrologica?.requiere_calibracion && eq.informacion_metrologica?.proxima_calibracion) {
        const fechaCal = new Date(eq.informacion_metrologica.proxima_calibracion)
        const mesCal = fechaCal.getMonth() + 1
        const anioCal = fechaCal.getFullYear()
        
        if ((anioCal < anioLimite) || (anioCal === anioLimite && mesCal <= mesLimite)) {
          calibraciones++
        }
      }
    })
    
    stats.value.mantenimientos_pendientes = vencidos + proximos
    stats.value.calibraciones_proximas = calibraciones
    
  } catch (err) {
    console.error('Error fetching dashboard stats:', err)
    error.value = 'Error al cargar estadísticas'
  }
}

// Fetch recent equipment
async function fetchEquiposRecientes() {
  try {
    const response = await equiposAPI.getAll({ limit: 3 })
    equiposRecientes.value = response.data.slice(0, 3)
  } catch (err) {
    console.error('Error fetching recent equipment:', err)
    error.value = 'Error al cargar equipos recientes'
  }
}

// Load all data on mount
onMounted(async () => {
  loading.value = true
  await Promise.all([
    fetchDashboardStats(),
    fetchEquiposRecientes()
  ])
  loading.value = false
})

function navigateToPage(page) {
  emit('changePage', page)
}

function formatDate(dateString) {
  if (!dateString) return 'N/A'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-CO')
}
</script>

<template>
  <div class="dashboard-container">
    <h2 class="page-title">Información General</h2>

    <!-- Loading Skeleton -->
    <div v-if="loading">
      <div class="stats-grid">
        <div class="stat-card skeleton">
          <div class="skeleton-line" style="width: 60%; height: 16px; margin-bottom: 10px;"></div>
          <div class="skeleton-line" style="width: 40%; height: 32px; margin-bottom: 10px;"></div>
          <div class="skeleton-line" style="width: 70%; height: 14px;"></div>
        </div>
        <div class="stat-card skeleton">
          <div class="skeleton-line" style="width: 60%; height: 16px; margin-bottom: 10px;"></div>
          <div class="skeleton-line" style="width: 40%; height: 32px; margin-bottom: 10px;"></div>
          <div class="skeleton-line" style="width: 70%; height: 14px;"></div>
        </div>
        <div class="stat-card skeleton">
          <div class="skeleton-line" style="width: 60%; height: 16px; margin-bottom: 10px;"></div>
          <div class="skeleton-line" style="width: 40%; height: 32px; margin-bottom: 10px;"></div>
          <div class="skeleton-line" style="width: 70%; height: 14px;"></div>
        </div>
      </div>
      
      <div class="content-card skeleton" style="margin-top: 30px;">
        <div class="skeleton-line" style="width: 40%; height: 24px; margin-bottom: 20px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px; margin-bottom: 10px;"></div>
        <div class="skeleton-line" style="width: 100%; height: 50px;"></div>
      </div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      {{ error }}
    </div>

    <!-- Dashboard Content -->
    <div v-else>
      <!-- Stats Grid -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-label">Total Equipos</div>
          <div class="stat-value">{{ stats.total_equipos }}</div>
          <div class="stat-trend success">Registrados en el sistema</div>
        </div>
        <div class="stat-card" style="border-left-color: #003d6b;">
          <div class="stat-label">Mantenimientos Pendientes</div>
          <div class="stat-value">{{ stats.mantenimientos_pendientes }}</div>
          <div class="stat-trend warning">Próximos 30 días</div>
        </div>
        <div class="stat-card" style="border-left-color: #4CAF50;">
          <div class="stat-label">Calibraciones Próximas</div>
          <div class="stat-value">{{ stats.calibraciones_proximas }}</div>
          <div class="stat-trend warning">Este mes</div>
        </div>
      </div>

      <!-- Alerts -->
      <div class="alert alert-danger" @click="navigateToPage('Equipos Pendientes')" v-if="stats.mantenimientos_pendientes > 0">
        <span style="font-size: 20px;">⚠️</span>
        <div>
          <strong>Atención:</strong> Hay {{ stats.mantenimientos_pendientes }} equipos con mantenimiento pendiente.
          <strong>Clic aquí para ver detalles</strong>
        </div>
      </div>

      <div class="alert alert-warning" @click="navigateToPage('Equipos Pendientes')" v-if="stats.calibraciones_proximas > 0">
        <span style="font-size: 20px;">⚠️</span>
        <div>
          <strong>Próximas calibraciones:</strong> {{ stats.calibraciones_proximas }} equipos requieren calibración pronto.
          <strong>Clic aquí para ver detalles</strong>
        </div>
      </div>

      <!-- Recent Equipment Table -->
      <div class="content-card">
        <h3 style="color: #006633; margin-bottom: 20px;">Equipos Agregados Recientemente</h3>
        <table v-if="equiposRecientes.length > 0">
          <thead>
            <tr>
              <th>Código</th>
              <th>Nombre</th>
              <th>Marca</th>
              <th>Modelo</th>
              <th>Registro INVIMA</th>
              <th>Riesgo</th>
              <th>Sede</th>
              <th>Fecha de Ingreso</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="equipo in equiposRecientes" :key="equipo.id">
              <td><strong>{{ equipo.codigo_interno || 'N/A' }}</strong></td>
              <td>{{ equipo.nombre_equipo || 'N/A' }}</td>
              <td>{{ equipo.marca || 'N/A' }}</td>
              <td>{{ equipo.modelo || 'N/A' }}</td>
              <td><span class="invima-badge">{{ equipo.registro_invima || 'N/A' }}</span></td>
              <td><span class="riesgo-badge" :class="'riesgo-' + (equipo.clasificacion_riesgo || 'na')">{{ equipo.clasificacion_riesgo || 'N/A' }}</span></td>
              <td>{{ equipo.sede?.nombre || 'N/A' }}</td>
              <td>{{ formatDate(equipo.registro_adquisicion?.fecha_adquisicion) }}</td>
            </tr>
          </tbody>
        </table>
        <p v-else style="text-align: center; color: #616161; padding: 20px;">
          No hay equipos registrados recientemente
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard-container {
  width: 100%;
  max-width: 100%;
  overflow-x: hidden;
}

.page-title {
  font-size: 28px;
  color: #006633;
  font-weight: 600;
  margin-bottom: 30px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 30px;
  width: 100%;
  max-width: 100%;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 10px;
  border-left: 4px solid #006633;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s;
  min-width: 0;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-label {
  color: #616161;
  margin-bottom: 8px;
  font-size: 14px;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #006633;
}

.stat-trend {
  font-size: 12px;
  margin-top: 8px;
}

.stat-trend.success {
  color: #4CAF50;
}

.stat-trend.warning {
  color: #ff9800;
}

.alert {
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.alert:hover {
  transform: translateX(5px);
}

.alert-danger {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
  border-left: 4px solid #f44336;
}

.alert-warning {
  background: rgba(255, 152, 0, 0.1);
  color: #ff9800;
  border-left: 4px solid #ff9800;
}

.alert-danger:hover {
  background: rgba(244, 67, 54, 0.15);
  cursor: pointer;
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

tbody tr:hover {
  background: rgba(0, 102, 51, 0.04);
}

.badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
}

.badge-success {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}

.badge-secondary {
  background: rgba(158, 158, 158, 0.1);
  color: #9e9e9e;
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
