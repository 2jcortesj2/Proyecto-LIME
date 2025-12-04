<script setup>
import { ref, onMounted, computed } from 'vue'
import { useResponsables, useNotifications, useFormatting, useAccordion, useModal } from '@/composables'
import { equiposService } from '@/services'
import ModalCrearResponsable from '@/components/modals/responsables/ModalCrearResponsable.vue'
import ModalEditarResponsable from '@/components/modals/responsables/ModalEditarResponsable.vue'
import ModalEliminarResponsable from '@/components/modals/responsables/ModalEliminarResponsable.vue'
import ModalCambiarResponsable from '@/components/modals/responsables/ModalCambiarResponsable.vue'

const notifications = useNotifications()
const { normalizeText, formatUbicacion } = useFormatting()
const { expandedRows, toggleRow, isExpanded } = useAccordion()
const changeResponsableModal = useModal()

// Usar composable de responsables
const {
  responsables,
  loading,
  error,
  submitLoading,
  successMessage, // Keeping it for now if modals rely on it, but we'll use notifications
  formErrors,
  fetchResponsables,
  createResponsable,
  updateResponsable,
  deleteResponsable,
  resetFormErrors
} = useResponsables()

// Equipment accordion state
const equiposPorResponsable = ref({}) // Cache: { responsableId: [equipos] }
const loadingEquipos = ref({}) // Loading state: { responsableId: boolean }

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
const selectedResponsable = ref(null)

// Filter Panel State
const showFilterPanel = ref(false)

// Filter State
const filtros = ref({
  roles: []
})

const collapsedSections = ref({
  ordenar: false,
  rol: false
})

const toggleSection = (section) => {
  collapsedSections.value[section] = !collapsedSections.value[section]
}

const ordenamiento = ref('nombre-asc')

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

// Obtener roles únicos
const rolesUnicos = computed(() => {
  const roles = responsables.value.map(r => r.rol).filter(Boolean)
  return [...new Set(roles)].sort()
})

const filteredResponsables = computed(() => {
  let result = responsables.value

  // Filtro por búsqueda
  if (searchQuery.value) {
    const normalizedQuery = normalizeText(searchQuery.value)
    result = result.filter(resp => 
      normalizeText(resp.nombre_completo || '').includes(normalizedQuery) ||
      normalizeText(resp.rol || '').includes(normalizedQuery) ||
      normalizeText(resp.email || '').includes(normalizedQuery) ||
      normalizeText(resp.telefono || '').includes(normalizedQuery)
    )
  }

  // Filtro por roles
  if (filtros.value.roles.length > 0) {
    result = result.filter(resp => filtros.value.roles.includes(resp.rol))
  }

  // Ordenamiento
  switch (ordenamiento.value) {
    case 'nombre-asc':
      result.sort((a, b) => a.nombre_completo.localeCompare(b.nombre_completo))
      break
    case 'nombre-desc':
      result.sort((a, b) => b.nombre_completo.localeCompare(a.nombre_completo))
      break
    case 'rol-asc':
      result.sort((a, b) => (a.rol || '').localeCompare(b.rol || ''))
      break
    case 'rol-desc':
      result.sort((a, b) => (b.rol || '').localeCompare(a.rol || ''))
      break
    case 'equipos-asc':
      result.sort((a, b) => (a.equipos_asignados_count || 0) - (b.equipos_asignados_count || 0))
      break
    case 'equipos-desc':
      result.sort((a, b) => (b.equipos_asignados_count || 0) - (a.equipos_asignados_count || 0))
      break
  }

  return result
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

// Filter methods
function toggleFilterPanel() {
  showFilterPanel.value = !showFilterPanel.value
}

function toggleRolFilter(rol) {
  const index = filtros.value.roles.indexOf(rol)
  if (index > -1) {
    filtros.value.roles.splice(index, 1)
  } else {
    filtros.value.roles.push(rol)
  }
  currentPage.value = 1
}

function borrarTodosFiltros() {
  filtros.value.roles = []
  ordenamiento.value = 'nombre-asc'
  currentPage.value = 1
}

// Sort toggle methods
const toggleSortCheckbox = (field) => {
  const isActive = ordenamiento.value === `${field}-asc` || ordenamiento.value === `${field}-desc`
  if (isActive) {
    ordenamiento.value = 'nombre-asc' // Reset to default
  } else {
    ordenamiento.value = `${field}-asc` // Activate in ascending order
  }
}

const toggleSortDirection = (field) => {
  const isActive = ordenamiento.value === `${field}-asc` || ordenamiento.value === `${field}-desc`
  if (isActive) {
    ordenamiento.value = ordenamiento.value === `${field}-asc` ? `${field}-desc` : `${field}-asc`
  }
}

const filtrosActivos = computed(() => {
  return filtros.value.roles.length
})

const ordenamientoActivo = computed(() => {
  return ordenamiento.value !== 'nombre-asc'
})

// ===== CREATE FUNCTIONS =====
const resetCreateForm = () => {
  createForm.value = {
    nombre_completo: '',
    rol: '',
    email: '',
    telefono: '',
    activo: true
  }
  resetFormErrors()
}

const submitCreateForm = async () => {
  const success = await createResponsable(createForm.value)
  if (success) {
    notifications.success('<AppIcon name="check" size="16" /> Responsable creado exitosamente')
    closeCreateModal()
    resetCreateForm()
  } else {
    notifications.error('<AppIcon name="close" size="16" /> Error al crear el responsable')
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
  const success = await updateResponsable(editForm.value.id, editForm.value)
  if (success) {
    notifications.success('<AppIcon name="check" size="16" /> Responsable actualizado exitosamente')
    closeEditModal()
  } else {
    notifications.error('<AppIcon name="close" size="16" /> Error al actualizar el responsable')
  }
}

// Handle delete button click with validation
const handleDeleteClick = (responsable) => {
  if (responsable.equipos_asignados_count > 0) {
    notifications.warning(
      `<AppIcon name="alert" size="16" /> No se puede eliminar a ${responsable.nombre_completo}. Tiene ${responsable.equipos_asignados_count} equipo(s) asignado(s). Por favor, reasigne los equipos primero.`,
      5000
    )
    return
  }
  openDeleteModal(responsable)
}

// ===== DELETE FUNCTIONS =====
const confirmDelete = async () => {
  if (!selectedResponsable.value) return
  
  const result = await deleteResponsable(selectedResponsable.value)
  if (result.success) {
    notifications.success('<AppIcon name="check" size="16" /> Responsable eliminado exitosamente')
    closeDeleteModal()
  } else {
    notifications.error(result.message || '<AppIcon name="close" size="16" /> Error al eliminar el responsable')
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
  resetFormErrors()
}

const openDeleteModal = (responsable) => {
  selectedResponsable.value = responsable
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  selectedResponsable.value = null
}

// ===== EQUIPMENT ACCORDION FUNCTIONS =====
const fetchEquiposForResponsable = async (responsableId) => {
  // Check if already cached
  if (equiposPorResponsable.value[responsableId]) {
    return
  }

  loadingEquipos.value[responsableId] = true
  
  try {
    const equipos = await equiposService.getAll({ responsable: responsableId })
    equiposPorResponsable.value[responsableId] = equipos
  } catch (err) {
    console.error('Error fetching equipment:', err)
    notifications.error('Error al cargar los equipos')
    equiposPorResponsable.value[responsableId] = []
  } finally {
    loadingEquipos.value[responsableId] = false
  }
}

const handleRowClick = async (responsable) => {
  const wasExpanded = isExpanded(responsable.id)
  toggleRow(responsable.id)
  
  // If expanding and no data cached, fetch equipment
  if (!wasExpanded && !equiposPorResponsable.value[responsable.id]) {
    await fetchEquiposForResponsable(responsable.id)
  }
}

const openChangeResponsableModal = (equipo) => {
  changeResponsableModal.open(equipo)
}

const handleChangeResponsable = async (data) => {
  try {
    const { equipoId, nuevoResponsableId, justificacion } = data
    
    // Update equipment with new responsable
    await equiposService.update(equipoId, {
      responsable: nuevoResponsableId,
      justificacion: justificacion
    })
    
    notifications.success('Responsable cambiado exitosamente')
    
    // Refresh responsables list
    await fetchResponsables()
    
    // Clear equipment cache for affected responsables
    equiposPorResponsable.value = {}
    
    // Reload equipment for currently expanded rows to reflect changes immediately
    for (const id of expandedRows.value) {
      await fetchEquiposForResponsable(id)
    }
    
    changeResponsableModal.close()
  } catch (err) {
    console.error('Error changing responsable:', err)
    notifications.error('Error al cambiar el responsable')
    throw err
  }
}

onMounted(() => {
  fetchResponsables()
})
</script>

<template>
  <div id="responsables-page">
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

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Responsables</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Responsables / Lista</div>
      </div>
      <button class="btn btn-primary" @click="openCreateModal"><AppIcon name="plus" size="16" /> Nuevo Responsable</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Buscar por nombre, rol, email o teléfono..." 
            class="search-input"
          >
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''" 
            class="clear-search-btn"
            title="Limpiar búsqueda"
          >
            <AppIcon name="close" size="16" />
          </button>
        </div>
        <button class="filter-button" @click="toggleFilterPanel">
          <AppIcon name="menu" size="16" /> Filtrar y Ordenar
          <span v-if="filtrosActivos > 0 || ordenamientoActivo" class="filter-badge">
            {{ filtrosActivos + (ordenamientoActivo ? 1 : 0) }}
          </span>
        </button>
      </div>

    <!-- Skeleton Loader -->
    <div v-if="loading" class="skeleton-table">
      <table>
        <thead>
          <tr>
            <th style="width: 25%;">Nombre</th>
            <th style="width: 15%;">Rol</th>
            <th style="width: 10%; text-align: center;">Equipos</th>
            <th style="width: 25%;">Email</th>
            <th style="width: 15%;">Teléfono</th>
            <th style="width: 10%; text-align: center;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="i in 8" :key="i">
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text"></div></td>
            <td><div class="skeleton-text" style="width: 40%; margin: 0 auto;"></div></td>
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
          <th style="width: 23%;">Nombre</th>
          <th style="width: 14%;">Rol</th>
          <th style="width: 10%; text-align: center;">Equipos</th>
          <th style="width: 22%;">Email</th>
          <th style="width: 13%;">Teléfono</th>
          <th style="width: 18%;">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <template v-for="responsable in paginatedResponsables" :key="responsable.id">
          <tr @click="handleRowClick(responsable)" class="clickable-row" :class="{ 'row-expanded': isExpanded(responsable.id) }">
            <td>
              <div style="font-weight: 600;">{{ responsable.nombre_completo }}</div>
            </td>
            <td>
              <div style="font-size: 14px; color: #616161;">{{ responsable.rol || 'N/A' }}</div>
            </td>
            <td style="text-align: center;">
              <span class="badge badge-success" style="font-size: 13px;">
                {{ responsable.equipos_asignados_count || 0 }}
              </span>
            </td>
            <td>
              <div style="font-size: 14px; color: #616161;">{{ responsable.email || 'N/A' }}</div>
            </td>
            <td>
              <div style="font-size: 14px; color: #616161;">{{ responsable.telefono || 'N/A' }}</div>
            </td>
            <td @click.stop>
              <div class="actions-container">
                <button 
                  class="btn btn-info btn-sm btn-ver" 
                  :class="{ 'btn-ver-active': isExpanded(responsable.id) }"
                  @click="handleRowClick(responsable)"
                  title="Ver equipos asignados"
                >
                  <AppIcon name="eye" size="16" />
                </button>
                <button class="btn btn-secondary btn-sm" @click="openEditModal(responsable)" title="Editar">
                  <AppIcon name="edit" size="16" />
                </button>
                <button 
                  class="btn btn-danger btn-sm" 
                  :class="{ 'btn-disabled': responsable.equipos_asignados_count > 0 }"
                  @click="handleDeleteClick(responsable)" 
                  :title="responsable.equipos_asignados_count > 0 
                    ? `No se puede eliminar: tiene ${responsable.equipos_asignados_count} equipo(s) asignado(s)` 
                    : 'Eliminar'"
                >
                  <AppIcon name="trash" size="16" />
                </button>
              </div>
            </td>
          </tr>
          
          <!-- Expanded equipment details row -->
          <tr v-if="isExpanded(responsable.id)" class="detalle-row active">
            <td colspan="6" class="detalle-cell">
              <div class="detalle-container">
                <!-- Loading state -->
                <div v-if="loadingEquipos[responsable.id]" style="text-align: center; padding: 20px;">
                  <div class="spinner" style="display: inline-block; width: 30px; height: 30px; border: 3px solid #f3f3f3; border-top: 3px solid #006633; border-radius: 50%; animation: spin 1s linear infinite;"></div>
                  <p style="color: #666; font-size: 13px; margin-top: 10px;">Cargando equipos...</p>
                </div>
                
                <!-- Equipment list -->
                <div v-else-if="equiposPorResponsable[responsable.id]?.length > 0">
                  <div class="detalle-header">
                    <div class="detalle-title"><AppIcon name="inventory" size="16" /> Equipos Asignados - {{ responsable.nombre_completo }}</div>
                    <button class="btn btn-secondary btn-sm" @click="handleRowClick(responsable)"><AppIcon name="close" size="16" /> Cerrar</button>
                  </div>
                  
                  <table class="tabla-equipos">
                    <thead>
                      <tr>
                        <th style="width: 10%; text-align: center;">Código</th>
                        <th style="width: 20%; text-align: center;">Equipo</th>
                        <th style="width: 20%; text-align: center;">Registro INVIMA</th>
                        <th style="width: 8%; text-align: center;">Riesgo</th>
                        <th style="width: 20%; text-align: center;">Sede / Ubicación</th>
                        <th style="width: 12%; text-align: center;">Estado</th>
                        <th style="width: 10%; text-align: center;">Acción</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="equipo in equiposPorResponsable[responsable.id]" :key="equipo.id">
                        <td style="text-align: center;"><strong>{{ equipo.codigo_interno || 'N/A' }}</strong></td>
                        <td>
                          <div style="font-weight: 600;">{{ equipo.nombre_equipo || 'N/A' }}</div>
                          <div style="font-size: 11px; color: #616161;">{{ equipo.marca }} - {{ equipo.modelo }}</div>
                        </td>
                        <td style="text-align: center;">
                          <span v-if="equipo.registro_invima" class="invima-badge">{{ equipo.registro_invima }}</span>
                          <span v-else class="invima-badge" style="background: rgba(158, 158, 158, 0.1); color: #9e9e9e;">N/A</span>
                        </td>
                        <td style="text-align: center;">
                          <span class="risk-box" :class="`risk-${equipo.clasificacion_riesgo}`">
                            {{ equipo.clasificacion_riesgo || 'N/A' }}
                          </span>
                        </td>
                        <td>
                          <div style="font-weight: 600; font-size: 14px;">{{ equipo.sede?.nombre || 'N/A' }}</div>
                          <div style="font-size: 12px; color: #616161;">{{ formatUbicacion(equipo.ubicacion?.nombre) }}</div>
                        </td>
                        <td style="text-align: center;">
                          <span class="estado-badge" :class="`estado-${equipo.estado?.toLowerCase()}`">
                            {{ equipo.estado || 'N/A' }}
                          </span>
                        </td>
                        <td>
                          <button 
                            class="btn btn-secondary btn-sm" 
                            @click.stop="openChangeResponsableModal(equipo)"
                            title="Cambiar responsable"
                          >
                            Cambiar
                          </button>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                
                <!-- Empty state -->
                <div v-else class="no-equipment">
                  <AppIcon name="inventory" size="16" /> No hay equipos asignados a este responsable
                </div>
              </div>
            </td>
          </tr>
        </template>
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

    <!-- FILTER PANEL -->
    <div class="filtro-overlay" :class="{ active: showFilterPanel }" @click="showFilterPanel = false"></div>
    <div class="filtro-panel" :class="{ active: showFilterPanel }">
      <div class="filtro-header">
        <h3>FILTRAR Y ORDENAR</h3>
        <button class="borrar-todo" @click="borrarTodosFiltros">Borrar todo</button>
      </div>

      <div class="filtro-body">
        <!-- Ordenar por -->
        <div class="filtro-section">
          <button 
            class="filtro-section-title" 
            :class="{ collapsed: collapsedSections.ordenar }"
            @click="toggleSection('ordenar')"
          >
            Ordenar por
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <div class="sort-options">
              <label class="sort-item">
                <input 
                  type="checkbox" 
                  :checked="ordenamiento === 'nombre-asc' || ordenamiento === 'nombre-desc'"
                  @click="toggleSortCheckbox('nombre')"
                >
                <span 
                  class="sort-label-area"
                  @click.prevent="toggleSortDirection('nombre')"
                >
                  <span class="sort-label">Nombre</span>
                  <span 
                    class="sort-arrow" 
                    :class="{ 'arrow-down': ordenamiento === 'nombre-desc' }"
                    v-if="ordenamiento === 'nombre-asc' || ordenamiento === 'nombre-desc'"
                  >
                    <AppIcon name="sort-asc" size="16" />
                  </span>
                </span>
              </label>

              <label class="sort-item">
                <input 
                  type="checkbox" 
                  :checked="ordenamiento === 'rol-asc' || ordenamiento === 'rol-desc'"
                  @click="toggleSortCheckbox('rol')"
                >
                <span 
                  class="sort-label-area"
                  @click.prevent="toggleSortDirection('rol')"
                >
                  <span class="sort-label">Rol</span>
                  <span 
                    class="sort-arrow" 
                    :class="{ 'arrow-down': ordenamiento === 'rol-desc' }"
                    v-if="ordenamiento === 'rol-asc' || ordenamiento === 'rol-desc'"
                  >
                    <AppIcon name="sort-asc" size="16" />
                  </span>
                </span>
              </label>

              <label class="sort-item">
                <input 
                  type="checkbox" 
                  :checked="ordenamiento === 'equipos-asc' || ordenamiento === 'equipos-desc'"
                  @click="toggleSortCheckbox('equipos')"
                >
                <span 
                  class="sort-label-area"
                  @click.prevent="toggleSortDirection('equipos')"
                >
                  <span class="sort-label">Equipos Asignados</span>
                  <span 
                    class="sort-arrow" 
                    :class="{ 'arrow-down': ordenamiento === 'equipos-desc' }"
                    v-if="ordenamiento === 'equipos-asc' || ordenamiento === 'equipos-desc'"
                  >
                    <AppIcon name="sort-asc" size="16" />
                  </span>
                </span>
              </label>
            </div>
          </div>
        </div>

        <!-- Rol -->
        <div class="filtro-section" v-if="rolesUnicos.length > 0">
          <button 
            class="filtro-section-title" 
            :class="{ collapsed: collapsedSections.rol }"
            @click="toggleSection('rol')"
          >
            Rol
            <span class="arrow"><AppIcon name="chevron-down" size="16" /></span>
          </button>
          <div class="filtro-content">
            <label class="filtro-item" v-for="rol in rolesUnicos" :key="rol">
              <input 
                type="checkbox" 
                :checked="filtros.roles.includes(rol)"
                @change="toggleRolFilter(rol)"
              >
              <span>{{ rol }}</span>
            </label>
          </div>
        </div>
      </div>

      <div class="filtro-footer">
        <p>{{ filteredResponsables.length }} responsables encontrados</p>
      </div>
    </div>

    <!-- EXTERNAL MODALS -->
    <ModalCrearResponsable
      :show="showCreateModal"
      :formData="createForm"
      :formErrors="formErrors"
      :successMessage="successMessage"
      :submitLoading="submitLoading"
      @close="closeCreateModal"
      @submit="submitCreateForm"
      @update:formData="createForm = $event"
    />

    <ModalEditarResponsable
      :show="showEditModal"
      :formData="editForm"
      :formErrors="formErrors"
      :successMessage="successMessage"
      :submitLoading="submitLoading"
      @close="closeEditModal"
      @submit="submitEditForm"
      @update:formData="editForm = $event"
    />

    <ModalEliminarResponsable
      :show="showDeleteModal"
      :responsable="selectedResponsable"
      :submitLoading="submitLoading"
      @close="closeDeleteModal"
      @confirm="confirmDelete"
    />

    <ModalCambiarResponsable
      :show="changeResponsableModal.isOpen.value"
      :equipo="changeResponsableModal.data.value"
      :responsables="responsables"
      @close="changeResponsableModal.close()"
      @save="handleChangeResponsable"
    />
  </div>
</template>

<style scoped>
/* Estilos específicos si son necesarios, el resto viene de components.css y filter-styles.css */

/* Clickable rows - use green highlight instead of pink */
.clickable-row {
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.clickable-row:hover {
  background-color: #f5f5f5;
}

.clickable-row.row-expanded {
  background-color: rgba(0, 102, 51, 0.05); /* Green tint */
}

/* Equipment table uses global styles from components.css */
.tabla-equipos {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

.tabla-equipos thead {
  background-color: #006633 !important;
}

.tabla-equipos thead tr {
  background-color: #006633 !important;
}

.tabla-equipos thead tr:hover {
  background-color: #006633 !important;
}

.tabla-equipos th {
  padding: 12px;
  text-align: left;
  font-weight: 600;
  font-size: 13px;
  color: white !important;
  border-bottom: 2px solid #004d26;
  background-color: #006633 !important;
}

.tabla-equipos td {
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
  font-size: 13px;
}

.tabla-equipos tbody tr {
  background-color: white;
}

.tabla-equipos tbody tr:hover {
  background-color: #fafafa;
}

.no-equipment {
  text-align: center;
  padding: 40px;
  color: #757575;
  font-size: 14px;
}

/* Spinner animation */
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Sort Items */
.sort-options {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.sort-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  cursor: pointer;
  transition: background-color 0.2s ease;
  border-radius: 4px;
}

.sort-item:hover {
  background-color: #f5f5f5;
}

.sort-item input[type="checkbox"] {
  cursor: pointer;
  flex-shrink: 0;
}

.sort-label-area {
  flex: 1;
  display: flex;
  align-items: center;
  cursor: pointer;
  gap: 10px;
}

.sort-item .sort-label {
  flex: 1;
  font-size: 14px;
  color: #212121;
  user-select: none;
}

.sort-arrow {
  font-size: 16px;
  color: #757575;
  font-weight: bold;
  transition: transform 0.3s ease, color 0.2s ease;
  flex-shrink: 0;
  margin-left: auto;
}

.sort-item:hover .sort-arrow {
  color: #9c27b0;
}

.sort-item input[type="checkbox"]:checked ~ .sort-label-area .sort-arrow {
  color: #9c27b0;
}

.sort-arrow.arrow-down {
  transform: rotate(180deg);
}

/* Button disabled state */
.btn-disabled {
  opacity: 0.4;
  cursor: not-allowed !important;
  pointer-events: auto !important;
}

.btn-disabled:hover {
  transform: none !important;
  box-shadow: none !important;
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
