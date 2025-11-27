# Proyecto LIME - Instalación del Backend

## Requisitos Previos

- Python 3.10 o superior
- MySQL 8.0 o superior
- pip (gestor de paquetes de Python)

## Pasos de Instalación

### 1. Crear Entorno Virtual

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

### 2. Instalar Dependencias

```bash
pip install -r requirements.txt
```

### 3. Configurar Base de Datos

Edita el archivo `LIME/settings.py` con las credenciales de tu base de datos:

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

### 4. Ejecutar Migraciones

```bash
python manage.py migrate
```

### 5. Cargar Datos Iniciales (Opcional)

```bash
# Ejecutar el script de migración de datos
python manage.py shell < merge_sql_data.py
```

### 6. Crear Superusuario

```bash
python manage.py createsuperuser
```

### 7. Ejecutar Servidor de Desarrollo

```bash
python manage.py runserver
```

El servidor estará disponible en: `http://127.0.0.1:8000/`

## Comandos Útiles

```bash
# Crear nuevas migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Acceder al shell de Django
python manage.py shell

# Ejecutar tests
python manage.py test
```

## Estructura del Proyecto

```
backend/
├── LIME/                  # Configuración principal del proyecto
├── equipos/              # App de gestión de equipos
├── sedes/                # App de gestión de sedes
├── servicios/            # App de gestión de servicios
├── responsables/         # App de gestión de responsables
├── historial_mantenimientos/  # App de historial de mantenimientos
├── historial_traslados/  # App de historial de traslados
├── reportes/             # App de generación de reportes
├── manage.py             # Script de gestión de Django
└── requirements.txt      # Dependencias del proyecto
```

## Solución de Problemas

### Error de conexión a MySQL

Asegúrate de que el servicio de MySQL esté iniciado:

```bash
# Windows
net start MySQL80

# Linux
sudo systemctl start mysql
```

### Error con mysqlclient

En Windows, puede que necesites instalar Visual C++ Build Tools:
- Descarga desde: https://visualstudio.microsoft.com/downloads/
- O usa: `pip install mysqlclient-binary`

### Error de permisos

En Linux/Mac, puede que necesites usar `sudo`:

```bash
sudo pip install -r requirements.txt
```
