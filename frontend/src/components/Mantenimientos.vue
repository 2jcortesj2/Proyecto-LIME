<script setup>
import { ref } from 'vue'

// Data de muestra para mantenimientos
const mantenimientos = ref([
  {
    id: 1,
    equipo: {
      codigo_interno: '135306',
      nombre: 'Congelador',
      marca: 'Challenger',
      modelo: 'CV430'
    },
    tipo_mantenimiento: 'preventivo',
    mes_mantenimiento: 11,
    anio_mantenimiento: 2024,
    descripcion: 'Limpieza general y verificación de temperatura',
    realizado_por: 'TecnoFrío SAS',
    costo: 250000,
    usuario_registro: 'Admin LIME',
    created_at: '2024-11-15 10:30:00'
  },
  {
    id: 2,
    equipo: {
      codigo_interno: '119325',
      nombre: 'Agregómetro',
      marca: 'Helena Labs',
      modelo: 'AGGRAM'
    },
    tipo_mantenimiento: 'calibracion',
    mes_mantenimiento: 7,
    anio_mantenimiento: 2025,
    descripcion: 'Limpieza, calibración y verificación de canales',
    realizado_por: 'Biocare Médica Ltda.',
    costo: 420000,
    usuario_registro: 'Admin LIME',
    created_at: '2025-07-10 14:15:00'
  },
  {
    id: 3,
    equipo: {
      codigo_interno: '120458',
      nombre: 'Centrífuga',
      marca: 'Eppendorf',
      modelo: '5810R'
    },
    tipo_mantenimiento: 'preventivo',
    mes_mantenimiento: 5,
    anio_mantenimiento: 2025,
    descripcion: 'Limpieza general, lubricación y verificación de velocidades',
    realizado_por: 'Tecno Lab SAS',
    costo: 550000,
    usuario_registro: 'Admin LIME',
    created_at: '2025-05-08 09:00:00'
  },
  {
    id: 4,
    equipo: {
      codigo_interno: '142789',
      nombre: 'Espectrofotómetro',
      marca: 'Thermo Scientific',
      modelo: 'Evolution 201'
    },
    tipo_mantenimiento: 'preventivo',
    mes_mantenimiento: 8,
    anio_mantenimiento: 2024,
    descripcion: 'Limpieza óptica, verificación de lámpara y calibración',
    realizado_por: 'Científica Sena S.A.',
    costo: 680000,
    usuario_registro: 'Admin LIME',
    created_at: '2024-08-02 11:30:00'
  },
  {
    id: 5,
    equipo: {
      codigo_interno: '135306',
      nombre: 'Congelador',
      marca: 'Challenger',
      modelo: 'CV430'
    },
    tipo_mantenimiento: 'calibracion',
    mes_mantenimiento: 5,
    anio_mantenimiento: 2024,
    descripcion: 'Calibración de sensor de temperatura',
    realizado_por: 'Metrología UdeA',
    costo: 180000,
    usuario_registro: 'Admin LIME',
    created_at: '2024-05-20 16:00:00'
  }
])

const mesesNombres = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

function formatMes(mes, anio) {
  return `${mesesNombres[mes - 1]} ${anio}`
}

function formatCosto(costo) {
  if (!costo) return 'N/A'
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP' }).format(costo)
}

function getTipoLabel(tipo) {
  const labels = {
    'preventivo': 'Preventivo',
    'correctivo': 'Correctivo',
    'calibracion': 'Calibración',
    'calificacion': 'Calificación',
    'verificacion': 'Verificación'
  }
  return labels[tipo] || tipo
}

function getTipoBadgeClass(tipo) {
  const classes = {
    'preventivo': 'badge-success',
    'correctivo': 'badge-danger',
    'calibracion': 'badge-info',
    'calificacion': 'badge-warning',
    'verificacion': 'badge-secondary'
  }
  return classes[tipo] || 'badge-secondary'
}

const showModal = ref(false)
const modalData = ref(null)

function abrirModal(mantenimiento) {
  modalData.value = mantenimiento
  showModal.value = true
}

function cerrarModal() {
  showModal.value = false
  modalData.value = null
}

function abrirNuevoMantenimiento() {
  // Aquí se implementaría la lógica para crear un nuevo mantenimiento
  alert('Funcionalidad en desarrollo')
}
</script>

<template>
  <div class="mantenimientos-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
      <div>
        <h2 class="page-title" style="margin: 0;">Mantenimientos</h2>
        <div style="color: #616161; font-size: 14px; margin-top: 5px;">Inicio / Mantenimientos / Lista</div>
      </div>
      <button class="btn btn-primary" @click="abrirNuevoMantenimiento">➕ Nuevo Mantenimiento</button>
    </div>

    <div class="content-card">
      <div class="search-filter-container">
        <div class="search-section">
          <input type="text" class="search-input" placeholder="🔍 Buscar por código, equipo, tipo o proveedor...">
        </div>
        <button class="filter-button">☰ Filtrar y Ordenar</button>
      </div>

      <table>
        <thead>
          <tr>
            <th>Código Equipo</th>
            <th>Equipo</th>
            <th>Tipo</th>
            <th>Mes/Año</th>
            <th>Realizado Por</th>
            <th>Costo</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="mant in mantenimientos" :key="mant.id" @click="abrirModal(mant)" style="cursor: pointer;">
            <td><strong>{{ mant.equipo.codigo_interno }}</strong></td>
            <td>
              <div style="font-weight: 600;">{{ mant.equipo.nombre }}</div>
              <div style="font-size: 12px; color: #616161;">{{ mant.equipo.marca }} - {{ mant.equipo.modelo }}</div>
            </td>
            <td>
              <span class="badge" :class="getTipoBadgeClass(mant.tipo_mantenimiento)">
                {{ getTipoLabel(mant.tipo_mantenimiento) }}
              </span>
            </td>
            <td><strong>{{ formatMes(mant.mes_mantenimiento, mant.anio_mantenimiento) }}</strong></td>
            <td>{{ mant.realizado_por }}</td>
            <td>{{ formatCosto(mant.costo) }}</td>
            <td @click.stop>
              <button class="btn btn-info btn-sm" @click="abrirModal(mant)">👁️</button>
              <button class="btn btn-secondary btn-sm">✏️</button>
              <button class="btn btn-danger btn-sm">🗑️</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal de Detalle -->
    <div class="modal" :class="{ active: showModal }" @click="cerrarModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <div class="modal-title">📋 Detalle del Mantenimiento</div>
          <button class="close-btn" @click="cerrarModal">✕</button>
        </div>
        <div class="modal-body" v-if="modalData">
          <div class="detail-grid">
            <div class="detail-section">
              <h4 class="detail-section-title">Información del Equipo</h4>
              <div class="detail-item">
                <span class="detail-label">Código Interno:</span>
                <span class="detail-value"><strong>{{ modalData.equipo.codigo_interno }}</strong></span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Nombre:</span>
                <span class="detail-value">{{ modalData.equipo.nombre }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Marca:</span>
                <span class="detail-value">{{ modalData.equipo.marca }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Modelo:</span>
                <span class="detail-value">{{ modalData.equipo.modelo }}</span>
              </div>
            </div>

            <div class="detail-section">
              <h4 class="detail-section-title">Información del Mantenimiento</h4>
              <div class="detail-item">
                <span class="detail-label">Tipo:</span>
                <span class="detail-value">
                  <span class="badge" :class="getTipoBadgeClass(modalData.tipo_mantenimiento)">
                    {{ getTipoLabel(modalData.tipo_mantenimiento) }}
                  </span>
                </span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Fecha:</span>
                <span class="detail-value"><strong>{{ formatMes(modalData.mes_mantenimiento, modalData.anio_mantenimiento) }}</strong></span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Realizado Por:</span>
                <span class="detail-value">{{ modalData.realizado_por }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Costo:</span>
                <span class="detail-value">{{ formatCosto(modalData.costo) }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Registrado Por:</span>
                <span class="detail-value">{{ modalData.usuario_registro }}</span>
              </div>
            </div>

            <div class="detail-section" style="grid-column: 1 / -1;">
              <h4 class="detail-section-title">Descripción</h4>
              <p style="margin: 0; line-height: 1.6;">{{ modalData.descripcion }}</p>
            </div>

            <div class="detail-section" style="grid-column: 1 / -1;" v-if="modalData.observaciones">
              <h4 class="detail-section-title">Observaciones</h4>
              <p style="margin: 0; line-height: 1.6;">{{ modalData.observaciones }}</p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="cerrarModal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.mantenimientos-container {
  width: 100%;
  max-width: 100%;
  overflow-x: hidden;
}

.page-title {
  font-size: 28px;
  color: #006633;
  font-weight: 600;
}

.content-card {
  background: white;
  border-radius: 10px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 25px;
  overflow-x: auto;
  max-width: 100%;
}

.search-filter-container {
  display: flex;
  gap: 20px;
  margin-bottom: 25px;
}

.search-section {
  flex: 1;
}

.search-input {
  width: 100%;
  padding: 12px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
}

.search-input:focus {
  outline: none;
  border-color: #006633;
}

.filter-button {
  padding: 12px 24px;
  background: white;
  border: 2px solid #006633;
  color: #006633;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s;
}

.filter-button:hover {
  background: #006633;
  color: white;
}

table {
  width: 100%;
  border-collapse: collapse;
  table-layout: auto;
}

thead {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
}

th {
  padding: 15px;
  text-align: left;
  font-size: 13px;
  text-transform: uppercase;
  white-space: nowrap;
}

td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
}

tbody tr:hover {
  background: rgba(0, 102, 51, 0.04);
}

.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
  font-size: 14px;
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
  margin-right: 5px;
}

.btn-info {
  background: #00a99d;
  color: white;
}

.btn-secondary {
  background: #e0e0e0;
}

.btn-danger {
  background: #f44336;
  color: white;
}

.badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
}

.badge-success {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}

.badge-danger {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
}

.badge-warning {
  background: rgba(255, 152, 0, 0.1);
  color: #ff9800;
}

.badge-info {
  background: rgba(0, 169, 157, 0.1);
  color: #00a99d;
}

.badge-secondary {
  background: rgba(97, 97, 97, 0.1);
  color: #616161;
}

/* Modal Styles */
.modal {
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  z-index: 1000;
  backdrop-filter: blur(4px);
}

.modal.active {
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 95%;
  max-width: 900px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.modal-header {
  padding: 25px;
  border-bottom: 2px solid #e0e0e0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(90deg, rgba(0, 102, 51, 0.05) 0%, transparent 100%);
  flex-shrink: 0;
}

.modal-title {
  font-size: 22px;
  color: #006633;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  font-size: 28px;
  cursor: pointer;
  color: #616161;
  padding: 0;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  color: #f44336;
}

.modal-body {
  padding: 25px;
  overflow-y: auto;
  flex: 1;
}

.modal-footer {
  padding: 20px 25px;
  border-top: 1px solid #e0e0e0;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  background: #f5f5f5;
  flex-shrink: 0;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.detail-section {
  background: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  border-left: 4px solid #006633;
}

.detail-section-title {
  font-size: 16px;
  color: #006633;
  font-weight: 600;
  margin-bottom: 15px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.detail-item {
  display: flex;
  margin-bottom: 10px;
  font-size: 14px;
}

.detail-label {
  font-weight: 600;
  color: #616161;
  min-width: 150px;
}

.detail-value {
  color: #212121;
}
</style>
