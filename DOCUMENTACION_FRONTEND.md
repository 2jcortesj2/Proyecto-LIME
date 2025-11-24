# Documentación del Frontend - Proyecto LIME

## Descripción General
El frontend de LIME es una aplicación de página única (SPA) construida con **Vue.js 3** y **Vite**. Proporciona una interfaz moderna y responsiva para la gestión de inventario y mantenimiento de equipos.

## Tecnologías Principales
*   **Vue.js 3**: Framework progresivo de JavaScript (Composition API).
*   **Vite**: Herramienta de construcción rápida.
*   **Vue Router**: Enrutamiento del lado del cliente.
*   **Axios**: Cliente HTTP para comunicación con el backend.

## Estructura del Proyecto (`src/`)

### Componentes Principales (`components/`)

1.  **`Dashboard.vue`**:
    *   **Función**: Vista principal con estadísticas generales.
    *   **Características**:
        *   Tarjetas de resumen (Total equipos, Vencidos, Próximos).
        *   Alertas interactivas para mantenimientos pendientes.
        *   Tabla de equipos agregados recientemente.
        *   Integración con endpoint `maintenance_stats`.

2.  **`EquiposPendientes.vue`**:
    *   **Función**: Gestión detallada de mantenimientos.
    *   **Secciones**:
        *   **Realizar Mantenimiento**: Equipos vencidos (filtro: `estado='Activo'` y `requiere_mantenimiento=True`).
        *   **Próximos a Revisión**: Equipos con mantenimiento futuro (filtro dinámico por meses: 3, 6, 12).
        *   **Equipos al Día**: Historial de equipos en estado normal.
    *   **Características**:
        *   Búsqueda avanzada (insensible a acentos/mayúsculas).
        *   Paginación.
        *   Acciones: "Completar" y "Reprogramar".

3.  **`Inventario.vue`**:
    *   **Función**: Listado completo del inventario.
    *   **Características**: Filtros por sede, servicio, estado y búsqueda general.

4.  **`Mantenimientos.vue`**:
    *   **Función**: Vista de historial de mantenimientos.

5.  **`Sidebar.vue`**:
    *   **Función**: Navegación principal lateral.

### Servicios (`services/`)

*   **`api.js`**: Configuración de Axios y definiciones de endpoints.
    *   `equiposAPI`: Métodos para interactuar con `/api/equipos/`.
    *   `dashboardAPI`: Métodos para estadísticas.

### Utilidades (`utils/`)

*   **`searchUtils.js`**:
    *   `normalizeText`: Normaliza texto (minúsculas, sin acentos) para búsquedas robustas.
    *   `filterEquiposBySearch`: Lógica centralizada de filtrado de equipos por múltiples campos (código, nombre, marca, modelo, sede, servicio).

## Características Clave

### Búsqueda Avanzada
Implementada en `searchUtils.js`, permite buscar equipos ignorando acentos y mayúsculas. Busca en múltiples campos simultáneamente.

### Filtrado de Mantenimiento
*   **Vencidos**: Basado en el estado calculado por el backend.
*   **Próximos**: Calculado dinámicamente en el frontend basado en la selección del usuario (3, 6, 12 meses), asegurando que se muestren todos los equipos futuros dentro del rango seleccionado.

### Consistencia de Datos
El frontend filtra explícitamente equipos con `estado='Activo'` para coincidir con las estadísticas del backend, asegurando que los contadores del Dashboard coincidan con las filas de las tablas.

## Ejecución

1.  **Instalación**: `npm install`.
2.  **Desarrollo**: `npm run dev` (puerto 5173 por defecto).
3.  **Producción**: `npm run build`.
