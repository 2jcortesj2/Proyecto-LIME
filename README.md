# 🏥 Proyecto LIME - Sistema de Gestión de Equipos Biomédicos

Sistema integral para la gestión de equipos biomédicos de la Universidad de Antioquia.

## 📋 Descripción

LIME (Laboratorio de Ingeniería Médica y Equipos) es una aplicación web diseñada para gestionar el inventario completo de equipos biomédicos, incluyendo:

- 📦 Inventario de equipos
- 🔧 Historial de mantenimientos y calibraciones
- 📍 Gestión de sedes y ubicaciones
- 👥 Gestión de responsables
- 🚚 Historial de traslados
- 📊 Reportes y estadísticas

## 🚀 Tecnologías

### Backend
- Django 4.2.18
- Django REST Framework
- MySQL
- Python 3.10+

### Frontend
- Vue.js 3
- Vite
- Axios

## 📁 Estructura del Proyecto

```
Proyecto-LIME/
├── backend/           # API Django REST
│   ├── LIME/         # Configuración principal
│   ├── equipos/      # App de equipos
│   ├── sedes/        # App de sedes
│   ├── ubicaciones/  # App de ubicaciones
│   ├── responsables/ # App de responsables
│   ├── historial_mantenimientos/
│   ├── historial_traslados/
│   └── ...
├── frontend/         # Aplicación Vue.js
│   ├── src/
│   │   ├── components/
│   │   ├── services/
│   │   ├── utils/
│   │   └── ...
│   └── ...
├── DIAGRAMA_UML.md
├── DOCUMENTACION_BACKEND.md
├── DOCUMENTACION_FRONTEND.md
└── README.md
```

## 🔧 Instalación

### Backend

1. Navega al directorio del backend:
```bash
cd backend
```

2. Crea un entorno virtual e instala las dependencias:
```bash
python -m venv venv
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
```

3. Configura la base de datos en `LIME/settings.py`

4. Ejecuta las migraciones:
```bash
python manage.py migrate
```

5. Inicia el servidor:
```bash
python manage.py runserver
```

**Ver instrucciones detalladas en:** [backend/INSTALACION.md](backend/INSTALACION.md)

### Frontend

1. Navega al directorio del frontend:
```bash
cd frontend
```

2. Instala las dependencias:
```bash
npm install
```

3. Inicia el servidor de desarrollo:
```bash
npm run dev
```

**Ver instrucciones detalladas en:** [frontend/INSTALACION.md](frontend/INSTALACION.md)

## 📚 Documentación

- [Diagrama UML del Sistema](DIAGRAMA_UML.md)
- [Documentación del Backend](DOCUMENTACION_BACKEND.md)
- [Documentación del Frontend](DOCUMENTACION_FRONTEND.md)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 👥 Autores

- Universidad de Antioquia
- Facultad de Ingeniería

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 📞 Contacto

Para consultas sobre el proyecto, contactar a la Facultad de Ingeniería de la Universidad de Antioquia.
