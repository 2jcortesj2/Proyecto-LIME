<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const form = ref({
  nombre: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const showPassword = ref(false)
const showConfirmPassword = ref(false)
const loading = ref(false)
const error = ref('')
const success = ref(false)

// Validación de contraseña
const passwordStrength = computed(() => {
  const pwd = form.value.password
  if (!pwd) return { level: 0, label: '', color: '' }

  let score = 0
  const checks = {
    length: pwd.length >= 12,
    longLength: pwd.length >= 14,
    uppercase: /[A-Z]/.test(pwd),
    lowercase: /[a-z]/.test(pwd),
    number: /[0-9]/.test(pwd),
    symbol: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pwd)
  }

  if (checks.length) score += 1
  if (checks.longLength) score += 1
  if (checks.uppercase) score += 1
  if (checks.lowercase) score += 1
  if (checks.number) score += 1
  if (checks.symbol) score += 1

  if (score <= 2) return { level: 1, label: 'Muy Débil', color: '#f44336', checks }
  if (score <= 3) return { level: 2, label: 'Débil', color: '#ff9800', checks }
  if (score <= 4) return { level: 3, label: 'Media', color: '#ffc107', checks }
  if (score <= 5) return { level: 4, label: 'Fuerte', color: '#4caf50', checks }
  return { level: 5, label: 'Muy Fuerte', color: '#006633', checks }
})

const passwordsMatch = computed(() => {
  if (!form.value.confirmPassword) return null
  return form.value.password === form.value.confirmPassword
})

const canSubmit = computed(() => {
  return form.value.nombre && 
         form.value.email && 
         form.value.password && 
         form.value.confirmPassword &&
         passwordsMatch.value &&
         passwordStrength.value.level >= 4
})

const handleRegister = async () => {
  error.value = ''

  if (!canSubmit.value) {
    error.value = 'Por favor completa todos los campos correctamente'
    return
  }

  loading.value = true

  try {
    const response = await fetch('http://127.0.0.1:8000/api/auth/register/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        nombre: form.value.nombre,
        email: form.value.email,
        password: form.value.password
      })
    })

    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.message || 'Error al registrar usuario')
    }

    success.value = true
    setTimeout(() => {
      router.push('/login')
    }, 2000)

  } catch (err) {
    error.value = err.message || 'Error al crear la cuenta'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="register-container">
    <div class="register-card">
      <!-- Header -->
      <div class="register-header">
        <div class="logo-lime">LIME</div>
        <div class="logo-subtitle">LABORATORIO INTEGRADO DE MEDICINA ESPECIALIZADA</div>
      </div>

      <!-- Body -->
      <div class="register-body">
        <h2 class="register-title">Crear Cuenta</h2>
        <p class="register-subtitle">Completa el formulario para registrarte</p>

        <form v-if="!success" @submit.prevent="handleRegister" class="register-form">
          <!-- Nombre -->
          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">👤</span>
              Nombre Completo
            </label>
            <input 
              type="text" 
              v-model="form.nombre"
              class="form-input"
              placeholder="Juan Pérez"
              required
            >
          </div>

          <!-- Email -->
          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">📧</span>
              Correo Electrónico
            </label>
            <input 
              type="email" 
              v-model="form.email"
              class="form-input"
              placeholder="usuario@ejemplo.com"
              required
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
                v-model="form.password"
                class="form-input password-input"
                placeholder="••••••••••••"
                required
              >
              <button 
                type="button"
                class="toggle-password"
                @click="showPassword = !showPassword"
                tabindex="-1"
              >
                {{ showPassword ? '👁️' : '👁️‍🗨️' }}
              </button>
            </div>

            <!-- Password Strength Indicator -->
            <div v-if="form.password" class="password-strength">
              <div class="strength-bar">
                <div 
                  class="strength-fill"
                  :style="{ 
                    width: (passwordStrength.level * 20) + '%',
                    background: passwordStrength.color 
                  }"
                ></div>
              </div>
              <div class="strength-label" :style="{ color: passwordStrength.color }">
                {{ passwordStrength.label }}
              </div>
            </div>

            <!-- Password Requirements -->
            <div v-if="form.password" class="password-requirements">
              <div class="requirement" :class="{ met: passwordStrength.checks.length }">
                {{ passwordStrength.checks.length ? '✓' : '○' }} Mínimo 12 caracteres
              </div>
              <div class="requirement" :class="{ met: passwordStrength.checks.uppercase }">
                {{ passwordStrength.checks.uppercase ? '✓' : '○' }} Mayúsculas (A-Z)
              </div>
              <div class="requirement" :class="{ met: passwordStrength.checks.lowercase }">
                {{ passwordStrength.checks.lowercase ? '✓' : '○' }} Minúsculas (a-z)
              </div>
              <div class="requirement" :class="{ met: passwordStrength.checks.number }">
                {{ passwordStrength.checks.number ? '✓' : '○' }} Números (0-9)
              </div>
              <div class="requirement" :class="{ met: passwordStrength.checks.symbol }">
                {{ passwordStrength.checks.symbol ? '✓' : '○' }} Símbolos (!@#$%...)
              </div>
            </div>
          </div>

          <!-- Confirm Password -->
          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">🔐</span>
              Confirmar Contraseña
            </label>
            <div class="password-container">
              <input 
                :type="showConfirmPassword ? 'text' : 'password'"
                v-model="form.confirmPassword"
                class="form-input password-input"
                :class="{ 
                  'input-error': passwordsMatch === false,
                  'input-success': passwordsMatch === true
                }"
                placeholder="••••••••••••"
                required
              >
              <button 
                type="button"
                class="toggle-password"
                @click="showConfirmPassword = !showConfirmPassword"
                tabindex="-1"
              >
                {{ showConfirmPassword ? '👁️' : '👁️‍🗨️' }}
              </button>
            </div>
            <div v-if="passwordsMatch === false" class="password-match-error">
              ✗ Las contraseñas no coinciden
            </div>
            <div v-if="passwordsMatch === true" class="password-match-success">
              ✓ Las contraseñas coinciden
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="error-message">
            ⚠️ {{ error }}
          </div>

          <!-- Submit Button -->
          <button 
            type="submit" 
            class="btn-register"
            :disabled="loading || !canSubmit"
          >
            <span v-if="!loading">Crear Cuenta</span>
            <span v-else class="loading">⏳ Creando cuenta...</span>
          </button>
        </form>

        <!-- Success Message -->
        <div v-else class="success-message">
          <div class="success-icon">✓</div>
          <h3>¡Cuenta Creada Exitosamente!</h3>
          <p>Redirigiendo al inicio de sesión...</p>
        </div>

        <!-- Login Link -->
        <div class="login-link">
          ¿Ya tienes una cuenta? 
          <a href="#" @click.prevent="router.push('/login')">Inicia sesión aquí</a>
        </div>
      </div>

      <!-- Footer -->
      <div class="register-footer">
        <div class="footer-text">© 2025 LIME - Universidad de Antioquia</div>
      </div>
    </div>

    <!-- Background Decoration -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
  </div>
</template>

<style scoped>
.register-container {
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
  right: -150px;
}

.circle-2 {
  width: 300px;
  height: 300px;
  bottom: -100px;
  left: -100px;
  animation-delay: 7s;
}

.circle-3 {
  width: 200px;
  height: 200px;
  top: 50%;
  left: 10%;
  animation-delay: 14s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) scale(1); }
  50% { transform: translateY(-40px) scale(1.1); }
}

.register-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 25px 70px rgba(0, 0, 0, 0.4);
  width: 100%;
  max-width: 550px;
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

.register-header {
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  padding: 30px;
  text-align: center;
  color: white;
}

.logo-lime {
  font-size: 48px;
  font-weight: 900;
  letter-spacing: 8px;
  color: white;
  text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.3);
  margin-bottom: 6px;
}

.logo-subtitle {
  font-size: 10px;
  letter-spacing: 2px;
  opacity: 0.95;
}

.register-body {
  padding: 35px 35px 30px;
  max-height: 80vh;
  overflow-y: auto;
}

.register-title {
  font-size: 28px;
  color: #006633;
  font-weight: 700;
  margin-bottom: 8px;
  text-align: center;
}

.register-subtitle {
  text-align: center;
  color: #757575;
  font-size: 14px;
  margin-bottom: 30px;
}

.register-form {
  margin-top: 25px;
}

.form-group {
  margin-bottom: 20px;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #212121;
  margin-bottom: 8px;
  font-size: 14px;
}

.label-icon {
  font-size: 16px;
}

.form-input {
  width: 100%;
  padding: 14px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 10px;
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

.input-error {
  border-color: #f44336 !important;
}

.input-error:focus {
  box-shadow: 0 0 0 4px rgba(244, 67, 54, 0.1) !important;
}

.input-success {
  border-color: #4caf50 !important;
}

.input-success:focus {
  box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.1) !important;
}

.password-container {
  position: relative;
}

.password-input {
  padding-right: 50px;
}

.toggle-password {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 20px;
  padding: 6px;
  opacity: 0.5;
  transition: all 0.2s;
  border-radius: 6px;
}

.toggle-password:hover {
  opacity: 1;
  background: rgba(0, 102, 51, 0.05);
}

.password-strength {
  margin-top: 10px;
}

.strength-bar {
  height: 6px;
  background: #e0e0e0;
  border-radius: 3px;
  overflow: hidden;
  margin-bottom: 6px;
}

.strength-fill {
  height: 100%;
  transition: all 0.3s;
  border-radius: 3px;
}

.strength-label {
  font-size: 13px;
  font-weight: 700;
  text-align: right;
}

.password-requirements {
  margin-top: 12px;
  padding: 12px;
  background: #f5f5f5;
  border-radius: 8px;
  font-size: 13px;
}

.requirement {
  color: #9e9e9e;
  margin-bottom: 6px;
  transition: color 0.2s;
}

.requirement:last-child {
  margin-bottom: 0;
}

.requirement.met {
  color: #006633;
  font-weight: 600;
}

.password-match-error {
  color: #f44336;
  font-size: 13px;
  margin-top: 6px;
  font-weight: 600;
}

.password-match-success {
  color: #4caf50;
  font-size: 13px;
  margin-top: 6px;
  font-weight: 600;
}

.error-message {
  background: rgba(244, 67, 54, 0.08);
  color: #d32f2f;
  padding: 12px 16px;
  border-radius: 10px;
  font-size: 14px;
  margin-bottom: 20px;
  border-left: 4px solid #f44336;
  font-weight: 500;
}

.btn-register {
  width: 100%;
  padding: 16px;
  background: linear-gradient(135deg, #006633 0%, #2d5016 100%);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 6px 15px rgba(0, 102, 51, 0.35);
  letter-spacing: 0.5px;
  margin-top: 10px;
}

.btn-register:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 102, 51, 0.45);
}

.btn-register:active:not(:disabled) {
  transform: translateY(0);
}

.btn-register:disabled {
  opacity: 0.5;
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

.success-message {
  text-align: center;
  padding: 40px 20px;
}

.success-icon {
  width: 80px;
  height: 80px;
  background: #006633;
  color: white;
  font-size: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  animation: scaleIn 0.5s ease-out;
}

@keyframes scaleIn {
  from {
    transform: scale(0);
  }
  to {
    transform: scale(1);
  }
}

.success-message h3 {
  color: #006633;
  font-size: 24px;
  margin-bottom: 10px;
}

.success-message p {
  color: #616161;
  font-size: 14px;
}

.login-link {
  text-align: center;
  margin-top: 25px;
  color: #616161;
  font-size: 14px;
  font-weight: 500;
}

.login-link a {
  color: #006633;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.2s;
}

.login-link a:hover {
  color: #2d5016;
  text-decoration: underline;
}

.register-footer {
  background: #f8f8f8;
  padding: 20px;
  text-align: center;
  border-top: 1px solid #e8e8e8;
}

.footer-text {
  font-size: 12px;
  color: #757575;
  font-weight: 500;
}

/* Responsive */
@media (max-width: 600px) {
  .register-container {
    padding: 0;
  }

  .register-card {
    border-radius: 0;
    max-width: 100%;
    box-shadow: none;
  }
  
  .logo-lime {
    font-size: 38px;
    letter-spacing: 6px;
  }
  
  .register-body {
    padding: 25px 20px;
    max-height: none;
  }
}
</style>
