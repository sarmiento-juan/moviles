import '../models/task.dart';
import '../data/local/task_local_datasource_base.dart';
import '../data/remote/task_remote_datasource.dart';

/// Resultado genérico de operaciones
class Result<T> {
  final T? data;
  final Exception? error;
  final bool isSuccess;

  Result.success(this.data) : error = null, isSuccess = true;

  Result.failure(this.error) : data = null, isSuccess = false;
}

/// Repository que orquesta operaciones locales y remotas (offline-first)
class TaskRepository {
  final TaskLocalDataSourceBase _localDataSource;
  final TaskRemoteDataSource _remoteDataSource;
  bool _isOnline = true;

  TaskRepository({
    required TaskLocalDataSourceBase localDataSource,
    required TaskRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  /// Actualizar estado de conectividad
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }

  /// Obtener todas las tareas (lectura offline-first)
  Future<Result<List<Task>>> getTasks() async {
    try {
      // Leer del local primero
      final localTasks = await _localDataSource.getTasks();

      // Si hay internet, refrescar en segundo plano
      if (_isOnline) {
        try {
          final remoteTasks = await _remoteDataSource.getTasks();

          // Actualizar local con datos remotos
          for (var task in remoteTasks) {
            await _localDataSource.insertOrUpdateTask(task);
          }

          return Result.success(remoteTasks);
        } catch (e) {
          // Si falla la sincronización, devolver datos locales
          return Result.success(localTasks);
        }
      }

      return Result.success(localTasks);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  /// Obtener tarea por ID
  Future<Result<Task>> getTaskById(String id) async {
    try {
      // Intentar obtener del local
      final localTask = await _localDataSource.getTaskById(id);
      if (localTask != null && !_isOnline) {
        return Result.success(localTask);
      }

      // Si hay internet, obtener del remoto
      if (_isOnline) {
        final remoteTask = await _remoteDataSource.getTaskById(id);
        await _localDataSource.insertOrUpdateTask(remoteTask);
        return Result.success(remoteTask);
      }

      // Fallback al local
      if (localTask != null) {
        return Result.success(localTask);
      }

      throw Exception('Tarea no encontrada');
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Crear nueva tarea (escritura offline-first)
  Future<Result<Task>> createTask(String title) async {
    try {
      final now = DateTime.now();
      final taskId = '${now.millisecondsSinceEpoch}_${title.hashCode}';
      final newTask = Task(
        id: taskId,
        title: title,
        completed: false,
        updatedAt: now,
      );

      // Guardar localmente primero
      await _localDataSource.insertOrUpdateTask(newTask);

      // Encolar la operación
      await _localDataSource.enqueueOperation(
        taskId,
        'CREATE',
        newTask.toJson(),
      );

      // Intentar sincronizar si hay internet
      if (_isOnline) {
        try {
          final remoteTas = await _remoteDataSource.createTask(newTask);
          return Result.success(remoteTas);
        } catch (e) {
          // Si falla, la operación está en la cola
          return Result.success(newTask);
        }
      }

      return Result.success(newTask);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Actualizar tarea
  Future<Result<Task>> updateTask(Task task) async {
    try {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());

      // Guardar localmente
      await _localDataSource.insertOrUpdateTask(updatedTask);

      // Encolar la operación
      await _localDataSource.enqueueOperation(
        task.id,
        'UPDATE',
        updatedTask.toJson(),
      );

      // Intentar sincronizar si hay internet
      if (_isOnline) {
        try {
          final remoteTask = await _remoteDataSource.updateTask(
            task.id,
            updatedTask,
          );
          return Result.success(remoteTask);
        } catch (e) {
          return Result.success(updatedTask);
        }
      }

      return Result.success(updatedTask);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Eliminar tarea (soft delete)
  Future<Result<void>> deleteTask(String id) async {
    try {
      // Marcar como eliminada localmente
      await _localDataSource.markTaskAsDeleted(id);

      // Encolar la operación
      await _localDataSource.enqueueOperation(id, 'DELETE', {'id': id});

      // Intentar sincronizar si hay internet
      if (_isOnline) {
        try {
          await _remoteDataSource.deleteTask(id);
        } catch (e) {
          // Si falla, está en la cola
        }
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Obtener operaciones pendientes
  Future<List<Map<String, dynamic>>> getPendingOperations() async {
    try {
      return await _localDataSource.getPendingOperations();
    } catch (e) {
      return [];
    }
  }

  /// Sincronizar operaciones pendientes
  Future<void> syncPendingOperations() async {
    if (!_isOnline) return;

    final operations = await getPendingOperations();

    for (final op in operations) {
      final operationId = op['id'] as String;
      final entityId = op['entity_id'] as String;
      final operation = op['op'] as String;

      try {
        // Ejecutar operación según tipo
        switch (operation) {
          case 'CREATE':
            final payload = _parsePayload(op['payload']);
            final task = Task.fromJson(payload);
            await _remoteDataSource.createTask(task);
            break;

          case 'UPDATE':
            final payload = _parsePayload(op['payload']);
            final task = Task.fromJson(payload);
            await _remoteDataSource.updateTask(entityId, task);
            break;

          case 'DELETE':
            await _remoteDataSource.deleteTask(entityId);
            break;
        }

        // Marcar como sincronizada
        await _localDataSource.markOperationAsSynced(operationId);
      } catch (e) {
        // Incrementar intentos
        await _localDataSource.incrementAttemptCount(operationId, e.toString());
      }
    }
  }

  /// Parsear payload (implementar según serialización)
  Map<String, dynamic> _parsePayload(String payload) {
    // Aquí iría la deserialización real
    // Por ahora, retornamos un mapa vacío
    return {};
  }

  /// Limpiar tareas antiguas
  Future<void> cleanup() async {
    await _localDataSource.cleanupDeletedTasks();
  }
}
