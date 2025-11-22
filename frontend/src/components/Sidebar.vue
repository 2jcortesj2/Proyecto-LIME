<script setup>
defineProps({
  currentPage: String
})

const emit = defineEmits(['changePage'])

const menuItems = [
  { icon: '📊', label: 'Información General' },
  { icon: '🔧', label: 'Inventario de Equipos' },
  { icon: '🔄', label: 'Traslados' },
  { icon: '🛠️', label: 'Mantenimientos' },
  { divider: true },
  { icon: '🏢', label: 'Sedes y Servicios' },
  { icon: '👥', label: 'Usuarios' },
  { divider: true },
  { icon: '📈', label: 'Reportes' },
  { icon: '⚙️', label: 'Configuración' }
]
</script>

<template>
  <aside class="sidebar">
    <template v-for="(item, index) in menuItems" :key="index">
      <div v-if="item.divider" class="divider"></div>
      <div
        v-else
        class="menu-item"
        :class="{ active: currentPage === item.label }"
        @click="emit('changePage', item.label)"
      >
        {{ item.icon }} {{ item.label }}
      </div>
    </template>
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

.divider {
  height: 1px;
  background: #e0e0e0;
  margin: 15px 25px;
}
</style>
