# Instrucciones para Ejecutar el Script SQL

## Opción 1: MySQL Workbench (Recomendado)

1. Abre **MySQL Workbench**
2. Conecta a tu servidor MySQL local
3. Ve a **File > Run SQL Script** (o presiona `Ctrl+Shift+O`)
4. Selecciona el archivo: `migracion_datos_lime.sql`
5. Selecciona el schema: `lime_db`
6. Click en **Run**

## Opción 2: Línea de Comandos MySQL

Si tienes MySQL en el PATH:

```bash
mysql -u root -p lime_db < migracion_datos_lime.sql
```

Si no está en el PATH, usa la ruta completa (ejemplo):

```bash
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p lime_db < migracion_datos_lime.sql
```

## Opción 3: PowerShell con Ruta Completa

```powershell
Get-Content migracion_datos_lime.sql | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p lime_db
```

## Verificación Post-Ejecución

Después de ejecutar el script, verifica los datos:

```sql
-- Contar equipos
SELECT COUNT(*) as total_equipos FROM equipos_equipo;

-- Contar historiales de mantenimiento
SELECT COUNT(*) as total_mantenimientos FROM historial_mantenimientos;

-- Contar historiales de traslados
SELECT COUNT(*) as total_traslados FROM historial_traslados;

-- Ver equipos con sus historiales
SELECT 
    e.nombre_equipo,
    COUNT(DISTINCT hm.id) as mantenimientos,
    COUNT(DISTINCT ht.id) as traslados
FROM equipos_equipo e
LEFT JOIN historial_mantenimientos hm ON e.id = hm.equipo_id
LEFT JOIN historial_traslados ht ON e.id = ht.equipo_id
GROUP BY e.id, e.nombre_equipo
ORDER BY e.nombre_equipo;
```

## Datos Esperados

- **9 equipos manuales** con datos completos
- **Historiales de mantenimiento**: Solo para equipos con `requiere_mantenimiento = 1`
- **Historiales de traslado**: Para todos los equipos (0-3 traslados aleatorios)

## Notas Importantes

⚠️ **ADVERTENCIA**: Este script ejecuta `TRUNCATE` en todas las tablas de equipos e historiales. Asegúrate de estar en un entorno de desarrollo/pruebas.

✅ Si quieres incluir los **47 equipos del Excel**, cierra el archivo Excel y ejecuta:
```bash
py Backend\merge_sql_data.py
```
Luego ejecuta el SQL actualizado.
