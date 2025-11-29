# 🔐 Sistema de Autenticación LIME

## 📋 Archivos Creados

### Frontend (Vue.js)
1. **Login.vue** - Pantalla de inicio de sesión
2. **Register.vue** - Registro de nuevos usuarios con validación de contraseña
3. **authGuard.js** - Guard para proteger rutas
4. **Usuarios.vue** - CRUD de usuarios (próximo a crear)

---

## 🎯 Cómo Implementar

### 1. Configurar Vue Router

En tu archivo `router/index.js`:

```javascript
import { createRouter, createWebHistory } from 'vue-router'
import { authGuard } from '@/utils/authGuard'

// Importar componentes
import Login from '@/components/Login.vue'
import Register from '@/components/Register.vue'
import Responsables from '@/components/Responsables.vue'
import Mantenimientos from '@/components/Mantenimientos.vue'
import Inventario from '@/components/Inventario.vue'
import Traslados from '@/components/Traslados.vue'
import Usuarios from '@/components/Usuarios.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/responsables',
    name: 'Responsables',
    component: Responsables,
    meta: { requiresAuth: true }
  },
  {
    path: '/mantenimientos',
    name: 'Mantenimientos',
    component: Mantenimientos,
    meta: { requiresAuth: true }
  },
  {
    path: '/inventario',
    name: 'Inventario',
    component: Inventario,
    meta: { requiresAuth: true }
  },
  {
    path: '/traslados',
    name: 'Traslados',
    component: Traslados,
    meta: { requiresAuth: true }
  },
  {
    path: '/usuarios',
    name: 'Usuarios',
    component: Usuarios,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Aplicar guard global
router.beforeEach(authGuard)

export default router
```

---

## 🔧 Backend Django - Endpoints Necesarios

### 1. Modelo de Usuario

En `models.py`:

```python
from django.contrib.auth.models import AbstractUser
from django.db import models

class Usuario(AbstractUser):
    nombre = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['nombre']
    
    class Meta:
        db_table = 'usuarios'
```

### 2. Serializers

En `serializers.py`:

```python
from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from .models import Usuario

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'nombre', 'email', 'created_at', 'updated_at']

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    
    class Meta:
        model = Usuario
        fields = ['nombre', 'email', 'password']
    
    def create(self, validated_data):
        usuario = Usuario.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            nombre=validated_data['nombre'],
            password=validated_data['password']
        )
        return usuario

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()
```

### 3. Views

En `views.py`:

```python
from rest_framework import status, generics
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from .models import Usuario
from .serializers import UsuarioSerializer, RegisterSerializer, LoginSerializer

class RegisterView(generics.CreateAPIView):
    serializer_class = RegisterSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        usuario = serializer.save()
        
        return Response({
            'message': 'Usuario creado exitosamente',
            'user': UsuarioSerializer(usuario).data
        }, status=status.HTTP_201_CREATED)

class LoginView(APIView):
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        
        user = authenticate(username=email, password=password)
        
        if user is None:
            return Response({
                'message': 'Credenciales incorrectas'
            }, status=status.HTTP_401_UNAUTHORIZED)
        
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'token': str(refresh.access_token),
            'refresh': str(refresh),
            'user': UsuarioSerializer(user).data
        })

class LogoutView(APIView):
    def post(self, request):
        try:
            refresh_token = request.data.get('refresh')
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({'message': 'Sesión cerrada exitosamente'})
        except Exception:
            return Response({'message': 'Token inválido'}, status=status.HTTP_400_BAD_REQUEST)

class UsuariosViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [permissions.IsAuthenticated]
```

### 4. URLs

En `urls.py`:

```python
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import RegisterView, LoginView, LogoutView, UsuariosViewSet

router = DefaultRouter()
router.register(r'usuarios', UsuariosViewSet)

urlpatterns = [
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/login/', LoginView.as_view(), name='login'),
    path('auth/logout/', LogoutView.as_view(), name='logout'),
    path('', include(router.urls)),
]
```

### 5. Settings

En `settings.py`:

```python
INSTALLED_APPS = [
    # ...
    'rest_framework',
    'rest_framework_simplejwt',
    'rest_framework_simplejwt.token_blacklist',
    'corsheaders',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    # ...
]

# JWT Settings
from datetime import timedelta

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(hours=24),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
}

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
}

# CORS
CORS_ALLOWED_ORIGINS = [
    "http://localhost:5173",  # Vite default
    "http://localhost:3000",
]

AUTH_USER_MODEL = 'tu_app.Usuario'
```

---

## 🚀 Instalación de Dependencias

### Backend:
```bash
pip install djangorestframework djangorestframework-simplejwt django-cors-headers
```

### Migraciones:
```bash
python manage.py makemigrations
python manage.py migrate
```

---

## 📝 Características Implementadas

### ✅ Login.vue
- Diseño profesional con colores LIME
- Validación de campos
- Mostrar/ocultar contraseña
- Mensajes de error
- Recordar sesión
- Link a registro y recuperación de contraseña
- Animaciones suaves
- Responsive

### ✅ Register.vue
- Validación de contraseña en tiempo real
- Indicador de fuerza de contraseña (Muy Débil/Débil/Media/Fuerte/Muy Fuerte)
- Requisitos de contraseña visibles:
  - Mínimo 12 caracteres (14+ es mejor)
  - Mayúsculas (A-Z)
  - Minúsculas (a-z)
  - Números (0-9)
  - Símbolos (!@#$%...)
- Verificación de coincidencia de contraseñas
- Botón deshabilitado hasta cumplir requisitos
- Mensaje de éxito con redirección automática

### ✅ authGuard.js
- Protección de rutas
- Redirección automática
- Verificación de token
- Funciones de utilidad (isAuthenticated, getCurrentUser, logout)

---

## 🎨 Paleta de Colores LIME

- Verde Principal: `#006633`
- Verde Secundario: `#2d5016`
- Verde Oscuro: `#004d26`
- Azul Hospital: `#00d4ff`
- Naranja: `#ff6b35`
- Rojo: `#f44336`
- Gris Claro: `#f5f5f5`

---

## 📌 Próximos Pasos

1. ✅ Login.vue creado
2. ✅ Register.vue creado
3. ✅ authGuard.js creado
4. ⏳ Crear Usuarios.vue (CRUD de usuarios)
5. ⏳ Implementar backend Django
6. ⏳ Probar flujo completo
7. ⏳ Agregar recuperación de contraseña

---

## 💡 Recomendaciones

1. **Seguridad**:
   - Usa HTTPS en producción
   - Implementa rate limiting en el backend
   - Agrega captcha en login después de X intentos fallidos
   - Implementa 2FA (Two-Factor Authentication) para mayor seguridad

2. **UX**:
   - Agrega validación de email con código de verificación
   - Implementa sistema de recuperación de contraseña
   - Agrega logs de actividad de usuario
   - Notificaciones de inicio de sesión desde dispositivos nuevos

3. **Performance**:
   - Implementa refresh tokens automático
   - Cache de datos de usuario
   - Lazy loading de componentes

---

¿Necesitas que cree el componente Usuarios.vue (CRUD) ahora?
