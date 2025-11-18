# 💻 Ejemplos de Código - To-Do App

## 1. Usar TaskProvider para CRUD

### Crear tarea
```dart
// En un Widget
context.read<TaskProvider>().createTask('Hacer la compra');
```

### Obtener todas las tareas
```dart
Future<void> _loadTasks() async {
  await context.read<TaskProvider>().loadTasks();
}
```

### Actualizar tarea
```dart
final updatedTask = task.copyWith(
  title: 'Nuevo título',
  completed: true,
);
await context.read<TaskProvider>().updateTask(updatedTask);
```

### Eliminar tarea
```dart
await context.read<TaskProvider>().deleteTask(taskId);
```

### Marcar como completada
```dart
await context.read<TaskProvider>().toggleTaskCompleted(task);
```

---

## 2. Usar Consumer para escuchar cambios

### Escuchar cambios en lista de tareas
```dart
Consumer<TaskProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (provider.error != null) {
      return ErrorWidget(message: provider.error!);
    }
    
    return ListView.builder(
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: provider.tasks[index]);
      },
    );
  },
)
```

### Escuchar estado de conectividad
```dart
Consumer<ConnectivityProvider>(
  builder: (context, connectivity, _) {
    return Column(
      children: [
        if (!connectivity.isOnline)
          Container(
            color: Colors.orange,
            child: Text('Modo sin conexión'),
          ),
        // Rest of UI
      ],
    );
  },
)
```

---

## 3. Crear formulario personalizado

### Form con validación
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        decoration: InputDecoration(labelText: 'Título'),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'El título es requerido';
          }
          if (value!.length < 3) {
            return 'Mínimo 3 caracteres';
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Procesar
          }
        },
        child: Text('Enviar'),
      ),
    ],
  ),
)
```

---

## 4. Implementar sincronización manual

### Sincronizar operaciones pendientes
```dart
Future<void> _syncPendingOperations() async {
  final syncService = context.read<SyncService>();
  await syncService.syncPendingOperations();
}
```

### Usar callback de sincronización
```dart
@override
void initState() {
  super.initState();
  final syncService = context.read<SyncService>();
  syncService.onSyncStatusChanged = (status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(status)),
    );
  };
}
```

---

## 5. Trabajar con base de datos SQLite

### Obtener tareas del local
```dart
final localDataSource = TaskLocalDataSource();
final tasks = await localDataSource.getTasks();
for (var task in tasks) {
  print('${task.id}: ${task.title} - ${task.completed}');
}
```

### Insertar tarea en local
```dart
final newTask = Task(
  id: '123',
  title: 'Hacer tarea',
  completed: false,
  updatedAt: DateTime.now(),
);
await localDataSource.insertOrUpdateTask(newTask);
```

### Encolar operación
```dart
await localDataSource.enqueueOperation(
  taskId,
  'CREATE',
  newTask.toJson(),
);
```

### Obtener operaciones pendientes
```dart
final pendingOps = await localDataSource.getPendingOperations();
for (var op in pendingOps) {
  print('${op['op']} - ${op['entity_id']} (Intentos: ${op['attempt_count']})');
}
```

---

## 6. Llamadas a API

### Obtener tareas de API
```dart
final remoteDataSource = TaskRemoteDataSource(
  baseUrl: 'http://localhost:3000',
);

try {
  final tasks = await remoteDataSource.getTasks();
  print('Tareas: ${tasks.length}');
} on ApiException catch (e) {
  print('Error: ${e.message} (${e.statusCode})');
}
```

### Crear tarea en API
```dart
try {
  final newTask = Task(
    id: 'unique-id',
    title: 'Nueva tarea',
    completed: false,
    updatedAt: DateTime.now(),
  );
  
  final createdTask = await remoteDataSource.createTask(newTask);
  print('Creada: ${createdTask.id}');
} on ApiException catch (e) {
  print('Error: ${e.message}');
}
```

### Actualizar con Idempotency-Key
```dart
// La Idempotency-Key evita duplicados en reintentos
final response = await _dio.put(
  '/tasks/$id',
  data: taskData,
  options: Options(
    headers: {
      'Idempotency-Key': '$id-${DateTime.now().millisecondsSinceEpoch}',
    },
  ),
);
```

---

## 7. Manejo de errores

### Capturar y mostrar errores
```dart
try {
  await _repository.getTasks();
} catch (e) {
  if (e is ApiException) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### Retry con backoff exponencial
```dart
Future<T> retryWithBackoff<T>({
  required Future<T> Function() operation,
  int maxRetries = 5,
}) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await operation();
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      
      // Backoff exponencial: 1, 2, 4, 8, 16 segundos
      final delaySeconds = 1 << i;
      await Future.delayed(Duration(seconds: delaySeconds));
    }
  }
  throw Exception('Max retries exceeded');
}

// Uso
try {
  final tasks = await retryWithBackoff(
    operation: () => _remoteDataSource.getTasks(),
  );
} catch (e) {
  print('Falló después de reintentos: $e');
}
```

---

## 8. Patterns avanzados

### Patrón Repository con offline-first
```dart
// Lectura: local primero, luego remoto en background
Future<List<Task>> getTasks() async {
  // Mostrar local inmediatamente
  final localTasks = await _localDataSource.getTasks();
  
  // Refrescar en background
  if (_isOnline) {
    try {
      final remoteTasks = await _remoteDataSource.getTasks();
      // Actualizar local con datos remotos
      for (var task in remoteTasks) {
        await _localDataSource.insertOrUpdateTask(task);
      }
      return remoteTasks;
    } catch (e) {
      // Si falla, devolver local
      return localTasks;
    }
  }
  
  return localTasks;
}
```

### Patrón de conflictos (Last-Write-Wins)
```dart
Task resolveConflict(Task local, Task remote) {
  // Ganador: el más reciente
  if (local.updatedAt.isAfter(remote.updatedAt)) {
    return local;
  } else {
    return remote;
  }
}
```

### Patrón de cambios observables
```dart
// En un StateNotifier o ChangeNotifier
void _watchConnectivity() {
  _connectivity.onConnectivityChanged.listen((result) {
    final isOnline = !result.contains(ConnectivityResult.none);
    
    if (isOnline && !_wasOnline) {
      // Reconectado: sincronizar
      _syncPendingOperations();
    }
    
    _wasOnline = isOnline;
    notifyListeners();
  });
}
```

---

## 9. Testing unitario

### Test del modelo Task
```dart
void main() {
  group('Task Model', () {
    test('Task.fromJson crea instancia correcta', () {
      final json = {
        'id': '1',
        'title': 'Test',
        'completed': false,
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      
      final task = Task.fromJson(json);
      
      expect(task.id, '1');
      expect(task.title, 'Test');
      expect(task.completed, false);
    });
    
    test('Task.toJson serializa correctamente', () {
      final task = Task(
        id: '1',
        title: 'Test',
        completed: false,
        updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );
      
      final json = task.toJson();
      
      expect(json['id'], '1');
      expect(json['title'], 'Test');
    });
    
    test('copyWith crea copia con cambios', () {
      final original = Task(
        id: '1',
        title: 'Original',
        completed: false,
        updatedAt: DateTime.now(),
      );
      
      final modified = original.copyWith(title: 'Modificado');
      
      expect(modified.title, 'Modificado');
      expect(modified.id, original.id);
    });
  });
}
```

---

## 10. Debugging

### Logs detallados
```dart
// En TaskProvider
void loadTasks() {
  print('[TaskProvider] Iniciando carga de tareas...');
  _isLoading = true;
  
  _repository.getTasks().then((result) {
    print('[TaskProvider] Tareas cargadas: ${result.data?.length ?? 0}');
    _tasks = result.data ?? [];
  }).onError((error, stack) {
    print('[TaskProvider] Error: $error\nStack: $stack');
  });
}
```

### Inspeccionar base de datos
```dart
Future<void> debugPrintDatabase() async {
  final localDataSource = TaskLocalDataSource();
  final tasks = await localDataSource.getTasks();
  print('===== TASKS =====');
  for (var task in tasks) {
    print('$task');
  }
  
  final ops = await localDataSource.getPendingOperations();
  print('===== PENDING OPERATIONS =====');
  for (var op in ops) {
    print('$op');
  }
}
```

---

## Consejos Prácticos

✅ Siempre validar entrada de usuario  
✅ Usar `.copyWith()` para evitar mutar objetos  
✅ Implementar timeouts en requests HTTP  
✅ Logging para debugging  
✅ Manejo seguro de nulos  
✅ Tests unitarios para lógica crítica  
✅ Hot reload durante desarrollo  

---

*Para más ejemplos, ver el código fuente en cada archivo.*
