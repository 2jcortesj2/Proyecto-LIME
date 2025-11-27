# Diagrama UML - Sistema LIME

## Diagrama de Clases del Backend

```mermaid
classDiagram
    class Sede {
        +int id
        +string nombre
        +string ciudad
        +string direccion
        +string telefono
        +string estado
        +total_servicios()
        +total_equipos()
    }
    
    class Servicio {
        +int id
        +string nombre
        +FK sede
        +string responsable
        +string estado
        +total_equipos()
    }
    
    class Responsable {
        +int id
        +string nombre_completo
        +string cedula
        +string email
        +string telefono
        +string rol
        +string estado
    }
    
    class Equipo {
        +int id
        +string proceso
        +FK sede
        +FK servicio
        +FK responsable
        +string nombre_equipo
        +string codigo_interno
        +string codigo_ips
        +string codigo_ecri
        +string ubicacion_fisica
        +string marca
        +string modelo
        +string serie
        +MultiSelectField clasificacion_misional
        +string clasificacion_ips
        +string clasificacion_riesgo
        +string registro_invima
        +string estado
    }
    
    class RegistroAdquisicion {
        +int id
        +OneToOne equipo
        +string tiempo_vida_util
        +date fecha_adquisicion
        +string propietario
        +string fecha_fabricacion
        +string nit_proveedor
        +string nombre_proveedor
        +bool en_garantia
        +date fecha_finalizacion_garantia
        +string forma_adquisicion
        +string tipo_documento
        +string numero_documento
        +decimal valor_compra
    }
    
    class DocumentacionEquipo {
        +int id
        +OneToOne equipo
        +bool hoja_vida
        +bool registro_importacion
        +bool manual_operacion
        +string idioma_manual
        +bool manual_servicio
        +bool guia_rapida
        +bool instructivo_manejo
        +bool protocolo_mto_preventivo
        +string frecuencia_metrologica
    }
    
    class InformacionMetrologica {
        +int id
        +OneToOne equipo
        +bool requiere_mantenimiento
        +int frecuencia_mantenimiento
        +date ultimo_mantenimiento
        +bool requiere_calibracion
        +string magnitud
        +string rango_equipo
        +string rango_trabajo
        +string resolucion
        +string error_maximo
        +fecha_proximo_mantenimiento_calculada()
        +estado_mantenimiento()
    }
    
    class CondicionesFuncionamiento {
        +int id
        +OneToOne equipo
        +string voltaje
        +string corriente
        +string potencia
        +string presion
        +string dimensiones
        +string peso
        +string otros
    }
    
    class HistorialMantenimiento {
        +int id
        +FK equipo
        +string tipo_mantenimiento
        +int mes_mantenimiento
        +int anio_mantenimiento
        +string realizado_por
        +text descripcion
        +text observaciones
        +decimal costo
        +fecha_mantenimiento()
    }
    
    class HistorialTraslado {
        +int id
        +FK equipo
        +date fecha_traslado
        +FK sede_origen
        +FK servicio_origen
        +FK sede_destino
        +FK servicio_destino
        +text justificacion
        +string usuario_registro
    }
    
    %% Relaciones
    Sede "1" --> "0..*" Servicio : contiene
    Sede "1" --> "0..*" Equipo : tiene
    Servicio "1" --> "0..*" Equipo : tiene
    Responsable "1" --> "0..*" Equipo : responsable_de
    
    Equipo "1" --> "0..1" RegistroAdquisicion : tiene
    Equipo "1" --> "0..1" DocumentacionEquipo : tiene
    Equipo "1" --> "0..1" InformacionMetrologica : tiene
    Equipo "1" --> "0..1" CondicionesFuncionamiento : tiene
    Equipo "1" --> "0..*" HistorialMantenimiento : tiene
    Equipo "1" --> "0..*" HistorialTraslado : tiene
    
    Sede "1" --> "0..*" HistorialTraslado : origen
    Sede "1" --> "0..*" HistorialTraslado : destino
    Servicio "1" --> "0..*" HistorialTraslado : origen
    Servicio "1" --> "0..*" HistorialTraslado : destino
```

## Diagrama de Arquitectura del Sistema

```mermaid
flowchart TB
    subgraph Frontend["Frontend - Vue.js"]
        Dashboard[Dashboard.vue]
        Inventario[Inventario.vue]
        Pendientes[EquiposPendientes.vue]
        Mantenimientos[Mantenimientos.vue]
        Traslados[Traslados.vue]
        SedesServ[SedesServicios.vue]
        Sidebar[Sidebar.vue]
        
        API[services/api.js]
        Utils[utils/searchUtils.js]
    end
    
    subgraph Backend["Backend - Django/DRF"]
        subgraph Apps["Django Apps"]
            AppEquipos[equipos]
            AppSedes[sedes]
            AppServicios[servicios]
            AppResp[responsables]
            AppMant[historial_mantenimientos]
            AppTrasl[historial_traslados]
        end
        
        subgraph Models["Models"]
            EquipoModel[Equipo]
            InfoMet[InformacionMetrologica]
            RegAdq[RegistroAdquisicion]
            Doc[DocumentacionEquipo]
            Cond[CondicionesFuncionamiento]
        end
        
        Admin[Django Admin]
    end
    
    subgraph Database["Base de Datos"]
        MySQL[(MySQL 8.0)]
    end
    
    Dashboard --> API
    Inventario --> API
    Pendientes --> API
    Mantenimientos --> API
    Traslados --> API
    SedesServ --> API
    
    Dashboard --> Utils
    Inventario --> Utils
    Pendientes --> Utils
    
    API -->|HTTP/REST| Apps
    
    Admin -->|Gestión| Models
    Apps -->|ORM| Models
    Models -->|Django ORM| MySQL
    
    style Frontend fill:#e8f5e9
    style Backend fill:#e3f2fd
    style Database fill:#fff3e0
```

## Diagrama de Flujo: Estados de Mantenimiento

```mermaid
flowchart TD
    Start([Equipo Creado]) --> Check{¿Requiere<br/>Mantenimiento?}
    
    Check -->|No| NoReq[Estado: No Requiere]
    Check -->|Sí| HasFreq{¿Tiene Frecuencia<br/>y Último Mant.?}
    
    HasFreq -->|No| NoProg[Estado: No Programado]
    HasFreq -->|Sí| CalcFecha[Calcular Fecha<br/>Próximo Mant.]
    
    CalcFecha --> CompareDate{Comparar con<br/>Fecha Actual}
    
    CompareDate -->|Fecha < Hoy| Vencido[Estado: Vencido<br/>🔴 Alerta]
    CompareDate -->|Hoy ≤ Fecha ≤ Hoy+3m| Proximo[Estado: Próximo<br/>🟡 Atención]
    CompareDate -->|Fecha > Hoy+3m| Normal[Estado: Normal<br/>🟢 OK]
    
    Vencido --> Dashboard1[Mostrar en Dashboard]
    Proximo --> Dashboard1
    Normal --> Dashboard1
    
    Dashboard1 --> Action{Acción del<br/>Usuario}
    
    Action -->|Completar| RegMant[Registrar<br/>Mantenimiento]
    Action -->|Reprogramar| UpdateFecha[Actualizar<br/>Fecha]
    
    RegMant --> UpdateUltimo[Actualizar<br/>Último Mant.]
    UpdateUltimo --> CalcFecha
    
    UpdateFecha --> CalcFecha
    
    style Vencido fill:#ffcdd2
    style Proximo fill:#fff9c4
    style Normal fill:#c8e6c9
    style NoReq fill:#e0e0e0
    style NoProg fill:#ffecb3
```

## Diagrama de Secuencia: Crear Equipo

```mermaid
sequenceDiagram
    actor Usuario
    participant Frontend
    participant API
    participant Backend
    participant DB as Base de Datos
    
    Usuario->>Frontend: Clic en "Nuevo Equipo"
    Frontend->>Frontend: Abrir Modal de Creación
    Frontend->>API: Cargar Sedes/Servicios/Responsables
    API->>Backend: GET /api/sedes/, /api/servicios/, /api/responsables/
    Backend->>DB: SELECT * FROM sedes, servicios, responsables
    DB-->>Backend: Datos
    Backend-->>API: JSON Response
    API-->>Frontend: Datos para dropdowns
    
    Usuario->>Frontend: Llenar formulario (6 tabs)
    Usuario->>Frontend: Clic en "Guardar Equipo"
    
    Frontend->>Frontend: Validar formulario
    alt Validación fallida
        Frontend-->>Usuario: Mostrar errores en rojo
    else Validación exitosa
        Frontend->>API: POST /api/equipos/ (JSON payload)
        API->>Backend: Crear Equipo
        Backend->>DB: INSERT Equipo
        Backend->>DB: INSERT RegistroAdquisicion
        Backend->>DB: INSERT DocumentacionEquipo
        Backend->>DB: INSERT InformacionMetrologica
        Backend->>DB: INSERT CondicionesFuncionamiento
        DB-->>Backend: IDs creados
        Backend-->>API: Equipo creado (201)
        API-->>Frontend: Success
        Frontend-->>Usuario: Mensaje "✅ Equipo creado exitosamente"
        Frontend->>Frontend: Cerrar modal
        Frontend->>Frontend: Refrescar lista de equipos
    end
```

## Diagrama de Componentes: Frontend

```mermaid
graph TB
    subgraph Components["Componentes Vue"]
        App[App.vue]
        Sidebar[Sidebar.vue]
        Dashboard[Dashboard.vue]
        Inventario[Inventario.vue]
        Pendientes[EquiposPendientes.vue]
        Mantenimientos[Mantenimientos.vue]
        Traslados[Traslados.vue]
        SedesServ[SedesServicios.vue]
    end
    
    subgraph Services["Servicios"]
        API[api.js]
        EquiposAPI[equiposAPI]
        SedesAPI[sedesAPI]
        ServiciosAPI[serviciosAPI]
        RespAPI[responsablesAPI]
    end
    
    subgraph Utils["Utilidades"]
        SearchUtils[searchUtils.js]
        NormalizeText[normalizeText]
        FilterEquipos[filterEquiposBySearch]
    end
    
    App --> Sidebar
    App --> Dashboard
    App --> Inventario
    App --> Pendientes
    App --> Mantenimientos
    App --> Traslados
    App --> SedesServ
    
    Dashboard --> EquiposAPI
    Inventario --> EquiposAPI
    Inventario --> SedesAPI
    Inventario --> ServiciosAPI
    Inventario --> RespAPI
    Pendientes --> EquiposAPI
    Mantenimientos --> EquiposAPI
    SedesServ --> SedesAPI
    
    Inventario --> SearchUtils
    Pendientes --> SearchUtils
    
    API --> EquiposAPI
    API --> SedesAPI
    API --> ServiciosAPI
    API --> RespAPI
    
    SearchUtils --> NormalizeText
    SearchUtils --> FilterEquipos
    
    style Components fill:#e8f5e9
    style Services fill:#e3f2fd
    style Utils fill:#fff3e0
```

## Notas Adicionales

### Convenciones de Nombres
- **Models**: PascalCase (Equipo, InformacionMetrologica)
- **Fields**: snake_case (codigo_interno, fecha_adquisicion)
- **Components**: PascalCase (Dashboard.vue, Inventario.vue)
- **Functions**: camelCase (normalizeText, filterEquiposBySearch)

### Relaciones Clave
1. **Sede → Servicio → Equipo**: Jerarquía organizacional
2. **Equipo → 4 modelos 1:1**: Información extendida
3. **Equipo → N historiales**: Trazabilidad temporal
4. **InformacionMetrologica**: Lógica crítica de estados

### Estados del Sistema
- **Equipos**: Activo, Inactivo
- **Mantenimiento**: Vencido, Próximo, Normal, No Requiere, No Programado
- **Tipo Mantenimiento**: Preventivo, Correctivo, Calibración, Verificación

### Flujos Principales
1. **Dashboard → EquiposPendientes**: Ver equipos que requieren atención
2. **Inventario → Modal Detalle**: Ver información completa
3. **Inventario → Modal Edición**: Modificar equipo
4. **SedesServicios → Acordeón**: Gestionar estructura organizacional
