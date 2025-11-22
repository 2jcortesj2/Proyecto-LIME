<script setup>
import { ref } from 'vue'
import Header from './components/Header.vue'
import Sidebar from './components/Sidebar.vue'
import Dashboard from './components/Dashboard.vue'

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
        <Dashboard v-if="currentPage === 'Información General'" />
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

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: #f5f5f5;
  overflow: hidden;
  height: 100vh;
}

.app {
  height: 100vh;
  display: flex;
  flex-direction: column;
}

.container {
  display: flex;
  height: calc(100vh - 90px);
}

.main-content {
  flex: 1;
  padding: 30px;
  overflow-y: auto;
  max-height: calc(100vh - 90px);
  min-height: calc(100vh - 90px);
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
</style>
