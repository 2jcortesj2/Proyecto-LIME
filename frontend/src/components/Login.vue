<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')
const showPassword = ref(false)

const handleLogin = async () => {
  error.value = ''
  
  if (!email.value || !password.value) {
    error.value = 'Por favor ingresa tu correo y contraseña'
    return
  }

  loading.value = true

  try {
    const response = await fetch('http://127.0.0.1:8000/api/auth/login/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: email.value,
        password: password.value
      })
    })

    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.message || 'Credenciales incorrectas')
    }

    const data = await response.json()
    
    // Guardar token y usuario
    localStorage.setItem('token', data.token)
    localStorage.setItem('user', JSON.stringify(data.user))
    
    // Redirigir al dashboard
    router.push('/responsables')
    
  } catch (err) {
    error.value = err.message || 'Error al iniciar sesión. Verifica tus credenciales.'
  } finally {
    loading.value = false
  }
}

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}
</script>

<template>
  <div class="login-container">
    <div class="login-card">
      <!-- Header con logos -->
      <div class="login-header">
        <div class="logo-lime">LIME</div>
        <div class="logo-subtitle">LABORATORIO INTEGRADO DE MEDICINA ESPECIALIZADA</div>
        <div class="institutions">
          <div class="institution-item">
            <span class="institution-name hospital">Hospital AlmaMáter</span>
          </div>
          <div class="institution-divider">•</div>
          <div class="institution-item">
            <span class="institution-name university">Universidad de Antioquia</span>
          </div>
        </div>
        <div class="faculty">Facultad de Medicina</div>
      </div>

      <!-- Body del formulario -->
      <div class="login-body">
        <h2 class="login-title">Iniciar Sesión</h2>
        <p class="login-subtitle">Ingresa tus credenciales para acceder al sistema</p>

        <form @submit.prevent="handleLogin" class="login-form">
          <!-- Email -->
          <div class="form-group">
            <label class="form-label">
              <span class="label-icon"><AppIcon name="mail" size="16" /></span>
              Correo Electrónico
            </label>
            <input 
              type="email" 
              v-model="email"
              class="form-input"
              placeholder="usuario@ejemplo.com"
              autocomplete="email"
            >
          </div>

          <!-- Password -->
          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">🔒</span>
              Contraseña
            </label>
            <div class="password-container">
              <input 
                :type="showPassword ? 'text' : 'password'"
                v-model="password"
                class="form-input password-input"
                placeholder="••••••••••••"
                autocomplete="current-password"
              >
              <button 
                type="button"
                class="toggle-password"
                @click="togglePasswordVisibility"
                tabindex="-1"
              >
                <AppIcon :name="showPassword ? 'eye' : 'eye-off'" size="20" />
              </button>
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="error-message">
            <AppIcon name="alert" size="16" /> {{ error }}
          </div>

          <!-- Opciones -->
          <div class="form-options">
            <label class="remember-me">
              <input type="checkbox">
              <span>Recordarme</span>
            </label>
            <a href="#" class="forgot-password" @click.prevent="router.push('/forgot-password')">
              ¿Olvidaste tu contraseña?
            </a>
          </div>

          <!-- Botón de Login -->
          <button 
            type="submit" 
            class="btn-login"
            :disabled="loading"
          >
            <span v-if="!loading">Iniciar Sesión</span>
            <span v-else class="loading">⏳ Verificando...</span>
          </button>
        </form>

        <!-- Link de registro -->
        <div class="register-link">
          ¿No tienes una cuenta? 
          <a href="#" @click.prevent="router.push('/register')">Regístrate aquí</a>
        </div>
      </div>

      <!-- Footer -->
      <div class="login-footer">
        <div class="footer-text">© 2025 LIME - Universidad de Antioquia</div>
        <div class="footer-links">
          <a href="#">Términos</a>
          <span>•</span>
          <a href="#">Privacidad</a>
          <span>•</span>
          <a href="#">Soporte</a>
        </div>
      </div>
    </div>

    <!-- Decoración de fondo -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
  </div>
</template>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #006633 0%, #2d5016 50%, #004d26 100%);
  padding: 20px;
  position: relative;
  overflow: hidden;
}

.bg-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.05);
  animation: float 20s infinite ease-in-out;
}

.circle-1 {
  width: 400px;
  height: 400px;
  top: -150px;
  left: -150px;
}

.circle-2 {
  width: 300px;
  height: 300px;
  bottom: -100px;
  right: -100px;
  animation-delay: 7s;
}

.circle-3 {
  width: 200px;
  height: 200px;
  top: 40%;
  right: 10%;
  animation-delay: 14s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) scale(1); }
  50% { transform: translateY(-40px) scale(1.1); }
}

.login-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 25px 70px rgba(0, 0, 0, 0.4);
  width: 100%;
  max-width: 500px;
  position: relative;
  z-index: 1;
  overflow: hidden;
  animation: slideIn 0.6s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  padding: 35px 30px;
  text-align: center;
  color: white;
}

.logo-lime {
  font-size: 56px;
  font-weight: 900;
  letter-spacing: 10px;
  color: white;
  text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.3);
  margin-bottom: 8px;
}

.logo-subtitle {
  font-size: 10px;
  letter-spacing: 2px;
  opacity: 0.95;
  margin-bottom: 20px;
}

.institutions {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.25);
  margin-top: 15px;
  flex-wrap: wrap;
}

.institution-item {
  display: flex;
  align-items: center;
}

.institution-name {
  font-size: 14px;
  font-weight: 600;
}

.institution-name.hospital {
  color: #00d4ff;
}

.institution-name.university {
  color: white;
}

.institution-divider {
  opacity: 0.5;
  font-size: 12px;
}

.faculty {
  font-size: 13px;
  opacity: 0.9;
  margin-top: 8px;
}

.login-body {
  padding: 40px 35px;
}

.login-title {
  font-size: 30px;
  color: #006633;
  font-weight: 700;
  margin-bottom: 10px;
  text-align: center;
}

.login-subtitle {
  text-align: center;
  color: #757575;
  font-size: 14px;
  margin-bottom: 35px;
}

.login-form {
  margin-top: 30px;
}

.form-group {
  margin-bottom: 22px;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #212121;
  margin-bottom: 10px;
  font-size: 14px;
}

.label-icon {
  font-size: 17px;
}

.form-input {
  width: 100%;
  padding: 15px 18px;
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  font-size: 15px;
  transition: all 0.3s;
  background: #fafafa;
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: #006633;
  background: white;
  box-shadow: 0 0 0 4px rgba(0, 102, 51, 0.1);
}

.password-container {
  position: relative;
}

.password-input {
  padding-right: 55px;
}

.toggle-password {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 22px;
  padding: 8px;
  opacity: 0.5;
  transition: all 0.2s;
  border-radius: 6px;
}

.toggle-password:hover {
  opacity: 1;
  background: rgba(0, 102, 51, 0.05);
}

.error-message {
  background: rgba(244, 67, 54, 0.08);
  color: #d32f2f;
  padding: 14px 18px;
  border-radius: 10px;
  font-size: 14px;
  margin-bottom: 22px;
  border-left: 4px solid #f44336;
  animation: shake 0.4s;
  font-weight: 500;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  20% { transform: translateX(-8px); }
  40% { transform: translateX(8px); }
  60% { transform: translateX(-8px); }
  80% { transform: translateX(8px); }
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28px;
  font-size: 14px;
}

.remember-me {
  display: flex;
  align-items: center;
  gap: 7px;
  cursor: pointer;
  color: #616161;
  font-weight: 500;
}

.remember-me input {
  cursor: pointer;
  width: 17px;
  height: 17px;
  accent-color: #006633;
}

.forgot-password {
  color: #006633;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.2s;
}

.forgot-password:hover {
  color: #2d5016;
  text-decoration: underline;
}

.btn-login {
  width: 100%;
  padding: 17px;
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 6px 15px rgba(0, 102, 51, 0.35);
  letter-spacing: 0.5px;
}

.btn-login:hover:not(:disabled) {
  transform: translateY(-3px);
  box-shadow: 0 10px 25px rgba(0, 102, 51, 0.45);
}

.btn-login:active:not(:disabled) {
  transform: translateY(-1px);
}

.btn-login:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.loading {
  display: inline-block;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.6; }
}

.register-link {
  text-align: center;
  margin-top: 28px;
  color: #616161;
  font-size: 14px;
  font-weight: 500;
}

.register-link a {
  color: #006633;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.2s;
}

.register-link a:hover {
  color: #2d5016;
  text-decoration: underline;
}

.login-footer {
  background: #f8f8f8;
  padding: 22px;
  text-align: center;
  border-top: 1px solid #e8e8e8;
}

.footer-text {
  font-size: 12px;
  color: #757575;
  margin-bottom: 10px;
  font-weight: 500;
}

.footer-links {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
  font-size: 12px;
}

.footer-links a {
  color: #006633;
  text-decoration: none;
  transition: all 0.2s;
  font-weight: 600;
}

.footer-links a:hover {
  color: #2d5016;
  text-decoration: underline;
}

.footer-links span {
  color: #d0d0d0;
}

/* Responsive */
@media (max-width: 600px) {
  .login-container {
    padding: 0;
  }

  .login-card {
    border-radius: 0;
    max-width: 100%;
    box-shadow: none;
  }
  
  .logo-lime {
    font-size: 42px;
    letter-spacing: 7px;
  }

  .logo-subtitle {
    font-size: 9px;
  }
  
  .login-body {
    padding: 30px 25px;
  }

  .institutions {
    flex-direction: column;
    gap: 8px;
  }

  .institution-divider {
    display: none;
  }
}
</style>
