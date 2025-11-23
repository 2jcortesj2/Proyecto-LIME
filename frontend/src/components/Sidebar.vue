<script setup>
import { ref, defineProps, defineEmits } from 'vue'

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
</script>

<template>
  <aside class="sidebar">
    <nav>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Información General' }"
        @click="changePage('Información General')"
      >
        📊 Información General
      </div>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Inventario de Equipos' }"
        @click="changePage('Inventario de Equipos')"
      >
        🔬 Inventario de Equipos
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
          🛠️ Mantenimientos
        </div>
        <div class="accordion-content" v-show="mantenimientosExpanded">
          <div 
            class="menu-item sub-item" 
            :class="{ active: currentPage === 'Historial de Mantenimientos' }"
            @click="changePage('Historial de Mantenimientos')"
          >
            📋 Historial Completo
          </div>
          <div 
            class="menu-item sub-item" 
            :class="{ active: currentPage === 'Equipos Pendientes' }"
            @click="changePage('Equipos Pendientes')"
          >
            ⚠️ Equipos Pendientes
          </div>
        </div>
      </div>
      
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Traslados' }"
        @click="changePage('Traslados')"
      >
        🔄 Traslados
      </div>
      
      <div class="divider"></div>
      
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Sedes y Servicios' }"
        @click="changePage('Sedes y Servicios')"
      >
        🏢 Sedes y Servicios
      </div>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Usuarios' }"
        @click="changePage('Usuarios')"
      >
        👥 Usuarios
      </div>
      
      <div class="divider"></div>
      
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Reportes' }"
        @click="changePage('Reportes')"
      >
        📈 Reportes
      </div>
      <div 
        class="menu-item" 
        :class="{ active: currentPage === 'Configuración' }"
        @click="changePage('Configuración')"
      >
        ⚙️ Configuración
      </div>
    </nav>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 260px;
  background: white;
  padding: 20px 0;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
}

.menu-item {
  padding: 15px 25px;
  cursor: pointer;
  border-left: 4px solid transparent;
  transition: all 0.3s;
  text-align: left;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.menu-item:hover {
  background: #f5f5f5;
  border-left-color: #006633;
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
</style>
