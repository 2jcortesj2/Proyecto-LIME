<script setup>
import { ref, onMounted, computed } from 'vue'

const traslados = ref([])
const loading = ref(true)
const error = ref(null)
const searchQuery = ref('')

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [10, 20, 50, 100]

const fetchTraslados = async () => {
  loading.value = true
  try {
    const response = await fetch('http://127.0.0.1:8000/api/traslados/')
    if (!response.ok) throw new Error('Error al cargar el historial de traslados')
    traslados.value = await response.json()
  } catch (err) {
    error.value = err.message
    console.error(err)
  } finally {
    loading.value = false
  }
}

const filteredTraslados = computed(() => {
  if (!searchQuery.value) return traslados.value
  const query = searchQuery.value.toLowerCase()
  return traslados.value.filter(t => 
    (t.equipo_codigo && t.equipo_codigo.toLowerCase().includes(query)) ||
    (t.equipo_nombre && t.equipo_nombre.toLowerCase().includes(query)) ||
    (t.equipo_marca && t.equipo_marca.toLowerCase().includes(query)) ||
    (t.equipo_modelo && t.equipo_modelo.toLowerCase().includes(query))
  )
})

// Pagination computed properties
const totalPages = computed(() => Math.ceil(filteredTraslados.value.length / itemsPerPage.value))

const paginatedTraslados = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredTraslados.value.slice(start, end)
})

// Pagination methods
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

const formatFecha = (fecha) => {
  if (!fecha) return 'N/A'
  const date = new Date(fecha)
  return date.toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric' })
}

onMounted(() => {
  fetchTraslados()
})
</script>

<template>
  <div id="traslados-page">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Historial de Traslados</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Traslados / Historial</div>
      </div>
      <button class="btn btn-primary">➕ Nuevo Traslado</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            class="search-input" 
            placeholder="🔍 Buscar por código, nombre, marca o modelo..." 
            v-model="searchQuery"
          >
        </div>
      </div>

      <!-- Skeleton Loader -->
      <div v-if="loading" class="skeleton-table">
        <table>
          <thead>
            <tr>
              <th style="width: 8%; text-align: center;">Código</th>
              <th style="width: 18%; text-align: center;">Equipo</th>
              <th style="width: 10%; text-align: center;">Origen</th>
              <th style="width: 4%; text-align: center;"></th>
              <th style="width: 10%; text-align: center;">Destino</th>
              <th style="width: 30%; text-align: center;">Justificación</th>
              <th style="width: 10%; text-align: center;">Fecha</th>
              <th style="width: 10%; text-align: center;">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="i in 8" :key="i">
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text"></div></td>
              <td><div class="skeleton-text skeleton-buttons"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>
      
      <table v-else id="trasladosTable">
        <thead>
          <tr>
            <th style="width: 8%; text-align: center;">Código</th>
            <th style="width: 18%; text-align: center;">Equipo</th>
            <th style="width: 10%; text-align: center;">Origen</th>
            <th style="width: 4%; text-align: center;"></th>
            <th style="width: 10%; text-align: center;">Destino</th>
            <th style="width: 30%; text-align: center;">Justificación</th>
            <th style="width: 10%; text-align: center;">Fecha</th>
            <th style="width: 10%; text-align: center;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="traslado in paginatedTraslados" :key="traslado.id">
            <td><strong>{{ traslado.equipo_codigo }}</strong></td>
            <td>
              <div style="font-weight: 600; color: #212121;">{{ traslado.equipo_nombre }}</div>
              <div style="font-size: 11px; color: #616161;">{{ traslado.equipo_marca }} - {{ traslado.equipo_modelo }}</div>
            </td>
            <td>
              <div style="font-weight: 600; font-size: 14px; color: #212121;">{{ traslado.sede_origen_nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ traslado.servicio_origen_nombre || 'N/A' }}</div>
            </td>
            <td style="text-align: center; color: #006633; font-size: 20px;">
              ➝
            </td>
            <td>
              <div style="font-weight: 600; font-size: 14px; color: #212121;">{{ traslado.sede_destino_nombre || 'N/A' }}</div>
              <div style="font-size: 12px; color: #616161;">{{ traslado.servicio_destino_nombre || 'N/A' }}</div>
            </td>
            <td>{{ traslado.justificacion }}</td>
            <td>{{ formatFecha(traslado.fecha_traslado) }}</td>
            <td>
              <div style="display: flex; gap: 5px; justify-content: center;">
                <button class="btn btn-secondary btn-sm" title="Editar">✏️</button>
                <button class="btn btn-danger btn-sm" title="Eliminar">🗑️</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination Footer -->
      <div class="pagination-footer">
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
  </div>
</template>

<style scoped>
.content-card {
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
  padding: 25px;
}

.search-filter-container {
  display: flex;
  justify-content: space-between;
  margin-bottom: 25px;
  gap: 15px;
}

.search-section {
  flex: 1;
  position: relative;
}

.search-input {
  width: 100%;
  padding: 14px 18px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #f5f5f5;
}

.search-input:focus {
  outline: none;
  border-color: #006633;
  background: white;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

/* Button Styles */
.page-title { font-size: 28px; color: #006633; font-weight: 700; margin-bottom: 30px; }
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-sm { padding: 8px 16px; font-size: 13px; }
.btn-secondary { background: #e0e0e0; }
.btn-secondary:hover { background: #d0d0d0; }
.btn-danger { background: #f44336; color: white; }
.btn-danger:hover { background: #d32f2f; }

table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}

th {
  text-align: left;
  padding: 15px;
  color: white;
  font-weight: 600;
  border-bottom: 2px solid #f0f0f0;
  font-size: 13px;
  text-transform: uppercase;
  background: #006633;
}

td {
  padding: 15px;
  border-bottom: 1px solid #f0f0f0;
  vertical-align: middle;
  color: #333;
  font-size: 14px;
  word-wrap: break-word;
}

tr:hover {
  background-color: #f9f9f9;
}

/* Pagination Styles */
.pagination-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.items-per-page {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #616161;
  font-size: 14px;
}

.page-select {
  padding: 5px 10px;
  border: 1px solid #e0e0e0;
  border-radius: 5px;
  color: #333;
}

.page-navigation {
  display: flex;
  align-items: center;
  gap: 15px;
}

.page-btn {
  padding: 8px 15px;
  border: 1px solid #e0e0e0;
  background: white;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.2s;
  color: #616161;
}

.page-btn:hover:not(:disabled) {
  background: #f5f5f5;
  color: #006633;
  border-color: #006633;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  color: #616161;
  font-size: 14px;
}

.page-input {
  width: 40px;
  padding: 5px;
  border: 1px solid #e0e0e0;
  border-radius: 5px;
  text-align: center;
}

/* Skeleton Styles */
.skeleton-table {
  width: 100%;
}

.skeleton-text {
  height: 15px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 4px;
}

.skeleton-buttons {
  width: 70%;
  height: 32px;
  margin: 0 auto;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>
