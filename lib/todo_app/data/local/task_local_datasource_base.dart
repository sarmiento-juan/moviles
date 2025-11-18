import '../../models/task.dart';

/// Interfaz abstracta para datasources locales
abstract class TaskLocalDataSourceBase {
  Future<List<Task>> getTasks();
  Future<Task?> getTaskById(String id);
  Future<void> insertOrUpdateTask(Task task);
  Future<void> markTaskAsDeleted(String id);
  Future<void> enqueueOperation(
    String entityId,
    String operation,
    Map<String, dynamic> payload,
  );
  Future<List<Map<String, dynamic>>> getPendingOperations();
  Future<void> markOperationAsSynced(String operationId);
  Future<void> incrementAttemptCount(String operationId, String error);
  Future<void> cleanupDeletedTasks();
}
