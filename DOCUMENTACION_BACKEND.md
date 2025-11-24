# Documentación del Backend - Proyecto LIME

## Descripción General
El backend de LIME está construido con **Django** y **Django REST Framework (DRF)**. Su propósito principal es gestionar el inventario de equipos biomédicos, industriales y de gases, así como sus mantenimientos, traslados y documentación.

## Estructura del Proyecto

El proyecto se organiza en múltiples aplicaciones (apps) para modularizar la funcionalidad:

### Aplicaciones Principales

1.  **`equipos`**:
    *   **Propósito**: Gestión central del inventario de equipos.
    *   **Modelos Clave**: `Equipo`, `InformacionMetrologica`, `RegistroAdquisicion`, `DocumentacionEquipo`, `CondicionesFuncionamiento`.
    *   **Endpoints Clave**:
        *   `/api/equipos/`: CRUD de equipos.
        *   `/api/equipos/maintenance-stats/`: Estadísticas de mantenimiento (Vencidos, Próximos, Normales).
        *   `/api/equipos/proximos-mantenimiento/`: Lista de equipos próximos a vencer.

2.  **`sedes`**:
    *   **Propósito**: Gestión de las sedes de la institución.
    *   **Modelos**: `Sede`.

3.  **`servicios`**:
    *   **Propósito**: Gestión de los servicios/áreas dentro de las sedes.
    *   **Modelos**: `Servicio`.

4.  **`responsables`**:
    *   **Propósito**: Gestión del personal responsable de los equipos.
    *   **Modelos**: `Responsable`.

5.  **`historial_mantenimientos`**:
    *   **Propósito**: Registro histórico de los mantenimientos realizados.
    *   **Modelos**: `HistorialMantenimiento`.

6.  **`historial_traslados`**:
    *   **Propósito**: Trazabilidad de la ubicación de los equipos.
    *   **Modelos**: `HistorialTraslado`.

7.  **`reportes`**:
    *   **Propósito**: Generación de reportes (PDF, Excel).

8.  **`configuracion`**:
    *   **Propósito**: Configuraciones generales del sistema.

## Scripts de Utilidad

*   **`merge_sql_data.py`**: Script para fusionar y enriquecer datos desde archivos SQL (`equipos_desde_excel.sql` y `migracion_datos_lime.sql`). Genera datos sintéticos para tablas relacionadas si no existen.
*   **`excel_to_sql.py`**: Convierte datos de Excel a formato SQL para migración.
*   **`analyze_excel.py`**: Analiza la estructura de archivos Excel para mapeo de datos.

## Lógica de Mantenimiento

La lógica de cálculo de estados de mantenimiento está centralizada en el modelo `InformacionMetrologica` y expuesta a través del endpoint `maintenance_stats`.

*   **Vencido**: Fecha de próximo mantenimiento < Hoy.
*   **Próximo**: Fecha de próximo mantenimiento <= Hoy + 3 meses.
*   **Normal**: Fecha de próximo mantenimiento > Hoy + 3 meses.
*   **No Requiere**: Equipos marcados explícitamente como que no requieren mantenimiento.

## Configuración y Ejecución

1.  **Entorno Virtual**: Activar `venv`.
2.  **Instalación**: `pip install -r requirements.txt`.
3.  **Ejecución**: `python manage.py runserver`.
4.  **Base de Datos**: SQLite (por defecto).

## API Endpoints

La API es accesible en `http://localhost:8000/api/`.
Documentación automática (si está configurada) en `/swagger/` o `/redoc/`.
