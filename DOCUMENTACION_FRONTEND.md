# Documentación del Frontend - Proyecto LIME

## Descripción General
El frontend de LIME es una aplicación de página única (SPA) construida con **Vue.js 3** y **Vite**. Proporciona una interfaz moderna, responsiva y profesional para la gestión de inventario y mantenimiento de equipos biomédicos.

## Tecnologías Principales
- **Vue.js 3.5.24**: Framework progresivo de JavaScript (Composition API)
- **Vite 7.2.4**: Herramienta de construcción rápida con HMR
- **Axios 1.13.2**: Cliente HTTP para comunicación con el backend
- **Vue Router 4.2.5**: Enrutamiento del lado del cliente (opcional)

## Estructura del Proyecto

```
frontend/
├── src/
│   ├── components/      # Componentes Vue
│   │   ├── Dashboard.vue
│   │   ├── Inventario.vue
│   │   ├── EquiposPendientes.vue
│   │   ├── Mantenimientos.vue
│   │   ├── Traslados.vue
│   │   ├── SedesServicios.vue
│   │   └── Sidebar.vue
│   ├── services/        # Servicios API
│   │   └── api.js
│   ├── utils/           # Utilidades
│   │   └── searchUtils.js
│   ├── assets/          # Recursos estáticos
│   ├── App.vue          # Componente raíz
│   └── main.js          # Punto de entrada
├── public/              # Archivos estáticos
├── index.html           # HTML principal
├── package.json         # Dependencias
└── vite.config.js       # Configuración Vite
```

## Componentes Principales

### 1. **`Dashboard.vue`**
**Función**: Vista principal con estadísticas y resumen general del sistema.

**Características**:
- 📊 Tarjetas de resumen (Total equipos, Sedes, Servicios)
- ⚠️ Estadísticas de mantenimiento (Vencidos, Próximos, Normales)
- 🔔 Alertas interactivas para mantenimientos pendientes
- 📋 Tabla de equipos agregados recientemente
- 🔄 Integración con endpoint `/api/equipos/maintenance-stats/`

**Mejoras visuales**:
- Gradientes de color verde institucional (#006633, #2d5016)
- Tarjetas con sombra y bordes redondeados
- Íconos intuitivos para cada sección

### 2. **`Inventario.vue`**
**Función**: Listado completo del inventario de equipos con funcionalidades avanzadas.

**Características**:
- 🔍 Búsqueda global multi-campo
- 🗂️ Filtro por sede, servicio, estado
- 📄 Paginación (10, 20, 50, 100 items)
- 👁️ Vista detallada expandible por equipo
- ✏️ Modal de edición con 6 tabs
- ➕ Modal de creación con validación
- 🎨 Badges coloreados para INVIMA y riesgo
- ⚡ Botón de limpiar búsqueda

**Tabs del modal de edición**:
1. Información General
2. Datos del Equipo
3. Registro Histórico
4. Documentos
5. Información Metrológica
6. Condiciones de Funcionamiento

**Tabla de mantenimientos**: Estilizada con gradiente verde

### 3. **`EquiposPendientes.vue`**
**Función**: Gestión detallada de mantenimientos y revisiones.

**Secciones**:
- **Realizar Revisión** (Vencidos):
  - Equipos con mantenimiento vencido
  - Barra de búsqueda integrada
  - Botones: Completar, Reprogramar
  - Badge rojo para fechas vencidas
  
- **Próximos a Revisión**:
  - Filtro dinámico por meses (3, 6, 12)
  - Equipos dentro del rango seleccionado
  - Contador de equipos en título

**Características avanzadas**:
- 🔍 Búsqueda avanzada (insensible a acentos/mayúsculas)
- 📄 Paginación independiente (10, 20, 50 items)
- 🎨 Skeleton loading profesional con tablas
- 🎯 Filtro por tipo de vista (vencidos/próximos/todos)
- 📊 Badges coloreados para riesgo e INVIMA

**Skeleton Loading**: Muestra tablas estructuradas durante carga

### 4. **`Mantenimientos.vue`**
**Función**: Vista de historial de mantenimientos realizados.

**Características**:
- 📊 Tabla con historial completo
- 🔍 Barra de búsqueda
- 📄 Paginación (10, 20, 50, 100 items)
- 🎨 Skeleton loading con tabla
- 📋 Acordeón para detalles de mantenimiento

**Mejoras UI/UX**:
- Altura de búsqueda igualada con Inventario
- Headers de tabla centrados
- Skeleton con estructura de tabla realista

### 5. **`Traslados.vue`**
**Función**: Gestión y visualización de traslados de equipos.

**Características**:
- 📊 Historial de traslados
- 🔍 Búsqueda por equipo
- 📄 Paginación
- 🚚 Vista de origen y destino

### 6. **`SedesServicios.vue`**
**Función**: Gestión de sedes y servicios institucionales.

**Características**:
- 🏢 Acordeón de sedes
- 📊 Contadores de servicios y equipos por sede
- ➕ Botones para agregar sede/servicio
- ✏️ Edición inline
- 🎨 Diseño moderno con estadísticas en header

**Mejoras visuales**:
- Stats visuales en el header del acordeón
- Botón "Ver más" para servicios (+5)
- Chevron animado para expandir/colapsar

### 7. **`Sidebar.vue`**
**Función**: Navegación lateral principal.

**Secciones**:
- 🏠 Dashboard
- 📦 Inventario de Equipos
- 🔧 Realizar Revisión
- 📅 Próximos a Revisión
- 🛠️ Historial de Mantenimientos
- 🚚 Traslados
- 🏢 Sedes y Servicios

**Características**:
- Íconos descriptivos
- Indicador visual de sección activa
- Gradiente de color institucional
- Responsive design

## Servicios API (`services/api.js`)

### Configuración de Axios
```javascript
const API_BASE_URL = 'http://127.0.0.1:8000/api'

const axiosInstance = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  }
})
```

### Servicios Disponibles

#### `equiposAPI`
```javascript
equiposAPI.getAll()                    // GET /api/equipos/
equiposAPI.getById(id)                 // GET /api/equipos/{id}/
equiposAPI.create(equipoData)          // POST /api/equipos/
equiposAPI.update(id, equipoData)      // PUT /api/equipos/{id}/
equiposAPI.delete(id)                  // DELETE /api/equipos/{id}/
equiposAPI.getMaintenanceStats()       // GET /api/equipos/maintenance-stats/
equiposAPI.getProximosMantenimiento()  // GET /api/equipos/proximos-mantenimiento/
```

#### `sedesAPI`
```javascript
sedesAPI.getAll()                      // GET /api/sedes/
sedesAPI.create(sedeData)              // POST /api/sedes/
```

#### `serviciosAPI`
```javascript
serviciosAPI.getAll()                  // GET /api/servicios/
```

#### `responsablesAPI`
```javascript
responsablesAPI.getAll()               // GET /api/responsables/
```

## Utilidades (`utils/search Utils.js`)

### Búsqueda Avanzada

```javascript
/**
 * Normaliza texto eliminando acentos y convirtiendo a minúsculas
 */
function normalizeText(text) {
  return text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
}

/**
 * Filtra equipos por búsqueda en múltiples campos
 * Búsqueda en: código, nombre, marca, modelo, serie, sede, servicio
 */
function filterEquiposBySearch(equipos, searchQuery) {
  if (!searchQuery) return equipos
  
  const normalized = normalizeText(searchQuery)
  
  return equipos.filter(eq => {
    return [
      eq.codigo_interno,
      eq.nombre_equipo,
      eq.marca,
      eq.modelo,
      eq.serie,
      eq.sede?.nombre,
      eq.servicio?.nombre
    ].some(field => 
      field && normalizeText(String(field)).includes(normalized)
    )
  })
}
```

## Características Clave del Frontend

### 1. Búsqueda Avanzada
- **Insensible a acentos y mayúsculas**
- **Multi-campo**: Busca en código, nombre, marca, modelo, sede, servicio
- **Tiempo real**: Filtra mientras escribe
- **Centralizada**: Lógica reutilizable en `searchUtils.js`

### 2. Paginación Consistente
- Implementada en: Inventario, EquiposPendientes, Mantenimientos
- Opciones: 10, 20, 50, 100 items por página
- Controles: Anterior, Siguiente, Indicador "Página X de Y"
- Estilo uniforme en todos los componentes

### 3. Skeleton Loading
- **Profesional**: Estructura de tabla realista
- **Consistente**: Mismo diseño en todos los componentes
- **Animado**: Efecto de carga con gradiente
- **Contextual**: Solo muestra la vista correspondiente

### 4. Validación de Formularios
- **Campos requeridos**: Marcados con asterisco rojo
- **Validación en tiempo real**: Mensajes de error inmediatos
- **Navegación automática**: Va al primer tab con errores
- **Mensajes claros**: Indica exactamente qué campo falta

### 5. Diseño Responsiv
- **Móvil**: Sidebar colapsable
- **Tablet**: Layout adaptativo
- **Desktop**: Vista completa optimizada

### 6. Consistencia Visual
- **Paleta de colores**:
  - Verde primario: #006633
  - Verde oscuro: #2d5016
  - Azul secundario: #00a99d
  - Rojo alerta: #f44336
  
- **Tipografía**: Segoe UI, Tahoma, Geneva, Verdana
- **Bordes**: Redondeados (8-10px)
- **Sombras**: Sutiles para profundidad

## Filtrado y Lógica de Mantenimiento

### Estados de Mantenimiento
El frontend recibe los estados calculados por el backend:

- **Vencido**: Mantenimiento atrasado
- **Próximo**: Dentro de 3 meses
- **Normal**: Más de 3 meses
- **No Requiere**: No necesita mantenimiento

### Filtrado Dinámico
```javascript
// Equipos vencidos
const equiposVencidos = computed(() => {
  return equipos.value.filter(eq => 
    eq.informacion_metrologica?.estado_mantenimiento === 'Vencido'
  )
})

// Equipos próximos (filtro por meses seleccionados)
const equiposProximos = computed(() => {
  const meses = parseInt(filtroMeses.value)
  const limite = new Date()
  limite.setMonth(limite.getMonth() + meses)
  
  return equipos.value.filter(eq => {
    const estado = eq.informacion_metrologica?.estado_mantenimiento
    const fechaProx = new Date(eq.informacion_metrologica?.fecha_proximo_mantenimiento_calculada)
    
    return estado === 'Próximo' && fechaProx <= limite
  })
})
```

### Consistencia de Datos
- **Filtro de activos**: Solo muestra equipos con `estado='Activo'`
- **Coincidencia con backend**: Los contadores del Dashboard coinciden con las tablas
- **Sincronización**: Usa los mismos cálculos que el backend

## Ejecución y Desarrollo

### Instalación
```bash
cd frontend
npm install
```

### Desarrollo
```bash
npm run dev
# Servidor en http://localhost:5173
```

### Producción
```bash
npm run build
# Archivos en dist/
```

### Preview
```bash
npm run preview
# Vista previa de build de producción
```

## Mejores Prácticas

### 1. Comunicación con API
- Usar servicios definidos en `api.js`
- Manejar errores con try-catch
- Mostrar feedback visual al usuario

### 2. Búsqueda
- Usar `searchUtils.js` para búsquedas
- Implementar debounce para performance
- Normalizar texto para mejor UX

### 3. Estado
- Usar Composition API
- Refs para datos reactivos
- Computed para datos derivados

### 4. Estilos
- Scoped styles en cada componente
- Variables CSS para colores
- Reutilizar clases comunes

### 5. Performance
- Paginación para listas grandes
- Skeleton loading para UX
- Lazy loading cuando sea posible

## Troubleshooting

### Error de CORS
```javascript
// Verificar que el backend tenga configurado:
CORS_ALLOWED_ORIGINS = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]
```

### Puerto en uso
```javascript
// Cambiar puerto en vite.config.js
export default {
  server: {
    port: 3000
  }
}
```

### Módulos no encontrados
```bash
rm -rf node_modules package-lock.json
npm install
```

### Cache de Vite
```bash
npm run dev -- --force
```

## Próximas Mejoras

- [ ] Implementar Vue Router para rutas
- [ ] Agregar Pinia para state management
- [ ] Implementar PWA capabilities
- [ ] Agregar tests unitarios con Vitest
- [ ] Mejorar accesibilidad (ARIA labels)
- [ ] Dark mode
- [ ] Exportación de reportes (PDF, Excel)
- [ ] Notificaciones push
