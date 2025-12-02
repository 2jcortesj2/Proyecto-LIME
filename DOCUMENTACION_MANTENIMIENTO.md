# Documentación: Sistema de Revisión y Reprogramación de Mantenimiento de Equipos

## Tabla de Contenidos
1. [Visión General](#visión-general)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Lógica de Negocio](#lógica-de-negocio)
4. [Componentes Frontend](#componentes-frontend)
5. [Backend y API](#backend-y-api)
6. [Flujos de Usuario](#flujos-de-usuario)
7. [Composables y Utilidades](#composables-y-utilidades)
8. [Constantes y Configuración](#constantes-y-configuración)
9. [Casos de Uso](#casos-de-uso)
10. [Troubleshooting](#troubleshooting)

---

## 1. Visión General

El sistema de mantenimiento de equipos permite gestionar el ciclo de vida del mantenimiento preventivo de equipos biomédicos, industriales y de gases. El sistema clasifica automáticamente los equipos según su estado de mantenimiento y proporciona interfaces para completar mantenimientos y reprogramar fechas.

### Objetivos del Sistema
- **Prevención**: Identificar equipos que requieren mantenimiento antes de que fallen
- **Organización**: Clasificar equipos por urgencia (Vencido, Próximo, Normal)
- **Trazabilidad**: Mantener historial completo de todos los mantenimientos realizados
- **Cumplimiento**: Asegurar que los equipos cumplan con las normativas de mantenimiento

### Estados de Mantenimiento
- **Vencido**: Requiere atención inmediata (fecha pasada o mes actual)
- **Próximo**: Requiere atención en los próximos 3 meses (excluyendo mes actual)
- **Normal**: Mantenimiento programado a más de 3 meses
- **No Requiere**: El equipo no requiere mantenimiento preventivo
- **No Programado**: Requiere mantenimiento pero no tiene fecha programada

---

## 2. Arquitectura del Sistema

### Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                        FRONTEND                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │ EquiposVencidos  │         │ EquiposProximos  │         │
│  │    .vue          │         │    .vue          │         │
│  └────────┬─────────┘         └────────┬─────────┘         │
│           │                            │                    │
│           └────────────┬───────────────┘                    │
│                        │                                    │
│           ┌────────────▼────────────┐                       │
│           │  Modales Compartidos    │                       │
│           ├─────────────────────────┤                       │
│           │ ModalReprogramar        │                       │
│           │ ModalCompletar          │                       │
│           └────────────┬────────────┘                       │
│                        │                                    │
│           ┌────────────▼────────────┐                       │
│           │     Composables         │                       │
│           ├─────────────────────────┤                       │
│           │ useMantenimiento        │                       │
│           │ useDateCalculations     │                       │
│           │ useFormatting           │                       │
│           │ useNotifications        │                       │
│           └────────────┬────────────┘                       │
│                        │                                    │
└────────────────────────┼────────────────────────────────────┘
                         │
                    API REST
                         │
┌────────────────────────▼────────────────────────────────────┐
│                        BACKEND                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              equipos/models.py                        │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │  InformacionMetrologica                              │  │
│  │  ├─ proximo_mantenimiento (DateField)                │  │
│  │  ├─ fecha_proximo_mantenimiento_calculada (property) │  │
│  │  └─ estado_mantenimiento (property)                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        historial_mantenimientos/models.py             │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │  HistorialMantenimiento                              │  │
│  │  ├─ tipo_mantenimiento                               │  │
│  │  ├─ mes_mantenimiento                                │  │
│  │  ├─ anio_mantenimiento                               │  │
│  │  ├─ realizado_por                                    │  │
│  │  └─ costo                                            │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Stack Tecnológico

**Frontend:**
- Vue 3 (Composition API)
- Vite
- Axios (HTTP client)

**Backend:**
- Django 4.x
- Django REST Framework
- PostgreSQL/SQLite

---

## 3. Lógica de Negocio

### 3.1 Cálculo de Estado de Mantenimiento

El estado de mantenimiento se calcula en el backend mediante la propiedad `estado_mantenimiento` del modelo `InformacionMetrologica`.

**Archivo:** `backend/equipos/models.py`

```python
@property
def estado_mantenimiento(self):
    """
    Determina el estado del mantenimiento: 'Vencido', 'Próximo', 'Normal', 'No Requiere'
    - Vencido: Fecha anterior a hoy O en el mes/año actual
    - Próximo: Dentro de los próximos 3 meses (pero no en el mes actual)
    - Normal: Más de 3 meses en el futuro
    """
    if not self.requiere_mantenimiento:
        return "No Requiere"
        
    fecha_proxima = self.fecha_proximo_mantenimiento_calculada
    if not fecha_proxima:
        return "No Programado"
        
    from datetime import date
    from dateutil.relativedelta import relativedelta
    
    hoy = date.today()
    fin_mes_actual = date(hoy.year, hoy.month, 1) + relativedelta(months=1) - relativedelta(days=1)
    limite_proximo = hoy + relativedelta(months=3)
    
    # Si la fecha es anterior a hoy O está en el mes/año actual, es Vencido
    if fecha_proxima < hoy or (fecha_proxima.year == hoy.year and fecha_proxima.month == hoy.month):
        return "Vencido"
    elif fecha_proxima <= limite_proximo:
        return "Próximo"
    else:
        return "Normal"
```

**Reglas de Clasificación:**

| Condición                                             | Estado  | Aparece en           |
| ----------------------------------------------------- | ------- | -------------------- |
| `fecha < hoy`                                         | Vencido | Realizar Revisión    |
| `fecha.mes == mes_actual AND fecha.año == año_actual` | Vencido | Realizar Revisión    |
| `hoy < fecha <= hoy + 3 meses`                        | Próximo | Próximos de Revisión |
| `fecha > hoy + 3 meses`                               | Normal  | -                    |

### 3.2 Cálculo de Fecha Próximo Mantenimiento

La fecha del próximo mantenimiento se calcula automáticamente basándose en:
1. **Último mantenimiento realizado**
2. **Frecuencia de mantenimiento** configurada para el equipo

**Archivo:** `backend/equipos/models.py`

```python
@property
def fecha_proximo_mantenimiento_calculada(self):
    """
    Calcula la fecha del próximo mantenimiento basándose en:
    - ultimo_mantenimiento
    - frecuencia_mantenimiento
    - proximo_mantenimiento (si fue reprogramado manualmente)
    """
    # Si fue reprogramado manualmente, usar esa fecha
    if self.proximo_mantenimiento:
        return self.proximo_mantenimiento
    
    # Si no hay último mantenimiento, no se puede calcular
    if not self.ultimo_mantenimiento:
        return None
    
    from dateutil.relativedelta import relativedelta
    fecha_base = self.ultimo_mantenimiento
    
    # Calcular según frecuencia
    if self.frecuencia_mantenimiento == 'Mensual':
        return fecha_base + relativedelta(months=1)
    elif self.frecuencia_mantenimiento == 'Bimestral':
        return fecha_base + relativedelta(months=2)
    elif self.frecuencia_mantenimiento == 'Trimestral':
        return fecha_base + relativedelta(months=3)
    elif self.frecuencia_mantenimiento == 'Cuatrimestral':
        return fecha_base + relativedelta(months=4)
    elif self.frecuencia_mantenimiento == 'Semestral':
        return fecha_base + relativedelta(months=6)
    else:
        # Por defecto anual
        return fecha_base + relativedelta(years=1)
```

### 3.3 Flujo de Actualización Automática

Cuando se completa un mantenimiento:

```
1. Usuario completa mantenimiento
   ↓
2. Se crea registro en HistorialMantenimiento
   ↓
3. Se actualiza ultimo_mantenimiento del equipo
   ↓
4. Se recalcula fecha_proximo_mantenimiento_calculada
   ↓
5. Se recalcula estado_mantenimiento
   ↓
6. Frontend recarga datos y muestra nuevo estado
```

---

## 4. Componentes Frontend

### 4.1 EquiposVencidos.vue

**Propósito:** Mostrar equipos que requieren atención inmediata.

**Ubicación:** `frontend/src/components/EquiposVencidos.vue`

**Características:**
- Muestra equipos con `estado_mantenimiento === 'Vencido'`
- Incluye equipos del mes actual
- Permite completar mantenimiento
- Permite reprogramar mantenimiento
- Búsqueda por código, nombre, marca, modelo, sede, ubicación
- Paginación configurable (5, 10, 20, 50 registros)

**Estructura de Datos:**

```javascript
const equiposVencidos = computed(() => {
  let filtered = equipos.value.filter(eq => 
    eq.informacion_metrologica?.estado_mantenimiento === 'Vencido'
  )
  
  filtered = filterEquiposBySearch(filtered, searchQuery.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})
```

**Columnas de la Tabla:**
- Código (8%)
- Equipo (14%)
- Registro INVIMA (16%)
- Riesgo (8%, centrado)
- Sede / Ubicación (15%)
- Último Mant. (10%)
- Próximo Mant. (10%)
- Acciones (21%, centrado)

### 4.2 EquiposProximos.vue

**Propósito:** Mostrar equipos que requerirán mantenimiento en los próximos meses.

**Ubicación:** `frontend/src/components/EquiposProximos.vue`

**Características:**
- Filtro de rango de meses (3, 6, 12 meses)
- Excluye equipos del mes actual (van a "Realizar Revisión")
- Excluye equipos vencidos
- Permite reprogramar mantenimiento
- Búsqueda y paginación

**Lógica de Filtrado:**

```javascript
const equiposProximos = computed(() => {
  let filtered = equipos.value.filter(eq => {
    if (!eq.informacion_metrologica?.requiere_mantenimiento) return false
    
    const fechaProxima = eq.informacion_metrologica?.fecha_proximo_mantenimiento_calculada
    if (!fechaProxima) return false
    
    // Parse the date
    const [year, month, day] = fechaProxima.split('T')[0].split('-').map(Number)
    const fechaDate = new Date(year, month - 1, day)
    const hoy = new Date()
    hoy.setHours(0, 0, 0, 0)
    
    // Exclude current month (should appear in "Realizar Revisión")
    if (fechaDate.getFullYear() === hoy.getFullYear() && fechaDate.getMonth() === hoy.getMonth()) {
      return false
    }
    
    // Exclude overdue dates
    if (fechaDate < hoy) return false
    
    // Check if within selected months range
    const limite = new Date(hoy)
    limite.setMonth(limite.getMonth() + monthsFilter.value)
    
    return fechaDate <= limite
  })
  
  filtered = filterEquiposBySearch(filtered, searchQuery.value)
  
  return filtered.sort((a, b) => {
    const fechaA = new Date(a.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    const fechaB = new Date(b.informacion_metrologica?.fecha_proximo_mantenimiento_calculada || 0)
    return fechaA - fechaB
  })
})
```

### 4.3 ModalCompletarMantenimiento.vue

**Propósito:** Registrar la finalización de un mantenimiento.

**Ubicación:** `frontend/src/components/modals/mantenimientos/ModalCompletarMantenimiento.vue`

**Campos del Formulario:**
- **Tipo de Mantenimiento** (requerido): Preventivo, Correctivo, Calibración
- **Fecha de Mantenimiento** (requerido): Fecha en que se realizó
- **Realizado Por** (requerido): Nombre del técnico o empresa
- **Costo** (opcional): Costo del mantenimiento
- **Descripción** (requerido): Descripción del trabajo realizado
- **Observaciones** (opcional): Notas adicionales
- **Usuario Registro** (requerido): Usuario que registra el mantenimiento

**Validación:**

```javascript
function confirmarCompletado() {
  // Validación usando composable
  const validationError = validateMantenimientoForm(form.value)
  if (validationError) {
    showError(validationError)
    return
  }

  // Preparar datos usando composable
  const data = prepareMantenimientoData(form.value, props.equipo.id)
  
  emit('submit', data)
}
```

**Flujo de Datos:**

```
1. Usuario abre modal desde EquiposVencidos
   ↓
2. Modal se llena con datos del equipo
   ↓
3. Usuario completa formulario
   ↓
4. Se valida formulario (useMantenimiento)
   ↓
5. Se preparan datos para backend
   ↓
6. Se envía POST a /api/mantenimientos/
   ↓
7. Backend crea registro y actualiza equipo
   ↓
8. Frontend recarga lista de equipos
   ↓
9. Se muestra notificación de éxito
```

### 4.4 ModalReprogramarMantenimiento.vue

**Propósito:** Cambiar la fecha programada del próximo mantenimiento.

**Ubicación:** `frontend/src/components/modals/mantenimientos/ModalReprogramarMantenimiento.vue`

**Características:**
- Selector visual de mes y año
- Deshabilita meses pasados
- Marca el mes actual
- Permite seleccionar mes actual (se guarda como último día del mes)
- Validación de fecha futura

**Lógica de Selección de Fecha:**

```javascript
function confirmarReprogramacion() {
  if (!selectedDate.value) return
  
  // Format as YYYY-MM-DD
  const year = selectedDate.value.getFullYear()
  const monthIndex = selectedDate.value.getMonth()
  const month = String(monthIndex + 1).padStart(2, '0')
  
  // Set to last day of the month to avoid "Vencido" status if current month is selected
  const lastDay = new Date(year, monthIndex + 1, 0).getDate()
  const day = String(lastDay).padStart(2, '0')
  
  const fechaFormateada = `${year}-${month}-${day}`
  
  emit('submit', {
    equipoId: props.equipo.id,
    nuevaFecha: fechaFormateada
  })
}
```

**Validación Backend:**

```python
@api_view(['POST'])
def reprogramar_mantenimiento(request, pk):
    # ...
    nueva_fecha = datetime.strptime(nueva_fecha_str, '%Y-%m-%d').date()
    
    # Validar que la fecha sea futura o hoy
    if nueva_fecha < datetime.now().date():
        return Response({'error': 'La nueva fecha debe ser posterior o igual a hoy'}, 
                       status=status.HTTP_400_BAD_REQUEST)
    
    equipo.informacion_metrologica.proximo_mantenimiento = nueva_fecha
    equipo.informacion_metrologica.save()
    # ...
```

---

## 5. Backend y API

### 5.1 Modelos de Datos

#### InformacionMetrologica

**Archivo:** `backend/equipos/models.py`

```python
class InformacionMetrologica(models.Model):
    equipo = models.OneToOneField(Equipo, on_delete=models.CASCADE, 
                                  related_name='informacion_metrologica')
    requiere_mantenimiento = models.BooleanField(default=False)
    frecuencia_mantenimiento = models.CharField(max_length=50, blank=True, null=True)
    ultimo_mantenimiento = models.DateField(blank=True, null=True)
    proximo_mantenimiento = models.DateField(blank=True, null=True)
    
    @property
    def fecha_proximo_mantenimiento_calculada(self):
        # ... (ver sección 3.2)
    
    @property
    def estado_mantenimiento(self):
        # ... (ver sección 3.1)
```

#### HistorialMantenimiento

**Archivo:** `backend/historial_mantenimientos/models.py`

```python
class HistorialMantenimiento(models.Model):
    TIPO_MANTENIMIENTO = [
        ('Preventivo', 'Preventivo'),
        ('Correctivo', 'Correctivo'),
        ('Calibración', 'Calibración'),
    ]
    
    equipo = models.ForeignKey(Equipo, on_delete=models.CASCADE, 
                               related_name='historial_mantenimientos')
    tipo_mantenimiento = models.CharField(max_length=50, choices=TIPO_MANTENIMIENTO)
    mes_mantenimiento = models.IntegerField()
    anio_mantenimiento = models.IntegerField()
    descripcion = models.TextField()
    realizado_por = models.CharField(max_length=200)
    costo = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    usuario_registro = models.CharField(max_length=100)
    observaciones = models.TextField(blank=True, null=True)
    fecha_registro = models.DateTimeField(auto_now_add=True)
    
    @property
    def fecha_display(self):
        meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
        return f"{meses[self.mes_mantenimiento - 1]} {self.anio_mantenimiento}"
```

### 5.2 Endpoints de API

#### GET /api/equipos/

**Descripción:** Obtiene todos los equipos con información de mantenimiento.

**Respuesta:**
```json
[
  {
    "id": 1,
    "codigo_interno": "LIME360",
    "nombre_equipo": "Microcentrífuga refrigerada",
    "marca": "HERMLE",
    "modelo": "Z 216 MK",
    "estado": "Activo",
    "informacion_metrologica": {
      "requiere_mantenimiento": true,
      "frecuencia_mantenimiento": "Semestral",
      "ultimo_mantenimiento": "2025-10-15",
      "proximo_mantenimiento": null,
      "fecha_proximo_mantenimiento_calculada": "2025-12-15",
      "estado_mantenimiento": "Vencido"
    },
    "sede": {
      "id": 1,
      "nombre": "SIU"
    },
    "ubicacion": {
      "id": 5,
      "nombre": "Prado"
    }
  }
]
```

#### POST /api/mantenimientos/

**Descripción:** Crea un nuevo registro de mantenimiento.

**Request Body:**
```json
{
  "equipo_id": 1,
  "tipo_mantenimiento": "Preventivo",
  "mes_mantenimiento": 12,
  "anio_mantenimiento": 2025,
  "descripcion": "Mantenimiento preventivo semestral",
  "realizado_por": "Técnico Juan Pérez",
  "costo": 150000,
  "usuario_registro": "admin",
  "observaciones": "Todo en orden"
}
```

**Lógica Backend:**
```python
def post(self, request):
    serializer = HistorialMantenimientoSerializer(data=request.data)
    if serializer.is_valid():
        mantenimiento = serializer.save()
        
        # Actualizar último mantenimiento del equipo
        equipo = mantenimiento.equipo
        fecha_mantenimiento = date(mantenimiento.anio_mantenimiento, 
                                   mantenimiento.mes_mantenimiento, 1)
        
        if hasattr(equipo, 'informacion_metrologica'):
            info = equipo.informacion_metrologica
            info.ultimo_mantenimiento = fecha_mantenimiento
            
            # Recalcular próximo mantenimiento basado en frecuencia
            if info.frecuencia_mantenimiento:
                # ... cálculo automático
                info.proximo_mantenimiento = None  # Forzar recálculo
            
            info.save()
        
        return Response(serializer.data, status=status.HTTP_201_CREATED)
```

#### POST /api/equipos/{id}/reprogramar/

**Descripción:** Reprograma la fecha del próximo mantenimiento.

**Request Body:**
```json
{
  "nueva_fecha": "2026-01-31"
}
```

**Validaciones:**
- Fecha debe estar en formato YYYY-MM-DD
- Fecha debe ser posterior o igual a hoy
- Equipo debe tener información metrológica

**Respuesta:**
```json
{
  "message": "Mantenimiento reprogramado exitosamente",
  "nueva_fecha": "2026-01-31"
}
```

---

## 6. Flujos de Usuario

### 6.1 Completar Mantenimiento

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Usuario navega a "Realizar Revisión"                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 2. Sistema muestra equipos con estado "Vencido"             │
│    - Incluye equipos del mes actual                         │
│    - Ordenados por fecha (más urgente primero)              │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 3. Usuario hace clic en "Completar" para un equipo          │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 4. Se abre ModalCompletarMantenimiento                       │
│    - Muestra datos del equipo                               │
│    - Formulario vacío listo para llenar                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 5. Usuario completa formulario:                             │
│    - Tipo de mantenimiento                                  │
│    - Fecha de realización                                   │
│    - Realizado por                                          │
│    - Costo (opcional)                                       │
│    - Descripción                                            │
│    - Observaciones (opcional)                               │
│    - Usuario registro                                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 6. Usuario hace clic en "Completar Mantenimiento"           │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 7. Frontend valida formulario (useMantenimiento)            │
│    - Campos requeridos completos                            │
│    - Formatos correctos                                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 8. Frontend envía POST a /api/mantenimientos/                │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 9. Backend procesa:                                          │
│    a) Crea registro en HistorialMantenimiento               │
│    b) Actualiza ultimo_mantenimiento del equipo             │
│    c) Recalcula fecha_proximo_mantenimiento_calculada       │
│    d) Recalcula estado_mantenimiento                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 10. Frontend recibe respuesta exitosa                       │
│     - Cierra modal                                          │
│     - Recarga lista de equipos                              │
│     - Muestra notificación de éxito                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 11. Equipo desaparece de "Realizar Revisión"                │
│     (si el nuevo estado no es "Vencido")                    │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Reprogramar Mantenimiento

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Usuario navega a "Realizar Revisión" o                   │
│    "Próximos de Revisión"                                   │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 2. Usuario hace clic en "Reprogramar" para un equipo        │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 3. Se abre ModalReprogramarMantenimiento                     │
│    - Muestra datos del equipo                               │
│    - Muestra fecha actual programada                        │
│    - Selector de mes/año                                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 4. Sistema deshabilita meses pasados                         │
│    - Meses anteriores al actual: deshabilitados             │
│    - Mes actual: habilitado (se guarda como último día)     │
│    - Meses futuros: habilitados                             │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 5. Usuario selecciona nuevo mes y año                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 6. Usuario hace clic en "Reprogramar"                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 7. Frontend formatea fecha:                                 │
│    - Si es mes actual: último día del mes                   │
│    - Si es mes futuro: último día del mes                   │
│    - Formato: YYYY-MM-DD                                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 8. Frontend envía POST a /api/equipos/{id}/reprogramar/     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 9. Backend valida:                                           │
│    - Fecha en formato correcto                              │
│    - Fecha >= hoy                                           │
│    - Equipo existe y tiene info metrológica                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 10. Backend actualiza:                                       │
│     - proximo_mantenimiento = nueva_fecha                   │
│     - estado_mantenimiento se recalcula automáticamente     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 11. Frontend recibe respuesta exitosa                       │
│     - Cierra modal                                          │
│     - Recarga lista de equipos                              │
│     - Muestra notificación de éxito                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│ 12. Equipo se mueve a la categoría correspondiente          │
│     según su nuevo estado_mantenimiento                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Composables y Utilidades

### 7.1 useMantenimiento.js

**Ubicación:** `frontend/src/composables/useMantenimiento.js`

**Propósito:** Centralizar lógica relacionada con mantenimientos.

**Funciones Principales:**

```javascript
// Obtener opciones de tipo de mantenimiento
function getTipoMantenimientoOptions() {
  return TIPOS_MANTENIMIENTO
}

// Obtener label de tipo
function getTipoLabel(tipo) {
  const option = TIPOS_MANTENIMIENTO.find(t => t.value === tipo)
  return option ? option.label : tipo
}

// Obtener clase CSS para badge de tipo
function getTipoBadgeClass(tipo) {
  const classes = {
    'Preventivo': 'tipo-preventivo',
    'Correctivo': 'tipo-correctivo',
    'Calibración': 'tipo-calibracion'
  }
  return classes[tipo] || 'tipo-default'
}

// Validar formulario de mantenimiento
function validateMantenimientoForm(form) {
  if (!form.tipo_mantenimiento) return 'Debe seleccionar un tipo de mantenimiento'
  if (!form.fecha_mantenimiento) return 'Debe ingresar la fecha del mantenimiento'
  if (!form.realizado_por) return 'Debe ingresar quién realizó el mantenimiento'
  if (!form.descripcion) return 'Debe ingresar una descripción'
  if (!form.usuario_registro) return 'Debe ingresar el usuario que registra'
  return null
}

// Preparar datos para enviar al backend
function prepareMantenimientoData(form, equipoId) {
  const { mes, anio } = splitDateToMonthYear(form.fecha_mantenimiento)
  
  return {
    equipo_id: equipoId,
    tipo_mantenimiento: form.tipo_mantenimiento,
    mes_mantenimiento: mes,
    anio_mantenimiento: anio,
    descripcion: form.descripcion,
    realizado_por: form.realizado_por,
    costo: form.costo || 0,
    usuario_registro: form.usuario_registro,
    observaciones: form.observaciones || ''
  }
}
```

### 7.2 useDateCalculations.js

**Ubicación:** `frontend/src/composables/useDateCalculations.js`

**Propósito:** Funciones para cálculos y validaciones de fechas.

**Funciones Principales:**

```javascript
// Verificar si una fecha está vencida
function isDateOverdue(fecha) {
  if (!fecha) return false
  const fechaObj = new Date(fecha)
  if (isNaN(fechaObj.getTime())) return false

  const hoy = new Date()
  hoy.setHours(0, 0, 0, 0)
  fechaObj.setHours(0, 0, 0, 0)

  return fechaObj < hoy
}

// Verificar si una fecha está próxima a vencer
function isDateUpcoming(fecha, monthsAhead = 3) {
  if (!fecha) return false
  const fechaObj = new Date(fecha)
  if (isNaN(fechaObj.getTime())) return false

  const hoy = new Date()
  hoy.setHours(0, 0, 0, 0)
  fechaObj.setHours(0, 0, 0, 0)

  const limite = new Date(hoy)
  limite.setMonth(limite.getMonth() + monthsAhead)

  return fechaObj >= hoy && fechaObj <= limite
}

// Dividir fecha ISO en mes y año
function splitDateToMonthYear(fechaISO) {
  const [anio, mes] = fechaISO.split('-')
  return {
    mes: parseInt(mes),
    anio: parseInt(anio)
  }
}

// Verificar si un mes está deshabilitado
function isMonthDisabled(monthIndex, year) {
  const hoy = new Date()
  const currentYear = hoy.getFullYear()
  const currentMonth = hoy.getMonth()

  if (year > currentYear) return false
  if (year < currentYear) return true

  return monthIndex < currentMonth
}

// Verificar si es el mes actual
function isCurrentMonth(monthIndex, year) {
  const hoy = new Date()
  return year === hoy.getFullYear() && monthIndex === hoy.getMonth()
}
```

### 7.3 useFormatting.js

**Ubicación:** `frontend/src/composables/useFormatting.js`

**Propósito:** Formateo consistente de datos para visualización.

**Funciones Principales:**

```javascript
// Formatear fecha evitando problemas de zona horaria
function formatFecha(fecha) {
  if (!fecha) return 'N/A'
  
  // Parsear la fecha manualmente para evitar problemas de zona horaria
  const [year, month, day] = fecha.split('T')[0].split('-').map(Number)
  
  const meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ]
  
  // month viene como 1-12, necesitamos índice 0-11
  return `${meses[month - 1]} ${year}`
}

// Formatear costo
function formatCosto(costo) {
  if (!costo) return '$0'
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: 'COP',
    minimumFractionDigits: 0
  }).format(costo)
}

// Obtener clase CSS para badge de estado de mantenimiento
function getMantenimientoBadgeClass(estado) {
  const classes = {
    'Vencido': 'estado-vencido',
    'Próximo': 'estado-proximo',
    'Normal': 'estado-normal',
    'No Requiere': 'estado-no-requiere',
    'No Programado': 'estado-no-programado'
  }
  return classes[estado] || 'estado-default'
}
```

### 7.4 useNotifications.js

**Ubicación:** `frontend/src/composables/useNotifications.js`

**Propósito:** Sistema de notificaciones toast para feedback al usuario.

**Funciones Principales:**

```javascript
function showNotification(message, type = 'info', duration = 3000) {
  const id = ++notificationId
  const notification = {
    id,
    message,
    type, // 'success', 'error', 'warning', 'info'
    visible: true
  }

  notifications.value.push(notification)

  if (duration > 0) {
    setTimeout(() => {
      removeNotification(id)
    }, duration)
  }

  return id
}

function success(message, duration = 3000) {
  return showNotification(message, 'success', duration)
}

function error(message, duration = 5000) {
  return showNotification(message, 'error', duration)
}
```

---

## 8. Constantes y Configuración

### 8.1 mantenimiento.js

**Ubicación:** `frontend/src/constants/mantenimiento.js`

```javascript
export const TIPOS_MANTENIMIENTO = [
  { value: 'Preventivo', label: 'Preventivo' },
  { value: 'Correctivo', label: 'Correctivo' },
  { value: 'Calibración', label: 'Calibración' }
]

export const MESES_NOMBRES = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

export const MESES_NOMBRES_CORTOS = [
  'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
  'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
]

export const ESTADOS_MANTENIMIENTO = [
  { value: 'Vencido', label: 'Vencido', color: '#f44336' },
  { value: 'Próximo', label: 'Próximo', color: '#ff9800' },
  { value: 'Normal', label: 'Normal', color: '#4caf50' },
  { value: 'No Requiere', label: 'No Requiere', color: '#9e9e9e' }
]

export const OPCIONES_FILTRO_MESES = [
  { value: 3, label: 'Próximos 3 meses' },
  { value: 6, label: 'Próximos 6 meses' },
  { value: 12, label: 'Próximos 12 meses' }
]
```

---

## 9. Casos de Uso

### Caso de Uso 1: Mantenimiento Preventivo Regular

**Escenario:** Un equipo requiere mantenimiento preventivo semestral.

**Datos Iniciales:**
- Equipo: Microcentrífuga LIME360
- Frecuencia: Semestral
- Último mantenimiento: 15 de Junio 2025
- Fecha calculada próximo: 15 de Diciembre 2025
- Fecha actual: 1 de Diciembre 2025

**Flujo:**
1. Sistema calcula que el próximo mantenimiento es el 15 de Diciembre 2025
2. Como estamos en Diciembre, `estado_mantenimiento` = "Vencido"
3. Equipo aparece en "Realizar Revisión"
4. Técnico realiza mantenimiento el 10 de Diciembre 2025
5. Usuario registra mantenimiento completado
6. Sistema actualiza:
   - `ultimo_mantenimiento` = 10 de Diciembre 2025
   - `fecha_proximo_mantenimiento_calculada` = 10 de Junio 2026
   - `estado_mantenimiento` = "Próximo" (dentro de 6 meses)
7. Equipo desaparece de "Realizar Revisión"
8. Equipo aparece en "Próximos de Revisión"

### Caso de Uso 2: Reprogramación por Indisponibilidad

**Escenario:** Un equipo necesita mantenimiento pero el técnico no está disponible.

**Datos Iniciales:**
- Equipo: Refrigerador FAGOR
- Próximo mantenimiento: Noviembre 2025
- Fecha actual: 1 de Diciembre 2025
- Estado: Vencido

**Flujo:**
1. Equipo aparece en "Realizar Revisión" (Noviembre ya pasó)
2. Usuario hace clic en "Reprogramar"
3. Usuario selecciona Enero 2026
4. Sistema guarda fecha como 31 de Enero 2026
5. Sistema recalcula:
   - `proximo_mantenimiento` = 31 de Enero 2026
   - `estado_mantenimiento` = "Próximo" (dentro de 2 meses)
6. Equipo desaparece de "Realizar Revisión"
7. Equipo aparece en "Próximos de Revisión"

### Caso de Uso 3: Mantenimiento Correctivo No Programado

**Escenario:** Un equipo falla y requiere mantenimiento correctivo inmediato.

**Datos Iniciales:**
- Equipo: Cualquier equipo activo
- Próximo mantenimiento: Marzo 2026
- Estado: Normal

**Flujo:**
1. Equipo NO aparece en "Realizar Revisión" ni "Próximos de Revisión"
2. Usuario navega a "Historial de Mantenimientos"
3. Usuario hace clic en "Crear Mantenimiento"
4. Usuario busca y selecciona el equipo
5. Usuario completa formulario:
   - Tipo: Correctivo
   - Fecha: 1 de Diciembre 2025
   - Descripción: "Falla en motor, reemplazo de componente"
6. Sistema crea registro en historial
7. Sistema actualiza `ultimo_mantenimiento` = 1 de Diciembre 2025
8. Sistema NO modifica `proximo_mantenimiento` (sigue siendo Marzo 2026)
9. Estado permanece como "Normal"

---

## 10. Troubleshooting

### Problema 1: Equipos del Mes Actual No Aparecen en "Realizar Revisión"

**Síntoma:** Un equipo con mantenimiento programado para el mes actual aparece en "Próximos de Revisión" en lugar de "Realizar Revisión".

**Causa:** La lógica de `estado_mantenimiento` en el backend no está considerando el mes actual como "Vencido".

**Solución:**
Verificar que la lógica en `backend/equipos/models.py` incluya:
```python
if fecha_proxima < hoy or (fecha_proxima.year == hoy.year and fecha_proxima.month == hoy.month):
    return "Vencido"
```

### Problema 2: Fechas se Muestran con un Mes Incorrecto

**Síntoma:** Una fecha guardada como "2025-01-15" se muestra como "Diciembre 2024".

**Causa:** Problema de zona horaria al parsear fechas con `new Date()`.

**Solución:**
Usar el método de parseo manual en `useFormatting.js`:
```javascript
function formatFecha(fecha) {
  const [year, month, day] = fecha.split('T')[0].split('-').map(Number)
  const meses = ['Enero', 'Febrero', ...] 
  return `${meses[month - 1]} ${year}`
}
```

### Problema 3: Filtro de Meses No Funciona

**Síntoma:** Cambiar el filtro de "Próximos 3 meses" a "Próximos 6 meses" no actualiza la lista.

**Causa:** El componente no está reactivo al cambio de `monthsFilter`.

**Solución:**
Asegurar que `monthsFilter` sea una `ref` y que el computed `equiposProximos` lo use:
```javascript
const monthsFilter = ref(3)

const equiposProximos = computed(() => {
  // ... usar monthsFilter.value en el filtrado
})
```

### Problema 4: Equipos Duplicados en Ambas Vistas

**Síntoma:** Un equipo aparece tanto en "Realizar Revisión" como en "Próximos de Revisión".

**Causa:** La lógica de filtrado en `EquiposProximos.vue` no excluye correctamente el mes actual.

**Solución:**
Agregar exclusión explícita del mes actual:
```javascript
if (fechaDate.getFullYear() === hoy.getFullYear() && 
    fechaDate.getMonth() === hoy.getMonth()) {
  return false
}
```

### Problema 5: No Se Puede Reprogramar para el Mes Actual

**Síntoma:** Al intentar reprogramar para el mes actual, el backend rechaza la fecha.

**Causa:** La validación del backend es muy estricta (`fecha <= hoy`).

**Solución:**
Relajar la validación en `backend/equipos/views.py`:
```python
if nueva_fecha < datetime.now().date():  # Cambiar <= por <
    return Response({'error': 'La nueva fecha debe ser posterior o igual a hoy'})
```

Y en el frontend, enviar el último día del mes:
```javascript
const lastDay = new Date(year, monthIndex + 1, 0).getDate()
const day = String(lastDay).padStart(2, '0')
```

### Problema 6: Notificaciones No Aparecen

**Síntoma:** Al completar o reprogramar, no se muestra ninguna notificación.

**Causa:** El componente de notificaciones no está importado o no está en el template.

**Solución:**
1. Importar `useNotifications` en el componente
2. Usar `success()` y `error()` en lugar de `alert()`
3. Asegurar que el componente de notificaciones esté en `App.vue`

---

## Apéndice A: Glosario

- **Estado de Mantenimiento**: Clasificación automática del equipo según su fecha de próximo mantenimiento
- **Vencido**: Equipo que requiere atención inmediata (fecha pasada o mes actual)
- **Próximo**: Equipo que requerirá mantenimiento en los próximos 3 meses
- **Frecuencia de Mantenimiento**: Intervalo entre mantenimientos (Mensual, Semestral, Anual, etc.)
- **Reprogramar**: Cambiar la fecha del próximo mantenimiento sin crear un registro de historial
- **Completar**: Registrar que se realizó un mantenimiento, creando un registro en el historial

## Apéndice B: Estructura de Archivos

```
proyecto-lime/
├── backend/
│   ├── equipos/
│   │   ├── models.py              # InformacionMetrologica, estado_mantenimiento
│   │   ├── views.py               # reprogramar_mantenimiento endpoint
│   │   └── serializers.py
│   └── historial_mantenimientos/
│       ├── models.py              # HistorialMantenimiento
│       ├── views.py               # crear mantenimiento endpoint
│       └── serializers.py
│
└── frontend/
    ├── src/
    │   ├── components/
    │   │   ├── EquiposVencidos.vue
    │   │   ├── EquiposProximos.vue
    │   │   └── modals/
    │   │       └── mantenimientos/
    │   │           ├── ModalCompletarMantenimiento.vue
    │   │           └── ModalReprogramarMantenimiento.vue
    │   ├── composables/
    │   │   ├── useMantenimiento.js
    │   │   ├── useDateCalculations.js
    │   │   ├── useFormatting.js
    │   │   └── useNotifications.js
    │   ├── constants/
    │   │   └── mantenimiento.js
    │   └── services/
    │       └── api.js
    └── ...
```

---

**Última actualización:** Diciembre 2025  
**Versión:** 1.0  
**Autor:** Sistema LIME - Gestión de Equipos Biomédicos
