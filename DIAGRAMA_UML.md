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
        +bool estado
        +total_ubicaciones()
        +total_equipos()
    }
    
    class Ubicacion {
        +int id
        +string nombre
        +FK sede
        +bool estado
        +total_equipos()
    }
    
    class Responsable {
        +int id
        +string nombre_completo
        +string email
        +string telefono
        +string rol
        +total_equipos_asignados()
        +total_traslados_registrados()
    }
    
    class Equipo {
        +int id
        +string proceso
        +FK sede
        +FK ubicacion
        +FK responsable
        +string nombre_equipo
        +string codigo_interno
        +string codigo_ips
        +string codigo_ecri
        +string marca
        +string modelo
        +string serie
        +MultiSelectField clasificacion_misional
        +string clasificacion_ips
        +string clasificacion_riesgo
        +string registro_invima
        +int tiempo_vida_util
        +string estado
    }
    
    class RegistroAdquisicion {
        +int id
        +OneToOne equipo
        +date fecha_adquisicion
        +string propietario
        +date fecha_fabricacion
        +string nit_proveedor
        +string nombre_proveedor
        +bool en_garantia
        +date fecha_fin_garantia
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
        +bool manual_servicio
        +bool guia_rapida
        +bool protocolo_mto_preventivo
        +string frecuencia_metrologica
    }
    
    class InformacionMetrologica {
        +int id
        +OneToOne equipo
        +bool requiere_mantenimiento
        +string frecuencia_mantenimiento
        +date ultimo_mantenimiento
        +date proximo_mantenimiento
        +bool requiere_calibracion
        +string frecuencia_calibracion
        +date ultima_calibracion
        +date proxima_calibracion
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
        +string humedad_relativa
        +string temperatura
        +string dimensiones
        +string peso
        +text otros
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
        +datetime fecha_traslado
        +FK sede_origen
        +FK ubicacion_origen
        +FK sede_destino
        +FK ubicacion_destino
        +text justificacion
        +FK responsable_registro
        +datetime created_at
    }
    
    %% Relaciones
    Sede "1" --> "0..*" Ubicacion : contiene
    Sede "1" --> "0..*" Equipo : tiene
    Ubicacion "1" --> "0..*" Equipo : tiene
    Responsable "1" --> "0..*" Equipo : responsable_de
    Responsable "1" --> "0..*" HistorialTraslado : registra
    
    Equipo "1" --> "0..1" RegistroAdquisicion : tiene
    Equipo "1" --> "0..1" DocumentacionEquipo : tiene
    Equipo "1" --> "0..1" InformacionMetrologica : tiene
    Equipo "1" --> "0..1" CondicionesFuncionamiento : tiene
    Equipo "1" --> "0..*" HistorialMantenimiento : tiene
    Equipo "1" --> "0..*" HistorialTraslado : tiene
    
    Sede "1" --> "0..*" HistorialTraslado : origen
    Sede "1" --> "0..*" HistorialTraslado : destino
    Ubicacion "1" --> "0..*" HistorialTraslado : origen
    Ubicacion "1" --> "0..*" HistorialTraslado : destino
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
        SedesUbic[SedesServicios.vue]
        Responsables[Responsables.vue]
        Sidebar[Sidebar.vue]
        
        API[services/api.js]
        Utils[utils/searchUtils.js]
    end
    
    subgraph Backend["Backend - Django/DRF"]
        subgraph Apps["Django Apps"]
            AppEquipos[equipos]
            AppSedes[sedes]
            AppUbicaciones[ubicaciones]
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
    SedesUbic --> API
    Responsables --> API
    
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
        SedesUbic[SedesServicios.vue]
        Responsables[Responsables.vue]
    end
    
    subgraph Services["Servicios"]
        API[api.js]
        EquiposAPI[equiposAPI]
        SedesAPI[sedesAPI]
        UbicacionesAPI[ubicacionesAPI]
        RespAPI[responsablesAPI]
        TrasladosAPI[trasladosAPI]
        MantenimientosAPI[mantenimientosAPI]
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
    App --> SedesUbic
    App --> Responsables
    
    Dashboard --> EquiposAPI
    Inventario --> EquiposAPI
    Inventario --> SedesAPI
    Inventario --> UbicacionesAPI
    Inventario --> RespAPI
    Pendientes --> EquiposAPI
    Mantenimientos --> MantenimientosAPI
    Traslados --> TrasladosAPI
    Traslados --> UbicacionesAPI
    SedesUbic --> SedesAPI
    SedesUbic --> UbicacionesAPI
    Responsables --> RespAPI
    
    Inventario --> SearchUtils
    Pendientes --> SearchUtils
    
    API --> EquiposAPI
    API --> SedesAPI
    API --> UbicacionesAPI
    API --> RespAPI
    API --> TrasladosAPI
    API --> MantenimientosAPI
    
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
1. **Sede → Ubicacion → Equipo**: Jerarquía organizacional (Servicio fue reemplazado por Ubicacion)
2. **Equipo → 4 modelos 1:1**: Información extendida
3. **Equipo → N historiales**: Trazabilidad temporal
4. **InformacionMetrologica**: Lógica crítica de estados
5. **Responsable → Equipo**: Asignación de responsables a equipos
6. **Responsable → HistorialTraslado**: Registro de quién realizó el traslado

### Estados del Sistema
- **Equipos**: Activo, Inactivo, Baja, En Mantenimiento
- **Mantenimiento**: Vencido, Próximo, Normal, No Requiere, No Programado
- **Tipo Mantenimiento**: Preventivo, Correctivo, Calibración, Verificación

### Flujos Principales
1. **Dashboard → EquiposPendientes**: Ver equipos que requieren atención
2. **Inventario → Modal Detalle**: Ver información completa
3. **Inventario → Modal Edición**: Modificar equipo
4. **SedesServicios → Acordeón**: Gestionar estructura organizacional (ahora con Ubicaciones)
5. **Traslados**: Registrar movimientos de equipos entre ubicaciones

### Cambios Recientes en el Esquema
- **Eliminado**: Tabla `Servicio` y campo `ubicacion_fisica` en Equipo
- **Agregado**: Tabla `Ubicacion` con FK a Sede
- **Agregado**: Campo `proceso` en Equipo (CharField)
- **Modificado**: Campo `ubicacion` en Equipo (ahora FK a Ubicacion)
- **Modificado**: Campo `usuario_registro` en HistorialTraslado (ahora `responsable_registro` como FK a Responsable)
- **Modificado**: Campos `servicio_origen` y `servicio_destino` en HistorialTraslado (ahora `ubicacion_origen` y `ubicacion_destino`)
