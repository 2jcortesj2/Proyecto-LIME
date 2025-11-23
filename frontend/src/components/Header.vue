<template>
  <header class="header">
    <!-- Logo Container -->
    <div class="logo-container">
      <div class="logo-wrapper">
        <img src="/logo_lime.png" alt="LIME Logo" class="logo-img lime-logo" />
      </div>
      <div class="logo-divider"></div>
      <div class="logo-wrapper">
        <img src="/logo_hospital.png" alt="Hospital Alma Máter Logo" class="logo-img hospital-logo" />
      </div>
      <div class="logo-divider"></div>
      <div class="logo-wrapper">
        <img src="/logo_uda.png" alt="Universidad de Antioquia Logo" class="logo-img uda-logo" />
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
  padding: 10px 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
  height: 90px;
}

.logo-container {
  display: flex;
  align-items: center;
  gap: 15px;
  background: white;
  padding: 5px 20px;
  border-radius: 8px;
  height: 70px;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
}

.logo-img {
  height: auto;
  object-fit: contain;
}

.lime-logo {
  max-height: 50px;
  max-width: 120px;
}

.hospital-logo {
  max-height: 45px;
  max-width: 140px;
}

.uda-logo {
  max-height: 55px;
  max-width: 140px;
}

.logo-divider {
  width: 1px;
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
