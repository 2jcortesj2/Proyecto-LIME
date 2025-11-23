# Conversión de Excel a SQL - Proyecto LIME

Este documento explica cómo usar el script `excel_to_sql.py` para convertir el inventario de equipos desde Excel a formato SQL.

## 📋 Descripción

El script `excel_to_sql.py` lee el archivo Excel de inventario de equipos biomédicos y genera automáticamente un archivo SQL con todos los `INSERT` statements necesarios para poblar la base de datos LIME.

## 🚀 Uso

### Paso 1: Verificar dependencias

Asegúrate de tener instaladas las librerías necesarias:

```bash
pip install pandas openpyxl
```

### Paso 2: Ejecutar el script

Desde el directorio `Backend`:

```bash
py excel_to_sql.py
```

### Paso 3: Ejecutar el SQL generado

El script genera el archivo `equipos_desde_excel.sql` en la raíz del proyecto. Para ejecutarlo:

**Opción 1 - MySQL Command Line:**
```bash
mysql -u root -p lime_db < equipos_desde_excel.sql
```

**Opción 2 - MySQL Workbench:**
1. Abre MySQL Workbench
2. File > Run SQL Script
3. Selecciona `equipos_desde_excel.sql`
4. Ejecuta

## 📊 Estructura del Excel

El script espera un archivo Excel con la siguiente estructura:

- **Archivo**: `F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx`
- **Hoja**: `Hoja1`
- **Fila de inicio de datos**: Fila 9 (las primeras 8 filas son encabezados)

### Columnas principales esperadas:

| Columna | Tabla destino | Campo |
|---------|---------------|-------|
| Sede | `equipos_equipo` | `sede_id` |
| Proceso | `equipos_equipo` | `servicio_id` |
| Nombre del equipo | `equipos_equipo` | `nombre_equipo` |
| Código de inventario interno | `equipos_equipo` | `codigo_interno` |
| Código IPS | `equipos_equipo` | `codigo_ips` |
| Código ECRI | `equipos_equipo` | `codigo_ecri` |
| Marca | `equipos_equipo` | `marca` |
| Modelo | `equipos_equipo` | `modelo` |
| Serie | `equipos_equipo` | `serie` |
| Fecha de adquisición | `equipos_registroadquisicion` | `fecha_adquisicion` |
| NIT proveedor | `equipos_registroadquisicion` | `nit_proveedor` |
| Nombre proveedor | `equipos_registroadquisicion` | `nombre_proveedor` |
| Hoja de vida | `equipos_documentacionequipo` | `hoja_vida` |
| Manual de operación | `equipos_documentacionequipo` | `manual_operacion` |
| Magnitud | `equipos_informacionmetrologica` | `magnitud` |
| Voltaje | `equipos_condicionesfuncionamiento` | `voltaje` |
| Dimensiones | `equipos_condicionesfuncionamiento` | `dimensiones` |

## 🔧 Configuración

Puedes modificar las siguientes variables en `excel_to_sql.py`:

```python
# Archivo de entrada
EXCEL_FILE = r"ruta\al\archivo.xlsx"

# Archivo de salida
OUTPUT_SQL = r"ruta\al\archivo.sql"

# Número de filas a saltar
SKIP_ROWS = 8
```

## 📝 Mapeo de Sedes y Servicios

El script utiliza los siguientes mapeos:

### Sedes:
- Prado → ID: 1
- SIU → ID: 2
- San Vicente → ID: 3

### Servicios:
- LIME → ID: 1
- LIME - Hematología → ID: 2
- LIME - Citometría de flujo → ID: 3
- LIME - Almacén → ID: 4
- ... (ver script para lista completa)

## ✅ Validaciones

El script realiza las siguientes validaciones y limpiezas:

1. **Valores nulos**: Convierte valores vacíos, `N/A`, `NA` a `NULL` en SQL
2. **Booleanos**: Convierte `SI`, `SÍ`, `YES`, `X` a `1` y `NO`, `N` a `0`
3. **Fechas**: Intenta parsear diferentes formatos de fecha
4. **Comillas**: Escapa comillas simples en strings
5. **Espacios**: Elimina espacios en blanco al inicio y final

## 📊 Salida

El script genera un archivo SQL con:

- Encabezado con información de generación
- `SET FOREIGN_KEY_CHECKS = 0` para evitar errores de FK
- Un bloque de INSERTs por cada equipo:
  - `equipos_equipo`
  - `equipos_registroadquisicion`
  - `equipos_documentacionequipo`
  - `equipos_informacionmetrologica`
  - `equipos_condicionesfuncionamiento`
- `SET FOREIGN_KEY_CHECKS = 1` al final
- Resumen de equipos insertados

## ⚠️ Advertencias

1. **Backup**: Siempre haz un backup de tu base de datos antes de ejecutar el SQL generado
2. **Duplicados**: El script NO incluye `TRUNCATE`, por lo que puede generar duplicados si se ejecuta múltiples veces
3. **Responsables**: El campo `responsable_id` se deja como `NULL` - deberás asignarlo manualmente o modificar el script

## 🐛 Troubleshooting

### Error: "Missing optional dependency 'openpyxl'"
```bash
pip install openpyxl
```

### Error: "No such file or directory"
Verifica que la ruta del archivo Excel sea correcta en la variable `EXCEL_FILE`

### Error: "Duplicate entry"
El script no limpia la base de datos antes de insertar. Ejecuta primero:
```sql
TRUNCATE TABLE equipos_condicionesfuncionamiento;
TRUNCATE TABLE equipos_informacionmetrologica;
TRUNCATE TABLE equipos_documentacionequipo;
TRUNCATE TABLE equipos_registroadquisicion;
TRUNCATE TABLE equipos_equipo;
```

## 📞 Soporte

Para modificar el mapeo de columnas o agregar nuevos campos, edita las funciones en `excel_to_sql.py`.
