# Taller Segundo Plano - Flutter

Aplicación que demuestra el uso de **programación asíncrona** y **concurrencia** en Flutter.

## 📋 Descripción

Esta aplicación implementa ejemplos prácticos de:
- ✅ **Future / async / await** - Operaciones asíncronas
- ✅ **Timer** - Cronómetros y temporizadores
- ✅ **Isolate** - Procesamiento en segundo plano

## 🎯 Requisitos Implementados

### 1️⃣ Asincronía con Future / async / await

**Archivo:** `views/future/future_view.dart`

**Características:**
- Servicio simulado con `Future.delayed` (2-3 segundos)
- Manejo de 3 estados: Cargando 🟡, Éxito 🟢, Error 🔴
- Logs en consola: `[ANTES]`, `[DURANTE]`, `[DESPUÉS]`
- Manejo de errores con try/catch
- Ejecución paralela con `Future.wait()`

**Ejemplo de código:**
```dart
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

**Archivo:** `views/future/timer_view.dart`

**Características:**
- ✅ Botón **Iniciar** - Comienza desde 0
- ✅ Botón **Pausar** - Detiene temporalmente
- ✅ Botón **Reanudar** - Continúa desde donde pausó
- ✅ Botón **Reiniciar** - Vuelve a 0
- ✅ Actualización cada 1 segundo
- ✅ Formato MM:SS
- ✅ Limpieza automática en `dispose()`

**Ejemplo de código:**
```dart
void _iniciarTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() => _segundos++);
    print('⏱️ [TIMER] Tiempo: $_segundos segundos');
  });
}

@override
void dispose() {
  _timer?.cancel(); // ¡Importante! Libera recursos
  super.dispose();
}
```

### 3️⃣ Isolate - Tareas Pesadas

**Archivo:** `views/isolate/isolate_view.dart`

**Características:**
- Función CPU-bound: suma hasta 1,000,000,000
- Uso de `Isolate.spawn`
- Comunicación con `SendPort` y `ReceivePort`
- 3 modos de demostración:
  - 🔴 **Sin Isolate** - Bloquea la UI
  - 🟢 **Con Isolate** - UI fluida
  - 🟣 **Múltiples Isolates** - Procesamiento paralelo
- Contador de UI visible que demuestra que no se bloquea

**Ejemplo de código:**
```dart
Future<void> _ejecutarConIsolate() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_tareaPesada, receivePort.sendPort);
  
  final sendPort = await receivePort.first as SendPort;
  final responsePort = ReceivePort();
  
  sendPort.send({
    'limite': 1000000000,
    'replyPort': responsePort.sendPort,
  });
  
  final resultado = await responsePort.first;
  setState(() => _resultado = resultado);
}

static void _tareaPesada(SendPort sendPort) async {
  // Cálculo intensivo que NO bloquea la UI principal
  int suma = 0;
  for (int i = 0; i < limite; i++) {
    suma += i;
  }
  replyPort.send({'suma': suma, 'tiempo': tiempo});
}
```

##  Pantallas

### Menú Principal
- **Home Screen** - Pantalla de bienvenida
- **Drawer** - Menú lateral con todas las opciones

### Sección ASINCRONÍA
1. **Future & Async/Await**
   - Estados visuales (Inactivo/Cargando/Éxito/Error)
   - Botones: "Recargar Usuarios" y "Dashboard"
   - Lista de usuarios
   - Manejo de errores

2. **Timer**
   - Cronómetro en formato MM:SS
   - 4 botones de control
   - Estado visual en tiempo real

3. **Isolate**
   - Contador de UI (demuestra que no se bloquea)
   - Área de resultados
   - 3 botones de prueba
   - Comparativa de rendimiento

##  Estructura del Proyecto

```
taller_segundo_plano/
├── main.dart                      # Entry point
├── routes/
│   └── app_router.dart           # GoRouter config
├── themes/
│   └── app_theme.dart            # Tema Material 3
├── views/
│   ├── home/
│   │   └── home_screen.dart
│   ├── future/
│   │   ├── future_view.dart      # Future/async demo
│   │   ├── timer_view.dart       # Timer/cronómetro
│   │   └── data_service.dart     # Servicio simulado
│   ├── isolate/
│   │   └── isolate_view.dart     # Isolate demo
│   ├── ciclo_vida/
│   │   └── ciclo_vida_screen.dart
│   └── paso_parametros/
│       └── paso_parametros_screen.dart
└── widgets/
    ├── base_view.dart            # Widget base
    └── custom_drawer.dart        # Menú lateral
```

##  Cómo Ejecutar

```bash
# Desde la raíz del proyecto Flutter
flutter run
```

O ejecuta el archivo directamente:
```bash
flutter run lib/taller_segundo_plano/main.dart
```

## Logs en Consola

La aplicación imprime logs para seguir el flujo:

- `🟡 [ANTES]` - Antes de iniciar
- `🔵 [DURANTE]` - Durante la ejecución
- `🟢 [DESPUÉS]` - Al completar
- `🔴 [ERROR]` - Si hay error
- `⏱️ [TIMER]` - Eventos del cronómetro
- `🧵 [ISOLATE]` - Operaciones en Isolate

## 🎓 Mejores Prácticas

### 1. Verificar mounted
```dart
if (!mounted) return;
setState(() {});
```

### 2. Liberar recursos
```dart
@override
void dispose() {
  _timer?.cancel();
  _controller.dispose();
  super.dispose();
}
```

### 3. Manejo de errores
```dart
try {
  final data = await fetchData();
} catch (e) {
  print('Error: $e');
  setState(() => _error = e.toString());
}
```

##  Dependencias

```yaml
dependencies:
  go_router: ^14.6.2         # Navegación
  flutter_dotenv: ^5.2.1     # Variables de entorno
```

##  Debugging

```bash
# Ver dispositivos
flutter devices

# Ejecutar con logs
flutter run -v

# Ver logs de Android
adb logcat
```

##  Comparativa

| Característica | Future | Timer | Isolate |
|----------------|--------|-------|---------|
| Uso principal | I/O async | Períódico | CPU-bound |
| Bloquea UI | No | No | No |
| Múltiples hilos | No | No | Sí |
| Overhead | Bajo | Bajo | Medio |

##  Tips

1. **Hot Reload:** Presiona `r` durante ejecución
2. **Hot Restart:** Presiona `R` durante ejecución
3. **Logs:** Abre la consola de debug
4. **Performance:** Usa Isolate solo para tareas pesadas

##  Solución de Problemas

Si el emulador no conecta:
```bash
adb kill-server
adb start-server
adb devices
```

Si hay errores de compilación:
```bash
flutter clean
flutter pub get
flutter run
```
##  Autor

**Juan Manuel Sarmiento Cubidez**  
Universidad: UCEVA  
Fecha: Octubre 2025

---

**Versión:** 1.0.0  
**Flutter:** 3.35.3  
**Dart:** 3.9.2
