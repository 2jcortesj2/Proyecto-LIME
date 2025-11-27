<script setup>
import { ref } from 'vue'
import Header from './components/Header.vue'
import Sidebar from './components/Sidebar.vue'
import Dashboard from './components/Dashboard.vue'
import Mantenimientos from './components/Mantenimientos.vue'
import EquiposPendientes from './components/EquiposPendientes.vue'
import Inventario from './components/Inventario.vue'
import Traslados from './components/Traslados.vue'
import SedesServicios from './components/SedesServicios.vue'
import Responsables from './components/Responsables.vue'

const currentPage = ref('Información General')

function showPage(page) {
  currentPage.value = page
}
</script>

<template>
  <div class="app">
    <Header />
    <div class="container">
      <Sidebar :currentPage="currentPage" @changePage="showPage" />
      <main class="main-content">
        <Dashboard v-if="currentPage === 'Información General'" @changePage="showPage" />
        <Inventario v-else-if="currentPage === 'Inventario de Equipos'" />
        <Mantenimientos v-else-if="currentPage === 'Historial de Mantenimientos'" />
        <Traslados v-else-if="currentPage === 'Traslados'" />
        <SedesServicios v-else-if="currentPage === 'Sedes y Servicios'" />
        <Responsables v-else-if="currentPage === 'Responsables'" />

        <EquiposPendientes v-else-if="currentPage === 'Realizar Revisión'" viewMode="vencidos" />
        <EquiposPendientes v-else-if="currentPage === 'Proximos de Revision'" viewMode="proximos" />
        <EquiposPendientes v-else-if="currentPage === 'Equipos Pendientes'" viewMode="all" />
        <div v-else class="page-placeholder">
          <h2 class="page-title">{{ currentPage }}</h2>
          <p style="color: #616161;">Esta página está en desarrollo.</p>
        </div>
      </main>
    </div>
  </div>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100vh;
  overflow: hidden;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: #f5f5f5;
}

#app {
  width: 100%;
  height: 100vh;
  margin: 0;
  padding: 0;
}

.app {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  margin: 0;
  padding: 0;
}

.container {
  display: flex;
  width: 100%;
  height: calc(100vh - 90px);
  margin: 0;
  padding: 0;
}

.main-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  overflow-x: hidden;
  max-height: calc(100vh - 90px);
  min-height: calc(100vh - 90px);
  width: 100%;
}

.page-title {
  font-size: 28px;
  color: #006633;
  font-weight: 600;
  margin-bottom: 30px;
}

.page-placeholder {
  text-align: center;
  padding: 60px 20px;
}

/* Global custom scrollbar styling */
*::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

*::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.03);
}

*::-webkit-scrollbar-thumb {
  background: rgba(0, 102, 51, 0.35);
  border-radius: 10px;
  transition: background 0.3s;
}

*::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 102, 51, 0.6);
}

/* Firefox scrollbar */
* {
  scrollbar-width: thin;
  scrollbar-color: rgba(0, 102, 51, 0.35) rgba(0, 0, 0, 0.03);
}
</style>
