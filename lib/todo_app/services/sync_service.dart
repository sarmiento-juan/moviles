import 'dart:async';
import '../repositories/task_repository.dart';

/// Servicio de sincronización con reintentos exponenciales
class SyncService {
  final TaskRepository _repository;
  Timer? _syncTimer;
  bool _isSyncing = false;
  int _maxRetries = 5;

  // Función callback para notificar cambios
  void Function(String)? onSyncStatusChanged;

  SyncService({required TaskRepository repository}) : _repository = repository;

  /// Iniciar sincronización automática
  void startAutoSync({Duration interval = const Duration(minutes: 5)}) {
    _syncTimer = Timer.periodic(interval, (_) {
      syncPendingOperations();
    });
  }

  /// Detener sincronización automática
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Sincronizar operaciones pendientes con backoff exponencial
  Future<void> syncPendingOperations() async {
    if (_isSyncing) return;

    _isSyncing = true;
    onSyncStatusChanged?.call('Sincronizando...');

    try {
      final operations = await _repository.getPendingOperations();
      int syncedCount = 0;
      int failedCount = 0;

      for (final op in operations) {
        final operationId = op['id'] as String;
        final attemptCount = op['attempt_count'] as int? ?? 0;

        // Si ya alcanzó max reintentos, saltar
        if (attemptCount >= _maxRetries) {
          onSyncStatusChanged?.call(
            'Operación $operationId: máximo de reintentos alcanzado',
          );
          failedCount++;
          continue;
        }

        // Calcular backoff exponencial: 2^attemptCount segundos
        final backoffSeconds = _calculateBackoff(attemptCount);
        await Future.delayed(Duration(seconds: backoffSeconds));

        try {
          // Aquí iría la lógica de sincronización específica
          // Por ahora, marcamos como sincronizada
          await _repository.syncPendingOperations();
          syncedCount++;
        } catch (e) {
          onSyncStatusChanged?.call('Error sincronizando operación: $e');
          failedCount++;
        }
      }

      if (syncedCount > 0) {
        onSyncStatusChanged?.call('Sincronizado: $syncedCount operaciones');
      }
      if (failedCount > 0) {
        onSyncStatusChanged?.call('Falló: $failedCount operaciones');
      }
    } catch (e) {
      onSyncStatusChanged?.call('Error en sincronización: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Calcular backoff exponencial
  int _calculateBackoff(int attemptCount) {
    // 2^attemptCount, máximo 32 segundos
    return (1 << attemptCount).clamp(0, 32);
  }

  /// Limpiar recursos
  void dispose() {
    stopAutoSync();
  }
}
