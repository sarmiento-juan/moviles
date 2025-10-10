# Taller HTTP - Chuck Norris Jokes

Aplicacion Flutter que consume la **Chuck Norris API** para mostrar bromas sobre Chuck Norris con navegacion entre pantallas.

## Descripcion

Esta aplicacion demuestra el uso de peticiones HTTP en Flutter consumiendo una API RESTful. Utiliza la API publica de Chuck Norris para obtener y mostrar bromas con arquitectura completa: **Listado, Detalle y Navegacion**.

## Caracteristicas Principales

### Funcionalidades Implementadas

#### 1. Pantalla de Listado (Home)
- **ListView.builder**: Muestra 10 bromas en formato de lista
- **Imagenes**: Icono de Chuck Norris en cada tarjeta
- **Categorias**: Chip badges mostrando las categorias de cada broma
- **Filtrado**: Dialog para seleccionar categoria especifica
- **Estados Visuales**: Loading (CircularProgressIndicator), Exito, Error
- **Pull to Refresh**: Desliza hacia abajo para recargar
- **Navegacion**: Tap en cualquier broma para ver detalles

#### 2. Pantalla de Detalle
- **Navegacion con go_router**: Recibe parametros por ruta (ID + data)
- **Informacion Ampliada**: Texto completo, imagen grande, categorias
- **Acciones**: Copiar al portapapeles, ver info tecnica
- **Boton Atras**: Navegacion de regreso al listado
- **Diseno Hero**: Imagen destacada con gradiente

#### 3. Navegacion y Rutas
- **go_router**: Sistema de rutas declarativas
- **Rutas con nombre**: `'home'` y `'detail'`
- **Parametros**: Path parameters (`/detail/:id`) + extra data
- **Deep Linking**: Soporte para URLs directas

## Tecnologias Utilizadas

### Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.2              # Peticiones HTTP
  flutter_dotenv: ^5.2.1    # Variables de entorno
  go_router: ^14.6.2        # Navegacion declarativa
  cupertino_icons: ^1.0.8   # Iconos iOS
```

### Arquitectura del Proyecto

```
lib/Taller_http/
├── models/
│   └── joke.dart                    # Modelo de datos (fromJson/toJson)
├── services/
│   └── chuck_norris_service.dart    # Servicio HTTP (separado del UI)
├── views/
│   └── jokes/
│       ├── jokes_list_view.dart     # Pantalla de LISTADO
│       ├── joke_detail_view.dart    # Pantalla de DETALLE
│       └── jokes_single_view.dart   # Vista antigua (backup)
├── widgets/
│   └── base_view.dart               # Widget base reutilizable
├── routes/
│   └── app_router.dart              # Configuracion de go_router
├── themes/
│   └── app_theme.dart               # Tema de la aplicacion
├── main.dart                        # Punto de entrada
├── README.md                        # Esta documentacion
└── QUICK_START.md                   # Guia rapida de ejecucion
```

##  API Utilizada

**Chuck Norris API**: https://api.chucknorris.io

### Endpoints Consumidos

1. **Broma Aleatoria**
   ```
   GET https://api.chucknorris.io/jokes/random
   ```

2. **Categorias Disponibles**
   ```
   GET https://api.chucknorris.io/jokes/categories
   ```

3. **Broma por Categoria**
   ```
   GET https://api.chucknorris.io/jokes/random?category={category}
   ```

4. **Busqueda de Bromas**
   ```
   GET https://api.chucknorris.io/jokes/search?query={query}
   ```

### Respuesta de Ejemplo

```json
{
  "id": "abc123",
  "value": "Chuck Norris can divide by zero.",
  "icon_url": "https://api.chucknorris.io/img/avatar/chuck-norris.png",
  "categories": ["dev"],
  "created_at": "2020-01-05 13:42:19.324003",
  "updated_at": "2020-01-05 13:42:19.324003"
}
```

## Modelo de Datos

### Clase `Joke`

```dart
class Joke {
  final String id;           // ID unico de la broma
  final String value;        // Texto de la broma
  final String iconUrl;      // URL del icono de Chuck Norris
  final String url;          // URL de la broma en la API
  final List<String> categories;  // Categorias asociadas
  final String createdAt;    // Fecha de creacion
  final String updatedAt;    // Fecha de actualizacion
  
  // Getters utiles
  bool get hasCategories;    // Verifica si tiene categorias
  String get categoriesText; // Categorias formateadas
}
```

## Sistema de Rutas (go_router)

### Rutas Definidas

| Ruta | Nombre | Vista | Descripcion |
|------|--------|-------|-------------|
| `/` | `home` | `JokesListView` | Listado principal de bromas |
| `/detail/:id` | `detail` | `JokeDetailView` | Detalle de una broma especifica |

### Navegacion al Detalle

```dart
// En JokesListView: Navegacion con parametros
context.pushNamed(
  'detail',
  pathParameters: {'id': joke.id},  // Path parameter
  extra: {                           // Data adicional
    'value': joke.value,
    'iconUrl': joke.iconUrl,
    'url': joke.url,
    'categories': joke.categories,
    'createdAt': joke.createdAt,
    'updatedAt': joke.updatedAt,
  },
);
```

### Navegacion de Regreso

```dart
// En JokeDetailView: Volver atras
context.pop();  // Regresa a la pantalla anterior

// O usar el boton nativo "atras" del AppBar
```

### Configuracion del Router

```dart
// lib/Taller_http/routes/app_router.dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const JokesListView(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          return JokeDetailView(id: id, jokeData: extra);
        },
      ),
    ],
  );
}
```

##  Configuracion

### Archivo `.env`

Crea un archivo `.env` en la raiz del proyecto:

```env
# Chuck Norris API
CHUCK_NORRIS_API_URL=https://api.chucknorris.io
```

## 📖 Conceptos Clave Implementados

### 1. Separacion de Logica HTTP en Service

** MAL - Logica en la Vista:**
```dart
// NO HACER ESTO
class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    http.get(Uri.parse('https://api...')); //  HTTP en build()
    return Container();
  }
}
```

** BIEN - Service Separado:**
```dart
// lib/services/chuck_norris_service.dart
class ChuckNorrisService {
  Future<Joke> getRandomJoke() async {
    final response = await http.get(Uri.parse('$_baseUrl/jokes/random'));
    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}

// lib/views/jokes_list_view.dart
class _JokesListViewState extends State<JokesListView> {
  final ChuckNorrisService _service = ChuckNorrisService(); //  Service
  
  @override
  void initState() {
    super.initState();
    _loadJokes(); //  En initState(), NO en build()
  }
}
```

### 2. Manejo de Estados (Loading/Success/Error)

```dart
enum LoadingState { idle, loading, success, error }

// Estado de carga
bool _isLoading = false;
String? _error;
List<Joke> _jokes = [];

// Durante la peticion
setState(() {
  _isLoading = true;
  _error = null;
});

// En la UI
if (_isLoading)
  CircularProgressIndicator()
else if (_error != null)
  Text('Error: $_error')
else
  ListView.builder(...)
```

### 3. try/catch y Validacion de statusCode

```dart
Future<void> _loadJokes() async {
  try {
    final jokes = [];
    for (int i = 0; i < 10; i++) {
      final joke = await _service.getRandomJoke();
      jokes.add(joke);
    }
    setState(() {
      _jokes = jokes;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _error = 'Error: $e';
      _isLoading = false;
    });
    
    // Mensaje al usuario con Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error de conexion: $e'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Reintentar',
          onPressed: () => _loadJokes(),
        ),
      ),
    );
  }
}
```

### 4. ListView.builder (NO ListView directo)

** BIEN - ListView.builder (eficiente):**
```dart
ListView.builder(
  itemCount: _jokes.length,
  itemBuilder: (context, index) {
    final joke = _jokes[index];
    return Card(
      child: ListTile(
        leading: Image.network(joke.iconUrl),
        title: Text(joke.value),
        onTap: () => _navigateToDetail(joke),
      ),
    );
  },
)
```

** MAL - ListView con children (ineficiente):**
```dart
// NO HACER ESTO con listas grandes
ListView(
  children: _jokes.map((joke) => Card(...)).toList(), // 
)
```

### 5. No Bloquear la UI - async/await

```dart
//  CORRECTO: No bloquea la UI
Future<void> _loadJokes() async {
  final jokes = await _service.getRandomJoke(); // Espera sin bloquear
  setState(() => _jokes = jokes);
}

//  INCORRECTO: Bloquearia la UI
void _loadJokes() {
  final jokes = _service.getRandomJoke().then(...); // Mal uso
}
```

### 6. Variables de Entorno con dotenv

```dart
// .env
CHUCK_NORRIS_API_URL=https://api.chucknorris.io

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); //  Cargar antes de runApp
  runApp(const MyApp());
}

// service.dart
final String _baseUrl = dotenv.env['CHUCK_NORRIS_API_URL'] ?? 'fallback';
```

##  Interfaz de Usuario

### Componentes Principales

1. **Tarjeta de Broma**
   - Icono de Chuck Norris (si esta disponible)
   - Texto de la broma con estilo italic
   - Chips con categorias
   - Gradiente naranja de fondo

2. **Botones de Accion**
   - **Nueva Broma Aleatoria**: Boton elevado naranja
   - **Ver por Categoria**: Boton outlined con dialog

3. **Estados Visuales**
   - **Loading**: CircularProgressIndicator centrado
   - **Error**: Tarjeta roja con icono de error
   - **Success**: Tarjeta con gradiente y contenido

### RefreshIndicator

```dart
RefreshIndicator(
  onRefresh: _loadRandomJoke,
  child: SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    // contenido...
  ),
)
```

##  Casos de Uso - Flujo Completo

### Flujo 1: Ver Listado de Bromas
```
Usuario abre la app
   → initState() ejecuta _loadJokes()
   → CircularProgressIndicator se muestra (_isLoading = true)
   → Service hace 10 peticiones HTTP a la API
   → Cada respuesta se parsea con Joke.fromJson()
   → setState actualiza _jokes con las bromas
   → ListView.builder renderiza las 10 Cards
   → Usuario ve el listado completo
```

### Flujo 2: Navegar al Detalle
```
Usuario toca una broma en el listado
   → onTap ejecuta _navigateToDetail(joke)
   → context.pushNamed('detail', ...) con parametros
   → go_router navega a /detail/:id
   → JokeDetailView recibe id + jokeData
   → Vista de detalle se renderiza con info ampliada
   → Usuario ve texto completo + imagen grande
```

### Flujo 3: Volver Atras
```
Usuario presiona boton "Volver al Listado"
   → context.pop() ejecuta
   → go_router regresa a la ruta anterior (/)
   → JokesListView se muestra de nuevo
   → Listado conserva el estado (no recarga)
```

### Flujo 4: Filtrar por Categoria
```
Usuario presiona icono de filtro
   → Dialog con categorias se muestra
   → Usuario selecciona "dev"
   → _loadJokes(category: 'dev') ejecuta
   → Service hace peticiones con ?category=dev
   → ListView se actualiza con bromas de esa categoria
   → Header muestra "Categoria: DEV"
```

### Flujo 5: Manejo de Errores
```
Usuario intenta cargar bromas sin internet
   → try { await _service.getRandomJoke() }
   → catch (e) captura el error
   → setState actualiza _error con mensaje
   → UI muestra Card roja con error
   → SnackBar aparece con boton "Reintentar"
   → Usuario presiona "Reintentar"
   → _loadJokes() se ejecuta de nuevo
```

## 🚦 Manejo de Errores

```dart
try {
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    // Procesar respuesta exitosa
  } else {
    throw Exception('Error: ${response.statusCode}');
  }
} catch (e) {
  throw Exception('Error de conexion: $e');
}
```

### Tipos de Errores Manejados

1. **Error de Red**: Sin conexion a internet
2. **Error HTTP**: Codigos 4xx, 5xx
3. **Error de Parsing**: JSON mal formado
4. **Timeout**: Peticion demorada

##  Ejecucion

### Modo Debug

```bash
# Ejecutar en el main especifico del taller
flutter run -t lib/Taller_http/main.dart
```

### Hot Reload

```bash
# Durante la ejecucion, presiona 'r' para hot reload
r
```

##  Aprendizajes

### Conceptos HTTP
-  Metodos HTTP (GET)
-  Codigos de estado (200, 404, 500)
-  Headers y query parameters
-  Deserializacion JSON

### Buenas Practicas
-  Separacion de responsabilidades (Service, Model, View)
-  Manejo de estados con setState
-  Try-catch para errores
-  Variables de entorno para configuracion
-  Valores por defecto en modelos
-  Feedback visual para el usuario

### Flutter Widgets
-  StatefulWidget y setState
-  RefreshIndicator
-  CircularProgressIndicator
-  Card con gradientes
-  AlertDialog
-  Chips y Wrap

## 🔄 Flujo de Datos Completo

```
┌─────────────────────┐
│   JokesListView     │ (Vista - Listado)
│   initState()       │
└──────────┬──────────┘
           │ 1. Llama _loadJokes()
           ▼
┌──────────────────────────┐
│ ChuckNorrisService       │ (Service)
│ getRandomJoke() x10      │
└──────────┬───────────────┘
           │ 2. HTTP GET x10
           ▼
    ┌─────────────┐
    │  Chuck API  │ (API Externa)
    │ /jokes/random│
    └──────┬──────┘
           │ 3. JSON Response x10
           ▼
    ┌─────────────┐
    │ Joke.fromJson() │ (Modelo)
    └──────┬──────┘
           │ 4. List<Joke>
           ▼
    ┌─────────────┐
    │  setState() │ (Actualiza UI)
    └──────┬──────┘
           │ 5. Renderiza
           ▼
┌──────────────────────────┐
│   ListView.builder       │
│   10 Cards con bromas    │
└──────────┬───────────────┘
           │ 6. Usuario toca Card
           ▼
┌──────────────────────────┐
│   context.pushNamed()    │ (Navegacion)
│   'detail'               │
└──────────┬───────────────┘
           │ 7. Pasa parametros
           ▼
┌──────────────────────────┐
│   JokeDetailView         │ (Vista - Detalle)
│   Recibe id + jokeData   │
└──────────────────────────┘
```

##  Capturas de Pantalla

### Pantalla 1: Listado de Bromas

```
┌─────────────────────────────────┐
│ ← Chuck Norris Jokes      🔽    │  ← AppBar con filtro
├─────────────────────────────────┤
│ 😊 Chuck Norris Facts           │  ← Header
│ Categoria: DEV                  │
├─────────────────────────────────┤
│ ┌───────────────────────────┐   │
│ │ 🧔 Chuck Norris can...   │ → │  ← Card 1
│ │    #DEV                   │   │
│ └───────────────────────────┘   │
│ ┌───────────────────────────┐   │
│ │ 🧔 Chuck Norris doesn't.. │ → │  ← Card 2
│ │    #MOVIE                 │   │
│ └───────────────────────────┘   │
│ ┌───────────────────────────┐   │
│ │ 🧔 When Chuck Norris...   │ → │  ← Card 3
│ │    (Sin categoria)        │   │
│ └───────────────────────────┘   │
│           ⋮                     │
└─────────────────────────────────┘
```

### Pantalla 2: Detalle de Broma

```
┌─────────────────────────────────┐
│ ← Detalle                       │  ← AppBar
├─────────────────────────────────┤
│         ╔═══════════╗           │
│         ║           ║           │
│         ║   🧔👊    ║           │  ← Imagen Hero
│         ║           ║           │
│         ╚═══════════╝           │
├─────────────────────────────────┤
│  Chuck Norris Fact            │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Chuck Norris can divide by  │ │  ← Texto completo
│ │ zero and get infinity       │ │
│ └─────────────────────────────┘ │
│                                 │
│ Categorias:                     │
│ [DEV] [SCIENCE]                 │  ← Categorias
│                                 │
│ 🔖 ID: SR9ceDDCQX2...           │  ← ID
│                                 │
│ [Copiar]   [Info]               │  ← Botones
│ [← Volver al Listado]           │
└─────────────────────────────────┘
```

### Estado: Cargando

```
┌─────────────────────────────────┐
│ ← Chuck Norris Jokes      🔽    │
├─────────────────────────────────┤
│                                 │
│                                │
│     Cargando bromas...          │  ← CircularProgressIndicator
│                                 │
└─────────────────────────────────┘
```

### Estado: Error

```
┌─────────────────────────────────┐
│ ← Chuck Norris Jokes      🔽    │
├─────────────────────────────────┤
│                                 │
│                                │
│         Error                   │
│ Error de conexion: timeout      │  ← Mensaje de error
│                                 │
│      [Reintentar]               │  ← Boton
│                                 │
└─────────────────────────────────┘
```

## 📊 Categorias Disponibles

Las categorias de Chuck Norris incluyen:

- `animal` - Bromas sobre animales
- `career` - Sobre carreras profesionales
- `celebrity` - Sobre celebridades
- `dev` - Para desarrolladores
- `explicit` - Contenido explicito
- `fashion` - Sobre moda
- `food` - Sobre comida
- `history` - Historicas
- `money` - Sobre dinero
- `movie` - Sobre peliculas
- `music` - Sobre musica
- `political` - Politicas
- `religion` - Religiosas
- `science` - Cientificas
- `sport` - Deportivas
- `travel` - Sobre viajes

##  Mejoras Futuras

### Funcionalidades Adicionales
- [ ] Busqueda de bromas por texto
- [ ] Favoritos (almacenamiento local)
- [ ] Compartir bromas en redes sociales
- [ ] Historial de bromas vistas
- [ ] Modo oscuro
- [ ] Animaciones de transicion
- [ ] Cache de bromas offline

### Optimizaciones
- [ ] Implementar Provider o Riverpod para state management
- [ ] Agregar tests unitarios
- [ ] Implementar Dio para HTTP avanzado
- [ ] Agregar retry logic
- [ ] Implementar paginacion

##  Notas Importantes

1. **No requiere API Key**: La Chuck Norris API es completamente gratuita
2. **Sin limite de rate**: No tiene restricciones de peticiones
3. **CORS habilitado**: Funciona desde web sin problemas
4. **HTTPS**: Todas las peticiones son seguras

##  Contribucion

Este es un proyecto educativo. Sientete libre de:
- Agregar nuevas funcionalidades
- Mejorar el diseno
- Optimizar el codigo
- Reportar bugs

##  Licencia

Proyecto educativo de codigo abierto.

---

**Desarrollado con** ❤️ **por estudiantes de Flutter UCEVA**

*Chuck Norris no necesita try-catch... los errores le tienen miedo* 😎
