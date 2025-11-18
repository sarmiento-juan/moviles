# Parcial 2 - Datos Abiertos Colombia

Aplicacion Flutter que consume la **API Colombia** para mostrar informacion sobre departamentos, presidentes, atracciones turisticas y aeropuertos del pais.

## Resumen Ejecutivo

### Descripcion General
Aplicacion movil desarrollada en Flutter que consume la API publica de Colombia (https://api-colombia.com) para mostrar informacion geografica, politica y turistica del pais. Implementa arquitectura MVC, navegacion declarativa con go_router, y manejo completo de estados.

### Endpoints Utilizados
- **Department**: 3 endpoints (listar, obtener por ID, buscar)
- **President**: 3 endpoints (listar, obtener por ID, buscar)
- **TouristicAttraction**: 3 endpoints (listar, obtener por ID, buscar)
- **Airport**: 3 endpoints (listar, obtener por ID, buscar)
- **Total**: 12 endpoints consumidos

### Estructura del Proyecto
```
parcial_de_prueba/
├── config/         # Tema y configuracion (1 archivo)
├── models/         # Modelos de datos (4 archivos)
├── routes/         # Navegacion go_router (1 archivo)
├── services/       # Servicios HTTP (4 archivos)
├── themes/         # Estilos globales (1 archivo)
├── views/          # Pantallas (9 archivos: 1 dashboard + 4 listas + 4 detalles)
├── widgets/        # Componentes reutilizables (4 archivos)
└── main.dart       # Punto de entrada
```
**Total**: 25 archivos organizados en arquitectura por capas

### Paquetes Implementados
- **http** (^1.2.2): Peticiones HTTP a la API REST
- **go_router** (^14.6.2): Navegacion declarativa y manejo de rutas
- **flutter_dotenv** (^5.2.1): Gestion de variables de entorno
- **flutter/material**: Componentes Material Design

### Funcionalidades Principales
- Dashboard principal con 4 secciones tematicas
- Navegacion fluida entre listas y detalles
- Manejo de estados (loading, success, error, empty)
- Pull-to-refresh en todas las listas
- Tema personalizado con colores de la bandera de Colombia
- Busqueda y filtrado de datos
- Copiar informacion al portapapeles
- Responsive design

---

## Descripcion

Esta aplicacion demuestra el consumo de multiples endpoints de una API RESTful publica, implementando arquitectura por capas, navegacion con `go_router`, y manejo completo de estados (cargando, exito, error).

## API Utilizada

**API Colombia**: https://api-colombia.com

Documentacion Swagger: https://api-colombia.com/swagger/index.html

### Endpoints Consumidos

1. **Department** - Departamentos de Colombia
   - `GET /api/v1/Department` - Lista todos los departamentos
   - `GET /api/v1/Department/{id}` - Obtiene un departamento por ID
   - `GET /api/v1/Department/search/{name}` - Busca departamentos por nombre

2. **President** - Presidentes de Colombia
   - `GET /api/v1/President` - Lista todos los presidentes
   - `GET /api/v1/President/{id}` - Obtiene un presidente por ID
   - `GET /api/v1/President/search/{name}` - Busca presidentes por nombre

3. **TouristicAttraction** - Atracciones Turisticas
   - `GET /api/v1/TouristicAttraction` - Lista todas las atracciones
   - `GET /api/v1/TouristicAttraction/{id}` - Obtiene una atraccion por ID
   - `GET /api/v1/TouristicAttraction/search/{name}` - Busca atracciones

4. **Airport** - Aeropuertos
   - `GET /api/v1/Airport` - Lista todos los aeropuertos
   - `GET /api/v1/Airport/{id}` - Obtiene un aeropuerto por ID
   - `GET /api/v1/Airport/search/{name}` - Busca aeropuertos

## Arquitectura del Proyecto

```
lib/parcial_de_prueba/
├── config/                          # Configuracion general
├── models/                          # Modelos de datos
│   ├── department.dart              # Modelo de Departamento
│   ├── president.dart               # Modelo de Presidente
│   ├── touristic_attraction.dart    # Modelo de Atraccion Turistica
│   └── airport.dart                 # Modelo de Aeropuerto
├── routes/                          # Configuracion de navegacion
│   └── app_router.dart              # Rutas con go_router
├── services/                        # Logica de peticiones HTTP
│   ├── department_service.dart      # Servicio de Departamentos
│   ├── president_service.dart       # Servicio de Presidentes
│   ├── touristic_attraction_service.dart
│   └── airport_service.dart         # Servicio de Aeropuertos
├── themes/                          # Estilos globales
│   └── app_theme.dart               # Tema de la aplicacion
├── views/                           # Pantallas principales
│   ├── dashboard_view.dart          # Dashboard con 4 cards
│   ├── departments_list_view.dart   # Listado de departamentos
│   ├── department_detail_view.dart  # Detalle de departamento
│   ├── presidents_list_view.dart    # Listado de presidentes
│   ├── president_detail_view.dart   # Detalle de presidente
│   ├── attractions_list_view.dart   # Listado de atracciones
│   ├── attraction_detail_view.dart  # Detalle de atraccion
│   ├── airports_list_view.dart      # Listado de aeropuertos
│   └── airport_detail_view.dart     # Detalle de aeropuerto
├── widgets/                         # Componentes reutilizables
│   ├── dashboard_card.dart          # Card del dashboard
│   ├── loading_widget.dart          # Estado de carga
│   ├── error_widget.dart            # Estado de error
│   └── empty_state_widget.dart      # Estado vacio
└── main.dart                        # Punto de entrada
```

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.2              # Peticiones HTTP
  flutter_dotenv: ^5.2.1    # Variables de entorno
  go_router: ^14.6.2        # Navegacion declarativa
  cupertino_icons: ^1.0.8   # Iconos
```

## Configuracion

### Archivo `.env`

Crea/actualiza el archivo `.env` en la raiz del proyecto:

```env
# API Colombia
API_COLOMBIA_URL=https://api-colombia.com
```

## Rutas Implementadas

### Dashboard
- **Ruta**: `/`
- **Nombre**: `home`
- **Vista**: `DashboardView`
- **Descripcion**: Pantalla principal con 4 cards para navegar a cada endpoint

### Departamentos
- **Listado**: `/departments` → `DepartmentsListView`
- **Detalle**: `/departments/:id` → `DepartmentDetailView`
- **Parametros**: `id` (path parameter) + `Department` object (extra)

### Presidentes
- **Listado**: `/presidents` → `PresidentsListView`
- **Detalle**: `/presidents/:id` → `PresidentDetailView`
- **Parametros**: `id` (path parameter) + `President` object (extra)

### Atracciones Turisticas
- **Listado**: `/attractions` → `AttractionsListView`
- **Detalle**: `/attractions/:id` → `AttractionDetailView`
- **Parametros**: `id` (path parameter) + `TouristicAttraction` object (extra)

### Aeropuertos
- **Listado**: `/airports` → `AirportsListView`
- **Detalle**: `/airports/:id` → `AirportDetailView`
- **Parametros**: `id` (path parameter) + `Airport` object (extra)

## Ejemplos de Respuesta JSON

### Department
```json
{
  "id": 1,
  "name": "Amazonas",
  "description": "Departamento ubicado en el sur de Colombia...",
  "cityCapitalId": 1,
  "municipalities": 11,
  "surface": "109665",
  "population": 79093,
  "phonePrefix": "8",
  "regionId": 6
}
```

### President
```json
{
  "id": 1,
  "name": "Gustavo",
  "lastName": "Petro Urrego",
  "startPeriodDate": "2022-08-07",
  "endPeriodDate": "2026-08-07",
  "politicalParty": "Colombia Humana",
  "description": "Primer presidente de izquierda...",
  "image": "https://...",
  "cityId": 149
}
```

### TouristicAttraction
```json
{
  "id": 1,
  "name": "Catedral de Sal de Zipaquira",
  "description": "Obra arquitectonica subterranea...",
  "images": ["https://...", "https://..."],
  "latitude": "5.017778",
  "longitude": "-74.003889",
  "cityId": 149
}
```

### Airport
```json
{
  "id": 1,
  "name": "Aeropuerto Internacional El Dorado",
  "oaciCode": "SKBO",
  "iataCode": "BOG",
  "type": "Internacional",
  "departmentId": 25,
  "cityId": 149,
  "latitude": "4.701594",
  "longitude": "-74.146947"
}
```

## Manejo de Estados

Cada vista de listado implementa 3 estados:

1. **Loading** (Cargando)
   - Muestra `CircularProgressIndicator`
   - Mensaje personalizado: "Cargando departamentos...", etc.

2. **Success** (Exito)
   - `ListView.builder` con los datos
   - `RefreshIndicator` para recargar
   - Navegacion al detalle con `context.go()`

3. **Error** (Error)
   - Mensaje de error amigable
   - Boton "Reintentar"
   - Captura de excepciones con try-catch

## Modelos de Datos

Todos los modelos implementan:
- Constructor con parametros nombrados
- `fromJson()` para deserializacion
- `toJson()` para serializacion
- Getters utiles para formateo de datos

Ejemplo:
```dart
class Department {
  final int id;
  final String name;
  // ...

  Department.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

## Servicios HTTP

Todos los servicios siguen el mismo patron:
- Uso de `http` package
- URL base desde `.env` con `flutter_dotenv`
- Manejo de errores con try-catch
- Validacion de `statusCode`
- Retorno de modelos tipados

Ejemplo:
```dart
class DepartmentService {
  final String _baseUrl = dotenv.env['API_COLOMBIA_URL'] ?? '';

  Future<List<Department>> getAllDepartments() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/v1/Department'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Department.fromJson(json)).toList();
    }
    throw Exception('Error: ${response.statusCode}');
  }
}
```

## Navegacion con go_router

### Navegacion al Listado
```dart
// Desde Dashboard
context.go('/departments');
```

### Navegacion al Detalle
```dart
// Desde Listado, pasando objeto completo
context.go(
  '/departments/${department.id}',
  extra: department,
);
```

### Navegacion de Regreso
```dart
// Boton back automatico en AppBar
// O programaticamente:
context.pop();
```

## Ejecucion

### Ejecutar la aplicacion

```bash
# Ejecutar en el main especifico del parcial
flutter run -t lib/parcial_de_prueba/main.dart
```

### Hot Reload
```bash
# Durante la ejecucion, presiona 'r' para hot reload
r
```

## Caracteristicas Implementadas

### Dashboard
- Grid de 4 cards con gradientes
- Iconos representativos para cada endpoint
- Navegacion directa al listado correspondiente
- Card informativa sobre la API

### Listados
- ListView.builder eficiente
- Cards con informacion resumida
- Avatar/Imagen representativa
- Pull to refresh
- Boton refresh en AppBar
- Estados de loading, error y vacio

### Detalles
- Header con imagen/gradiente
- Informacion completa del registro
- Sections organizadas con iconos
- Copiar al portapapeles (IDs, coordenadas, etc.)
- Navegacion fluida de regreso

### Widgets Reutilizables
- `DashboardCard`: Card del dashboard con gradiente
- `LoadingWidget`: Indicador de carga
- `ErrorWidget`: Estado de error con retry
- `EmptyStateWidget`: Estado vacio

## Tema de la Aplicacion

Paleta de colores basada en la bandera de Colombia:
- **Azul** (#003893): Departamentos
- **Rojo** (#CE1126): Presidentes
- **Amarillo** (#FCD116): Atracciones
- **Verde** (#009739): Aeropuertos

## Flujo de Trabajo Git

### Ramas
- `main`: Rama estable
- `dev`: Rama de integracion
- `feature/parcial_api_colombia`: Desarrollo del parcial

### Commits
Formato: `tipo: descripcion`

Ejemplos:
```
feat: add department model and service
feat: implement dashboard view
feat: add go_router configuration
fix: handle null values in president model
docs: update README with API examples
```

### Pull Request
1. Crear PR de `feature/parcial_api_colombia` → `dev`
2. Incluir descripcion detallada
3. Agregar screenshots
4. Revision y merge a `dev`
5. Merge de `dev` → `main`

## Autor

Desarrollado por estudiantes de Flutter UCEVA

## Licencia

Proyecto educativo de codigo abierto

---

**Universidad:** UCEVA
**Materia:** Desarrollo Movil
**Proyecto:** Parcial 2 - Consumo de API Colombia
