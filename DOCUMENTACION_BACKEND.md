# Documentación del Backend - Proyecto LIME

## Descripción General
El backend de LIME está construido con **Django 4.2.18** y **Django REST Framework (DRF)**. Su propósito principal es gestionar el inventario de equipos biomédicos, industriales y de gases, así como sus mantenimientos, traslados y documentación.

## Tecnologías Principales
- **Django 4.2.18**: Framework web de Python
- **Django REST Framework 3.15.2**: API REST
- **MySQL 8.0+**: Base de datos
- **django-cors-headers**: Manejo de CORS
- **django-multiselectfield**: Campos de selección múltiple
- **pandas/openpyxl**: Procesamiento de datos Excel

## Estructura del Proyecto

El proyecto se organiza en múltiples aplicaciones (apps) para modularizar la funcionalidad:

### Aplicaciones Principales

#### 1. **`equipos`**
- **Propósito**: Gestión central del inventario de equipos.
- **Modelos Principales**:
  - `Equipo`: Modelo principal con información general del equipo
  - `InformacionMetrologica`: Datos de mantenimiento y calibración
  - `RegistroAdquisicion`: Información de compra y adquisición
  - `DocumentacionEquipo`: Registro de documentos disponibles
  - `CondicionesFuncionamiento`: Especificaciones técnicas

- **Endpoints Clave**:
  - `GET /api/equipos/`: Listar todos los equipos
  - `GET /api/equipos/{id}/`: Detalle de un equipo
  - `POST /api/equipos/`: Crear nuevo equipo
  - `PUT /api/equipos/{id}/`: Actualizar equipo
  - `DELETE /api/equipos/{id}/`: Eliminar equipo
  - `GET /api/equipos/maintenance-stats/`: Estadísticas de mantenimiento
  - `GET /api/equipos/proximos-mantenimiento/`: Equipos próximos a vencer

- **Admin**: Panel con inlines colapsables, acciones en lote (activar/inactivar), campos coloreados por estado

#### 2. **`sedes`**
- **Propósito**: Gestión de las sedes institucionales.
- **Modelo**: `Sede` (nombre, ciudad, dirección, teléfono, estado)
- **Endpoints**: `/api/sedes/` (CRUD completo)
- **Admin**: Contadores de servicios y equipos, acciones en lote, búsqueda avanzada

#### 3. **`servicios`**
- **Propósito**: Gestión de servicios/áreas dentro de sedes.
- **Modelo**: `Servicio` (nombre, sede, responsable, estado)
- **Endpoints**: `/api/servicios/` (CRUD completo)
- **Admin**: Contador de equipos, autocomplete de sede, acciones en lote

#### 4. **`responsables`**
- **Propósito**: Gestión del personal responsable.
- **Modelo**: `Responsable` (nombre, cédula, email, teléfono, rol, estado)
- **Endpoints**: `/api/responsables/` (CRUD completo)
- **Admin**: Campos coloreados por rol, acciones en lote, filtros por rol y estado

#### 5. **`historial_mantenimientos`**
- **Propósito**: Registro histórico de mantenimientos.
- **Modelo**: `HistorialMantenimiento` (equipo, tipo, fecha, costo, descripción)
- **Endpoints**: `/api/historial-mantenimientos/` (CRUD completo)
- **Admin**: Tipos coloreados, formato de moneda, búsqueda por equipo

#### 6. **`historial_traslados`**
- **Propósito**: Trazabilidad de ubicación de equipos.
- **Modelo**: `HistorialTraslado` (equipo, origen, destino, fecha, justificación)
- **Endpoints**: `/api/historial-traslados/` (CRUD completo)
- **Admin**: Vista visual de traslados, protección contra eliminación, date hierarchy

#### 7. **`reportes`**
- **Propósito**: Generación de reportes (PDF, Excel).
- **Estado**: En desarrollo

#### 8. **`configuracion`**
- **Propósito**: Configuraciones generales del sistema.
- **Estado**: Configuración básica

## Lógica de Mantenimiento

La lógica de cálculo de estados de mantenimiento está centralizada en el modelo `InformacionMetrologica`:

### Estados de Mantenimiento

- **Vencido**: `fecha_proximo_mantenimiento < hoy`
- **Próximo**: `hoy <= fecha_proximo_mantenimiento <= hoy + 3 meses`
- **Normal**: `fecha_proximo_mantenimiento > hoy + 3 meses`
- **No Programado**: `requiere_mantenimiento = True` pero sin fecha asignada

### Cálculo Automático

```python
@property
def fecha_proximo_mantenimiento_calculada(self):
    if self.ultimo_mantenimiento and self.frecuencia_mantenimiento:
        return self.ultimo_mantenimiento + relativedelta(months=self.frecuencia_mantenimiento)
    return None

@property
def estado_mantenimiento(self):
    if not self.requiere_mantenimiento:
        return "No Requiere"
    
    fecha_prox = self.fecha_proximo_mantenimiento_calculada
    if not fecha_prox:
        return "No Programado"
    
    hoy = date.today()
    if fecha_prox < hoy:
        return "Vencido"
    elif fecha_prox <= hoy + relativedelta(months=3):
        return "Próximo"
    else:
        return "Normal"
```

## Panel de Administración de Django

### Características Generales
- **Inlines Colapsables**: Modelos relacionados organizados en secciones
- **Acciones en Lote**: Activar/inactivar múltiples registros
- **Campos Coloreados**: Estados y tipos con colores distintivos
- **Búsqueda Avanzada**: Múltiples campos de búsqueda
- **Filtros Inteligentes**: Filtros relevantes por modelo
- **Autocomplete**: Mejora UX en relaciones
- **Contadores Visuales**: Métricas de relaciones

### Mejoras por Modelo

#### Equipos
- Estado coloreado (verde/rojo)
- 4 inlines: Registro, Documentación, Metrológica, Condiciones
- Actions: activar_equipos, inactivar_equipos
- Búsqueda en 8+ campos

#### Sedes
- Contadores: total_servicios (verde), total_equipos (azul)
- Estado coloreado
- Actions: activar_sedes, inactivar_sedes

#### Servicios
- Contador: total_equipos
- Autocomplete para sede
- Actions: activar_servicios, inactivar_servicios

#### Responsables
- Rol coloreado (azul/verde/púrpura)
- Estado coloreado
- Actions: activar_responsables, inactivar_responsables

#### Historial Mantenimientos
- Tipo coloreado (preventivo, correctivo, calibración)
- Costo formateado ($X,XXX.XX)
- Fecha en formato legible

#### Historial Traslados
- Vista visual de origen/destino
- Protección contra eliminación (solo superusuarios)
- Date hierarchy

## Scripts de Utilidad

### `merge_sql_data.py`
- Fusiona datos desde múltiples fuentes SQL
- Genera datos sintéticos para relaciones faltantes
- Limpia y normaliza datos (ej: "Clase I" → "I")

### `excel_to_sql.py`
- Convierte datos de Excel a formato SQL
- Mapeo de columnas configurable
- Validación de datos

### `generar_historiales.py`
- Genera historiales de mantenimiento aleatorios
- Útil para testing y demostración

## Configuración y Ejecución

### Instalación

```bash
# Crear entorno virtual
python -m venv venv
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# Instalar dependencias
pip install -r requirements.txt

# Configurar base de datos en LIME/settings.py
# Ejecutar migraciones
python manage.py migrate

# Crear superusuario
python manage.py createsuperuser

# Ejecutar servidor
python manage.py runserver
```

### Configuración de Base de Datos

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'lime_db',
        'USER': 'tu_usuario',
        'PASSWORD': 'tu_contraseña',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

### CORS Configuration

```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:5173",  # Frontend development
    "http://127.0.0.1:5173",
]
```

## API Endpoints

### Base URL
`http://localhost:8000/api/`

### Endpoints Disponibles

```
GET    /api/equipos/                    # Listar equipos
POST   /api/equipos/                    # Crear equipo
GET    /api/equipos/{id}/               # Detalle equipo
PUT    /api/equipos/{id}/               # Actualizar equipo
DELETE /api/equipos/{id}/               # Eliminar equipo
GET    /api/equipos/maintenance-stats/  # Estadísticas
GET    /api/equipos/proximos-mantenimiento/  # Próximos

GET    /api/sedes/                      # CRUD sedes
GET    /api/servicios/                  # CRUD servicios
GET    /api/responsables/               # CRUD responsables
GET    /api/historial-mantenimientos/  # CRUD mantenimientos
GET    /api/historial-traslados/       # CRUD traslados
```

## Modelos de Datos

### Relaciones Principales

```
Sede → Servicio → Equipo
Responsable → Equipo
Equipo → InformacionMetrologica (1:1)
Equipo → RegistroAdquisicion (1:1)
Equipo → DocumentacionEquipo (1:1)
Equipo → CondicionesFuncionamiento (1:1)
Equipo → HistorialMantenimiento (1:N)
Equipo → HistorialTraslado (1:N)
```

## Mejores Prácticas

1. **Siempre usar el panel de administración** para gestión rápida
2. **Usar acciones en lote** para operaciones múltiples
3. **Aprovechar autocomplete** para reducir errores
4. **Revisar campos coloreados** para identificación rápida
5. **Usar búsqueda avanzada** antes de crear duplicados

## Troubleshooting

### Error de conexión MySQL
```bash
# Verificar que MySQL esté corriendo
net start MySQL80  # Windows
sudo systemctl start mysql  # Linux
```

### Error de migraciones
```bash
# Reiniciar migraciones
python manage.py migrate --fake-initial
```

### CORS errors
Verificar que el frontend esté en `CORS_ALLOWED_ORIGINS` en settings.py
