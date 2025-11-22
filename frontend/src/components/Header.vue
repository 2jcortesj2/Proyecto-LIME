<template>
  <header class="header">
    <!-- Logo Container -->
    <div class="logo-container">
      <div style="text-align: center;">
        <div style="font-size: 32px; font-weight: 800; color: #006633; line-height: 1;">LIME</div>
        <div style="font-size: 7px; color: #006633; text-transform: uppercase;">
          Laboratorio Integrado de Medicina Especializada
        </div>
      </div>
      <div class="logo-divider"></div>
      <div style="text-align: center;">
        <div style="font-size: 20px; font-weight: 700; color: #003d6b;">Hospital</div>
        <div>
          <span style="font-size: 24px; font-weight: 800; color: #003d6b;">Alma</span>
          <span style="font-size: 24px; font-weight: 800; color: #00a99d;">Máter</span>
        </div>
      </div>
      <div class="logo-divider"></div>
      <div style="font-size: 14px; font-weight: 700; color: #006633; line-height: 1.3;">
        UNIVERSIDAD<br>DE ANTIOQUIA
      </div>
    </div>

    <!-- Title -->
    <div style="text-align: center; flex: 1; margin: 0 30px;">
      <h1 style="font-size: 24px; margin-bottom: 5px;">Sistema de Inventario de Equipos</h1>
      <p style="font-size: 13px; opacity: 0.9;">Gestión y control de activos tecnológicos y médicos</p>
    </div>

    <!-- User Info -->
    <div style="display: flex; align-items: center; gap: 15px;">
      <div style="text-align: right;">
        <div style="font-weight: 600; font-size: 14px;">Admin LIME</div>
        <div style="font-size: 12px; opacity: 0.8;">Administrador del Sistema</div>
      </div>
      <div class="user-avatar">JL</div>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
  padding: 20px 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.logo-container {
  display: flex;
  align-items: center;
  gap: 20px;
  background: white;
  padding: 10px 20px;
  border-radius: 8px;
}

.logo-divider {
  width: 2px;
  height: 40px;
  background: #ddd;
}

.user-avatar {
  width: 45px;
  height: 45px;
  border-radius: 50%;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  color: #006633;
  font-size: 18px;
}
</style>
