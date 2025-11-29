// authGuard.js - Guard de autenticación para Vue Router

export function authGuard(to, from, next) {
  const token = localStorage.getItem('token')
  const user = localStorage.getItem('user')

  // Rutas públicas que no requieren autenticación
  const publicRoutes = ['/login', '/register', '/forgot-password']

  if (publicRoutes.includes(to.path)) {
    // Si ya está autenticado y trata de ir a login, redirigir al dashboard
    if (token && user) {
      next('/responsables')
    } else {
      next()
    }
  } else {
    // Rutas protegidas - requieren autenticación
    if (!token || !user) {
      // No está autenticado, redirigir al login
      next('/login')
    } else {
      // Verificar si el token aún es válido
      try {
        const userData = JSON.parse(user)
        // Aquí podrías agregar validación adicional del token
        next()
      } catch (error) {
        // Token inválido, limpiar y redirigir
        localStorage.removeItem('token')
        localStorage.removeItem('user')
        next('/login')
      }
    }
  }
}

// Función para verificar si el usuario está autenticado
export function isAuthenticated() {
  const token = localStorage.getItem('token')
  const user = localStorage.getItem('user')
  return !!(token && user)
}

// Función para obtener el usuario actual
export function getCurrentUser() {
  const user = localStorage.getItem('user')
  try {
    return user ? JSON.parse(user) : null
  } catch (error) {
    return null
  }
}

// Función para cerrar sesión
export function logout() {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  window.location.href = '/login'
}
