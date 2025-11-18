# Diagramas y Flujos - API Colombia App

## Tabla de Contenido
1. [Arquitectura General](#arquitectura-general)
2. [Flujo de Datos](#flujo-de-datos)
3. [Navegacion](#navegacion)
4. [Ciclo de Vida de una Vista](#ciclo-de-vida-de-una-vista)

---

## Arquitectura General

```
┌─────────────────────────────────────────────────────────────┐
│                      APLICACION FLUTTER                      │
│                   API COLOMBIA CONSUMER                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐      ┌──────────────┐     ┌──────────────┐
│   MODELS     │      │   SERVICES   │     │    VIEWS     │
│ (Datos)      │◄────►│   (API)      │────►│    (UI)      │
└──────────────┘      └──────────────┘     └──────────────┘
        │                     │                     │
        │                     │                     ▼
        │                     │             ┌──────────────┐
        │                     │             │   WIDGETS    │
        │                     │             │ (Componentes)│
        │                     │             └──────────────┘
        │                     │                     │
        └─────────────────────┴─────────────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │    ROUTES    │
                      │ (Navegacion) │
                      └──────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │    THEMES    │
                      │  (Estilos)   │
                      └──────────────┘
```

---

## Flujo de Datos

### De API a UI

```
API COLOMBIA
https://api-colombia.com
        │
        │ HTTP GET
        │
        ▼
┌──────────────────┐
│   SERVICES       │
│ - DepartmentSvc  │  ← Lee URL desde .env
│ - PresidentSvc   │  ← Hace peticion HTTP
│ - AttractionSvc  │  ← Valida statusCode
│ - AirportSvc     │  ← Decodifica JSON
└──────────────────┘
        │
        │ JSON String
        │
        ▼
┌──────────────────┐
│   MODELS         │
│ - Department     │  ← fromJson()
│ - President      │  ← Convierte JSON a Object
│ - Attraction     │  ← Valida tipos
│ - Airport        │  ← Retorna instancia
└──────────────────┘
        │
        │ List<Model>
        │
        ▼
┌──────────────────┐
│   VIEWS          │
│ - ListView       │  ← setState()
│ - DetailView     │  ← Actualiza UI
│                  │  ← Renderiza datos
└──────────────────┘
        │
        │ Widgets
        │
        ▼
┌──────────────────┐
│   SCREEN         │
│  [Pantalla       │
│   del usuario]   │
└──────────────────┘
```

### Flujo de Estados

```
INICIO DE VISTA
      │
      ▼
┌─────────────┐
│ initState() │
└─────────────┘
      │
      ▼
┌──────────────────────────┐
│ _loadData()              │
│ setState(() {            │
│   _isLoading = true;     │
│ })                       │
└──────────────────────────┘
      │
      ▼
┌──────────────────────────┐
│ service.getData()        │
│ (Peticion HTTP)          │
└──────────────────────────┘
      │
      ├─────────┬──────────┐
      │         │          │
      ▼         ▼          ▼
   SUCCESS   ERROR     EMPTY
      │         │          │
      ▼         ▼          ▼
┌─────────┐ ┌──────┐ ┌────────┐
│setState │ │set   │ │set     │
│data=[]  │ │Error │ │data=[] │
│loading  │ │      │ │        │
│=false   │ │      │ │        │
└─────────┘ └──────┘ └────────┘
      │         │          │
      ▼         ▼          ▼
┌─────────┐ ┌──────┐ ┌────────┐
│ListView │ │Error │ │Empty   │
│         │ │Widget│ │Widget  │
└─────────┘ └──────┘ └────────┘
```

---

## Navegacion

### Mapa de Rutas

```
                    ┌────────────────┐
                    │   DASHBOARD    │
                    │       (/)      │
                    └────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ DEPARTMENTS  │    │  PRESIDENTS  │    │  ATTRACTIONS │
│ /departments │    │ /presidents  │    │ /attractions │
└──────────────┘    └──────────────┘    └──────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ DETAIL       │    │  DETAIL      │    │  DETAIL      │
│ /depart./:id │    │ /presid./:id │    │ /attract./:id│
└──────────────┘    └──────────────┘    └──────────────┘

        │
        ▼
┌──────────────┐
│  AIRPORTS    │
│  /airports   │
└──────────────┘
        │
        ▼
┌──────────────┐
│  DETAIL      │
│ /airport/:id │
└──────────────┘
```

### Stack de Navegacion

```
Navegacion con context.push():

PUSH                          POP
────►                         ◄────

Dashboard                     Dashboard
    ↓ push                        ↑ pop
DepartmentList               DepartmentList
    ↓ push                        ↑ pop
DepartmentDetail             DepartmentDetail

Stack:
[Dashboard, DepartmentList, DepartmentDetail]
                             └─ Actual
```

---

## Ciclo de Vida de una Vista

### Ejemplo: DepartmentsListView

```
1. CREACION
   │
   ▼
   createState()
   │
   ▼
   initState()
   │
   ├─> _loadDepartments()
   │   │
   │   ├─> setState(_isLoading = true)
   │   │   │
   │   │   ▼
   │   │   build() → Muestra LoadingWidget
   │   │
   │   ├─> DepartmentService.getAllDepartments()
   │   │   │
   │   │   ▼
   │   │   HTTP GET a API
   │   │   │
   │   │   ▼
   │   │   [SUCCESS] o [ERROR]
   │   │
   │   └─> setState(_departments = data, _isLoading = false)
   │       │
   │       ▼
   │       build() → Muestra ListView
   │
   ▼
   build()
   │
   └─> Renderiza UI segun estado


2. INTERACCION USUARIO
   │
   ▼
   Usuario toca "Pull to Refresh"
   │
   ▼
   onRefresh callback
   │
   ▼
   _loadDepartments() (repite ciclo)


3. NAVEGACION
   │
   ▼
   Usuario toca un departamento
   │
   ▼
   onTap callback
   │
   ▼
   context.push('/departments/:id', extra: department)
   │
   ▼
   DepartmentDetailView se crea


4. DESTRUCCION
   │
   ▼
   Usuario sale de la vista
   │
   ▼
   dispose()
   │
   ▼
   Limpieza de recursos
```

---

## Flujo HTTP Request Detallado

```
┌─────────────────────────────────────────────────────────┐
│                   DEPARTMENT SERVICE                     │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
          ┌────────────────────────────────┐
          │ 1. Leer URL desde .env         │
          │    API_COLOMBIA_URL            │
          └────────────────────────────────┘
                          │
                          ▼
          ┌────────────────────────────────┐
          │ 2. Construir endpoint          │
          │    $baseUrl/api/v1/Department  │
          └────────────────────────────────┘
                          │
                          ▼
          ┌────────────────────────────────┐
          │ 3. http.get(uri)               │
          │    Enviar peticion HTTP        │
          └────────────────────────────────┘
                          │
                          ▼
          ┌────────────────────────────────┐
          │ 4. Esperar respuesta           │
          │    await                       │
          └────────────────────────────────┘
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
      ┌──────────────┐        ┌─────────────┐
      │ statusCode   │        │ statusCode  │
      │    200       │        │   != 200    │
      │   (OK)       │        │  (ERROR)    │
      └──────────────┘        └─────────────┘
              │                       │
              ▼                       ▼
      ┌──────────────┐        ┌─────────────┐
      │ 5. Decodificar│       │ 6. Lanzar   │
      │    JSON       │        │   Exception │
      │ json.decode() │        └─────────────┘
      └──────────────┘                │
              │                       │
              ▼                       │
      ┌──────────────┐                │
      │ 6. Mapear a  │                │
      │    Modelos   │                │
      │ .map(...     │                │
      │  fromJson)   │                │
      └──────────────┘                │
              │                       │
              ▼                       │
      ┌──────────────┐                │
      │ 7. Retornar  │                │
      │ List<Model>  │                │
      └──────────────┘                │
              │                       │
              └───────────┬───────────┘
                          │
                          ▼
              ┌────────────────────┐
              │   VISTA recibe     │
              │   datos o error    │
              └────────────────────┘
```

---

## Estructura de Archivos Detallada

```
lib/parcial_de_prueba/
│
├── 📁 config/                    (Configuraciones)
│   └── (vacia actualmente)
│
├── 📁 models/                    (4 archivos - Estructuras de datos)
│   ├── 📄 department.dart        (~100 lineas)
│   ├── 📄 president.dart         (~110 lineas)
│   ├── 📄 touristic_attraction.dart (~120 lineas)
│   └── 📄 airport.dart           (~100 lineas)
│
├── 📁 services/                  (4 archivos - Logica API)
│   ├── 📄 department_service.dart     (~150 lineas)
│   ├── 📄 president_service.dart      (~150 lineas)
│   ├── 📄 touristic_attraction_service.dart (~150 lineas)
│   └── 📄 airport_service.dart        (~150 lineas)
│
├── 📁 themes/                    (1 archivo - Estilos)
│   └── 📄 app_theme.dart         (~80 lineas)
│
├── 📁 routes/                    (1 archivo - Navegacion)
│   └── 📄 app_router.dart        (~100 lineas)
│
├── 📁 widgets/                   (4 archivos - Componentes UI)
│   ├── 📄 dashboard_card.dart    (~80 lineas)
│   ├── 📄 loading_widget.dart    (~30 lineas)
│   ├── 📄 error_widget.dart      (~70 lineas)
│   └── 📄 empty_state_widget.dart (~50 lineas)
│
├── 📁 views/                     (9 archivos - Pantallas)
│   ├── 📄 dashboard_view.dart         (~120 lineas)
│   ├── 📄 departments_list_view.dart  (~130 lineas)
│   ├── 📄 department_detail_view.dart (~230 lineas)
│   ├── 📄 presidents_list_view.dart   (~145 lineas)
│   ├── 📄 president_detail_view.dart  (~250 lineas)
│   ├── 📄 attractions_list_view.dart  (~148 lineas)
│   ├── 📄 attraction_detail_view.dart (~230 lineas)
│   ├── 📄 airports_list_view.dart     (~130 lineas)
│   └── 📄 airport_detail_view.dart    (~220 lineas)
│
├── 📄 main.dart                  (~30 lineas - Entry point)
├── 📄 README.md                  (Documentacion principal)
└── 📄 GUIA_RAPIDA.md            (Guia de inicio)

TOTAL: 24 archivos de codigo + 2 docs
```

---

## Flujo Completo: Usuario Ve Detalle de Departamento

```
┌──────────────────────────────────────────────────────────────┐
│ 1. USUARIO ABRE LA APP                                       │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. main.dart ejecuta                                         │
│    - WidgetsFlutterBinding.ensureInitialized()               │
│    - dotenv.load() → Carga .env                              │
│    - runApp(MyApp())                                         │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. MaterialApp.router se inicializa                          │
│    - Aplica AppTheme.lightTheme                              │
│    - Conecta AppRouter.router                                │
│    - Carga ruta inicial "/"                                  │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. DashboardView se renderiza                                │
│    - Muestra 4 DashboardCards                                │
│    - Card 1: Departamentos (Azul)                            │
│    - Card 2: Presidentes (Rojo)                              │
│    - Card 3: Atracciones (Amarillo)                          │
│    - Card 4: Aeropuertos (Verde)                             │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. USUARIO TOCA CARD "DEPARTAMENTOS"                         │
│    onTap: () => context.push('/departments')                 │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 6. go_router navega a /departments                           │
│    - Apila DepartmentsListView en stack                      │
│    - Mantiene DashboardView en background                    │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 7. DepartmentsListView.initState()                           │
│    - Llama _loadDepartments()                                │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 8. setState(() => _isLoading = true)                         │
│    - Actualiza estado                                        │
│    - Dispara rebuild                                         │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 9. build() ejecuta                                           │
│    - Verifica _isLoading == true                             │
│    - Retorna LoadingWidget                                   │
│    - Usuario ve spinner + "Cargando departamentos..."        │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 10. DepartmentService.getAllDepartments()                    │
│     - baseUrl = dotenv.env['API_COLOMBIA_URL']               │
│     - uri = '$baseUrl/api/v1/Department'                     │
│     - response = await http.get(uri)                         │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 11. API COLOMBIA RESPONDE                                    │
│     HTTP 200 OK                                              │
│     Body: [                                                  │
│       {"id":1,"name":"Amazonas",...},                        │
│       {"id":2,"name":"Antioquia",...},                       │
│       ...                                                    │
│     ]                                                        │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 12. Servicio procesa JSON                                    │
│     - json.decode(response.body)                             │
│     - data.map((json) => Department.fromJson(json))          │
│     - Retorna List<Department>                               │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 13. setState(() {                                            │
│       _departments = departments;                            │
│       _isLoading = false;                                    │
│     })                                                       │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 14. build() ejecuta nuevamente                               │
│     - _isLoading == false                                    │
│     - _departments.isNotEmpty                                │
│     - Retorna ListView.builder                               │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 15. USUARIO VE LISTA DE 32 DEPARTAMENTOS                     │
│     Card 1: Amazonas - 11 municipios - Poblacion: 76,589    │
│     Card 2: Antioquia - 125 municipios - Poblacion: 6.4M    │
│     Card 3: ...                                              │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 16. USUARIO TOCA "ANTIOQUIA"                                 │
│     onTap: () {                                              │
│       context.push('/departments/5', extra: department)      │
│     }                                                        │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 17. go_router navega a /departments/5                        │
│     - Parsea pathParameter 'id' = 5                          │
│     - Obtiene 'extra' = Department object                    │
│     - Crea DepartmentDetailView(id: 5, department: obj)      │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 18. DepartmentDetailView.build()                             │
│     - Verifica department != null                            │
│     - Muestra Scaffold con AppBar                            │
│     - Header con gradiente azul                              │
│     - Seccion estadisticas                                   │
│     - Descripcion completa                                   │
│     - Informacion tecnica                                    │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 19. USUARIO VE DETALLE COMPLETO DE ANTIOQUIA                 │
│     - Nombre: Antioquia                                      │
│     - Municipios: 125                                        │
│     - Superficie: 63,612 km²                                 │
│     - Poblacion: 6,407,102                                   │
│     - Prefijo: 604                                           │
│     - Descripcion: ...                                       │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 20. USUARIO PRESIONA BOTON RETROCESO                         │
│     IconButton(                                              │
│       icon: Icons.arrow_back,                                │
│       onPressed: () => context.pop()                         │
│     )                                                        │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 21. go_router hace POP del stack                             │
│     - Remueve DepartmentDetailView                           │
│     - Restaura DepartmentsListView                           │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ 22. USUARIO VE LISTA NUEVAMENTE                              │
│     (Los datos siguen ahi, no se recargaron)                 │
└──────────────────────────────────────────────────────────────┘
```

---

## Paleta de Colores

```
Bandera de Colombia:

┌─────────────────────────────┐
│                             │
│         AMARILLO            │  #FCD116
│                             │
├─────────────────────────────┤
│           AZUL              │  #003893
├─────────────────────────────┤
│           ROJO              │  #CE1126
└─────────────────────────────┘

Uso en la app:
- Azul    (#003893): Departamentos, AppBar, Cards
- Rojo    (#CE1126): Presidentes, Gradientes
- Amarillo(#FCD116): Atracciones Turisticas
- Verde   (#009739): Aeropuertos
```

---

*Documentacion visual del flujo y arquitectura de la aplicacion*
