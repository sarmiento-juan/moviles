# Documentacion del Desarrollo - API Colombia App

## Indice
1. [Vision General](#vision-general)
2. [Proceso de Desarrollo](#proceso-de-desarrollo)
3. [Estructura de Carpetas](#estructura-de-carpetas)
4. [Flujo de Funcionamiento](#flujo-de-funcionamiento)
5. [Decisiones Tecnicas](#decisiones-tecnicas)

---

## Vision General

Esta aplicacion fue desarrollada para consumir la API publica de Colombia (https://api-colombia.com) y mostrar informacion sobre 4 recursos principales: Departamentos, Presidentes, Atracciones Turisticas y Aeropuertos.

### Objetivo Principal
Crear una aplicacion Flutter que demuestre:
- Consumo de multiples endpoints REST
- Arquitectura limpia y escalable
- Navegacion declarativa moderna
- Manejo profesional de estados

---

## Proceso de Desarrollo

### Fase 1: Planificacion
1. **Analisis de la API**: Revisar la documentacion de API Colombia
2. **Definicion de endpoints**: Seleccionar 4 recursos con 3 operaciones cada uno
3. **Diseño de arquitectura**: Decidir estructura MVC por capas
4. **Seleccion de paquetes**: http, go_router, flutter_dotenv

### Fase 2: Configuracion Base
1. **Setup inicial**: Configurar proyecto Flutter
2. **Variables de entorno**: Crear archivo `.env` con URL base
3. **Dependencias**: Agregar paquetes necesarios al `pubspec.yaml`
4. **Tema**: Diseñar tema con colores de la bandera de Colombia

### Fase 3: Desarrollo por Capas
1. **Modelos**: Crear clases con fromJson/toJson
2. **Servicios**: Implementar llamadas HTTP
3. **Widgets**: Desarrollar componentes reutilizables
4. **Vistas**: Construir pantallas (listas y detalles)
5. **Rutas**: Configurar navegacion con go_router
6. **Integracion**: Conectar todas las capas

### Fase 4: Pruebas y Ajustes
1. **Testing manual**: Probar flujos de navegacion
2. **Manejo de errores**: Validar estados de error
3. **UI/UX**: Ajustar diseño y animaciones
4. **Documentacion**: Crear README y guias

---

## Estructura de Carpetas

### 📁 `config/`
**Proposito**: Archivos de configuracion global de la aplicacion

**Archivo principal**:
- `app_theme.dart`: No existe en esta implementacion (el tema esta en `themes/`)

**Nota**: Esta carpeta se creo para futuras configuraciones pero actualmente no tiene archivos.

---

### 📁 `models/`
**Proposito**: Definir la estructura de datos que vienen de la API

**Como funciona**:
1. Cada modelo representa un recurso de la API
2. Contiene propiedades que mapean los campos JSON
3. Metodos `fromJson()` para convertir JSON a objeto Dart
4. Metodos `toJson()` para convertir objeto Dart a JSON
5. Getters computados para datos derivados

**Archivos**:

#### `department.dart`
- Representa un departamento de Colombia
- Propiedades: id, name, description, municipalities, surface, population, phonePrefix
- Getter: `formattedPopulation` (formato con comas)

#### `president.dart`
- Representa un presidente de Colombia
- Propiedades: id, name, lastName, startPeriodDate, endPeriodDate, politicalParty, image
- Getters: `fullName` (nombre + apellido), `period` (rango de fechas)

#### `touristic_attraction.dart`
- Representa una atraccion turistica
- Propiedades: id, name, description, images (array), latitude, longitude
- Getters: `mainImage` (primera imagen), `hasImages`, `coordinates`

#### `airport.dart`
- Representa un aeropuerto
- Propiedades: id, name, oaciCode, iataCode, type, latitude, longitude
- Getter: `coordinates` (lat, long formateadas)

**Ejemplo de uso**:
```dart
// Convertir JSON de API a objeto
final department = Department.fromJson(jsonData);

// Acceder a propiedades
print(department.name); // "Antioquia"
print(department.formattedPopulation); // "6,407,102"
```

---

### 📁 `services/`
**Proposito**: Manejar todas las peticiones HTTP a la API

**Como funciona**:
1. Cada servicio consume un recurso especifico de la API
2. Usa el paquete `http` para hacer peticiones GET
3. Lee la URL base desde variables de entorno (.env)
4. Valida statusCode (200 = exito)
5. Maneja errores con try-catch
6. Retorna listas o objetos del modelo correspondiente

**Archivos**:

#### `department_service.dart`
**Metodos**:
- `getAllDepartments()`: Obtiene todos los departamentos
- `getDepartmentById(int id)`: Obtiene un departamento especifico
- `searchDepartments(String query)`: Busca por nombre

**Endpoint usado**: `/api/v1/Department`

#### `president_service.dart`
**Metodos**:
- `getAllPresidents()`: Lista todos los presidentes
- `getPresidentById(int id)`: Detalle de un presidente
- `searchPresidents(String query)`: Busqueda por nombre

**Endpoint usado**: `/api/v1/President`

#### `touristic_attraction_service.dart`
**Metodos**:
- `getAllAttractions()`: Lista atracciones turisticas
- `getAttractionById(int id)`: Detalle de atraccion
- `searchAttractions(String query)`: Buscar atracciones

**Endpoint usado**: `/api/v1/TouristicAttraction`

#### `airport_service.dart`
**Metodos**:
- `getAllAirports()`: Lista aeropuertos
- `getAirportById(int id)`: Detalle de aeropuerto
- `searchAirports(String query)`: Buscar aeropuertos

**Endpoint usado**: `/api/v1/Airport`

**Flujo tipico**:
```dart
// 1. Servicio hace peticion HTTP
final response = await http.get(Uri.parse('$baseUrl/api/v1/Department'));

// 2. Valida respuesta
if (response.statusCode == 200) {
  // 3. Decodifica JSON
  final List<dynamic> data = json.decode(response.body);
  
  // 4. Convierte a objetos usando modelo
  return data.map((json) => Department.fromJson(json)).toList();
}
```

---

### 📁 `themes/`
**Proposito**: Definir estilos globales de la aplicacion

**Archivo principal**:

#### `app_theme.dart`
**Contenido**:
- Paleta de colores basada en la bandera de Colombia
  - Azul: `#003893`
  - Rojo: `#CE1126`
  - Amarillo: `#FCD116`
  - Verde: `#009739`
- Tema de Cards con bordes redondeados
- Tema de AppBar con elevacion
- Tema de botones elevados

**Uso**:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

---

### 📁 `views/`
**Proposito**: Pantallas principales de la aplicacion

**Como funciona**:
1. Son StatefulWidget (tienen estado mutable)
2. Usan servicios para obtener datos
3. Manejan 4 estados: loading, success, error, empty
4. Renderizan UI segun el estado actual

**Archivos**:

#### `dashboard_view.dart` - Pantalla Principal
- **Que hace**: Muestra 4 cards para navegar a cada seccion
- **Componentes**: GridView con 4 DashboardCard
- **Navegacion**: usa `context.push()` para ir a listas
- **Diseño**: Colores de bandera de Colombia

#### `departments_list_view.dart` - Lista de Departamentos
- **Que hace**: Muestra todos los departamentos en ListView
- **Features**: Pull-to-refresh, icono circular con inicial
- **Datos**: Nombre, numero de municipios, poblacion
- **Navegacion**: Toca card → va a detalle con `context.push()`

#### `department_detail_view.dart` - Detalle de Departamento
- **Que hace**: Muestra informacion completa de un departamento
- **Secciones**: Header con gradiente, estadisticas, descripcion, info tecnica
- **Features**: Boton de retroceso, compartir, copiar al portapapeles
- **Datos**: Todos los campos del modelo Department

#### `presidents_list_view.dart` - Lista de Presidentes
- **Que hace**: Lista presidentes con imagen
- **Features**: Pull-to-refresh, imagen de perfil o icono
- **Datos**: Nombre completo, periodo, partido politico
- **Diseño**: ListTile con imagen circular

#### `president_detail_view.dart` - Detalle de Presidente
- **Que hace**: Biografia completa del presidente
- **Secciones**: Header con imagen, biografia, periodo presidencial
- **Features**: Boton retroceso, compartir, copiar datos
- **Diseño**: Tema rojo (color bandera)

#### `attractions_list_view.dart` - Lista de Atracciones
- **Que hace**: Muestra atracciones turisticas con imagen
- **Features**: Pull-to-refresh, imagen principal o icono
- **Datos**: Nombre, descripcion breve
- **Diseño**: Card con imagen

#### `attraction_detail_view.dart` - Detalle de Atraccion
- **Que hace**: Detalle completo de atraccion turistica
- **Diseño especial**: SliverAppBar expandible con imagen
- **Secciones**: Galeria de imagenes, descripcion, ubicacion (lat/long)
- **Features**: Scroll con parallax effect

#### `airports_list_view.dart` - Lista de Aeropuertos
- **Que hace**: Lista aeropuertos de Colombia
- **Features**: Pull-to-refresh
- **Datos**: Nombre, codigos OACI/IATA, tipo
- **Diseño**: ListTile simple

#### `airport_detail_view.dart` - Detalle de Aeropuerto
- **Que hace**: Informacion completa del aeropuerto
- **Secciones**: Header verde, codigos internacionales, ubicacion, clasificacion
- **Features**: Copiar codigos OACI/IATA al portapapeles
- **Diseño**: Tema verde (color bandera)

**Patron de estados comun en todas las vistas**:
```dart
if (_isLoading) {
  return LoadingWidget(); // Spinner
}
if (_error != null) {
  return ErrorWidget(); // Mensaje error + retry
}
if (_data.isEmpty) {
  return EmptyStateWidget(); // Sin datos
}
return ListView(...); // Datos OK
```

---

### 📁 `widgets/`
**Proposito**: Componentes reutilizables en toda la app

**Archivos**:

#### `dashboard_card.dart`
- **Que es**: Card con gradiente para el dashboard
- **Props**: title, subtitle, icon, color, onTap
- **Diseño**: Gradiente, icono grande, texto centrado
- **Uso**: Las 4 cards del dashboard principal

#### `loading_widget.dart`
- **Que es**: Indicador de carga centrado
- **Props**: message (opcional)
- **Diseño**: CircularProgressIndicator + texto
- **Uso**: Cuando se cargan datos de la API

#### `error_widget.dart`
- **Que es**: Pantalla de error con boton retry
- **Props**: message, onRetry (opcional)
- **Diseño**: Icono de error + mensaje + boton
- **Uso**: Cuando falla una peticion HTTP

#### `empty_state_widget.dart`
- **Que es**: Pantalla cuando no hay datos
- **Props**: message, icon
- **Diseño**: Icono grande + mensaje centrado
- **Uso**: Cuando la API retorna array vacio

**Ventaja de widgets reutilizables**:
- Codigo DRY (Don't Repeat Yourself)
- Facil mantenimiento
- Consistencia visual
- Menos lineas de codigo

---

### 📁 `routes/`
**Proposito**: Configuracion de navegacion de la app

**Archivo principal**:

#### `app_router.dart`
**Que hace**:
- Define todas las rutas de la aplicacion
- Usa `go_router` para navegacion declarativa
- Maneja parametros de ruta (`:id`)
- Pasa datos entre pantallas con `extra`

**Rutas configuradas** (12 total):

1. `/` - Dashboard (home)
2. `/departments` - Lista departamentos
3. `/departments/:id` - Detalle departamento
4. `/presidents` - Lista presidentes
5. `/presidents/:id` - Detalle presidente
6. `/attractions` - Lista atracciones
7. `/attractions/:id` - Detalle atraccion
8. `/airports` - Lista aeropuertos
9. `/airports/:id` - Detalle aeropuerto

**Ejemplo de ruta con parametro**:
```dart
GoRoute(
  path: '/departments/:id',
  name: 'department_detail',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id'] ?? '0');
    final department = state.extra as Department?;
    return DepartmentDetailView(id: id, department: department);
  },
)
```

**Navegacion en codigo**:
```dart
// Ir a lista
context.push('/departments');

// Ir a detalle pasando datos
context.push('/departments/5', extra: departmentObject);

// Regresar
context.pop();
```

---

### 📄 `main.dart`
**Proposito**: Punto de entrada de la aplicacion

**Que hace**:
1. Carga variables de entorno con `dotenv.load()`
2. Ejecuta la app con `runApp()`
3. Configura `MaterialApp.router`
4. Aplica tema global
5. Conecta router de navegacion

**Codigo clave**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Carga API_COLOMBIA_URL
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'API Colombia',
      theme: AppTheme.lightTheme, // Tema personalizado
      routerConfig: AppRouter.router, // Rutas
      debugShowCheckedModeBanner: false,
    );
  }
}
```

---

## Flujo de Funcionamiento

### Flujo Completo: Usuario ve lista de Departamentos

```
1. Usuario abre app
   ↓
2. main.dart carga .env y ejecuta app
   ↓
3. MaterialApp.router carga ruta inicial "/"
   ↓
4. AppRouter muestra DashboardView
   ↓
5. Usuario toca card "Departamentos"
   ↓
6. context.push('/departments') navega a lista
   ↓
7. DepartmentsListView se monta
   ↓
8. initState() llama _loadDepartments()
   ↓
9. setState(() => _isLoading = true)
   ↓
10. DepartmentService.getAllDepartments()
    ↓
11. http.get('https://api-colombia.com/api/v1/Department')
    ↓
12. API retorna JSON con array de departamentos
    ↓
13. Servicio convierte JSON a List<Department>
    ↓
14. setState(() => _departments = data, _isLoading = false)
    ↓
15. build() renderiza ListView.builder con datos
    ↓
16. Usuario ve lista de departamentos
    ↓
17. Usuario toca un departamento
    ↓
18. context.push('/departments/5', extra: department)
    ↓
19. DepartmentDetailView muestra detalles
    ↓
20. Usuario presiona boton retroceso
    ↓
21. context.pop() regresa a lista
```

### Flujo de Estados

```
Estado LOADING:
  _isLoading = true
  → Muestra LoadingWidget
  → Spinner girando + "Cargando..."

Estado SUCCESS:
  _isLoading = false
  _error = null
  _data.isNotEmpty
  → Muestra ListView con datos

Estado ERROR:
  _isLoading = false
  _error = "mensaje de error"
  → Muestra ErrorWidget
  → Boton "Reintentar"

Estado EMPTY:
  _isLoading = false
  _error = null
  _data.isEmpty
  → Muestra EmptyStateWidget
  → "No se encontraron datos"
```

---

## Decisiones Tecnicas

### ¿Por que go_router en lugar de Navigator?
- **Razon**: Navegacion declarativa moderna
- **Ventajas**: URLs tipadas, deep linking, mejor para web
- **Comparacion**: `context.push()` vs `Navigator.push()`

### ¿Por que http en lugar de dio?
- **Razon**: Simplicidad para este proyecto
- **Ventajas**: Oficial de Dart, ligero, suficiente para GET requests
- **Cuando usar dio**: Interceptores, cancelacion, progreso de descarga

### ¿Por que StatefulWidget?
- **Razon**: Necesitamos estado mutable (loading, data, error)
- **Alternativas**: Provider, Riverpod, Bloc (excesivo para este caso)

### ¿Por que no usar FutureBuilder?
- **Razon**: Mas control sobre estados intermedios
- **Ventajas**: Manejo explicito de loading/error/success
- **Desventaja**: Mas codigo boilerplate

### ¿Por que .env para URLs?
- **Razon**: Buena practica, separar configuracion de codigo
- **Ventajas**: Facil cambiar entre dev/prod
- **Seguridad**: No commitear credenciales al repo

### Patron Arquitectonico: MVC por Capas
```
Models (Datos)
   ↕
Services (Logica de negocio / API)
   ↕
Views (UI / Presentacion)
   ↕
Widgets (Componentes reutilizables)
```

**Ventajas**:
- Separacion de responsabilidades
- Facil testing unitario
- Codigo escalable y mantenible
- Reutilizacion de componentes

---

## Resumen de Archivos

| Carpeta | Archivos | Proposito | Lineas aprox |
|---------|----------|-----------|--------------|
| models/ | 4 | Estructura de datos | ~400 |
| services/ | 4 | Peticiones HTTP | ~600 |
| views/ | 9 | Pantallas UI | ~1800 |
| widgets/ | 4 | Componentes reusables | ~300 |
| routes/ | 1 | Navegacion | ~100 |
| themes/ | 1 | Estilos globales | ~80 |
| main.dart | 1 | Entry point | ~30 |
| **TOTAL** | **24** | **Aplicacion completa** | **~3310** |

---

## Proximos Pasos de Mejora

1. **Testing**: Agregar unit tests para servicios
2. **State Management**: Migrar a Riverpod o Bloc para mejor escalabilidad
3. **Cache**: Implementar cache local con SharedPreferences
4. **Offline Mode**: Guardar datos para modo sin internet
5. **Search**: Agregar barra de busqueda en listas
6. **Favoritos**: Permitir marcar items como favoritos
7. **Analytics**: Agregar Firebase Analytics
8. **CI/CD**: GitHub Actions para deploy automatico

---

## Conclusion

Esta aplicacion demuestra una arquitectura solida y escalable para consumir APIs REST en Flutter. La separacion por capas facilita el mantenimiento y la adicion de nuevas funcionalidades.

**Puntos clave del desarrollo**:
- ✅ Arquitectura limpia MVC
- ✅ 12 endpoints consumidos
- ✅ Navegacion declarativa con go_router
- ✅ Manejo completo de estados
- ✅ UI tematica con colores de Colombia
- ✅ Codigo reutilizable y DRY
- ✅ Buenas practicas (env vars, error handling)

---

*Documentacion creada para explicar el funcionamiento y desarrollo de la aplicacion API Colombia*
