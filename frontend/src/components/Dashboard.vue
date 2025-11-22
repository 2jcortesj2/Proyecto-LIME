<template>
  <div>
    <h2 class="page-title">Información General</h2>

    <!-- Stats Grid -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-label">Total Equipos</div>
        <div class="stat-value">284</div>
        <div class="stat-trend success">↑ 12 nuevos este mes</div>
      </div>
      <div class="stat-card" style="border-left-color: #00a99d;">
        <div class="stat-label">Equipos Activos</div>
        <div class="stat-value">267</div>
        <div class="stat-trend success">94% del total</div>
      </div>
      <div class="stat-card" style="border-left-color: #003d6b;">
        <div class="stat-label">Mantenimientos Pendientes</div>
        <div class="stat-value">18</div>
        <div class="stat-trend warning">Próximos 30 días</div>
      </div>
      <div class="stat-card" style="border-left-color: #4CAF50;">
        <div class="stat-label">Calibraciones Próximas</div>
        <div class="stat-value">7</div>
        <div class="stat-trend warning">Este mes</div>
      </div>
    </div>

    <!-- Alerts -->
    <div class="alert alert-danger">
      <span style="font-size: 20px;">⚠️</span>
      <div>
        <strong>Atención:</strong> Hay 5 equipos con mantenimiento vencido.
        <strong>Clic aquí para ver detalles</strong>
      </div>
    </div>

    <div class="alert alert-warning">
      <span style="font-size: 20px;">📅</span>
      <div>
        <strong>Próximos mantenimientos:</strong> 18 equipos requieren mantenimiento en los próximos 30 días.
        <strong>Clic aquí para ver detalles</strong>
      </div>
    </div>

    <!-- Recent Equipment Table -->
    <div class="content-card">
      <h3 style="color: #006633; margin-bottom: 20px;">Equipos Agregados Recientemente</h3>
      <table>
        <thead>
          <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Marca</th>
            <th>Modelo</th>
            <th>Sede</th>
            <th>Estado</th>
            <th>Fecha</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>135306</strong></td>
            <td>Congelador</td>
            <td>Challenger</td>
            <td>CV430</td>
            <td>Prado - LIME Central</td>
            <td><span class="badge badge-success">Activo</span></td>
            <td>2025-11-15</td>
          </tr>
          <tr>
            <td><strong>119325</strong></td>
            <td>Agregómetro</td>
            <td>Helena Labs</td>
            <td>AGGRAM</td>
            <td>Prado - Hematología</td>
            <td><span class="badge badge-success">Activo</span></td>
            <td>2025-11-14</td>
          </tr>
          <tr>
            <td><strong>142789</strong></td>
            <td>Espectrofotómetro</td>
            <td>Thermo Scientific</td>
            <td>Evolution 201</td>
            <td>Prado - LIME Central</td>
            <td><span class="badge badge-success">Activo</span></td>
            <td>2025-11-13</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 10px;
  border-left: 4px solid #006633;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-label {
  color: #616161;
  margin-bottom: 8px;
  font-size: 14px;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #006633;
}

.stat-trend {
  font-size: 12px;
  margin-top: 8px;
}

.stat-trend.success {
  color: #4CAF50;
}

.stat-trend.warning {
  color: #ff9800;
}

.alert {
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.alert:hover {
  transform: translateX(5px);
}

.alert-danger {
  background: rgba(244, 67, 54, 0.1);
  color: #f44336;
  border-left: 4px solid #f44336;
}

.alert-warning {
  background: rgba(255, 152, 0, 0.1);
  color: #ff9800;
  border-left: 4px solid #ff9800;
}

.content-card {
  background: white;
  border-radius: 10px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 25px;
}

table {
  width: 100%;
  border-collapse: collapse;
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
}

td {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
}

tbody tr:hover {
  background: rgba(0, 102, 51, 0.04);
}

.badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
}

.badge-success {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}
</style>
