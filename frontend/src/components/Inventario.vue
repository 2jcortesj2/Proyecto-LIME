<script setup>
import { ref, onMounted, computed } from 'vue'

const equipos = ref([])
const loading = ref(true)
const detailLoading = ref(false)
const error = ref(null)
const searchQuery = ref('')
const expandedEquipoId = ref(null)
const selectedEquipo = ref(null)
const activeTab = ref('info') // 'info', 'metrologia', 'traslados', 'mantenimientos'

// Mapeo de pestañas
const tabs = {
  info: 'Información General',
  metrologia: 'Metrología',
  traslados: 'Historial Traslados',
  mantenimientos: 'Mantenimientos'
}

const fetchEquipos = async () => {
  loading.value = true
  try {
    const response = await fetch('http://127.0.0.1:8000/api/equipos/')
    if (!response.ok) throw new Error('Error al cargar equipos')
    equipos.value = await response.json()
  } catch (err) {
    error.value = err.message
    console.error(err)
  } finally {
    loading.value = false
  }
}

const fetchEquipoDetalle = async (id) => {
  detailLoading.value = true
  selectedEquipo.value = null
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/equipos/${id}/`)
    if (!response.ok) throw new Error('Error al cargar detalle del equipo')
    selectedEquipo.value = await response.json()
  } catch (err) {
    console.error(err)
    // Fallback to list item if fetch fails, though it won't have history
    selectedEquipo.value = equipos.value.find(e => e.id === id)
  } finally {
    detailLoading.value = false
  }
}

const filteredEquipos = computed(() => {
  if (!searchQuery.value) return equipos.value
  const query = searchQuery.value.toLowerCase()
  return equipos.value.filter(eq => 
    (eq.nombre_equipo && eq.nombre_equipo.toLowerCase().includes(query)) ||
    (eq.codigo_interno && eq.codigo_interno.toLowerCase().includes(query)) ||
    (eq.marca && eq.marca.toLowerCase().includes(query)) ||
    (eq.modelo && eq.modelo.toLowerCase().includes(query)) ||
    (eq.serie && eq.serie.toLowerCase().includes(query))
  )
})

const toggleDetalle = (id) => {
  if (expandedEquipoId.value === id) {
    expandedEquipoId.value = null
    selectedEquipo.value = null
  } else {
    expandedEquipoId.value = id
    activeTab.value = 'info' // Reset tab
    fetchEquipoDetalle(id)
  }
}

const setActiveTab = (tab) => {
  activeTab.value = tab
}

const getRiesgoBadgeClass = (riesgo) => {
  if (!riesgo) return 'badge-secondary'
  if (riesgo === 'III' || riesgo === 'IIb') return 'badge-danger'
  if (riesgo === 'IIa') return 'badge-warning'
  return 'badge-success'
}

const getEstadoBadgeClass = (estado) => {
  if (!estado) return 'estado-inactivo'
  if (estado === 'Activo') return 'estado-activo'
  if (estado === 'En Mantenimiento' || estado === 'Mantenimiento') return 'estado-mantenimiento'
  if (estado === 'Baja') return 'estado-baja'
  return 'estado-inactivo'
}

const formatFecha = (fecha) => {
  if (!fecha) return 'N/A'
  const date = new Date(fecha)
  const meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ]
  return `${meses[date.getMonth()]} ${date.getFullYear()}`
}

onMounted(() => {
  fetchEquipos()
})
</script>

<template>
  <div id="equipos-page">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Inventario de Equipos</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Equipos / Lista</div>
      </div>
      <button class="btn btn-primary">➕ Nuevo Equipo</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input 
            type="text" 
            class="search-input" 
            placeholder="🔍 Buscar por código, nombre, marca, modelo o serie..." 
            v-model="searchQuery"
          >
        </div>
        <button class="filter-button">☰ Filtrar y Ordenar</button>
      </div>

      <!-- Skeleton Loader -->
      <div v-if="loading" class="skeleton-container">
        <div class="skeleton-header"></div>
        <div class="skeleton-row" v-for="i in 5" :key="i">
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
          <div class="skeleton-cell"></div>
        </div>
      </div>

      <div v-else-if="error" style="color: red; text-align: center; padding: 40px;">{{ error }}</div>
      
      <table v-else id="equiposTable">
        <thead>
          <tr>
            <th style="width: 90px;">Código</th>
            <th style="width: 220px;">Equipo</th>
            <th style="width: 160px;">Registro Invima</th>
            <th style="width: 70px;">Riesgo</th>
            <th style="width: 180px;">Sede / Servicio</th>
            <th style="width: 150px;">Encargado</th>
            <th style="width: 120px;">Estado</th>
            <th style="width: 140px;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="equipo in filteredEquipos" :key="equipo.id">
            <tr :data-equipo="equipo.id" @click="toggleDetalle(equipo.id)" :class="{ 'row-active': expandedEquipoId === equipo.id }">
              <td><strong>{{ equipo.codigo_interno }}</strong></td>
              <td>
                <div style="font-weight: 600;">{{ equipo.nombre_equipo }}</div>
                <div style="font-size: 11px; color: #616161;">{{ equipo.marca }} - {{ equipo.modelo }}</div>
              </td>
              <td>
                <span v-if="equipo.registro_invima" class="invima-badge">{{ equipo.registro_invima }}</span>
                <span v-else class="invima-badge" style="background: rgba(158, 158, 158, 0.1); color: #9e9e9e;">N/A</span>
              </td>
              <td>
                <span class="risk-box" :class="getRiesgoBadgeClass(equipo.clasificacion_riesgo)">
                  {{ equipo.clasificacion_riesgo || 'N/A' }}
                </span>
              </td>
              <td>
                <div style="font-weight: 600; font-size: 13px;">{{ equipo.sede?.nombre || 'N/A' }}</div>
                <div style="font-size: 11px; color: #616161;">{{ equipo.servicio?.nombre || 'N/A' }}</div>
              </td>
              <td>{{ equipo.responsable_nombre || 'N/A' }}</td>
              <td>
                <span class="estado-badge" :class="getEstadoBadgeClass(equipo.estado)">
                  {{ equipo.estado || 'N/A' }}
                </span>
              </td>
              <td @click.stop>
                <div style="display: flex; gap: 10px;">
                  <button 
                    class="btn btn-info btn-sm btn-ver" 
                    :class="{ 'btn-ver-active': expandedEquipoId === equipo.id }"
                    @click="toggleDetalle(equipo.id)"
                  >👁️</button>
                  <button class="btn btn-secondary btn-sm" @click.stop>✏️</button>
                  <button class="btn btn-danger btn-sm" @click.stop>🗑️</button>
                </div>
              </td>
            </tr>

            <!-- Detalle Row -->
            <tr v-if="expandedEquipoId === equipo.id" class="detalle-row active">
              <td colspan="8" class="detalle-cell">
                <div class="detalle-container">
                  <div v-if="detailLoading" style="padding: 40px; text-align: center;">
                    Cargando detalles...
                  </div>
                  <div v-else-if="selectedEquipo">
                    <div class="detalle-header">
                      <div class="detalle-title">📋 Detalle del Equipo - {{ selectedEquipo.nombre_equipo }} ({{ selectedEquipo.codigo_interno }})</div>
                      <button class="btn btn-secondary btn-sm" @click="toggleDetalle(equipo.id)">✕ Cerrar</button>
                    </div>

                    <div class="detalle-tabs">
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'info' }"
                        @click="setActiveTab('info')"
                      >Información General</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'metrologia' }"
                        @click="setActiveTab('metrologia')"
                      >Metrología</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'traslados' }"
                        @click="setActiveTab('traslados')"
                      >Historial Traslados</div>
                      <div 
                        class="detalle-tab" 
                        :class="{ active: activeTab === 'mantenimientos' }"
                        @click="setActiveTab('mantenimientos')"
                      >Mantenimientos</div>
                    </div>

                    <!-- Tab Content: Información General -->
                    <div v-show="activeTab === 'info'" class="detalle-content active">
                      <div class="detalle-grid">
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">A. Información General</h4>
                          <div class="detalle-item"><span class="detalle-label">Proceso:</span><span class="detalle-value">LIME</span></div>
                          <div class="detalle-item"><span class="detalle-label">Código Interno:</span><span class="detalle-value"><strong>{{ selectedEquipo.codigo_interno }}</strong></span></div>
                          <div class="detalle-item"><span class="detalle-label">Código IPS:</span><span class="detalle-value">{{ selectedEquipo.codigo_ips || 'Pendiente' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Responsable:</span><span class="detalle-value">{{ selectedEquipo.responsable_nombre || 'N/A' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Ubicación:</span><span class="detalle-value">{{ selectedEquipo.ubicacion_fisica }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Sede:</span><span class="detalle-value">{{ selectedEquipo.sede_info?.nombre }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Servicio:</span><span class="detalle-value">{{ selectedEquipo.servicio_info?.nombre }}</span></div>
                        </div>
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">B. Información del Equipo</h4>
                          <div class="detalle-item"><span class="detalle-label">Nombre:</span><span class="detalle-value">{{ selectedEquipo.nombre_equipo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Marca:</span><span class="detalle-value">{{ selectedEquipo.marca }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Modelo:</span><span class="detalle-value">{{ selectedEquipo.modelo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Serie:</span><span class="detalle-value">{{ selectedEquipo.serie }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Clasif. IPS:</span><span class="detalle-value">{{ selectedEquipo.clasificacion_ips }}</span></div>
                          <div class="detalle-item">
                            <span class="detalle-label">Registro INVIMA:</span>
                            <span class="detalle-value">
                              <span v-if="selectedEquipo.registro_invima" class="invima-badge">{{ selectedEquipo.registro_invima }}</span>
                              <span v-else style="color: #999;">N/A</span>
                            </span>
                          </div>
                        </div>
                        <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">C. Registro Histórico</h4>
                          <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                            <div class="detalle-item"><span class="detalle-label">Fecha Adquisición:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.fecha_adquisicion }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Propietario:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.propietario }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Forma Adquisición:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.forma_adquisicion }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Proveedor:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.nombre_proveedor }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">En Garantía:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.en_garantia ? 'Sí' : 'No' }}</span></div>
                            <div class="detalle-item"><span class="detalle-label">Documento:</span><span class="detalle-value">{{ selectedEquipo.registro_adquisicion?.tipo_documento }} #{{ selectedEquipo.registro_adquisicion?.numero_documento }}</span></div>
                          </div>
                        </div>
                        <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">D. Inventario de Documentos</h4>
                          <div class="documentos-grid">
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.hoja_vida ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.hoja_vida ? '✅' : '❌' }}</span>
                              <span>Hoja de Vida</span>
                            </div>
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.registro_importacion ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.registro_importacion ? '✅' : '❌' }}</span>
                              <span>Registro Importación</span>
                            </div>
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.manual_operacion ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.manual_operacion ? '✅' : '❌' }}</span>
                              <span>Manual Operación (Esp)</span>
                            </div>
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.manual_servicio ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.manual_servicio ? '✅' : '❌' }}</span>
                              <span>Manual Servicio</span>
                            </div>
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.guia_rapida ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.guia_rapida ? '✅' : '❌' }}</span>
                              <span>Guía Rápida</span>
                            </div>
                            <div class="documento-item">
                              <span class="x-icon">❌</span>
                              <span>Instructivo Manejo</span>
                            </div>
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.protocolo_mto_preventivo ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.protocolo_mto_preventivo ? '✅' : '❌' }}</span>
                              <span>Protocolo Mto Prev</span>
                            </div>
                            <div class="documento-item">
                              <span :class="selectedEquipo.documentacion?.frecuencia_metrologica ? 'check-icon' : 'x-icon'">{{ selectedEquipo.documentacion?.frecuencia_metrologica ? '✅' : '❌' }}</span>
                              <span>Frecuencia Metrológica</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Tab Content: Metrología -->
                    <div v-show="activeTab === 'metrologia'" class="detalle-content active">
                      <div class="detalle-grid">
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">E. Info Metrológica Administrativa</h4>
                          <div class="detalle-item"><span class="detalle-label">Requiere Mantenimiento:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.requiere_mantenimiento ? '✅ Sí' : 'No' }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Frecuencia:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.frecuencia_mantenimiento }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Último Mantenimiento:</span><span class="detalle-value">{{ formatFecha(selectedEquipo.informacion_metrologica?.ultimo_mantenimiento) }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Próximo Mantenimiento:</span><span class="detalle-value">{{ formatFecha(selectedEquipo.informacion_metrologica?.fecha_proximo_mantenimiento_calculada) }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Estado Mantenimiento:</span><span class="detalle-value"><strong>{{ selectedEquipo.informacion_metrologica?.estado_mantenimiento || 'N/A' }}</strong></span></div>
                          <div class="detalle-item"><span class="detalle-label">Requiere Calibración:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.requiere_calibracion ? '✅ Sí' : 'No' }}</span></div>
                        </div>
                        <div class="detalle-section">
                          <h4 class="detalle-section-title">F. Info Metrológica Técnica</h4>
                          <div class="detalle-item"><span class="detalle-label">Magnitud:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.magnitud }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Rango del Equipo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.rango_equipo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Rango de Trabajo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.rango_trabajo }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Resolución:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.resolucion }}</span></div>
                          <div class="detalle-item"><span class="detalle-label">Error Máximo:</span><span class="detalle-value">{{ selectedEquipo.informacion_metrologica?.error_maximo }}</span></div>
                        </div>
                      </div>
                    </div>

                    <!-- Tab Content: Traslados -->
                    <div v-show="activeTab === 'traslados'" class="detalle-content active">
                      <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">Historial de Traslados</h4>
                          <table v-if="selectedEquipo.traslados && selectedEquipo.traslados.length > 0" style="width: 100%; margin-top: 10px;">
                            <thead>
                              <tr>
                                <th>Fecha</th>
                                <th>Origen</th>
                                <th>Destino</th>
                                <th>Justificación</th>
                                <th>Usuario</th>
                              </tr>
                            </thead>
                            <tbody>
                              <tr v-for="traslado in selectedEquipo.traslados" :key="traslado.id">
                                <td>{{ new Date(traslado.fecha_traslado).toLocaleDateString() }}</td>
                                <td>{{ traslado.sede_origen_nombre }} / {{ traslado.servicio_origen_nombre }}</td>
                                <td>{{ traslado.sede_destino_nombre }} / {{ traslado.servicio_destino_nombre }}</td>
                                <td>{{ traslado.justificacion }}</td>
                                <td>{{ traslado.usuario_registro }}</td>
                              </tr>
                            </tbody>
                          </table>
                          <p v-else style="padding: 20px; color: #666;">No hay traslados registrados.</p>
                      </div>
                    </div>

                    <!-- Tab Content: Mantenimientos -->
                    <div v-show="activeTab === 'mantenimientos'" class="detalle-content active">
                      <div class="detalle-section" style="grid-column: 1 / -1;">
                          <h4 class="detalle-section-title">Historial de Mantenimientos</h4>
                          <table v-if="selectedEquipo.mantenimientos && selectedEquipo.mantenimientos.length > 0" style="width: 100%; margin-top: 10px;">
                            <thead>
                              <tr>
                                <th>Fecha</th>
                                <th>Tipo</th>
                                <th>Realizado Por</th>
                                <th>Costo</th>
                                <th>Descripción</th>
                                <th>Observaciones</th>
                              </tr>
                            </thead>
                            <tbody>
                              <tr v-for="mant in selectedEquipo.mantenimientos" :key="mant.id">
                                <td>{{ mant.fecha_display }}</td>
                                <td style="text-transform: capitalize;">{{ mant.tipo_mantenimiento }}</td>
                                <td>{{ mant.realizado_por }}</td>
                                <td>${{ mant.costo }}</td>
                                <td>{{ mant.descripcion }}</td>
                                <td>{{ mant.observaciones || 'N/A' }}</td>
                              </tr>
                            </tbody>
                          </table>
                          <p v-else style="padding: 20px; color: #666;">No hay mantenimientos registrados.</p>
                      </div>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
/* Estilos copiados y adaptados del Mockup */
.content-card { background: white; border-radius: 10px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 25px; }
.search-filter-container { display: flex; gap: 20px; margin-bottom: 25px; align-items: center; }
.search-section { flex: 1; }
.search-input { 
  width: 100%; 
  padding: 14px 18px; 
  border: 2px solid #e0e0e0; 
  border-radius: 8px; 
  font-size: 14px;
  transition: all 0.3s ease;
}
.search-input:focus { 
  outline: none; 
  border-color: #006633; 
  box-shadow: 0 0 0 3px rgba(0, 102, 51, 0.1);
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
.page-title { font-size: 28px; color: #006633; font-weight: 600; margin-bottom: 30px; }
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }
.btn-sm { padding: 8px 16px; font-size: 13px; }
.btn-info { background: #00a99d; color: white; }
.btn-secondary { background: #e0e0e0; }
.btn-danger { background: #f44336; color: white; }
.btn-success { background: #4CAF50; color: white; }
.btn-warning { background: #ff9800; color: white; }

.btn-ver {
  background: #00a99d;
  transition: all 0.3s ease;
}

.btn-ver:hover {
  background: #008f85;
}

.btn-ver-active {
  background: #006633 !important;
  color: white !important;
}

.btn-ver-active:hover {
  background: #005028 !important;
}

table { width: 100%; border-collapse: collapse; }
thead { background: linear-gradient(135deg, #006633 0%, #2d5016 100%); color: white; }
th { padding: 15px; text-align: left; font-size: 13px; text-transform: uppercase; }
td { padding: 15px; border-bottom: 1px solid #e0e0e0; font-size: 14px; }
tbody tr:hover { background: rgba(0,102,51,0.04); }
tbody tr[data-equipo] { cursor: pointer; transition: all 0.2s; position: relative; }
tbody tr[data-equipo]:hover { background: rgba(0,102,51,0.08); }
tbody tr[data-equipo]:hover td:first-child { font-weight: 600; }
tbody tr.row-active { background: rgba(0,102,51,0.12); border-left: 4px solid #006633; }

/* INVIMA Badge Styling - Copied from EquiposPendientes */
.invima-badge {
  font-size: 11px;
  padding: 3px 8px;
  background: rgba(0, 102, 51, 0.1);
  color: #006633;
  border-radius: 20px;
  font-weight: 600;
  display: block;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.invima-box-detail {
  font-size: 11px;
  padding: 3px 8px;
  background: rgba(0, 102, 51, 0.1);
  color: #006633;
  border-radius: 20px;
  font-weight: 600;
  min-width: 120px;
  display: inline-block;
  text-align: center;
}

/* Risk Box Styling */
.risk-box {
  display: inline-block;
  padding: 4px 12px;
  background: #e8e8e8;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  color: #333;
}

.risk-box.badge-danger { background: #ffe0e0; color: #d32f2f; }
.risk-box.badge-warning { background: #fff3e0; color: #f57c00; }
.risk-box.badge-success { background: #e8f5e9; color: #388e3c; }
.risk-box.badge-secondary { background: #e8e8e8; color: #666; }

/* Estado Badge Styling */
.estado-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 11px;
  font-weight: 600;
  text-align: center;
  min-width: 100px;
}

.estado-activo {
  background: rgba(76, 175, 80, 0.15);
  color: #2e7d32;
}

.estado-mantenimiento {
  background: rgba(244, 67, 54, 0.15);
  color: #c62828;
}

.estado-baja {
  background: rgba(158, 158, 158, 0.15);
  color: #616161;
}

.estado-inactivo {
  background: rgba(255, 152, 0, 0.15);
  color: #e65100;
}

.badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
.badge-success { background: rgba(76, 175, 80, 0.1); color: #4CAF50; }
.badge-danger { background: rgba(244, 67, 54, 0.1); color: #f44336; }
.badge-warning { background: rgba(255, 152, 0, 0.1); color: #ff9800; }
.badge-secondary { background: rgba(158, 158, 158, 0.1); color: #666; }

/* Skeleton Loader */
.skeleton-container {
  padding: 20px 0;
}

.skeleton-header {
  height: 50px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 8px;
  margin-bottom: 15px;
}

.skeleton-row {
  display: grid;
  grid-template-columns: 90px 220px 160px 70px 180px 150px 120px 140px;
  gap: 15px;
  margin-bottom: 12px;
}

.skeleton-cell {
  height: 45px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 6px;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* Document Inventory Grid */
.documentos-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px 20px;
  margin-top: 15px;
}

.documento-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.check-icon {
  font-size: 16px;
  flex-shrink: 0;
}

.x-icon {
  font-size: 16px;
  flex-shrink: 0;
}

/* Detalle Row Styles */
.detalle-row { display: none; }
.detalle-row.active { display: table-row; }
.detalle-cell { padding: 0 !important; background: #f9f9f9; border-bottom: 3px solid #006633 !important; }
.detalle-container { padding: 30px; animation: slideDown 0.3s ease; position: relative; }
@keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
.detalle-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #e0e0e0; }
.detalle-title { font-size: 20px; color: #006633; font-weight: 600; }
.detalle-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #e0e0e0; padding-bottom: 0; }
.detalle-tab { padding: 12px 20px; cursor: pointer; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: all 0.3s; font-weight: 500; background: white; border-radius: 8px 8px 0 0; }
.detalle-tab:hover { background: #f5f5f5; color: #006633; }
.detalle-tab.active { color: #006633; border-bottom-color: #006633; font-weight: 600; background: #f9f9f9; }
.detalle-content { display: none; }
.detalle-content.active { display: block; }
.detalle-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
.detalle-section { background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #006633; }
.detalle-section-title { font-size: 16px; color: #006633; font-weight: 600; margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px; }
.detalle-item { display: flex; margin-bottom: 10px; font-size: 14px; }
.detalle-label { font-weight: 600; color: #616161; min-width: 180px; }
.detalle-value { color: #212121; }
</style>
