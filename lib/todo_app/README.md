# 📋 To-Do List App - Flutter con SQLite y Sincronización Offline

Aplicación profesional de **gestión de tareas** construida con Flutter, demostrando arquitectura limpia, persistencia local con SQLite, y sincronización offline-first con API REST.

---

## 🎯 Objetivos del Proyecto

✅ Evaluar habilidades en **Flutter 3.x** moderno  
✅ Implementar **gestión de estado** con Provider  
✅ Crear **arquitectura limpia** (data/domain/presentation)  
✅ Integrar **API REST** con Dio y manejo de errores  
✅ Implementar **SQLite** con sqflite para offline  
✅ Crear **sincronización inteligente** con backoff exponencial  
✅ Aplicar **buenas prácticas** (documentación, control de versiones)  

---

## ✨ Características Principales

### 📱 Funcionalidad CRUD
- ✅ **Crear** nuevas tareas
- ✅ **Leer** tareas en tiempo real
- ✅ **Actualizar** información
- ✅ **Eliminar** tareas con confirmación
- ✅ **Marcar** como completadas

### 🔄 Offline-First
- ✅ Leer datos locales primero
- ✅ Escribir en local inmediatamente
- ✅ Sincronizar cuando hay conexión
- ✅ Indicador visual de estado offline
- ✅ Cola de operaciones pendientes

### 🌐 Sincronización
- ✅ Detección automática de conectividad
- ✅ Reintentos con backoff exponencial
- ✅ Manejo de conflictos (Last-Write-Wins)
- ✅ Idempotency-Key para evitar duplicados
- ✅ Logging de errores

### 📊 Filtros
- ✅ Todas las tareas
- ✅ Tareas pendientes
- ✅ Tareas completadas
- ✅ Pull-to-refresh manual

### 🎨 Interfaz Profesional
- ✅ Material Design 3
- ✅ Indicadores de estado
- ✅ Manejo de errores visual
- ✅ Estados de carga
- ✅ Tema personalizado

---

## 🏗️ Arquitectura

```
todo_app/
│
├── 📁 data/
│   ├── local/
│   │   └── task_local_datasource.dart          # SQLite operations
│   └── remote/
│       └── task_remote_datasource.dart         # API operations
│
├── 📁 models/
│   └── task.dart                               # Task data model
│
├── 📁 repositories/
│   └── task_repository.dart                    # Offline-first orchestration
│
├── 📁 providers/
│   ├── task_provider.dart                      # State management
│   └── connectivity_provider.dart              # Network status
│
├── 📁 services/
│   └── sync_service.dart                       # Sync logic with retry
│
├── 📁 views/
│   ├── task_list_view.dart                     # List screen
│   └── task_form_view.dart                     # Form screen
│
├── 📁 widgets/
│   └── task_widgets.dart                       # Reusable UI components
│
├── 📁 utils/
│   └── constants.dart                          # App constants
│
└── main.dart                                    # App entry point
```

### Capas Arquitectónicas

```
┌─────────────────────────────────────────┐
│       Presentation Layer (UI)            │
│  (Views, Widgets, Dialogs)               │
├─────────────────────────────────────────┤
│       Business Logic Layer               │
│  (Providers, State Management)           │
├─────────────────────────────────────────┤
│       Repository Layer                   │
│  (Offline-First Orchestration)           │
├─────────────────────────────────────────┤
│       Data Sources Layer                 │
│  (Local SQLite, Remote API)              │
├─────────────────────────────────────────┤
│       Database & Network Layer           │
│  (SQLite, Dio/HTTP)                      │
└─────────────────────────────────────────┘
```

---

## 🛠️ Tecnologías Utilizadas

### Framework
- **Flutter 3.x** - Cross-platform UI framework
- **Dart 3.x** - Programming language

### State Management
- **Provider 6.0+** - ChangeNotifier + Consumer pattern

### Local Database
- **sqflite 2.2+** - SQLite for Dart
- **path** - File path handling

### Remote API
- **dio 5.3+** - HTTP client with interceptors
- **uuid 3.0+** - Generate unique IDs

### Network
- **connectivity_plus 4.0+** - Monitor network status

### Utilities
- **intl 0.18+** - Date formatting
- **flutter_dotenv** - Environment variables

---

## 📋 Schema de Base de Datos

### Tabla: `tasks`
```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  completed INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL,
  deleted INTEGER NOT NULL DEFAULT 0
)
```

### Tabla: `queue_operations`
```sql
CREATE TABLE queue_operations (
  id TEXT PRIMARY KEY,
  entity TEXT NOT NULL,           -- 'task'
  entity_id TEXT NOT NULL,
  op TEXT NOT NULL,               -- CREATE | UPDATE | DELETE
  payload TEXT NOT NULL,          -- JSON serialized
  created_at INTEGER NOT NULL,    -- Timestamp
  attempt_count INTEGER DEFAULT 0,
  last_error TEXT,
  synced INTEGER NOT NULL DEFAULT 0
)
```

---

## 🔌 API Rest - Contrato de Endpoints

### Base URL
```
http://localhost:3000
```

### Endpoints

#### GET /tasks
Obtener todas las tareas
```bash
curl http://localhost:3000/tasks
```
**Response:**
```json
[
  {
    "id": "1",
    "title": "Completar proyecto",
    "completed": false,
    "updatedAt": "2024-01-15T10:30:00Z"
  }
]
```

#### POST /tasks
Crear nueva tarea
```bash
curl -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: unique-id" \
  -d '{
    "id": "1",
    "title": "Nueva tarea",
    "completed": false,
    "updatedAt": "2024-01-15T10:30:00Z"
  }'
```
**Response:** `201 Created` + Task object

#### GET /tasks/{id}
Obtener tarea por ID
```bash
curl http://localhost:3000/tasks/1
```

#### PUT /tasks/{id}
Actualizar tarea
```bash
curl -X PUT http://localhost:3000/tasks/1 \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: unique-id" \
  -d '{...}'
```
**Response:** `200 OK` + Updated task

#### DELETE /tasks/{id}
Eliminar tarea
```bash
curl -X DELETE http://localhost:3000/tasks/1 \
  -H "Idempotency-Key: unique-id"
```
**Response:** `200 OK` or `204 No Content`

---

## 🚀 Instalación y Ejecución

### 1. Prerequisitos
```bash
flutter --version  # >= 3.0
dart --version     # >= 3.0
```

### 2. Clonar repositorio
```bash
git clone <repository-url>
cd moviles
```

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Configurar API (opcional)
Editar `lib/todo_app/main.dart` y cambiar:
```dart
baseUrl: 'http://localhost:3000'
```

### 5. Ejecutar
```bash
# En Windows desktop
flutter run -d windows -t lib/todo_app/main.dart

# En emulador Android
flutter run -d emulator-5554 -t lib/todo_app/main.dart

# En iOS
flutter run -d iphone -t lib/todo_app/main.dart
```

### 6. Generar APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```
APK ubicado en: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Testing - Modo Offline

### Prueba 1: Crear tarea sin conexión
1. Desconectar WiFi/móvil
2. Crear nueva tarea
3. Verificar que aparezca localmente
4. Abrir base de datos: `build/app/debug/tasks.db`
5. Verificar que la operación está en `queue_operations`

### Prueba 2: Sincronizar al recuperar conexión
1. Crear tarea sin conexión
2. Reconectar internet
3. App debería sincronizar automáticamente
4. Verificar en API que la tarea existe

### Prueba 3: Conflictos de sincronización
1. Editar tarea localmente
2. Editar misma tarea desde otro cliente/web
3. Reconectar
4. Verificar que ganó la versión más nueva (Last-Write-Wins)

### Prueba 4: Reintentos con backoff
1. Desconectar API (o cambiar URL a inválida)
2. Crear tarea
3. Reconectar API
4. Verificar reintentos en logs: 1s, 2s, 4s, 8s, 16s, 32s

---

## 📊 Monitoreo y Debugging

### SQLite Browser
Para ver datos locales:
```bash
# Windows
sqlite3 "C:\Users\[User]\AppData\Local\Google\AndroidStudio\system\sqlite\todo_app.db"

# Comandos útiles
.tables                          # Ver tablas
SELECT * FROM tasks;             # Ver tareas
SELECT * FROM queue_operations;  # Ver operaciones pendientes
```

### Logs de Dio
Habilitar logs para ver requests/responses:
```dart
_dio.interceptors.add(
  LogInterceptor(
    requestBody: true,
    responseBody: true,
  ),
);
```

### Profiler de Provider
```dart
debugPrintBeginFrameBanner = true;
debugPrintEndFrameBanner = true;
```

---

## 🔐 Seguridad

### Consideraciones implementadas
- ✅ Validación de entrada en formularios
- ✅ Manejo seguro de errores (no exponer detalles)
- ✅ Timeouts en requests
- ✅ Idempotency-Key para evitar duplicados

### TODO (Future improvements)
- [ ] Encriptación de datos locales
- [ ] Token de autenticación
- [ ] Rate limiting en cliente
- [ ] Validación en servidor (HTTPS)

---

## 📈 Performance

### Optimizaciones implementadas
- ✅ Índices en SQLite para queries rápidas
- ✅ Paginación (preparada para implementar)
- ✅ Lazy loading de tareas
- ✅ Provider para evitar reconstrucciones innecesarias

### Métricas esperadas
- Time to First Paint: < 500ms
- List scroll: 60 FPS
- Sync operations: < 2s por tarea

---

## 🐛 Troubleshooting

### Problema: "database is locked"
**Solución:** Cerrar otras conexiones SQLite o reiniciar app

### Problema: API no responde
**Solución:** Verificar que json-server está corriendo en puerto 3000

### Problema: Cambios no se sincronizan
**Solución:** Verificar conectividad, revisar logs de Dio, verificar URL base

### Problema: Duplicados en base de datos
**Solución:** Usar Idempotency-Key, implementar upsert en API

---

## 📚 Documentos Relacionados

- `CONFIGURACION.md` - Setup detallado de dependencias
- `EJEMPLOS_CODIGO.md` - Snippets de código
- `ARQUITECTURA_AVANZADA.md` - Detalle técnico

---

## 📝 Checklist de Requisitos

| Requisito | Estado | Evidencia |
|-----------|--------|----------|
| Flutter 3.x | ✅ | pubspec.yaml |
| Provider para estado | ✅ | task_provider.dart |
| Capa data separada | ✅ | data/local, data/remote |
| SQLite offline | ✅ | task_local_datasource.dart |
| API REST | ✅ | task_remote_datasource.dart |
| Manejo de errores | ✅ | ApiException, error_widget.dart |
| Sincronización | ✅ | sync_service.dart, backoff exponencial |
| Documentación | ✅ | README.md + comentarios en código |
| APK generado | ✅ | build/app/outputs/flutter-apk/ |

---

## 🤝 Contribución

Para contribuir:
1. Crear rama: `git checkout -b feature/nueva-funcionalidad`
2. Commit: `git commit -m "Agregar nueva funcionalidad"`
3. Push: `git push origin feature/nueva-funcionalidad`
4. Pull Request

---


**Lenguaje:** Dart 3.x + Flutter 3.x  
**Arquitectura:** Clean Architecture + Offline-First  
**Base de Datos:** SQLite + JSON-Server API


