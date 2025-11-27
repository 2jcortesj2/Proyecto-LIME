# Proyecto LIME - Instalación del Frontend

## Requisitos Previos

- Node.js 18.0 o superior
- npm 9.0 o superior

## Verificar Instalación de Node.js

```bash
node --version
npm --version
```

Si no tienes Node.js instalado, descárgalo desde: https://nodejs.org/

## Pasos de Instalación

### 1. Navegar al Directorio del Frontend

```bash
cd frontend
```

### 2. Instalar Dependencias

```bash
npm install
```

### 3. Configurar Variables de Entorno (Opcional)

Crea un archivo `.env` en la raíz del directorio frontend:

```env
VITE_API_URL=http://127.0.0.1:8000/api
```

### 4. Ejecutar Servidor de Desarrollo

```bash
npm run dev
```

El servidor estará disponible en: `http://localhost:5173/`

### 5. Compilar para Producción

```bash
npm run build
```

Los archivos compilados estarán en el directorio `dist/`

## Comandos Disponibles

```bash
# Modo desarrollo
npm run dev

# Compilar para producción
npm run build

# Vista previa de la compilación
npm run preview

# Verificar código (linting)
npm run lint
```

## Estructura del Proyecto

```
frontend/
├── public/              # Archivos estáticos
├── src/
│   ├── assets/         # Recursos (imágenes, estilos)
│   ├── components/     # Componentes Vue
│   │   ├── Inventario.vue
│   │   ├── Mantenimientos.vue
│   │   ├── EquiposPendientes.vue
│   │   ├── SedesServicios.vue
│   │   ├── Traslados.vue
│   │   ├── Sidebar.vue
│   │   └── Dashboard.vue
│   ├── App.vue         # Componente raíz
│   └── main.js         # Punto de entrada
├── index.html          # HTML principal
├── package.json        # Dependencias y scripts
└── vite.config.js      # Configuración de Vite
```

## Dependencias Principales

- **Vue 3**: Framework progresivo de JavaScript
- **Vite**: Build tool moderno y rápido
- **Axios**: Cliente HTTP para llamadas API
- **Vue Router**: Enrutamiento (si se agrega en el futuro)

## Solución de Problemas

### Error de módulos no encontrados

```bash
# Eliminar node_modules y reinstalar
rm -rf node_modules package-lock.json
npm install
```

### Puerto en uso

Si el puerto 5173 está en uso, puedes cambiarlo en `vite.config.js`:

```javascript
export default {
  server: {
    port: 3000
  }
}
```

### Problemas de CORS

Asegúrate de que el backend tenga configurado CORS correctamente en `settings.py`:

```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]
```

### Cache de Vite

Si experimentas problemas con archivos antiguos:

```bash
# Limpiar cache de Vite
npm run dev -- --force
```

## Desarrollo

### Hot Module Replacement (HMR)

Vite incluye HMR por defecto. Los cambios en el código se reflejarán automáticamente en el navegador sin necesidad de recargar la página.

### DevTools

Instala Vue DevTools para depuración:
- Chrome: https://chrome.google.com/webstore/detail/vuejs-devtools/
- Firefox: https://addons.mozilla.org/en-US/firefox/addon/vue-js-devtools/

## Compilación para Producción

```bash
npm run build
```

Esto generará archivos optimizados en el directorio `dist/` que puedes desplegar en cualquier servidor web estático.

### Despliegue

Los archivos compilados son estáticos y pueden desplegarse en:
- Netlify
- Vercel
- GitHub Pages
- Apache/Nginx
- Firebase Hosting
