<script setup>
import { ref, onMounted } from 'vue'
import { sedesAPI } from '../services/api'

const sedes = ref([])
const loading = ref(true)
const error = ref(null)
const expandedSedes = ref(new Set())
const showAllServices = ref(new Map()) // Track which sedes have expanded service lists

async function fetchSedes() {
  try {
    loading.value = true
    const response = await sedesAPI.getAll()
    sedes.value = response.data
    // All accordions closed by default
  } catch (err) {
    console.error('Error fetching sedes:', err)
    error.value = 'Error al cargar la información de sedes y ubicaciones.'
  } finally {
    loading.value = false
  }
}

function toggleSede(sedeId) {
  if (expandedSedes.value.has(sedeId)) {
    expandedSedes.value.delete(sedeId)
  } else {
    expandedSedes.value.add(sedeId)
  }
}

function toggleShowAllServices(sedeId) {
  const current = showAllServices.value.get(sedeId) || false
  showAllServices.value.set(sedeId, !current)
}

function getVisibleUbicaciones(sede) {
  const showAll = showAllServices.value.get(sede.id) || false
  if (!sede.ubicaciones) return []
  return showAll ? sede.ubicaciones : sede.ubicaciones.slice(0, 5)
}

function hasMoreUbicaciones(sede) {
  return sede.ubicaciones && sede.ubicaciones.length > 5
}

onMounted(() => {
  fetchSedes()
})
</script>

<template>
  <div class="sedes-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Sedes y Ubicaciones</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Configuración / Sedes</div>
      </div>
      <button class="btn btn-primary" @click="() => {}">➕ Nueva Sede</button>
    </div>

    <div v-if="loading" class="loading-state">
      <div class="spinner"></div>
      <p>Cargando sedes y ubicaciones...</p>
    </div>

    <div v-else-if="error" class="error-state">
      {{ error }}
    </div>

    <div v-else class="sedes-list">
      <div v-for="sede in sedes" :key="sede.id" class="sede-card" :class="{ expanded: expandedSedes.has(sede.id) }">
        <!-- Header Section - Clickable for Accordion -->
        <div class="sede-header" @click="toggleSede(sede.id)">
          <div class="sede-header-content">
            <div class="header-left">
              <span class="chevron" :class="{ rotated: expandedSedes.has(sede.id) }">▼</span>
              <div class="sede-title-section">
                <h2 class="sede-title">🏢 Sede {{ sede.nombre }}</h2>
                <p class="sede-address">Dirección {{ sede.nombre }}, {{ sede.ciudad }}</p>
              </div>
            </div>
            
            <div class="header-right">
              <div class="header-stats">
                <div class="mini-stat stat-green">
                  <span class="mini-stat-value">{{ sede.total_ubicaciones }}</span>
                  <span class="mini-stat-label">Ubicaciones</span>
                </div>
                <div class="mini-stat stat-blue">
                  <span class="mini-stat-value">{{ sede.total_equipos }}</span>
                  <span class="mini-stat-label">Equipos</span>
                </div>
              </div>
              <div class="sede-actions">
                <button class="btn-secondary" @click.stop>✏️ Editar Sede</button>
                <button class="btn-tertiary" @click.stop>➕ Nueva Ubicación</button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Collapsible Content -->
        <div v-show="expandedSedes.has(sede.id)" class="sede-body">
          <!-- Stats Cards -->
          <!-- Stats Cards Removed (Moved to Header) -->

          <!-- Services Section -->
          <div class="services-section">
            <h3 class="services-title">Ubicaciones de la Sede</h3>
            
            <div class="services-list">
              <div v-for="ubicacion in getVisibleUbicaciones(sede)" :key="ubicacion.id" class="servicio-row">
                <div class="servicio-info">
                  <h4 class="servicio-name">{{ ubicacion.nombre }}</h4>
                  <div class="servicio-meta">
                    <span class="servicio-equipos">🔧 {{ ubicacion.num_equipos }} equipos</span>
                    <span class="separator">•</span>
                    <span class="servicio-responsable">👤 Responsable: {{ ubicacion.responsable }}</span>
                  </div>
                </div>
                <div class="servicio-actions">
                  <button class="btn-edit">✏️ Editar</button>
                </div>
              </div>
              
              <div v-if="hasMoreUbicaciones(sede)" class="ver-mas-container">
                <button class="btn-ver-mas" @click.stop="toggleShowAllServices(sede.id)">
                  {{ showAllServices.get(sede.id) ? '▲ Ver menos' : '▼ Ver más (' + (sede.ubicaciones.length - 5) + ' más)' }}
                </button>
              </div>
              
              <div v-if="!sede.ubicaciones || sede.ubicaciones.length === 0" class="no-services">
                No hay ubicaciones registradas en esta sede.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.sedes-container {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.page-title { 
  font-size: 28px; 
  color: #006633; 
  font-weight: 600; 
  margin-bottom: 30px; 
}

.btn { 
  padding: 12px 24px; 
  border: none; 
  border-radius: 6px; 
  cursor: pointer; 
  font-weight: 600; 
  transition: all 0.3s; 
}

.btn-primary { 
  background: #006633; 
  color: white; 
}

.btn-primary:hover { 
  background: #2d5016; 
  transform: translateY(-2px); 
}

.loading-state, .error-state {
  text-align: center;
  padding: 40px;
  color: #666;
}

.spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #006633;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.sedes-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.sede-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  overflow: hidden;
  transition: all 0.3s ease;
  /* Removed border as requested */
}

.sede-header {
  padding: 25px;
  cursor: pointer;
  background: white;
  transition: background 0.2s;
}

.sede-header:hover {
  background: #fafafa;
}

.sede-header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sede-title-section {
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.sede-title {
  font-size: 24px;
  color: #006633;
  margin: 0 0 5px 0;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.sede-address {
  color: #666;
  font-size: 14px;
  margin: 0;
}

.sede-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-left {
  display: flex;
  align-items: center;
  flex: 1;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.chevron {
  font-size: 14px;
  color: #999;
  transition: transform 0.3s;
  margin-right: 15px;
}

.header-stats {
  display: flex;
  gap: 10px;
}

.mini-stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 5px 15px;
  border-radius: 6px;
  min-width: 80px;
}

.stat-green {
  background: rgba(0,102,51,0.05);
  color: #006633;
}

.stat-blue {
  background: rgba(0,169,157,0.05);
  color: #00a99d;
}

.mini-stat-value {
  font-weight: 700;
  font-size: 18px;
  line-height: 1.2;
}

.mini-stat-label {
  font-size: 11px;
  opacity: 0.8;
}

.chevron.rotated {
  transform: rotate(180deg);
}

.sede-body {
  padding: 0 25px 25px 25px;
  animation: slideDown 0.3s ease-out;
  border-top: 1px solid #e0e0e0;
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}



.btn-secondary {
  background-color: #26a69a; /* Teal/Cyan color from mockup */
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-secondary:hover {
  background-color: #00897b;
}

.btn-tertiary {
  background-color: #006633; /* Color del primario */
  color: white;

  /* Tamaño y forma del secundario */
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-tertiary:hover {
  background-color: #2d5016; /* Hover del primario */
}

.stats-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px; /* Reduced from 30px to bring services closer */
  margin-top: 10px;
}

.stat-card {
  padding: 15px;
  border-radius: 8px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.stat-card-green {
  background: rgba(0,102,51,0.05); /* Light green background from mockup */
}

.stat-card-green .stat-value {
  color: #006633; /* Green text from mockup */
}

.stat-card-blue {
  background: rgba(0,169,157,0.05); /* Light cyan/turquoise background from mockup */
}

.stat-card-blue .stat-value {
  color: #00a99d; /* Cyan/turquoise text from mockup */
}

.stat-label {
  font-size: 12px;
  color: #616161;
  margin-bottom: 0px;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
}

.services-title {
  color: #006633;
  font-size: 16px;
  margin-bottom: 10px; /* Reduced from 15px to bring closer to stats */
  margin-top: 10px; /* Reduced spacing from stats cards */
  font-weight: 700; /* Bold */
}

.services-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.servicio-row {
  background: #f5f5f5; /* Same as page background */
  /* Removed border */
  border-radius: 8px;
  padding: 12px 20px; /* Reduced from 15px to 12px for less height */
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: background 0.2s;
  box-shadow: 0 1px 3px rgba(0,0,0,0.03); /* Subtle shadow instead of border */
}

.servicio-row:hover {
  background: #eeeeee;
}

.servicio-name {
  margin: 0 0 5px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.servicio-meta {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
  color: #666;
}

.separator {
  color: #ccc;
}

.btn-edit {
  background: #e0e0e0;
  border: none;
  padding: 6px 16px;
  border-radius: 4px;
  color: #333;
  font-weight: 600;
  cursor: pointer;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-edit:hover {
  background: #d0d0d0;
}

.ver-mas-container {
  text-align: center;
  margin-top: 10px;
}

.btn-ver-mas {
  background: transparent;
  border: none;
  color: #006633;
  font-weight: 600;
  cursor: pointer;
  font-size: 13px;
  padding: 8px 16px;
  transition: all 0.2s;
}

.btn-ver-mas:hover {
  background: rgba(0, 102, 51, 0.05);
  border-radius: 4px;
}

.no-services {
  text-align: center;
  padding: 20px;
  color: #888;
  font-style: italic;
  background: #f9f9f9;
  border-radius: 8px;
}
</style>
