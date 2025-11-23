<script setup>
import { ref, computed, onMounted } from 'vue'
import { equiposAPI } from '../services/api'

// Reactive data
const equipos = ref([])
const loading = ref(true)
const error = ref(null)

// Fetch equipment with maintenance info
async function fetchEquipos() {
  try {
    loading.value = true
    const response = await equiposAPI.getAll()
    
    // Filter only equipment that requires maintenance
    equipos.value = response.data.filter(eq => 
      eq.informacion_metrologica?.requiere_mantenimiento && 
      eq.informacion_metrologica?.proximo_mantenimiento
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

// Helper function to calculate next maintenance date
function calcularProximoMantenimiento(equipo) {
  if (!equipo.registro_adquisicion?.fecha_adquisicion) return null
  if (!equipo.informacion_metrologica?.frecuencia_mantenimiento) return null
  
  const fechaIngreso = new Date(equipo.registro_adquisicion.fecha_adquisicion)
  const frecuencia = equipo.informacion_metrologica.frecuencia_mantenimiento.toLowerCase()
  
  // Si tiene proximo_mantenimiento definido, usarlo
  if (equipo.informacion_metrologica.proximo_mantenimiento) {
    return new Date(equipo.informacion_metrologica.proximo_mantenimiento)
  }
  
  // Calcular basado en frecuencia
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
    // Por defecto, anual
    fechaProxima.setFullYear(fechaProxima.getFullYear() + 1)
  }
  
  return fechaProxima
}

// Computed properties para clasificar equipos
const equiposVencidos = computed(() => {
  const hoy = new Date()
  const mesActual = hoy.getMonth() + 1
  const anioActual = hoy.getFullYear()
  
  return equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    
    const fechaProxima = calcularProximoMantenimiento(eq)
    if (!fechaProxima) return false
    
    const mesProximo = fechaProxima.getMonth() + 1
    const anioProximo = fechaProxima.getFullYear()
    
    return (anioProximo < anioActual) || (anioProximo === anioActual && mesProximo < mesActual)
  }).sort((a, b) => {
    const fechaA = calcularProximoMantenimiento(a)
    const fechaB = calcularProximoMantenimiento(b)
    return fechaA - fechaB
  })
})

const equiposProximosVencer = computed(() => {
  const hoy = new Date()
  const mesActual = hoy.getMonth() + 1
  const anioActual = hoy.getFullYear()
  
  let mesLimite = mesActual + 3
  let anioLimite = anioActual
  if (mesLimite > 12) {
    mesLimite -= 12
    anioLimite += 1
  }
  
  return equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    
    const fechaProxima = calcularProximoMantenimiento(eq)
    if (!fechaProxima) return false
    
    const mesProximo = fechaProxima.getMonth() + 1
    const anioProximo = fechaProxima.getFullYear()
    
    const noVencido = (anioProximo > anioActual) || (anioProximo === anioActual && mesProximo >= mesActual)
    const dentroLimite = (anioProximo < anioLimite) || (anioProximo === anioLimite && mesProximo <= mesLimite)
    
    return noVencido && dentroLimite
  }).sort((a, b) => {
    const fechaA = calcularProximoMantenimiento(a)
    const fechaB = calcularProximoMantenimiento(b)
    return fechaA - fechaB
  })
})

const equiposNormales = computed(() => {
  const hoy = new Date()
  const mesActual = hoy.getMonth() + 1
  const anioActual = hoy.getFullYear()
  
  let mesLimite = mesActual + 3
  let anioLimite = anioActual
  if (mesLimite > 12) {
    mesLimite -= 12
    anioLimite += 1
  }
  
  return equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    
    const fechaProxima = calcularProximoMantenimiento(eq)
    if (!fechaProxima) return false
    
    const mesProximo = fechaProxima.getMonth() + 1
    const anioProximo = fechaProxima.getFullYear()
    
    return (anioProximo > anioLimite) || (anioProximo === anioLimite && mesProximo > mesLimite)
  }).sort((a, b) => {
    const fechaA = calcularProximoMantenimiento(a)
    const fechaB = calcularProximoMantenimiento(b)
    return fechaA - fechaB
  })
})

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
  const fecha = calcularProximoMantenimiento(equipo)
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
        <h2 class="page-title" style="margin: 0;">Equipos Pendientes de Mantenimiento</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Mantenimientos / Equipos Pendientes</div>
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
      <div class="content-card" v-if="equiposVencidos.length > 0">
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
            <tr v-for="eq in equiposVencidos" :key="eq.id" class="row-vencido">
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
                <div style="display: flex; gap: 8px;">
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
      </div>

      <!-- Equipos Próximos a Vencer -->
      <div class="content-card" v-if="equiposProximosVencer.length > 0">
        <div class="section-header proximo">
          <h3>⏰ Próximos a Vencer ({{ equiposProximosVencer.length }})</h3>
          <p>Equipos que requieren mantenimiento en los próximos 3 meses</p>
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
            <tr v-for="eq in equiposProximosVencer" :key="eq.id" class="row-proximo">
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
                <div style="display: flex; gap: 8px;">
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
      </div>

      <!-- Equipos Normales -->
      <div class="content-card" v-if="equiposNormales.length > 0">
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
            <tr v-for="eq in equiposNormales" :key="eq.id">
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

.row-vencido {
  background: rgba(244, 67, 54, 0.05);
}

.row-vencido:hover {
  background: rgba(244, 67, 54, 0.1) !important;
}

.row-proximo {
  background: rgba(255, 152, 0, 0.05);
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


