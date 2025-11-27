<script setup>
import { ref, onMounted, computed } from 'vue'

const responsables = ref([])
const loading = ref(true)
const error = ref(null)
const searchQuery = ref('')

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)
const itemsPerPageOptions = [10, 20, 50, 100]

// Modal State
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showDeleteModal = ref(false)

// Form state
const submitLoading = ref(false)
const formErrors = ref({})
const successMessage = ref('')
const selectedResponsable = ref(null)

// Create Form State
const createForm = ref({
  nombre_completo: '',
  rol: '',
  email: '',
  telefono: '',
  activo: true
})

// Edit Form State  
const editForm = ref({
  id: null,
  nombre_completo: '',
  rol: '',
  email: '',
  telefono: '',
  activo: true
})

const fetchResponsables = async () => {
  loading.value = true
  try {
    const response = await fetch('http://127.0.0.1:8000/api/responsables/')
    if (!response.ok) throw new Error('Error al cargar responsables')
    responsables.value = await response.json()
  } catch (err) {
    error.value = err.message
    console.error(err)
  } finally {
    loading.value = false
  }
}

const filteredResponsables = computed(() => {
  if (!searchQuery.value) return responsables.value
  const query = searchQuery.value.toLowerCase()
  return responsables.value.filter(resp => 
    (resp.nombre_completo && resp.nombre_completo.toLowerCase().includes(query)) ||
    (resp.rol && resp.rol.toLowerCase().includes(query)) ||
    (resp.email && resp.email.toLowerCase().includes(query))
  )
})

// Pagination computed properties
const totalPages = computed(() => Math.ceil(filteredResponsables.value.length / itemsPerPage.value))

const paginatedResponsables = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredResponsables.value.slice(start, end)
})

// Pagination methods
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

// ===== VALIDATION FUNCTIONS =====
const validateCreateForm = () => {
  const errors = {}
  
  if (!createForm.value.nombre_completo?.trim()) {
    errors.nombre_completo = 'El nombre es requerido'
  }
  if (!createForm.value.rol?.trim()) {
    errors.rol = 'El rol es requerido'
  }
  if (!createForm.value.email?.trim()) {
    errors.email = 'El email es requerido'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(createForm.value.email)) {
    errors.email = 'El email no es válido'
  }
  
  formErrors.value = errors
  return Object.keys(errors).length === 0
}

const validateEditForm = () => {
  const errors = {}
  
  if (!editForm.value.nombre_completo?.trim()) {
    errors.nombre_completo = 'El nombre es requerido'
  }
  if (!editForm.value.rol?.trim()) {
    errors.rol = 'El rol es requerido'
  }
  if (!editForm.value.email?.trim()) {
    errors.email = 'El email es requerido'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(editForm.value.email)) {
    errors.email = 'El email no es válido'
  }
  
  formErrors.value = errors
  return Object.keys(errors).length === 0
}

// ===== CREATE FUNCTIONS =====
const resetCreateForm = () => {
  createForm.value = {
    nombre_completo: '',
    rol: '',
    email: '',
    telefono: '',
    activo: true
  }
  formErrors.value = {}
}

const submitCreateForm = async () => {
  if (!validateCreateForm()) {
    successMessage.value = ''
    return
  }
  
  submitLoading.value = true
  successMessage.value = ''
  
  try {
    const response = await fetch('http://127.0.0.1:8000/api/responsables/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(createForm.value)
    })
    
    if (!response.ok) {
      const errorData = await response.json()
      console.error('Error response:', errorData)
      throw new Error(errorData.detail || 'Error al crear el responsable')
    }
    
    successMessage.value = '✅ Responsable creado exitosamente'
    
    // Refresh list
    await fetchResponsables()
    
    // Close modal after short delay
    setTimeout(() => {
      closeCreateModal()
      resetCreateForm()
      successMessage.value = ''
    }, 2000)
    
  } catch (err) {
    console.error('Error creating responsable:', err)
    formErrors.value = { submit: err.message || 'Error al crear el responsable. Por favor, intente nuevamente.' }
  } finally {
    submitLoading.value = false
  }
}

// ===== EDIT FUNCTIONS =====
const loadResponsableDataIntoEditForm = (responsable) => {
  editForm.value = {
    id: responsable.id,
    nombre_completo: responsable.nombre_completo || '',
    rol: responsable.rol || '',
    email: responsable.email || '',
    telefono: responsable.telefono || '',
    activo: responsable.activo !== undefined ? responsable.activo : true
  }
}

const submitEditForm = async () => {
  if (!validateEditForm()) {
    successMessage.value = ''
    return
  }
  
  submitLoading.value = true
  successMessage.value = ''
  
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/responsables/${editForm.value.id}/`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(editForm.value)
    })
    
    if (!response.ok) {
      const errorData = await response.json()
      console.error('Error response:', errorData)
      throw new Error(errorData.detail || 'Error al actualizar el responsable')
    }
    
    successMessage.value = '✅ Responsable actualizado exitosamente'
    
    // Refresh list
    await fetchResponsables()
    
    // Close modal after short delay
    setTimeout(() => {
      closeEditModal()
      successMessage.value = ''
    }, 2000)
    
  } catch (err) {
    console.error('Error updating responsable:', err)
    formErrors.value = { submit: err.message || 'Error al actualizar el responsable. Por favor, intente nuevamente.' }
  } finally {
    submitLoading.value = false
  }
}

// ===== DELETE FUNCTIONS =====
const confirmDelete = async () => {
  if (!selectedResponsable.value) return
  
  submitLoading.value = true
  
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/responsables/${selectedResponsable.value.id}/`, {
      method: 'DELETE'
    })
    
    if (!response.ok) {
      throw new Error('Error al eliminar el responsable')
    }
    
    // Refresh list
    await fetchResponsables()
    closeDeleteModal()
    
  } catch (err) {
    console.error('Error deleting responsable:', err)
    alert('Error al eliminar el responsable. Puede estar asociado a equipos.')
  } finally {
    submitLoading.value = false
  }
}

// ===== MODAL METHODS =====
const openCreateModal = () => {
  resetCreateForm()
  showCreateModal.value = true
}

const closeCreateModal = () => {
  showCreateModal.value = false
  resetCreateForm()
}

const openEditModal = (responsable) => {
  loadResponsableDataIntoEditForm(responsable)
  showEditModal.value = true
}

const closeEditModal = () => {
  showEditModal.value = false
  formErrors.value = {}
}

const openDeleteModal = (responsable) => {
  selectedResponsable.value = responsable
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  selectedResponsable.value = null
}

onMounted(() => {
  fetchResponsables()
})
</script>

<template>
  <div id="responsables-page">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Responsables</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Responsables / Lista</div>
      </div>
      <button class="btn btn-primary" @click="openCreateModal">➕ Nuevo Responsable</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="🔍 Buscar por nombre, rol o email..." 
            class="search-input"
          >
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''" 
            class="clear-search-btn"
            title="Limpiar búsqueda"
          >
            ✕
          </button>
        </div>
        <button class="filter-button">☰ Filtrar y Ordenar</button>
      </div>

    <!-- Skeleton Loader -->
    <div v-if="loading" class="skeleton-table">
      <table>
        <thead>
          <tr>
            <th style="width: 30%;">Nombre</th>
            <th style="width: 20%;">Rol</th>
            <th style="width: 25%;">Email</th>
            <th style="width: 15%;">Teléfono</th>
            <th style="width: 10%; text-align: center;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="i in 8" :key="i">
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text skeleton-buttons"></div></td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Error State -->
    <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>

    <!-- Table -->
    <table v-else id="responsablesTable">
      <thead>
        <tr>
          <th style="width: 30%;">Nombre</th>
          <th style="width: 20%;">Rol</th>
          <th style="width: 25%;">Email</th>
          <th style="width: 15%;">Teléfono</th>
          <th style="width: 10%; text-align: center;">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="responsable in paginatedResponsables" :key="responsable.id">
          <td>
            <div style="font-weight: 600;">{{ responsable.nombre_completo }}</div>
          </td>
          <td>
            <div style="font-size: 14px; color: #616161;">{{ responsable.rol || 'N/A' }}</div>
          </td>
          <td>
            <div style="font-size: 14px; color: #616161;">{{ responsable.email || 'N/A' }}</div>
          </td>
          <td>
            <div style="font-size: 14px; color: #616161;">{{ responsable.telefono || 'N/A' }}</div>
          </td>
          <td @click.stop>
            <div style="display: flex; gap: 6px; justify-content: center;">
              <button class="btn btn-secondary btn-sm" @click="openEditModal(responsable)" title="Editar">
                ✏️
              </button>
              <button class="btn btn-danger btn-sm" @click="openDeleteModal(responsable)" title="Eliminar">
                🗑️
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Empty State -->
    <div v-if="!loading && filteredResponsables.length === 0" style="text-align: center; padding: 40px; color: #616161;">
      No se encontraron responsables
    </div>

    <!-- Pagination Footer -->
    <div v-if="!loading && filteredResponsables.length > 0" class="pagination-footer">
      <div class="items-per-page">
        <span>Mostrar</span>
        <select v-model.number="itemsPerPage" @change="currentPage = 1" class="page-select">
          <option v-for="option in itemsPerPageOptions" :key="option" :value="option">
            {{ option }}
          </option>
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

    <!-- CREATE MODAL -->
    <div v-if="showCreateModal" class="modal-overlay" @click.self="closeCreateModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>Nuevo Responsable</h2>
          <button class="modal-close" @click="closeCreateModal">×</button>
        </div>
        
        <div class="modal-body">
          <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
          <div v-if="formErrors.submit" class="error-message">{{ formErrors.submit }}</div>
          
          <form @submit.prevent="submitCreateForm">
            <div class="form-group">
              <label class="form-label required">Nombre Completo</label>
              <input 
                type="text" 
                v-model="createForm.nombre_completo" 
                class="form-input"
                :class="{ 'input-error': formErrors.nombre_completo }"
                placeholder="Ej: Juan Pérez"
              >
              <span v-if="formErrors.nombre_completo" class="error-text">{{ formErrors.nombre_completo }}</span>
            </div>

            <div class="form-group">
              <label class="form-label required">Rol</label>
              <input 
                type="text" 
                v-model="createForm.rol" 
                class="form-input"
                :class="{ 'input-error': formErrors.rol }"
                placeholder="Ej: Ingeniero Biomédico"
              >
              <span v-if="formErrors.rol" class="error-text">{{ formErrors.rol }}</span>
            </div>

            <div class="form-group">
              <label class="form-label required">Email</label>
              <input 
                type="email" 
                v-model="createForm.email" 
                class="form-input"
                :class="{ 'input-error': formErrors.email }"
                placeholder="Ej: juan.perez@hospital.com"
              >
              <span v-if="formErrors.email" class="error-text">{{ formErrors.email }}</span>
            </div>

            <div class="form-group">
              <label class="form-label">Teléfono</label>
              <input 
                type="text" 
                v-model="createForm.telefono" 
                class="form-input"
                placeholder="Ej: +57 300 123 4567"
              >
            </div>

            <div class="form-actions">
              <button type="button" class="btn-secondary" @click="closeCreateModal" :disabled="submitLoading">
                Cancelar
              </button>
              <button type="submit" class="btn-primary" :disabled="submitLoading">
                {{ submitLoading ? 'Guardando...' : 'Guardar' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- EDIT MODAL -->
    <div v-if="showEditModal" class="modal-overlay" @click.self="closeEditModal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>Editar Responsable</h2>
          <button class="modal-close" @click="closeEditModal">×</button>
        </div>
        
        <div class="modal-body">
          <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
          <div v-if="formErrors.submit" class="error-message">{{ formErrors.submit }}</div>
          
          <form @submit.prevent="submitEditForm">
            <div class="form-group">
              <label class="form-label required">Nombre Completo</label>
              <input 
                type="text" 
                v-model="editForm.nombre_completo" 
                class="form-input"
                :class="{ 'input-error': formErrors.nombre_completo }"
              >
              <span v-if="formErrors.nombre_completo" class="error-text">{{ formErrors.nombre_completo }}</span>
            </div>

            <div class="form-group">
              <label class="form-label required">Rol</label>
              <input 
                type="text" 
                v-model="editForm.rol" 
                class="form-input"
                :class="{ 'input-error': formErrors.rol }"
              >
              <span v-if="formErrors.rol" class="error-text">{{ formErrors.rol }}</span>
            </div>

            <div class="form-group">
              <label class="form-label required">Email</label>
              <input 
                type="email" 
                v-model="editForm.email" 
                class="form-input"
                :class="{ 'input-error': formErrors.email }"
              >
              <span v-if="formErrors.email" class="error-text">{{ formErrors.email }}</span>
            </div>

            <div class="form-group">
              <label class="form-label">Teléfono</label>
              <input 
                type="text" 
                v-model="editForm.telefono" 
                class="form-input"
              >
            </div>

            <div class="form-actions">
              <button type="button" class="btn-secondary" @click="closeEditModal" :disabled="submitLoading">
                Cancelar
              </button>
              <button type="submit" class="btn-primary" :disabled="submitLoading">
                {{ submitLoading ? 'Guardando...' : 'Guardar Cambios' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- DELETE MODAL -->
    <div v-if="showDeleteModal" class="modal-overlay" @click.self="closeDeleteModal">
      <div class="modal-content modal-small">
        <div class="modal-header">
          <h2>Confirmar Eliminación</h2>
          <button class="modal-close" @click="closeDeleteModal">×</button>
        </div>
        
        <div class="modal-body">
          <p style="margin-bottom: 20px;">
            ¿Está seguro que desea eliminar al responsable <strong>{{ selectedResponsable?.nombre_completo }}</strong>?
          </p>
          <p style="color: #d32f2f; font-size: 14px;">
            Esta acción no se puede deshacer.
          </p>
          
          <div class="form-actions">
            <button type="button" class="btn-secondary" @click="closeDeleteModal" :disabled="submitLoading">
              Cancelar
            </button>
            <button type="button" class="btn-danger" @click="confirmDelete" :disabled="submitLoading">
              {{ submitLoading ? 'Eliminando...' : 'Eliminar' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Estilos copiados de Inventario para mantener coherencia */
.content-card { 
  background: white; 
  border-radius: 10px; 
  padding: 25px; 
  box-shadow: 0 2px 8px rgba(0,0,0,0.08); 
  margin-bottom: 25px; 
}

/* Search Section */
.search-section {
  position: relative;
  flex: 1;
}

.search-input {
  width: 100%;
  padding: 14px 18px;
  padding-right: 40px; /* Make room for clear button */
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #f5f5f5;
}

.search-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
  background: white;
}

.clear-search-btn {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #999;
  font-size: 18px;
  cursor: pointer;
  padding: 5px 8px;
  border-radius: 4px;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.clear-search-btn:hover {
  color: #006633;
  background: rgba(0, 102, 51, 0.1);
}

.search-filter-container { 
  display: flex; 
  gap: 20px; 
  margin-bottom: 25px; 
  align-items: center; 
}

.filter-button { 
  padding: 14px 24px; 
  background: white; 
  border: 2px solid #006633; 
  color: #006633; 
  border-radius: 8px; 
  cursor: pointer; 
  font-weight: 600; 
  font-size: 14px;
  display: flex; 
  align-items: center; 
  gap: 8px; 
  transition: all 0.3s ease;
  white-space: nowrap;
}

.filter-button:hover { 
  background: #006633; 
  color: white; 
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 102, 51, 0.2);
}

/* Button Styles */
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

.btn-sm { 
  padding: 8px 16px; 
  font-size: 13px; 
}

.btn-secondary { 
  background: #e0e0e0; 
}

.btn-danger { 
  background: #f44336; 
  color: white; 
}

table { 
  width: 100%; 
  border-collapse: collapse; 
  table-layout: fixed;
}

thead { 
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%); 
  color: white; 
}

th { 
  padding: 15px; 
  text-align: center; 
  font-size: 13px; 
  text-transform: uppercase;
  white-space: nowrap;
}

td { 
  padding: 15px; 
  border-bottom: 1px solid #e0e0e0; 
  font-size: 14px; 
}

tbody tr {
  background: white;
  transition: all 0.2s;
}

tbody tr:hover { 
  background: rgba(0, 102, 51, 0.08); 
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

/* Pagination Styles */
.pagination-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.items-per-page {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: #616161;
}

.page-select {
  padding: 6px;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  background: #f5f5f5;
  cursor: pointer;
  color: #212121;
  font-weight: 500;
}

.page-select:hover {
  background: #e8e8e8;
  border-color: #a0a0a0;
}

.page-navigation {
  display: flex;
  align-items: center;
  gap: 15px;
}

.page-btn {
  padding: 6px 12px;
  border: 1px solid #c0c0c0;
  background: #e8e8e8;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.2s;
  color: #212121;
  font-weight: 500;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background: #f0f0f0;
}

.page-btn:not(:disabled):hover {
  background: #d0d0d0;
  border-color: #006633;
  color: #006633;
}

.page-info {
  font-size: 14px;
  color: #616161;
  display: flex;
  align-items: center;
  gap: 8px;
}

.page-input {
  width: 40px;
  padding: 4px;
  text-align: center;
  border: 1px solid #c0c0c0;
  border-radius: 4px;
  background: #f5f5f5;
  color: #212121;
  font-weight: 600;
}

.page-input:focus {
  outline: none;
  border-color: #006633;
  background: white;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.modal-small {
  max-width: 450px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px;
  border-bottom: 1px solid #e0e0e0;
}

.modal-header h2 {
  margin: 0;
  color: #006633;
  font-size: 24px;
}

.modal-close {
  background: none;
  border: none;
  font-size: 32px;
  cursor: pointer;
  color: #757575;
  line-height: 1;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.modal-close:hover {
  background: #f0f0f0;
  color: #212121;
}

.modal-body {
  padding: 24px;
}

.form-group {
  margin-bottom: 20px;
}

.form-label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #424242;
}

.form-label.required::after {
  content: ' *';
  color: #d32f2f;
}

.form-input {
  width: 100%;
  padding: 12px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 15px;
  transition: all 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: #006633;
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
}

.form-input.input-error {
  border-color: #d32f2f;
}

.error-text {
  display: block;
  color: #d32f2f;
  font-size: 13px;
  margin-top: 4px;
}

.success-message {
  background: #e8f5e9;
  color: #2e7d32;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 20px;
  font-weight: 600;
}

.error-message {
  background: #ffebee;
  color: #c62828;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.form-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
}

.btn-primary,
.btn-secondary,
.btn-danger {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-primary {
  background: #006633;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #004d26;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 102, 51, 0.3);
}

.btn-secondary {
  background: #f5f5f5;
  color: #424242;
}

.btn-secondary:hover:not(:disabled) {
  background: #e0e0e0;
}

.btn-danger {
  background: #d32f2f;
  color: white;
}

.btn-danger:hover:not(:disabled) {
  background: #b71c1c;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
}

.btn-primary:disabled,
.btn-secondary:disabled,
.btn-danger:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
