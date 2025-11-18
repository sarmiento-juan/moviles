import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

/// Estado global de tareas
class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = false;
  String? _error;
  TaskFilter _currentFilter = TaskFilter.all;

  TaskProvider(this._repository);

  // Getters
  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get currentFilter => _currentFilter;

  /// Cargar tareas
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getTasks();
      if (result.isSuccess) {
        _tasks = result.data ?? [];
        _applyFilter();
        _error = null;
      } else {
        _error = result.error.toString();
      }
    } catch (e) {
      _error = 'Error al cargar tareas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear nueva tarea
  Future<void> createTask(String title) async {
    if (title.isEmpty) {
      _error = 'El título no puede estar vacío';
      notifyListeners();
      return;
    }

    try {
      final result = await _repository.createTask(title);
      if (result.isSuccess && result.data != null) {
        _tasks.add(result.data!);
        _applyFilter();
        _error = null;
      } else {
        _error = 'Error al crear tarea';
      }
    } catch (e) {
      _error = 'Error: $e';
    }
    notifyListeners();
  }

  /// Actualizar tarea
  Future<void> updateTask(Task task) async {
    try {
      final result = await _repository.updateTask(task);
      if (result.isSuccess && result.data != null) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = result.data!;
          _applyFilter();
        }
        _error = null;
      } else {
        _error = 'Error al actualizar tarea';
      }
    } catch (e) {
      _error = 'Error: $e';
    }
    notifyListeners();
  }

  /// Eliminar tarea
  Future<void> deleteTask(String id) async {
    try {
      final result = await _repository.deleteTask(id);
      if (result.isSuccess) {
        _tasks.removeWhere((t) => t.id == id);
        _applyFilter();
        _error = null;
      } else {
        _error = 'Error al eliminar tarea';
      }
    } catch (e) {
      _error = 'Error: $e';
    }
    notifyListeners();
  }

  /// Marcar tarea como completada
  Future<void> toggleTaskCompleted(Task task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    await updateTask(updatedTask);
  }

  /// Filtrar tareas
  void filterTasks(TaskFilter filter) {
    _currentFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  /// Aplicar filtro actual
  void _applyFilter() {
    switch (_currentFilter) {
      case TaskFilter.all:
        _filteredTasks = _tasks;
        break;
      case TaskFilter.pending:
        _filteredTasks = _tasks.where((t) => !t.completed).toList();
        break;
      case TaskFilter.completed:
        _filteredTasks = _tasks.where((t) => t.completed).toList();
        break;
    }
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Obtener contadores
  int getPendingCount() => _tasks.where((t) => !t.completed).length;
  int getCompletedCount() => _tasks.where((t) => t.completed).length;
}

/// Filtros disponibles
enum TaskFilter { all, pending, completed }
