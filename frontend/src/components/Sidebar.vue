<script setup>
import { ref, defineProps, defineEmits, onMounted } from 'vue'
import { equiposAPI } from '../services/api'

defineProps({
  currentPage: String
})

const emit = defineEmits(['changePage'])

const mantenimientosExpanded = ref(false)

function changePage(page) {
  emit('changePage', page)
}

function toggleMantenimientos() {
  mantenimientosExpanded.value = !mantenimientosExpanded.value
}

const stats = ref({
  vencidos: 0,
  proximos: 0
})

async function fetchStats() {
  try {
    const response = await equiposAPI.getMaintenanceStats()
    stats.value = response.data
  } catch (error) {
    console.error('Error fetching stats:', error)
  }
}

onMounted(() => {
  fetchStats()
  // Poll for updates every minute
  setInterval(fetchStats, 60000)
})
</script>

<template>
  <aside class="sidebar">
    <nav>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Información General' }"
        @click="changePage('Información General')"
      >
        <AppIcon name="activity" size="16" /> Información General
      </div>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Inventario de Equipos' }"
        @click="changePage('Inventario de Equipos')"
      >
        <AppIcon name="package" size="16" /> Inventario de Equipos
      </div>
      
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Traslados' }"
        @click="changePage('Traslados')"
      >
        <AppIcon name="refresh" size="16" /> Traslados
      </div>

      <!-- Accordion for Mantenimientos -->
      <div class="menu-accordion">
        <div 
          class="menu-item accordion-header" 
          :class="{ 
            active: currentPage === 'Historial de Mantenimientos' || currentPage === 'Equipos Pendientes',
            expanded: mantenimientosExpanded 
          }"
          @click="toggleMantenimientos"
        >
          <AppIcon name="wrench" size="16" /> Mantenimientos
        </div>
        <div class="accordion-content" v-show="mantenimientosExpanded">
          <div 
            class="menu-item sub-item" 
            :class="{ active: currentPage === 'Realizar Revisión' }"
            @click="changePage('Realizar Revisión')"
          >
            <AppIcon name="alert" size="16" /> Realizar Revisión
            <span v-if="stats.vencidos > 0" class="count-badge danger">{{ stats.vencidos }}</span>
          </div>
          <div 
            class="menu-item sub-item" 
            :class="{ active: currentPage === 'Proximos de Revision' }"
            @click="changePage('Proximos de Revision')"
          >
            <AppIcon name="clock" size="16" /> Próximos de revisión
            <span v-if="stats.proximos > 0" class="count-badge warning">{{ stats.proximos }}</span>
          </div>
          <div 
            class="menu-item sub-item" 
            :class="{ active: currentPage === 'Historial de Mantenimientos' }"
            @click="changePage('Historial de Mantenimientos')"
          >
            <AppIcon name="file" size="16" /> Historial Completo
          </div>
        </div>
      </div>
      
      <div class="divider"></div>
      
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Sedes y Ubicaciones' }"
        @click="changePage('Sedes y Ubicaciones')"
      >
        <AppIcon name="building" size="16" /> Sedes y Ubicaciones
      </div>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Responsables' }"
        @click="changePage('Responsables')"
      >
        <AppIcon name="user" size="16" /> Responsables
      </div>
    </nav>
    
    <!-- Marca de agua -->
    <div class="watermark">
      <p class="watermark-title">Desarrollado por:</p>
      <p class="watermark-name">Juliana González</p>
      <p class="watermark-name">Juan Artunduaga</p>
      <p class="watermark-name">Juan Cortés</p>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 260px;
  background: white;
  padding: 20px 0;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
  overflow-y: auto;
  max-height: 100%;
  display: flex;
  flex-direction: column;
}

/* Custom scrollbar styling */
.sidebar::-webkit-scrollbar {
  width: 6px;
}

.sidebar::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.03);
}

.sidebar::-webkit-scrollbar-thumb {
  background: rgba(0, 102, 51, 0.35);
  border-radius: 10px;
  transition: background 0.3s;
}

.sidebar::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 102, 51, 0.6);
}

/* Firefox scrollbar */
.sidebar {
  scrollbar-width: thin;
  scrollbar-color: rgba(0, 102, 51, 0.35) rgba(0, 0, 0, 0.03);
}

nav {
  flex: 1;
}

.menu-item {
  padding: 15px 25px;
  cursor: pointer;
  border-left: 4px solid transparent;
  transition: all 0.3s;
  text-align: left;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  white-space: nowrap;
  gap: 8px;
}

.menu-item:hover {
  background: #f5f5f5;
  border-left-color: #006633;
  font-weight: bold;
}

.menu-item.active {
  background: rgba(0, 102, 51, 0.1);
  border-left-color: #006633;
  font-weight: 600;
  color: #006633;
}

.menu-accordion {
  position: relative;
}

.accordion-header {
  font-weight: 600;
  transition: background 0.3s;
}

.accordion-header.expanded {
  background: rgba(0, 102, 51, 0.08);
  border-left-color: #006633;
}

.accordion-content {
  background: #f9f9f9;
}

.sub-item {
  padding-left: 45px;
  font-size: 14px;
}

.sub-item:hover {
  background: #eeeeee;
}

.sub-item.active {
  background: rgba(0, 102, 51, 0.15);
}

.divider {
  height: 1px;
  background: #e0e0e0;
  margin: 15px 25px;
}

.count-badge {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: bold;
  margin-left: auto;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.count-badge.danger {
  background: #ffebee;
  color: #c62828;
}

.count-badge.warning {
  background: #fff3e0;
  color: #ef6c00;
}

.watermark {
  padding: 20px 25px;
  text-align: center;
  border-top: 1px solid #e0e0e0;
  margin-top: auto;
  background: linear-gradient(to bottom, transparent, rgba(0, 102, 51, 0.02));
}

.watermark-title {
  font-size: 11px;
  font-weight: 600;
  color: rgba(0, 102, 51, 0.7);
  margin-bottom: 8px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.watermark-name {
  font-size: 12px;
  color: rgba(0, 102, 51, 0.5);
  margin: 4px 0;
  font-weight: 400;
}
</style>