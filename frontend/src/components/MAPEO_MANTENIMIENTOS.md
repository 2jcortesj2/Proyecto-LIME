# MAPEO DETALLADO - Mantenimientos.vue

## 📋 RESUMEN GENERAL
- **Total de líneas:** 1145
- **Tipo de archivo:** Vue 3 Component (Composition API)
- **Propósito:** Historial completo de mantenimientos con filtros, búsqueda y paginación

---

## 🗂️ ESTRUCTURA DEL ARCHIVO

### **SECCIÓN 1: SCRIPT SETUP (Líneas 1-279)**

#### **1.1 Imports (Líneas 1-3)**
- `ref, onMounted, computed, watch` de Vue
- `mantenimientosAPI` de services/api

#### **1.2 Estado de Datos (Líneas 5-18)**
- `mantenimientos` (ref): Array de mantenimientos
- `loading` (ref): Estado de carga
- `error` (ref): Mensajes de error
- `searchQuery` (ref): Búsqueda de texto
- `totalItems` (ref): Total de items del backend
- `currentPage` (ref): Página actual
- `itemsPerPage` (ref): Items por página
- `itemsPerPageOptions`: Opciones de paginación [5, 10, 20, 50]
- `expandedRows` (ref): Set de IDs de filas expandidas

#### **1.3 Estado de Filtros (Líneas 20-36)**
- `showFilterPanel` (ref): Visibilidad del panel de filtros
- `filtros` (ref): Objeto con arrays de filtros (tipos, proveedores, años, meses)
- `ordenamiento` (ref): Tipo de ordenamiento ('reciente' por defecto)
- `mesesNombres`: Array con nombres de meses en español

#### **1.4 Funciones de Datos (Líneas 38-69)**
- `fetchMantenimientos(page, pageSize)`: Fetch principal con paginación
  - Construye params
  - Llama a `mantenimientosAPI.getAll(params)`
  - Maneja respuesta paginada (results/count)
  - Manejo de errores

#### **1.5 Computed Properties - Filtros Únicos (Líneas 71-85)**
- `tiposUnicos`: Tipos de mantenimiento únicos y ordenados
- `proveedoresUnicos`: Proveedores únicos y ordenados
- `aniosUnicos`: Años únicos ordenados (más reciente primero)

#### **1.6 Computed - Filtrado y Ordenamiento (Líneas 87-152)**
- `filteredMantenimientos`: Lógica completa de filtrado
  - Filtro por búsqueda (código, nombre, tipo, proveedor)
  - Filtro por tipos
  - Filtro por proveedores
  - Filtro por años
  - Filtro por meses
  - Ordenamiento (5 tipos):
    - `reciente`: Más recientes primero
    - `antiguo`: Más antiguos primero
    - `costo-mayor`: Mayor costo primero
    - `costo-menor`: Menor costo primero
    - `equipo-asc`: Alfabético por nombre de equipo

#### **1.7 Paginación (Líneas 154-175)**
- `totalPages`: Cálculo de páginas totales
- `paginatedMantenimientos`: Slice de datos filtrados
- `changePage(page)`: Cambio de página con validación
- `watch(itemsPerPage)`: Watcher para cambios en items por página

#### **1.8 Métodos de Filtros (Líneas 177-234)**
- `toggleFilterPanel()`: Toggle del panel lateral
- `toggleTipoFilter(tipo)`: Toggle de filtro de tipo
- `toggleProveedorFilter(proveedor)`: Toggle de filtro de proveedor
- `toggleAnioFilter(anio)`: Toggle de filtro de año
- `toggleMesFilter(mes)`: Toggle de filtro de mes
- `borrarTodosFiltros()`: Resetea todos los filtros
- `filtrosActivos`: Computed que cuenta filtros activos

#### **1.9 Métodos de UI (Líneas 236-278)**
- `toggleRow(id)`: Toggle de accordion
- `formatMes(mes, anio)`: Formatea mes/año en español
- `formatCosto(costo)`: Formatea costo en COP
- `getTipoLabel(tipo)`: Obtiene label legible del tipo
- `getTipoBadgeClass(tipo)`: Obtiene clase CSS para badge
- `abrirNuevoMantenimiento()`: Placeholder para nuevo mantenimiento

---

### **SECCIÓN 2: TEMPLATE (Líneas 281-547)**

#### **2.1 Estructura Principal (Líneas 282-289)**
- Container principal
- Header con título, breadcrumb y botón "Nuevo Mantenimiento"

#### **2.2 Loading State (Líneas 291-303)**
- Skeleton loader con líneas animadas
- Simula estructura de búsqueda y tabla

#### **2.3 Error State (Líneas 305-308)**
- Alert de error simple

#### **2.4 Content Card (Líneas 310-428)**
- **Búsqueda y Filtros (312-325):**
  - Input de búsqueda
  - Botón de filtros con badge de filtros activos
  
- **Tabla Principal (327-403):**
  - **Header (328-338):** 7 columnas (Código, Equipo, Tipo, Mes/Año, Realizado Por, Costo, Acciones)
  - **Body (339-402):** Loop sobre `mantenimientos` (⚠️ **BUG: debería ser paginatedMantenimientos**)
    - Fila principal con datos
    - Fila de accordion expandible con:
      - Header con título y botón cerrar
      - Grid horizontal con detalles (Responsable, Descripción)
      - Sección de observaciones (condicional)
  
- **Empty State (404-406):** Mensaje cuando no hay datos

- **Paginación (408-427):**
  - Selector de items por página
  - Navegación (Anterior/Siguiente)
  - Input de página actual

#### **2.5 Panel de Filtros (Líneas 430-545)**
- **Overlay (431):** Fondo oscuro clickeable
- **Panel Lateral (432-545):**
  - **Header (433-436):** Título y botón "Borrar todo"
  - **Body (438-540):** Secciones colapsables:
    - Ordenar por (5 opciones radio)
    - Tipo de Mantenimiento (checkboxes dinámicos)
    - Año (checkboxes dinámicos)
    - Mes (checkboxes de 12 meses)
    - Realizado Por (checkboxes dinámicos)
  - **Footer (542-544):** Contador de resultados

---

### **SECCIÓN 3: STYLES (Líneas 549-1145)**

#### **3.1 Layout Principal (550-569)**
- `.mantenimientos-container`: Container principal
- `.page-title`: Título verde
- `.content-card`: Card blanco con sombra

#### **3.2 Búsqueda y Filtros (571-640)**
- `.search-filter-container`: Flex container
- `.search-input`: Input con focus verde
- `.filter-button`: Botón con borde verde
- `.filter-badge`: Badge circular para contador

#### **3.3 Botones (642-686)**
- `.btn`: Estilos base
- `.btn-primary`: Verde principal
- `.btn-sm`: Tamaño pequeño
- `.btn-info`, `.btn-secondary`, `.btn-danger`: Variantes
- `.btn-close`: Posicionamiento absoluto

#### **3.4 Tabla (688-762)**
- `table`: Ancho completo, min-width 800px
- `thead`: Gradiente verde
- `th`: Padding, uppercase
- `td`: Padding, border-bottom
- `.col-codigo`: Ancho fijo 120px
- `tbody tr`: Hover y estados activos
- `.badge-*`: 5 variantes de badges

#### **3.5 Alerts (764-777)**
- `.alert-danger`: Alert rojo con borde izquierdo

#### **3.6 Accordion (779-873)**
- `.accordion-details-row`: Row de tabla
- `.detalle-cell`: Fondo gris, sin padding
- `.accordion-details`: Padding, animación slideDown
- `.detalle-header`: Flex con border-bottom
- `.detail-grid-horizontal`: Grid 2 columnas
- `.detail-item-horizontal`: Cards blancos con borde verde
- `.observaciones-section`: Sección cyan con borde

#### **3.7 Paginación (875-961)**
- `.pagination-footer`: Flex space-between
- `.items-per-page`: Selector de items
- `.page-select`: Select estilizado
- `.page-navigation`: Navegación con botones
- `.page-btn`: Botones de página
- `.page-input`: Input numérico

#### **3.8 Panel de Filtros (963-1123)**
- `.filtro-overlay`: Overlay con transición
- `.filtro-panel`: Panel lateral deslizable (400px)
- `.filtro-header`: Header con gradiente
- `.filtro-body`: Body scrolleable
- `.filtro-section`: Secciones con border-bottom
- `.filtro-section-title`: Títulos colapsables
- `.filtro-content`: Contenido de filtros
- `.filtro-item`: Items con hover
- `.filtro-footer`: Footer con contador

#### **3.9 Skeleton Loading (1125-1144)**
- `.skeleton`: Animación de carga
- `.skeleton-line`: Líneas con gradiente animado
- `@keyframes skeleton-loading`: Animación de background

---

## 🔍 PROBLEMAS IDENTIFICADOS

### **1. BUG CRÍTICO - Línea 340**
```vue
<template v-for="mant in mantenimientos" :key="mant.id">
```
❌ **Debería ser:** `paginatedMantenimientos`
- Actualmente renderiza TODOS los mantenimientos en lugar de solo la página actual

### **2. HARDCODING**
- **Línea 288:** Botón "Nuevo Mantenimiento" con alert placeholder
- **Línea 366-367:** Botones de editar y eliminar sin funcionalidad
- **Línea 254-263:** Mapeo de tipos hardcodeado
- **Línea 265-274:** Mapeo de clases de badges hardcodeado
- **Línea 33-36:** Nombres de meses hardcodeados

### **3. FALTA DE MODALS**
- No hay modal para crear mantenimiento
- No hay modal para editar mantenimiento
- No hay modal para eliminar mantenimiento
- No hay modal para ver detalles (actualmente usa accordion)

### **4. FALTA DE COMPOSABLES**
- Lógica de filtros podría estar en `useFilters.js`
- Lógica de paginación podría estar en `usePagination.js`
- Formateo de datos podría estar en `useFormatters.js`
- Manejo de accordion podría estar en `useAccordion.js`

### **5. ESTILOS NO GENERALIZADOS**
- Muchos estilos específicos que podrían estar en un archivo global
- Badges repetidos en otros componentes
- Botones con estilos similares a otros componentes
- Skeleton loader podría ser global

---

## 📝 PLAN DE REFACTORIZACIÓN

### **Fase 1: Crear Composables**
1. `useMantenimientosFilters.js` - Lógica de filtros
2. `usePagination.js` - Lógica de paginación
3. `useFormatters.js` - Formateo de datos
4. `useAccordion.js` - Manejo de accordion

### **Fase 2: Crear Modals**
1. `ModalCrearMantenimiento.vue`
2. `ModalEditarMantenimiento.vue`
3. `ModalEliminarMantenimiento.vue`
4. `ModalVerMantenimiento.vue` (opcional, reemplazar accordion)

### **Fase 3: Generalizar Estilos**
1. Mover badges a estilos globales
2. Mover botones a estilos globales
3. Mover skeleton loader a componente reutilizable
4. Crear variables CSS para colores

### **Fase 4: Eliminar Hardcoding**
1. Mover constantes a archivo de configuración
2. Implementar funcionalidad de modals
3. Conectar botones con modals

### **Fase 5: Fix Bugs**
1. Corregir loop de tabla (usar `paginatedMantenimientos`)
2. Validar lógica de paginación
3. Probar filtros y ordenamiento

---

## 🎯 PRIORIDADES

1. ✅ **CRÍTICO:** Fix bug de paginación (línea 340)
2. 🔴 **ALTO:** Crear modals básicos (Crear, Editar, Eliminar)
3. 🟡 **MEDIO:** Refactorizar a composables
4. 🟢 **BAJO:** Generalizar estilos
5. 🔵 **OPCIONAL:** Modal de ver detalles (reemplazar accordion)
