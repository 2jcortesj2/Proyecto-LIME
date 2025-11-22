# Migración de Datos - LIME

Este documento explica cómo usar el script de migración de datos para el sistema LIME.

## Archivo de Migración

**Archivo:** `migracion_datos_lime.sql`

Este script SQL contiene datos de prueba iniciales para el sistema LIME, incluyendo:
- 3 Sedes (Prado, SIU, San Vicente)
- 18 Servicios distribuidos en las 3 sedes
- 5 Equipos de muestra con información completa

## Estructura de la Base de Datos

El script utiliza las siguientes tablas (nomenclatura Django):

### Tablas Principales
- `sedes` - Información de sedes/ubicaciones
- `servicios` - Servicios/departamentos en cada sede
- `usuarios` - Usuarios del sistema
- `equipos_equipo` - Información básica de equipos

### Tablas Relacionadas (Un equipo puede tener)
- `equipos_registroadquisicion` - Datos de adquisición y compra
- `equipos_documentacionequipo` - Documentación disponible
- `equipos_informacionmetrologica` - Información de mantenimiento y calibración
- `equipos_condicionesfuncionamiento` - Condiciones operativas

## Cómo Ejecutar el Script

### Opción 1: Desde la Línea de Comandos

```bash
# Asegúrese de que MySQL esté corriendo
# Navegue al directorio del proyecto

mysql -u root -p lime_db < migracion_datos_lime.sql
```

Cuando se le solicite, ingrese la contraseña de MySQL (vacía si no tiene una configurada).

### Opción 2: Desde MySQL Workbench

1. Abra MySQL Workbench
2. Conéctese a su servidor MySQL local
3. Vaya a **File** > **Run SQL Script**
4. Seleccione el archivo `migracion_datos_lime.sql`
5. Seleccione el schema `lime_db`
6. Haga clic en **Run**

### Opción 3: Desde el Shell de MySQL

```bash
# Inicie el shell de MySQL
mysql -u root -p

# Dentro del shell MySQL:
USE lime_db;
SOURCE /ruta/completa/a/migracion_datos_lime.sql;
```

## IMPORTANTE ⚠️

**El script incluye comandos TRUNCATE que eliminarán TODOS los datos existentes** en las siguientes tablas:
- `equipos_condicionesfuncionamiento`
- `equipos_informacionmetrologica`
- `equipos_documentacionequipo`
- `equipos_registroadquisicion`
- `equipos_equipo`
- `servicios`
- `sedes`

**Solo ejecute este script en un entorno de desarrollo o prueba.**

## Valores Permitidos

### clasificacion_riesgo
- `'I'` - Clase I
- `'IIa'` - Clase IIa
- `'IIb'` - Clase IIb
- `'III'` - Clase III

### clasificacion_misional
- `'Docencia'`
- `'Investigación'`
- `'Extensión'`
- `'Mixto'`

### clasificacion_ips
- `'IND'` - Industrial
- `'BIO'` - Biomédico
- `'GASES'` - Gases medicinales

### estado (equipo)
- `'Activo'`
- `'Inactivo'`
- `'Baja'`
- `'En Mantenimiento'`

### forma_adquisicion
- `'Compra'`
- `'Apoyo Tecnológico'`
- `'Donación'`
- `'Convenio'`

## Patrón para Agregar Más Equipos

Cada equipo requiere 5 inserciones relacionadas:

```sql
-- 1. Equipo principal
INSERT INTO `equipos_equipo` (...) VALUES (...);
SET @equipo_id = LAST_INSERT_ID();

-- 2. Registro de adquisición
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, ...) VALUES (@equipo_id, ...);

-- 3. Documentación
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, ...) VALUES (@equipo_id, ...);

-- 4. Información metrológica
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, ...) VALUES (@equipo_id, ...);

-- 5. Condiciones de funcionamiento
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, ...) VALUES (@equipo_id, ...);
```

## Verificar la Importación

Después de ejecutar el script, puede verificar los datos con:

```sql
-- Ver sedes
SELECT * FROM sedes;

-- Ver servicios por sede
SELECT s.nombre, se.nombre as sede 
FROM servicios s 
JOIN sedes se ON s.sede_id = se.id;

-- Ver equipos
SELECT 
    e.nombre_equipo, 
    e.codigo_interno, 
    se.nombre as sede,
    sv.nombre as servicio
FROM equipos_equipo e
JOIN sedes se ON e.sede_id = se.id
JOIN servicios sv ON e.servicio_id = sv.id;
```

## Configuración de la Base de Datos

El archivo de configuración Django en `LIME/settings.py` debe tener:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'lime_db',
        'USER': 'root',
        'PASSWORD': '',  # Su contraseña de MySQL
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

## Próximos Pasos

Después de cargar los datos:

1. **Crear migraciones de Django** (si es necesario):
   ```bash
   cd LIME
   python manage.py makemigrations
   python manage.py migrate
   ```

2. **Verificar en el admin de Django**:
   ```bash
   python manage.py runserver
   ```
   Luego visite `http://127.0.0.1:8000/admin`

3. **Probar la API**:
   - Sedes: `http://127.0.0.1:8000/api/sedes/`
   - Servicios: `http://127.0.0.1:8000/api/servicios/`
   - Equipos: `http://127.0.0.1:8000/api/equipos/`

## Solución de Problemas

### Error: "Unknown database 'lime_db'"

Cree primero la base de datos:
```sql
CREATE DATABASE lime_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Error: "Table doesn't exist"

Ejecute primero las migraciones de Django:
```bash
python manage.py migrate
```

### Error: "Foreign key constraint fails"

El script desactiva temporalmente las restricciones de llave foránea, pero si aún tiene problemas:
1. Verifique que todas las tablas existan
2. Asegúrese de que los IDs de sede y servicio sean correctos
3. El campo `responsable_id` debe estar en NULL o referenciar un usuario válido

## Contacto

Para problemas o preguntas, contacte al equipo de desarrollo del proyecto LIME.
