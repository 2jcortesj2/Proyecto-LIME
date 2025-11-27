# Diagrama UML - Sistema LIME

## Diagrama de Clases del Backend

```mermaid
classDiagram
    %% Entidades Principales
    class Sede {
        +Integer id
        +String nombre
        +String direccion
        +String ciudad
        +String telefono
        +Boolean estado
        +__str__() String
    }

    class Servicio {
        +Integer id
        +String nombre
        +ForeignKey sede
        +String descripcion
        +String responsable
        +Boolean estado
        +__str__() String
    }

    class Equipo {
        +Integer id
        +ForeignKey sede
        +ForeignKey servicio
        +String codigo_interno
        +String codigo_ips
        +String nombre_equipo
        +String marca
        +String modelo
        +String serie
        +String clasificacion_ips
        +String clasificacion_riesgo
        +String registro_invima
        +String responsable_nombre
        +String ubicacion_fisica
        +String estado
        +DateTime created_at
        +DateTime updated_at
        +__str__() String
    }

    class RegistroAdquisicion {
        +Integer id
        +OneToOne equipo
        +Date fecha_adquisicion
        +String propietario
        +String forma_adquisicion
        +String nombre_proveedor
        +String telefono_proveedor
        +String email_proveedor
        +Boolean en_garantia
        +Date fecha_vencimiento_garantia
        +String tipo_documento
        +String numero_documento
        +Decimal valor_compra
        +__str__() String
    }

    class DocumentacionEquipo {
        +Integer id
        +OneToOne equipo
        +Boolean hoja_vida
        +Boolean registro_importacion
        +Boolean manual_operacion
        +Boolean manual_servicio
        +Boolean guia_rapida
        +Boolean protocolo_mto_preventivo
        +String frecuencia_metrologica
        +__str__() String
    }

    class InformacionMetrologica {
        +Integer id
        +OneToOne equipo
        +String magnitud
        +String rango_equipo
        +String rango_trabajo
        +String resolucion
        +String error_maximo
        +Boolean requiere_mantenimiento
        +String frecuencia_mantenimiento
        +Date ultimo_mantenimiento
        +Date proximo_mantenimiento
        +Boolean requiere_calibracion
        +String frecuencia_calibracion
        +Date ultima_calibracion
        +Date proxima_calibracion
        +__str__() String
        +fecha_proximo_mantenimiento_calculada() Date
        +estado_mantenimiento() String
    }

    class CondicionesFuncionamiento {
        +Integer id
        +OneToOne equipo
        +String voltaje
        +String corriente
        +String potencia
        +String presion
        +String dimensiones
        +String peso
        +Text otros
        +__str__() String
    }

    class HistorialTraslado {
        +Integer id
        +ForeignKey equipo
        +DateTime fecha_traslado
        +ForeignKey sede_origen
        +ForeignKey sede_destino
        +ForeignKey servicio_origen
        +ForeignKey servicio_destino
        +Text justificacion
        +String usuario_registro
        +DateTime created_at
        +__str__() String
    }

    class HistorialMantenimiento {
        +Integer id
        +ForeignKey equipo
        +String tipo_mantenimiento
        +Integer mes_mantenimiento
        +Integer anio_mantenimiento
        +Text descripcion
        +String realizado_por
        +Decimal costo
        +String usuario_registro
        +Text observaciones
        +DateTime created_at
        +__str__() String
        +fecha_display() String
    }

    %% Relaciones
    Sede "1" --> "0..*" Servicio : contiene
    Sede "1" --> "0..*" Equipo : aloja
    Servicio "1" --> "0..*" Equipo : tiene
    
    Equipo "1" --> "0..1" RegistroAdquisicion : tiene
    Equipo "1" --> "0..1" DocumentacionEquipo : tiene
    Equipo "1" --> "0..1" InformacionMetrologica : tiene
    Equipo "1" --> "0..1" CondicionesFuncionamiento : tiene
    Equipo "1" --> "0..*" HistorialTraslado : registra
    Equipo "1" --> "0..*" HistorialMantenimiento : registra
    
    HistorialTraslado --> Sede : sede_origen
    HistorialTraslado --> Sede : sede_destino
    HistorialTraslado --> Servicio : servicio_origen
    HistorialTraslado --> Servicio : servicio_destino
```

## Diagrama de Componentes del Frontend

```mermaid
graph TB
    subgraph "Frontend Vue.js"
        App[App.vue]
        Router[Vue Router]
        
        subgraph "Componentes"
            Dashboard[Dashboard.vue]
            EquiposPendientes[EquiposPendientes.vue]
            Inventario[Inventario.vue]
            Mantenimientos[Mantenimientos.vue]
            Sidebar[Sidebar.vue]
            Header[Header.vue]
        end
        
        subgraph "Servicios"
            API[api.js]
            Axios[Axios HTTP Client]
        end
        
        subgraph "Utilidades"
            SearchUtils[searchUtils.js]
        end
    end
    
    subgraph "Backend Django REST"
        EquiposAPI["/api/equipos/"]
        StatsAPI["/api/equipos/maintenance-stats/"]
        ProximosAPI["/api/equipos/proximos-mantenimiento/"]
        SedesAPI["/api/sedes/"]
        ServiciosAPI["/api/servicios/"]
    end
    
    App --> Router
    Router --> Dashboard
    Router --> EquiposPendientes
    Router --> Inventario
    Router --> Mantenimientos
    
    Dashboard --> API
    EquiposPendientes --> API
    Inventario --> API
    Mantenimientos --> API
    
    EquiposPendientes --> SearchUtils
    Inventario --> SearchUtils
    
    API --> Axios
    Axios --> EquiposAPI
    Axios --> StatsAPI
    Axios --> ProximosAPI
    Axios --> SedesAPI
    Axios --> ServiciosAPI
```

## Diagrama de Flujo de Datos - Mantenimiento

```mermaid
sequenceDiagram
    participant User as Usuario
    participant Dashboard as Dashboard.vue
    participant EquiposPend as EquiposPendientes.vue
    participant API as api.js
    participant Backend as Django Backend
    participant DB as Base de Datos

    User->>Dashboard: Accede al Dashboard
    Dashboard->>API: fetchMaintenanceStats()
    API->>Backend: GET /api/equipos/maintenance-stats/
    Backend->>DB: Consulta equipos con info metrológica
    DB-->>Backend: Datos de equipos
    Backend-->>API: {vencidos, proximos, normales, no_requiere}
    API-->>Dashboard: Estadísticas
    Dashboard->>Dashboard: Renderiza tarjetas con contadores
    
    User->>EquiposPend: Navega a "Equipos Pendientes"
    EquiposPend->>API: fetchEquipos()
    API->>Backend: GET /api/equipos/
    Backend->>DB: Consulta todos los equipos
    DB-->>Backend: Lista de equipos
    Backend-->>API: Array de equipos
    API-->>EquiposPend: Equipos con info metrológica
    EquiposPend->>EquiposPend: Filtra por estado='Activo'
    EquiposPend->>EquiposPend: Filtra por estado_mantenimiento
    EquiposPend->>User: Muestra equipos vencidos/próximos
    
    User->>EquiposPend: Selecciona filtro "Próximos 3 meses"
    EquiposPend->>EquiposPend: Recalcula filtro dinámico
    EquiposPend->>User: Actualiza tabla con equipos filtrados
```

## Diagrama de Estados del Mantenimiento

```mermaid
stateDiagram-v2
    [*] --> NoRequiere: requiere_mantenimiento = False
    [*] --> Normal: Fecha próximo > Hoy + 3 meses
    Normal --> Proximo: Fecha próximo <= Hoy + 3 meses
    Proximo --> Vencido: Fecha próximo < Hoy
    Vencido --> Normal: Se realiza mantenimiento
    NoRequiere --> [*]
    
    note right of Vencido
        Estado crítico
        Requiere acción inmediata
    end note
    
    note right of Proximo
        Alerta preventiva
        Planificar mantenimiento
    end note
    
    note right of Normal
        Estado óptimo
        Sin acciones requeridas
    end note
```

## Arquitectura General del Sistema

```mermaid
graph TB
    subgraph "Capa de Presentación"
        Browser[Navegador Web]
        VueApp[Aplicación Vue.js]
    end
    
    subgraph "Capa de Aplicación"
        Django[Django Backend]
        DRF[Django REST Framework]
        
        subgraph "Apps Django"
            EquiposApp[equipos]
            SedesApp[sedes]
            ServiciosApp[servicios]
            TrasladosApp[historial_traslados]
            MantenimientosApp[historial_mantenimientos]
            ReportesApp[reportes]
            ConfigApp[configuracion]
        end
    end
    
    subgraph "Capa de Datos"
        MySQL[(MySQL/MariaDB)]
    end
    
    Browser --> VueApp
    VueApp -->|HTTP/REST| DRF
    DRF --> Django
    Django --> EquiposApp
    Django --> SedesApp
    Django --> ServiciosApp
    Django --> TrasladosApp
    Django --> MantenimientosApp
    Django --> ReportesApp
    Django --> ConfigApp
    
    EquiposApp --> MySQL
    SedesApp --> MySQL
    ServiciosApp --> MySQL
    TrasladosApp --> MySQL
    MantenimientosApp --> MySQL
```

## Notas Importantes

### Relaciones Clave
- **Sede → Servicio**: Una sede puede tener múltiples servicios (1:N)
- **Equipo → Sede/Servicio**: Un equipo pertenece a una sede y un servicio (N:1)
- **Equipo → Modelos Relacionados**: Relación 1:1 con RegistroAdquisicion, DocumentacionEquipo, InformacionMetrologica, CondicionesFuncionamiento
- **Equipo → Historiales**: Relación 1:N con HistorialTraslado y HistorialMantenimiento

### Lógica de Negocio
- El cálculo del estado de mantenimiento se realiza en el modelo `InformacionMetrologica` mediante propiedades computadas
- Los filtros de equipos pendientes en el frontend se basan en el estado calculado por el backend
- La búsqueda avanzada normaliza texto para ignorar acentos y mayúsculas
