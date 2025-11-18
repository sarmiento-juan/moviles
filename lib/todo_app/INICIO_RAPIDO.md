# 🚀 Guía Rápida de Inicio

## ⚡ En 5 minutos

### 1. Instalar dependencias
```bash
cd moviles
flutter pub get
```

### 2. Iniciar API mock
```bash
# En otra terminal
npm install -g json-server
json-server --watch db.json --port 3000
```

### 3. Ejecutar app
```bash
flutter run -d windows -t lib/todo_app/main.dart
# o en emulador/dispositivo
flutter run -d emulator-5554 -t lib/todo_app/main.dart
```

### 4. ¡Listo!
- Crear tarea: Tap en botón "+"
- Editar: Menú en la tarjeta
- Eliminar: Confirmar en diálogo
- Filtrar: Botones de filtro

---

## 🎯 Primeras acciones

### ✅ 1. Crear tu primera tarea
1. Abre la app
2. Tap en botón azul "+" (abajo derecha)
3. Escribe: "Mi primer tarea"
4. Tap "Crear"

**Esperado:** Tarea aparece en la lista

### ✅ 2. Marcar como completada
1. Tap en checkbox de la tarea
2. Tarea se marca con ✓

**Esperado:** Aparece tachada

### ✅ 3. Filtrar tareas
1. Tap en "Pendientes"
2. Solo muestra tareas sin completar

**Esperado:** Filtro funciona

### ✅ 4. Probar offline
1. Desconectar WiFi/móvil
2. Crear nueva tarea
3. Aparece indicador naranja "Modo sin conexión"
4. Reconectar internet

**Esperado:** Tarea se sincroniza automáticamente

### ✅ 5. Ver base de datos
```bash
sqlite3 "~/.local/share/Flutter/tasks/todo_app.db"
> SELECT * FROM tasks;
```

**Esperado:** Ves tus tareas almacenadas

---

## 🔧 Troubleshooting Rápido

| Problema | Solución |
|----------|----------|
| "API connection refused" | Iniciar json-server en puerto 3000 |
| App tarda en cargar | Normal primera vez, usa hot reload después |
| Base de datos vacía | Asegúrate de crear tareas |
| Cambios no se ven | Hot reload: `r` en terminal |
| Emulador lento | Usar Windows desktop: `flutter run -d windows` |

---

## 📚 Próximos pasos

1. **Leer README.md** - Entiende la arquitectura
2. **Explorar código** - Ve estructura del proyecto
3. **Ver EJEMPLOS_CODIGO.md** - Aprende patrones
4. **Modificar UI** - Personaliza colores, fuentes
5. **Implementar feature** - Agrega nueva funcionalidad

---

## 🎓 Conceptos clave aprendidos

- ✅ **Offline-First** - Lee local, escribe local, sincroniza en background
- ✅ **SQLite** - Persistencia local con sqflite
- ✅ **Provider** - Gestión de estado con ChangeNotifier
- ✅ **Dio** - HTTP client con interceptores
- ✅ **Clean Architecture** - Capas separadas (data, domain, presentation)
- ✅ **Error Handling** - Manejo robusto de excepciones
- ✅ **Connectivity** - Detectar cambios de red

---

## 📊 Archivo de configuración db.json (referencia)

```json
{
  "tasks": [
    {
      "id": "1704067800000_completar-proyecto",
      "title": "Completar proyecto Flutter",
      "completed": false,
      "updatedAt": "2024-01-01T10:00:00Z"
    },
    {
      "id": "1704067800000_revisar-docs",
      "title": "Revisar documentación",
      "completed": true,
      "updatedAt": "2024-01-01T11:00:00Z"
    }
  ]
}
```

---

## 🎬 Demostración paso a paso

**Escenario: Crear y sincronizar tarea offline**

```
Paso 1: Desconectar internet
┌─────────────────────┐
│ 📱 App              │
│ ☁️ Sin conexión     │
└─────────────────────┘

Paso 2: Crear tarea "Comprar leche"
┌─────────────────────┐
│ 📱 App              │
│ [+] Nueva tarea → Crear
│ ✅ Tarea local     │
│ ❌ No en servidor  │
└─────────────────────┘

Paso 3: Verificar operación en cola
SQLite queue_operations:
{
  "id": "op_123",
  "op": "CREATE",
  "entity_id": "task_456",
  "synced": 0  ← pendiente
}

Paso 4: Reconectar internet
┌─────────────────────┐
│ 📱 App              │
│ 🔄 Sincronizando...│
└─────────────────────┘

Paso 5: Verificar en servidor
GET /tasks → "Comprar leche" aparece

Paso 6: Marcar como sincronizada
SQLite queue_operations:
{
  "id": "op_123",
  "op": "CREATE",
  "synced": 1  ← completado ✓
}
```

---

## 💡 Tips de desarrollo

### Hot Reload
```bash
flutter run -d windows
# Presiona: r (reload), R (restart)
```

### Ver logs
```bash
flutter logs
# Filtrar por tag
flutter logs -c  # clear
```

### Profiling
```bash
flutter run --profile -t lib/todo_app/main.dart
```

### Generar APK
```bash
flutter build apk --release
# Ubicación: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🚨 Errores comunes y soluciones

### Error: "database is locked"
```
Causa: Múltiples conexiones abiertas
Solución: Reiniciar app, cerrar debugger
```

### Error: "A new version of Flutter has been published"
```
Causa: Version mismatch
Solución: flutter upgrade
```

### Error: "Plugin not found"
```
Causa: Dependencia no instalada
Solución: flutter pub get
```

---

## 📞 Recursos útiles

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [SQLite Docs](https://www.sqlite.org/)
- [Dio Docs](https://pub.dev/packages/dio)
- [Provider Docs](https://pub.dev/packages/provider)

---

**Estado actual:** ✅ LISTO PARA USAR  
**Última actualización:** Enero 2024  
**Versión:** 1.0.0

*¡Ánimo, ya casi terminas! 🎉*
