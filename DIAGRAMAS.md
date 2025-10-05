# Diagramas y Flujos - Taller Segundo Plano

## 📊 Diagrama de Arquitectura de la Aplicación

```
┌─────────────────────────────────────────────────────────┐
│                     APLICACIÓN FLUTTER                   │
│                  (Main Thread - UI Thread)               │
└───────────────────┬─────────────────────────────────────┘
                    │
        ┌───────────┴────────────┐
        │                        │
    ┌───▼────┐            ┌──────▼──────┐
    │ Future │            │   Isolate   │
    │ async/ │            │  (Worker    │
    │ await  │            │   Thread)   │
    └───┬────┘            └──────┬──────┘
        │                        │
        │                        │
    Event Loop            Separate Thread
    (UI Thread)          (Compute Thread)
```

## 🔄 Flujo de Future/Async/Await

```
Usuario presiona "Recargar Usuarios"
           │
           ▼
    ┌──────────────────┐
    │ setState()       │
    │ Loading = true   │ 🟡 ANTES: UI muestra "Cargando..."
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ await            │ 🔵 DURANTE: Espera 2-3 segundos
    │ DataService      │     (UI sigue respondiendo)
    │ .fetchUsers()    │
    └────────┬─────────┘
             │
        ┌────┴────┐
        │         │
    Success   Error
        │         │
        ▼         ▼
    ┌───────┐ ┌──────┐
    │ 🟢    │ │ 🔴   │ 
    │ Lista │ │ Error│
    │ Datos │ │ Msg  │
    └───────┘ └──────┘
```

## ⏱️ Flujo del Timer

```
Estado Inicial: DETENIDO
       │
       ▼ [Botón: Iniciar]
    ┌──────────────────┐
    │ CORRIENDO        │ ◄──────┐
    │ Timer.periodic   │        │
    │ cada 1 segundo   │        │
    └────┬─────────────┘        │
         │                      │
         ▼ [Botón: Pausar]      │
    ┌──────────────────┐        │
    │ PAUSADO          │        │
    │ timer.cancel()   │        │
    └────┬─────────────┘        │
         │                      │
         ▼ [Botón: Reanudar] ───┘
         │
         ▼ [Botón: Reiniciar]
    ┌──────────────────┐
    │ DETENIDO         │
    │ segundos = 0     │
    └──────────────────┘
```

## 🧵 Flujo de Isolate

### Sin Isolate (Bloquea UI):
```
Usuario presiona "Sin Isolate"
           │
           ▼
    ┌──────────────────┐
    │ Cálculo pesado   │
    │ EN HILO PRINCIPAL│ ❌ UI BLOQUEADA
    │ (1 billion sum)  │    - No responde
    │                  │    - No actualiza
    │ ... 5-10 seg ... │    - Usuario espera
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Resultado        │
    │ mostrado         │
    └──────────────────┘
```

### Con Isolate (NO bloquea UI):
```
Usuario presiona "Con Isolate"
           │
           ▼
    ┌──────────────────────────────────────┐
    │ Hilo Principal (UI)                  │
    │ ┌─────────────────┐                  │
    │ │ ReceivePort     │                  │
    │ │ created         │                  │
    │ └────────┬────────┘                  │
    │          │                           │
    │          ▼                           │
    │ ┌─────────────────┐                  │
    │ │ Isolate.spawn   │                  │
    │ └────────┬────────┘                  │
    │          │                           │
    │  ┌───────┴──────────────────────┐    │
    │  │                              │    │
    │  ▼                              │    │
    │ UI sigue                        │    │
    │ respondiendo ✅                 │    │
    │ - Contador activo               │    │
    │ - Botones funcionan             │    │
    │ - Scroll funciona               │    │
    └─────────────────────────────────┼────┘
                                      │
                    ┌─────────────────▼─────────────┐
                    │ Isolate (Hilo Separado)       │
                    │ ┌──────────────────┐          │
                    │ │ Cálculo pesado   │          │
                    │ │ (1 billion sum)  │          │
                    │ │ ... 5-10 seg ... │          │
                    │ └────────┬─────────┘          │
                    │          │                    │
                    │          ▼                    │
                    │ ┌──────────────────┐          │
                    │ │ SendPort.send()  │          │
                    │ │ resultado        │          │
                    │ └────────┬─────────┘          │
                    └──────────┼────────────────────┘
                               │
                    ┌──────────▼───────────┐
                    │ UI recibe resultado  │
                    │ setState() con data  │
                    └──────────────────────┘
```

## 📊 Comparación: Future vs Isolate

```
┌─────────────────────────────────────────────────────────────┐
│                    CUANDO USAR CADA UNO                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FUTURE / ASYNC / AWAIT                                     │
│  ✅ Operaciones I/O                                         │
│     - HTTP requests                                         │
│     - File reading/writing                                  │
│     - Database queries                                      │
│  ✅ Operaciones rápidas (<16ms)                            │
│  ✅ Esperar múltiples operaciones (Future.wait)            │
│                                                             │
│  ❌ NO usar para cálculos pesados                          │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ISOLATE                                                    │
│  ✅ Cálculos CPU-bound                                      │
│     - Procesamiento de imágenes                             │
│     - Parsing de JSON grande                                │
│     - Encriptación/Desencriptación                          │
│     - Algoritmos complejos                                  │
│  ✅ Tareas que tardan >16ms                                │
│  ✅ Aprovechar múltiples núcleos                           │
│                                                             │
│  ❌ NO usar para operaciones I/O                           │
│  ❌ NO usar para tareas simples                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Estados de la Aplicación

### Future View - Estados:
```
┌──────────────┐
│   IDLE       │ ⚪ Esperando acción del usuario
└──────┬───────┘
       │
       ▼ [Usuario presiona botón]
┌──────────────┐
│   LOADING    │ 🟡 CircularProgressIndicator visible
└──────┬───────┘
       │
   ┌───┴───┐
   │       │
   ▼       ▼
┌────┐  ┌───────┐
│SUCCESS│ │ ERROR │
│  🟢   │ │  🔴   │
└───────┘ └───────┘
```

### Timer - Estados:
```
DETENIDO ──[Iniciar]──> CORRIENDO ──[Pausar]──> PAUSADO
   ▲                       │                      │
   │                       │                      │
   └──────[Reiniciar]──────┴─────[Reiniciar]─────┘
```

## 📱 Estructura de Navegación

```
lib/taller_segundo_plano/
│
├── main.dart ─────────────────► MaterialApp.router
│                                      │
│                                      ▼
├── routes/                      GoRouter Config
│   └── app_router.dart               │
│                                      │
│                    ┌─────────────────┼─────────────────┐
│                    │                 │                 │
│                    ▼                 ▼                 ▼
├── views/        Home            Future             Isolate
│   ├── home/       │                │                 │
│   ├── future/     │                │                 │
│   ├── isolate/    │                ▼                 │
│   ├── ciclo_vida/ │             Timer                │
│   └── paso_param/ │                                  │
│                    │                                  │
│                    └──────────┬───────────────────────┘
│                               │
├── widgets/                    │
│   ├── base_view.dart ◄────────┘ (Usado por todas)
│   └── custom_drawer.dart ◄────── (Menú lateral)
│
└── themes/
    └── app_theme.dart ◄──────────── (Tema global)
```

## 🔄 Ciclo de Vida de un Widget con Timer

```
┌────────────────────┐
│ initState()        │ ← Crear Timer aquí
│ - Crear Timer      │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│ build()            │ ← Mostrar UI
│ - Mostrar tiempo   │
└─────────┬──────────┘
          │
          ▼ (Timer.periodic ejecutándose)
┌────────────────────┐
│ setState()         │ ← Cada tick del Timer
│ - Actualizar UI    │
└─────────┬──────────┘
          │
          │ (Bucle mientras está activo)
          │
          ▼
┌────────────────────┐
│ dispose()          │ ← IMPORTANTE: Cancelar Timer
│ - timer?.cancel()  │
└────────────────────┘
```

## 📊 Event Loop de Flutter

```
                    ┌─────────────────┐
                    │  EVENT LOOP     │
                    │  (UI Thread)    │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
          ▼                  ▼                  ▼
    ┌──────────┐      ┌──────────┐      ┌──────────┐
    │ Microtask│      │  Events  │      │ Rendering│
    │  Queue   │      │  Queue   │      │  (60fps) │
    └──────────┘      └──────────┘      └──────────┘
                            │
                            │ Incluye:
                            │ - Future completions
                            │ - Timer callbacks
                            │ - User interactions
                            │ - Stream events
```

## 🎨 Paleta de Colores de Estados

```
🟡 LOADING    - Amarillo/Naranja  - En progreso
🟢 SUCCESS    - Verde             - Completado con éxito
🔴 ERROR      - Rojo              - Error/Fallo
⚪ IDLE       - Gris              - Sin actividad
🟣 PROCESSING - Morado            - Múltiples procesos
🔵 INFO       - Azul              - Información
```

## 📈 Rendimiento: Future vs Isolate

```
Operación: Suma de 1 billón de números

┌─────────────────────────────────────────┐
│ SIN ISOLATE (Main Thread)               │
│ ████████████████████████████████████    │ 100% CPU Main Thread
│ UI BLOQUEADA por 5-10 segundos          │
│ FPS: 0 (congelada)                      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ CON ISOLATE (Separate Thread)           │
│ Main:  ██                              │  5% CPU Main Thread
│ Worker: ████████████████████████████   │ 95% CPU Worker Thread
│ UI FLUIDA - 60 FPS mantenidos           │
│ FPS: 60 (smooth)                        │
└─────────────────────────────────────────┘
```

---

**Nota:** Estos diagramas son representaciones conceptuales para facilitar el entendimiento de los conceptos de asincronía y concurrencia en Flutter.
