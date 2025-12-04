<script setup>
import { ref } from 'vue'
import { onMounted } from 'vue'
import { useSedesUbicaciones } from '../composables/useSedesUbicaciones'
import { useAccordion } from '../composables/useAccordion'
import { useModal } from '../composables/useModal'
import { useNotifications } from '../composables/useNotifications'
import { trasladosAPI } from '../services/api'

// Importar modales
import ModalCrearSede from './modals/sedes/ModalCrearSede.vue'
import ModalEditarSede from './modals/sedes/ModalEditarSede.vue'
import ModalEliminarSede from './modals/sedes/ModalEliminarSede.vue'
import ModalCrearUbicacion from './modals/ubicaciones/ModalCrearUbicacion.vue'
import ModalEditarUbicacion from './modals/ubicaciones/ModalEditarUbicacion.vue'
import ModalEliminarUbicacion from './modals/ubicaciones/ModalEliminarUbicacion.vue'
import ModalCrearTraslado from './modals/traslados/ModalCrearTraslado.vue'

// Composables
const { 
  sedes, 
  ubicaciones, 
  responsables, 
  loading, 
  error, 
  fetchSedes, 
  fetchUbicaciones,
  fetchResponsables,
  fetchEquiposByUbicacion 
} = useSedesUbicaciones()

const { toggleRow: toggleSede, isExpanded } = useAccordion()
const notifications = useNotifications()

// Estado local para expansión de ubicaciones (para evitar conflictos con useAccordion)
const expandedUbicaciones = ref(new Set())

function toggleUbicacion(id) {
  const newSet = new Set(expandedUbicaciones.value)
  if (newSet.has(id)) {
    newSet.delete(id)
  } else {
    newSet.add(id)
  }
  expandedUbicaciones.value = newSet
}

function isUbicacionExpanded(id) {
  return expandedUbicaciones.value.has(id)
}

// Modales de Sedes
const modalCrearSede = useModal()
const modalEditarSede = useModal()
const modalEliminarSede = useModal()

// Modales de Ubicaciones
const modalCrearUbicacion = useModal()
const modalEditarUbicacion = useModal()
const modalEliminarUbicacion = useModal()

// Modal Traslado
const modalCrearTraslado = useModal()

// Estado para equipos por ubicación
const equiposPorUbicacion = ref({})
const loadingEquipos = ref({})

onMounted(async () => {
  await fetchSedes()
  // Cargar datos necesarios para el modal de traslados
  fetchUbicaciones()
  fetchResponsables()
})

// Handlers para Sedes
function handleCrearSede() {
  modalCrearSede.open()
}

function handleEditarSede(sede) {
  modalEditarSede.open(sede)
}

function handleEliminarSede(sede) {
  modalEliminarSede.open(sede)
}

// Handlers para Ubicaciones
function handleNuevaUbicacion(sedeId) {
  modalCrearUbicacion.open({ sedeId })
}

function handleEditarUbicacion(ubicacion) {
  modalEditarUbicacion.open(ubicacion)
}

function handleEliminarUbicacion(ubicacion) {
  if (ubicacion.num_equipos > 0) {
    notifications.warning(
      `No se puede eliminar "${ubicacion.nombre}". Tiene ${ubicacion.num_equipos} equipo(s) asignado(s). Por favor, traslade los equipos primero.`,
      5000
    )
    return
  }
  modalEliminarUbicacion.open(ubicacion)
}

// Handlers para Equipos y Traslados
async function handleToggleUbicacion(ubicacionId) {
  toggleUbicacion(ubicacionId)
  
  // Si se expande y no hay datos cargados, obtenerlos
  if (isUbicacionExpanded(ubicacionId) && !equiposPorUbicacion.value[ubicacionId]) {
    try {
      loadingEquipos.value[ubicacionId] = true
      const equipos = await fetchEquiposByUbicacion(ubicacionId)
      equiposPorUbicacion.value[ubicacionId] = equipos
    } catch (err) {
      console.error('Error cargando equipos:', err)
      showError('Error al cargar los equipos de la ubicación')
    } finally {
      loadingEquipos.value[ubicacionId] = false
    }
  }
}

function handleTrasladarEquipo(equipo) {
  modalCrearTraslado.open({ equipo })
}

async function handleSaveTraslado(formData) {
  try {
    await trasladosAPI.create(formData)
    notifications.success('Traslado registrado exitosamente')
    modalCrearTraslado.close()
    
    // Recargar equipos de la ubicación origen
    if (formData.ubicacion_origen) {
      const equipos = await fetchEquiposByUbicacion(formData.ubicacion_origen)
      equiposPorUbicacion.value[formData.ubicacion_origen] = equipos
    }
    
    // Recargar sedes para actualizar contadores
    fetchSedes()
  } catch (error) {
    console.error('Error al guardar traslado:', error)
    notifications.error('Error al registrar el traslado')
  }
}

// Get computed sedeId from modal data
function getSedeIdFromModal() {
  return modalCrearUbicacion.data.value?.sedeId || null
}
</script>

<template>
  <div class="sedes-container">
    <!-- Notifications Toast Container -->
    <div class="notifications-container">
      <div 
        v-for="notification in notifications.notifications.value" 
        :key="notification.id"
        class="notification-toast"
        :class="`notification-${notification.type}`"
      >
        {{ notification.message }}
      </div>
    </div>

    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title">Sedes y Ubicaciones</h2>
        <div class="breadcrumb">Inicio / Configuración / Sedes</div>
      </div>
      <button class="btn btn-primary" @click="handleCrearSede">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
        Nueva Sede
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="spinner"></div>
      <p>Cargando sedes y ubicaciones...</p>
    </div>

    <!--  Error State -->
    <div v-else-if="error" class="error-state">
      {{ error }}
    </div>

    <!-- Sedes List -->
    <div v-else class="sedes-list">
      <div v-for="sede in sedes" :key="sede.id" class="sede-card" :class="{ expanded: isExpanded(sede.id) }">
        <!-- Header Section - Clickable for Accordion -->
        <div class="sede-header" @click="toggleSede(sede.id)">
          <div class="sede-header-content">
            <div class="header-left">
              <span class="chevron" :class="{ rotated: isExpanded(sede.id) }"><AppIcon name="chevron-down" size="16" /></span>
              <div class="sede-title-section">
                <h2 class="sede-title">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: #006633; width: 24px; height: 24px;"><rect x="4" y="2" width="16" height="20" rx="2" ry="2"></rect><path d="M9 22v-4h6v4"></path><path d="M8 6h.01"></path><path d="M16 6h.01"></path><path d="M8 10h.01"></path><path d="M16 10h.01"></path><path d="M8 14h.01"></path><path d="M16 14h.01"></path></svg>
                  Sede {{ sede.nombre }}
                </h2>
                <p class="sede-address">{{ sede.direccion }}, {{ sede.ciudad }}</p>
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
                <button class="btn btn-secondary btn-sm" @click.stop="handleEditarSede(sede)">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                  Editar
                </button>
                <button class="btn btn-tertiary btn-sm" @click.stop="handleNuevaUbicacion(sede.id)">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                  Ubicación
                </button>
                <button class="btn btn-danger btn-icon-only" @click.stop="handleEliminarSede(sede)" title="Desactivar Sede">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Collapsible Content -->
        <div v-show="isExpanded(sede.id)" class="sede-body">
          <!-- Ubicaciones Section -->
          <div class="ubicaciones-section">
            <h3 class="ubicaciones-title">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 18px; height: 18px;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
              Ubicaciones de la Sede
            </h3>
            
            <div class="ubicaciones-list">
              <div v-for="ubicacion in sede.ubicaciones" :key="ubicacion.id" class="ubicacion-container">
                <div class="ubicacion-row" @click="handleToggleUbicacion(ubicacion.id)" :class="{ 'expanded': isUbicacionExpanded(ubicacion.id) }">
                  <div class="ubicacion-info">
                    <div class="ubicacion-header-main">
                      <span class="chevron-sm" :class="{ rotated: isUbicacionExpanded(ubicacion.id) }"><AppIcon name="chevron-right" size="16" /></span>
                      <h4 class="ubicacion-name">{{ ubicacion.nombre }}</h4>
                    </div>
                    <div class="ubicacion-meta">
                      <div class="meta-item">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="meta-icon"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                        <span>{{ ubicacion.num_equipos }} equipos</span>
                      </div>
                    </div>
                  </div>
                  <div class="ubicacion-actions">
                    <button class="btn btn-secondary btn-sm" @click.stop="handleEditarUbicacion(ubicacion)">
                      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                      Editar
                    </button>
                    <button 
                      class="btn btn-danger btn-sm" 
                      :class="{ 'btn-disabled': ubicacion.num_equipos > 0 }"
                      @click.stop="handleEliminarUbicacion(ubicacion)"
                      :title="ubicacion.num_equipos > 0 
                        ? `No se puede eliminar: tiene ${ubicacion.num_equipos} equipo(s) asignado(s)` 
                        : 'Eliminar'"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                      Eliminar
                    </button>
                  </div>
                </div>

                <!-- Lista de Equipos (Expandible) -->
                <div v-show="isUbicacionExpanded(ubicacion.id)" class="equipos-list-container">
                  <div v-if="loadingEquipos[ubicacion.id]" class="loading-equipos">
                    <div class="spinner-sm"></div> Cargando equipos...
                  </div>
                  <div v-else-if="!equiposPorUbicacion[ubicacion.id] || equiposPorUbicacion[ubicacion.id].length === 0" class="no-equipos">
                    No hay equipos registrados en esta ubicación.
                  </div>
                  <div v-else class="table-responsive">
                    <table class="tabla-equipos">
                      <thead>
                        <tr>
                          <th style="width: 12%; text-align: center;">Código</th>
                          <th style="width: 35%;">Equipo</th>
                          <th style="width: 20%; text-align: center;">Registro Invima</th>
                          <th style="width: 20%;">Encargado</th>
                          <th style="width: 13%; text-align: center;">Acciones</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="equipo in equiposPorUbicacion[ubicacion.id]" :key="equipo.id">
                          <td style="text-align: center;"><strong style="font-size: 14px;">{{ equipo.codigo_interno }}</strong></td>
                          <td>
                            <div class="equipo-name-cell">
                              <span class="equipo-name" style="font-size: 14px;">{{ equipo.nombre_equipo }}</span>
                              <span class="equipo-brand" style="font-size: 12px;">{{ equipo.marca }} {{ equipo.modelo }}</span>
                            </div>
                          </td>
                          <td style="text-align: center;">
                            <span v-if="equipo.registro_invima" class="invima-badge" style="font-size: 12px;">{{ equipo.registro_invima }}</span>
                            <span v-else class="invima-badge" style="background: rgba(158, 158, 158, 0.1); color: #9e9e9e; font-size: 12px;">N/A</span>
                          </td>
                          <td style="font-size: 14px;">{{ equipo.responsable_nombre || 'Sin asignar' }}</td>
                          <td style="text-align: center;">
                            <button class="btn btn-tertiary btn-sm" @click.stop="handleTrasladarEquipo(equipo)" style="font-size: 13px;">
                              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 14 4 9 9 4"></polyline><path d="M20 20v-7a4 4 0 0 0-4-4H4"></path></svg>
                              Trasladar
                            </button>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
              
              <div v-if="!sede.ubicaciones || sede.ubicaciones.length === 0" class="no-ubicaciones">
                No hay ubicaciones registradas en esta sede.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modales de Sedes -->
    <ModalCrearSede 
      :show="modalCrearSede.isOpen.value" 
      @close="modalCrearSede.close()" 
      @created="modalCrearSede.close()"
    />
    
    <ModalEditarSede 
      :show="modalEditarSede.isOpen.value"
      :sede="modalEditarSede.data.value"
      @close="modalEditarSede.close()" 
      @updated="modalEditarSede.close()"
    />
    
    <ModalEliminarSede 
      :show="modalEliminarSede.isOpen.value"
      :sede="modalEliminarSede.data.value"
      @close="modalEliminarSede.close()" 
      @deleted="modalEliminarSede.close()"
    />

    <!-- Modales de Ubicaciones -->
    <ModalCrearUbicacion 
      :show="modalCrearUbicacion.isOpen.value"
      :sede-id="getSedeIdFromModal()"
      @close="modalCrearUbicacion.close()" 
      @created="modalCrearUbicacion.close()"
    />
    
    <ModalEditarUbicacion 
      :show="modalEditarUbicacion.isOpen.value"
      :ubicacion="modalEditarUbicacion.data.value"
      @close="modalEditarUbicacion.close()" 
      @updated="modalEditarUbicacion.close()"
    />
    
    <ModalEliminarUbicacion 
      :show="modalEliminarUbicacion.isOpen.value"
      :ubicacion="modalEliminarUbicacion.data.value"
      @close="modalEliminarUbicacion.close()" 
      @deleted="fetchSedes"
    />

    <!-- Modal Traslado -->
    <ModalCrearTraslado
      :show="modalCrearTraslado.isOpen.value"
      :initial-equipo="modalCrearTraslado.data.value?.equipo"
      :sedes="sedes"
      :ubicaciones="ubicaciones"
      :responsables="responsables"
      @close="modalCrearTraslado.close()"
      @save="handleSaveTraslado"
    />
  </div>
</template>

<style scoped>
@import './modals/button-styles.css';

.sedes-container {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-title { 
  font-size: 28px; 
  color: #006633; 
  font-weight: 600; 
  margin: 0; 
}

.breadcrumb {
  color: #616161;
  font-size: 14px;
  margin-top: 5px;
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
  border: 1px solid #f0f0f0;
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

.ubicaciones-title {
  color: #006633;
  font-size: 16px;
  margin-bottom: 15px;
  margin-top: 20px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8px;
}

.ubicaciones-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.ubicacion-row {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 0.2s;
  border: 1px solid #eee;
}

.ubicacion-row:hover {
  background: white;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  border-color: #e0e0e0;
}

.ubicacion-name {
  margin: 0 0 5px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.ubicacion-meta {
  display: flex;
  align-items: center;
  gap: 15px;
  font-size: 13px;
  color: #666;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.meta-icon {
  width: 14px;
  height: 14px;
  opacity: 0.7;
}

.separator {
  color: #ddd;
}

.ubicacion-actions {
  display: flex;
  gap: 8px;
}

.no-ubicaciones {
  text-align: center;
  padding: 30px;
  color: #888;
  font-style: italic;
  background: #f9f9f9;
  border-radius: 8px;
  border: 1px dashed #ddd;
}

/* Estilos para lista de equipos */
.ubicacion-container {
  margin-bottom: 10px;
}

.ubicacion-row {
  cursor: pointer;
}

.ubicacion-row.expanded {
  background: #e8f5e9;
  border-color: #c8e6c9;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}

.ubicacion-header-main {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 5px;
}

.chevron-sm {
  font-size: 10px;
  color: #666;
  transition: transform 0.2s;
  display: inline-block;
}

.chevron-sm.rotated {
  transform: rotate(90deg);
}

.equipos-list-container {
  background: white;
  border: 1px solid #e0e0e0;
  border-top: none;
  border-bottom-left-radius: 8px;
  border-bottom-right-radius: 8px;
  padding: 15px;
  animation: slideDown 0.2s ease-out;
}

.loading-equipos {
  text-align: center;
  padding: 20px;
  color: #666;
  font-size: 13px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.spinner-sm {
  width: 16px;
  height: 16px;
  border: 2px solid #f3f3f3;
  border-top: 2px solid #006633;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.no-equipos {
  text-align: center;
  padding: 20px;
  color: #888;
  font-size: 13px;
  font-style: italic;
}

/* Estilos específicos para celdas de equipos */
.equipo-name-cell {
  display: flex;
  flex-direction: column;
}

.equipo-name {
  font-weight: 600;
  color: #006633;
}

.equipo-brand {
  font-size: 11px;
  color: #888;
}

/* Disabled button styles */
.btn-disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: auto !important;
}

/* Notifications Toast */
.notifications-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notification-toast {
  padding: 15px 20px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  font-weight: 500;
  min-width: 300px;
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    transform: translateX(400px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.notification-success {
  background: #4caf50;
  color: white;
}

.notification-error {
  background: #f44336;
  color: white;
}

.notification-warning {
  background: #ff9800;
  color: white;
}

.notification-info {
  background: #2196f3;
  color: white;
}
</style>
