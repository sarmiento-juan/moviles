# Taller Segundo Plano - Flutter UCEVA

Aplicación Flutter que demuestra el uso de **programación asíncrona** y **concurrencia** en Flutter, incluyendo Future, async/await, Timer e Isolates.

## 📋 Descripción del Proyecto

Esta aplicación educativa implementa ejemplos prácticos de manejo de tareas asíncronas y segundo plano en Flutter, mostrando las mejores prácticas para:
- Realizar peticiones asíncronas sin bloquear la UI
- Implementar cronómetros y temporizadores
- Ejecutar tareas pesadas en hilos separados (Isolates)

## 🎯 Requisitos Implementados

### 1️⃣ Asincronía con Future / async / await

**Ubicación:** `lib/taller_segundo_plano/views/future/`

**Implementación:**
- ✅ Servicio simulado (`DataService`) que consulta datos con `Future.delayed` (2-3 segundos)
- ✅ Uso de `async/await` para esperar resultados sin bloquear la UI
- ✅ Manejo de tres estados: **Cargando**, **Éxito** y **Error**
- ✅ Logs en consola mostrando el orden de ejecución (ANTES, DURANTE, DESPUÉS)
- ✅ Manejo de errores con try/catch
- ✅ Ejecución paralela de múltiples Futures con `Future.wait()`

**Características:**
```dart
// Ejemplo de uso
Future<void> _cargarUsuarios() async {
  print('🟡 [ANTES] Iniciando petición...');
  setState(() => _state = LoadingState.loading);
  
  try {
    print('🔵 [DURANTE] Procesando...');
    final usuarios = await DataService.fetchUsers();
    
    print('🟢 [DESPUÉS] Datos obtenidos');
    setState(() {
      _usuarios = usuarios;
      _state = LoadingState.success;
    });
  } catch (e) {
    print('🔴 [ERROR] $e');
    setState(() => _state = LoadingState.error);
  }
}
```

### 2️⃣ Timer - Cronómetro

**Ubicación:** `lib/taller_segundo_plano/views/future/timer_view.dart`

**Implementación:**
- ✅ **Iniciar**: Comienza el cronómetro desde 0
- ✅ **Pausar**: Detiene el cronómetro temporalmente
- ✅ **Reanudar**: Continúa desde donde se pausó
- ✅ **Reiniciar**: Vuelve a 0 y detiene el contador
- ✅ Actualización cada 1 segundo
- ✅ Formato de tiempo: MM:SS
- ✅ **Limpieza de recursos**: El timer se cancela automáticamente en `dispose()`
- ✅ Logs en consola de todos los eventos

**Características:**
```dart
// Timer que se actualiza cada segundo
_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  setState(() => _segundos++);
  print('⏱️ [TIMER] Tiempo: $_segundos segundos');
});

// Limpieza al salir
@override
void dispose() {
  _timer?.cancel(); // ¡Importante! Libera recursos
  super.dispose();
}
```

### 3️⃣ Isolate - Tareas Pesadas

**Ubicación:** `lib/taller_segundo_plano/views/isolate/isolate_view.dart`

**Implementación:**
- ✅ Función CPU-bound: Suma de números hasta 1,000,000,000
- ✅ Ejecución en Isolate usando `Isolate.spawn`
- ✅ Comunicación bidireccional con `SendPort` y `ReceivePort`
- ✅ Comparación: **Sin Isolate** (bloquea UI) vs **Con Isolate** (no bloquea)
- ✅ Ejecución de múltiples Isolates en paralelo
- ✅ Contador de UI visible que demuestra que la interfaz sigue respondiendo
- ✅ Resultado mostrado en la UI con tiempo de ejecución

**Diferencias demostradas:**
- 🔴 **Sin Isolate**: La UI se congela durante el cálculo
- 🟢 **Con Isolate**: La UI permanece fluida y responsiva
- 🟣 **Múltiples Isolates**: Procesamiento paralelo de varias tareas

**Características:**
```dart
// Crear y ejecutar Isolate
Future<void> _ejecutarConIsolate() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_tareaPesada, receivePort.sendPort);
  
  final sendPort = await receivePort.first as SendPort;
  final responsePort = ReceivePort();
  
  sendPort.send({'limite': 1000000000, 'replyPort': responsePort.sendPort});
  
  final resultado = await responsePort.first;
  setState(() => _resultado = resultado);
}

// Función que corre en el Isolate
static void _tareaPesada(SendPort sendPort) async {
  // Cálculo intensivo que NO bloquea la UI principal
  int suma = 0;
  for (int i = 0; i < limite; i++) {
    suma += i;
  }
  replyPort.send({'suma': suma, 'tiempo': tiempo});
}
```

## 📱 Pantallas de la Aplicación

### Flujo de Navegación

```
┌─────────────────┐
│   Home Screen   │ ← Pantalla inicial
└────────┬────────┘
         │
    ┌────┴────┐
    │ Drawer  │ ← Menú lateral
    └────┬────┘
         │
    ┌────┴─────────────────────────┐
    │                              │
    ├─ Future & Async/Await        │ → Estados: Cargando/Éxito/Error
    ├─ Timer (Cronómetro)          │ → Botones: Iniciar/Pausar/Reanudar/Reiniciar
    ├─ Isolate (Tareas Pesadas)    │ → Comparación: Sin Isolate vs Con Isolate
    ├─ Ciclo de Vida               │ → Demostración de lifecycle
    └─ Paso de Parámetros          │ → Navegación con parámetros
```

### Capturas de Funcionalidad

#### 1. Future & Async/Await
- Banner de estado (Inactivo/Cargando/Éxito/Error)
- Botones: "Recargar Usuarios" y "Dashboard"
- Lista de usuarios con información
- Manejo visual de errores con opción de reintentar

#### 2. Timer
- Marcador grande estilo cronómetro (MM:SS)
- Banner de estado (Detenido/Pausado/En ejecución)
- 4 botones de control con colores distintivos
- Panel de información con tiempo total en segundos

#### 3. Isolate
- Contador de UI que nunca se detiene
- Área de resultados con progreso
- 3 botones: "Sin Isolate", "Con Isolate", "Múltiples Isolates"
- Panel informativo con diferencias

## 🧠 Conceptos Clave

### ¿Cuándo usar Future y async/await?

**Usar Future cuando:**
- Necesitas realizar operaciones asíncronas (peticiones HTTP, lectura de archivos, consultas a BD)
- Quieres evitar bloquear la UI mientras esperas una respuesta
- Necesitas manejar errores de operaciones asíncronas
- Quieres ejecutar múltiples operaciones en paralelo

**Ejemplo de uso:**
```dart
// ✅ CORRECTO: No bloquea la UI
Future<List<User>> fetchUsers() async {
  await Future.delayed(Duration(seconds: 2)); // Simula red
  return userList;
}

// ❌ INCORRECTO: Bloquearía la UI
List<User> fetchUsersSync() {
  sleep(Duration(seconds: 2)); // ¡Bloquea todo!
  return userList;
}
```

### ¿Cuándo usar Timer?

**Usar Timer cuando:**
- Necesitas ejecutar código periódicamente (cronómetros, animaciones)
- Quieres implementar cuenta regresiva
- Necesitas actualizar la UI a intervalos regulares
- Quieres ejecutar código después de un delay

**Ejemplo de uso:**
```dart
// Timer único (ejecuta una vez después de 3 segundos)
Timer(Duration(seconds: 3), () {
  print('Han pasado 3 segundos');
});

// Timer periódico (ejecuta cada segundo)
Timer.periodic(Duration(seconds: 1), (timer) {
  print('Tick: ${timer.tick}');
  if (timer.tick >= 10) timer.cancel(); // Cancelar después de 10 ticks
});
```

**⚠️ IMPORTANTE:** Siempre cancelar el Timer en `dispose()`:
```dart
@override
void dispose() {
  _timer?.cancel(); // ¡Fundamental para evitar memory leaks!
  super.dispose();
}
```

### ¿Cuándo usar Isolate?

**Usar Isolate cuando:**
- Necesitas ejecutar cálculos pesados (procesamiento de imágenes, encriptación, parsing de JSON grandes)
- La operación tarda más de 16ms (causa lag en la UI)
- Quieres aprovechar múltiples núcleos del CPU
- Necesitas mantener la UI fluida durante procesamiento intensivo

**NO usar Isolate para:**
- Operaciones simples o rápidas
- Operaciones I/O (usar Future en su lugar)
- Cuando el overhead de crear el Isolate es mayor que el cálculo

**Ejemplo de uso:**
```dart
// ✅ BUENO: Procesamiento pesado en Isolate
Future<Image> processImage(Uint8List bytes) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_processImageIsolate, receivePort.sendPort);
  // ... comunicación con Isolate
}

// ❌ MALO: Operación simple en Isolate (overhead innecesario)
Future<int> addNumbers(int a, int b) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_add, receivePort.sendPort); // Overhead > beneficio
}
```

## 🏗️ Estructura del Proyecto

```
lib/taller_segundo_plano/
├── main.dart                      # Entry point de la aplicación
├── routes/
│   └── app_router.dart           # Configuración de rutas (GoRouter)
├── themes/
│   └── app_theme.dart            # Tema personalizado
├── views/
│   ├── home/
│   │   └── home_screen.dart      # Pantalla principal
│   ├── future/
│   │   ├── future_view.dart      # Vista de Future/async/await
│   │   ├── timer_view.dart       # Vista del cronómetro
│   │   └── data_service.dart     # Servicio simulado
│   ├── isolate/
│   │   └── isolate_view.dart     # Vista de Isolate
│   ├── ciclo_vida/
│   │   └── ciclo_vida_screen.dart
│   └── paso_parametros/
│       └── paso_parametros_screen.dart
└── widgets/
    ├── base_view.dart            # Widget base para pantallas
    └── custom_drawer.dart        # Menú lateral
```

## 🚀 Cómo Ejecutar

1. **Clonar el repositorio:**
```bash
git clone <url-del-repositorio>
cd moviles
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Ejecutar la aplicación:**
```bash
flutter run
```

4. **Ver logs en consola:**
Abre el terminal/consola para ver los mensajes de debug que muestran el orden de ejecución de las operaciones asíncronas.

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.6.2         # Navegación declarativa
  flutter_dotenv: ^5.2.1     # Variables de entorno
  cupertino_icons: ^1.0.8    # Iconos iOS
```

## 🎓 Aprendizajes Clave

### 1. Future vs Isolate
- **Future**: Para operaciones I/O (red, archivos, BD)
- **Isolate**: Para operaciones CPU-bound (cálculos, procesamiento)

### 2. Manejo de Estados
- Siempre verificar `mounted` antes de llamar `setState()`
- Usar enums para estados claros (`LoadingState`)
- Dar feedback visual al usuario

### 3. Limpieza de Recursos
- Cancelar Timers en `dispose()`
- Cerrar Streams y ReceivePorts
- Usar `try-finally` para garantizar limpieza

### 4. Mejores Prácticas
```dart
// ✅ BUENO: Verificar mounted
if (!mounted) return;
setState(() {});

// ✅ BUENO: Liberar recursos
@override
void dispose() {
  _timer?.cancel();
  _controller.dispose();
  super.dispose();
}

// ✅ BUENO: Manejo de errores
try {
  final data = await fetchData();
} catch (e) {
  print('Error: $e');
  setState(() => _error = e.toString());
}
```

## 📊 Comparativa de Rendimiento

| Operación | Sin Isolate | Con Isolate |
|-----------|-------------|-------------|
| UI bloqueada | ✅ Sí | ❌ No |
| Múltiples núcleos | ❌ No | ✅ Sí |
| Overhead | Bajo | Medio |
| Uso ideal | Tareas rápidas | Tareas pesadas |

## 🐛 Debugging

### Ver logs de Future:
- Busca `🟡 [ANTES]`, `🔵 [DURANTE]`, `🟢 [DESPUÉS]` en la consola

### Ver logs de Timer:
- Busca `⏱️ [TIMER]` en la consola

### Ver logs de Isolate:
- Busca `🧵 [ISOLATE]` en la consola

## 👨‍💻 Autor

**Juan Manuel Sarmiento Cubidez**
- Universidad: UCEVA
- Proyecto: Taller de Segundo Plano en Flutter

## 📝 Notas Adicionales

- Todos los servicios son **simulados** para fines educativos
- Los delays están configurados a 2-3 segundos para facilitar la observación
- Los cálculos en Isolate suman hasta 1,000,000,000 para demostrar carga CPU

## 🔗 Referencias

- [Flutter Async Documentation](https://dart.dev/codelabs/async-await)
- [Dart Isolates](https://dart.dev/guides/language/concurrency)
- [Timer Class](https://api.flutter.dev/flutter/dart-async/Timer-class.html)
- [GoRouter Package](https://pub.dev/packages/go_router)

---

**Fecha:** Octubre 2025  
**Versión:** 1.0.0

