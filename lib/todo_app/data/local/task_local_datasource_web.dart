import '../../models/task.dart';
import 'task_local_datasource_base.dart';

/// Data source para almacenamiento local en Web (usa memoria en desarrollo)
/// En producción, debería usar IndexedDB o LocalStorage
class TaskLocalDataSourceWeb implements TaskLocalDataSourceBase {
  static final TaskLocalDataSourceWeb _instance =
      TaskLocalDataSourceWeb._internal();
  final List<Task> _tasks = [];
  final List<Map<String, dynamic>> _queue = [];

  factory TaskLocalDataSourceWeb() {
    return _instance;
  }

  TaskLocalDataSourceWeb._internal();

  Future<void> init() async {
    // No hay nada que inicializar para almacenamiento en memoria
  }

  Future<List<Task>> getTasks() async {
    return List.from(_tasks);
  }

  Future<Task?> getTaskById(String id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> insertOrUpdateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
    } else {
      _tasks.add(task);
    }
  }

  Future<void> markTaskAsDeleted(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(completed: true, updatedAt: DateTime.now());
    }
  }

  Future<void> enqueueOperation(
    String entityId,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    _queue.add({
      'id': '${DateTime.now().millisecondsSinceEpoch}_$entityId',
      'entity_id': entityId,
      'op': operation,
      'payload': payload,
      'created_at': DateTime.now().toIso8601String(),
      'attempt_count': 0,
      'synced': false,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingOperations() async {
    return _queue.where((op) => !(op['synced'] ?? false)).toList();
  }

  Future<void> markOperationAsSynced(String operationId) async {
    final index = _queue.indexWhere((op) => op['id'] == operationId);
    if (index >= 0) {
      _queue[index]['synced'] = true;
    }
  }

  Future<void> incrementAttemptCount(String operationId, String error) async {
    final index = _queue.indexWhere((op) => op['id'] == operationId);
    if (index >= 0) {
      _queue[index]['attempt_count'] =
          (_queue[index]['attempt_count'] as int) + 1;
    }
  }

  Future<void> cleanupDeletedTasks() async {
    _tasks.removeWhere((task) => task.completed);
  }
}
