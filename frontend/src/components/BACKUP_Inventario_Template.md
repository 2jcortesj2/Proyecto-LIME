# BACKUP - Template y Estilos de Inventario.vue

Este archivo contiene SOLO el template HTML y estilos CSS extraídos de Inventario.vue como respaldo.

**Fecha de backup**: 2025-11-30 19:01
**Archivo original**: `src/components/Inventario.vue` (3,105 líneas, 130KB)
**Propósito**: Preservar estructura HTML y CSS mientras se refactoriza la lógica

## Nota Importante

Este backup preserva:
- ✅ Estructura HTML completa del template (líneas 1082-2900)
- ✅ Todos los estilos CSS scoped (líneas 2901-3105)
- ✅ Emojis y caracteres especiales intactos

## Instrucciones de Uso

Para restaurar el template en un nuevo componente:
1. Copiar la sección `<template>` completa
2. Copiar la sección `<style scoped>` completa
3. Ajustar las referencias a variables/funciones según el nuevo `<script setup>`

## Referencia Rápida del Template

### Secciones del Template:
- **Líneas 1083-1090**: Header con título y botón "Nuevo Equipo"
- **Líneas 1092-1114**: Barra de búsqueda y botón filtros
- **Líneas 1117-1144**: Skeleton loader (estado de carga)
- **Líneas 1148-1427**: Tabla principal de equipos con filas expandibles
  - **1163-1199**: Fila principal de equipo
  - **1202-1424**: Fila expandible con tabs de detalle
- **Líneas 1430-1447**: Footer de paginación
- **Líneas 1449-1990**: Modal crear equipo (6 tabs)
- **Líneas 1992-2500**: Modal editar equipo (6 tabs)
- **Líneas 2502-2560**: Modal eliminar equipo
- **Líneas 2562-2898**: Panel lateral de filtros

### Elementos Clave a Preservar:
- Emojis: ➕, 🔍, ✕, 👁️, ✏️, 🗑️, 📋, 📝, 🔧, 📅, 📄, ✅, ❌
- Clases CSS importantes: `.content-card`, `.modal`, `.filter-panel`, `.detalle-row`
- Estados de UI: `.active`, `.row-active`, `.btn-ver-active`
- Skeleton loaders con animaciones

---

**IMPORTANTE**: Ver archivo `Inventario.vue.backup` para el código completo original
