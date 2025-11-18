import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/task_widgets.dart';

/// Pantalla principal con lista de tareas
class TaskListView extends StatefulWidget {
  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  void initState() {
    super.initState();
    // Cargar tareas al iniciar
    Future.microtask(() {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tareas'),
        elevation: 0,
        actions: [
          Consumer<TaskProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Pendientes: ${provider.getPendingCount()}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Indicador de conexión
          Consumer<ConnectivityProvider>(
            builder: (context, connectivity, _) {
              return OfflineIndicator(isOnline: connectivity.isOnline);
            },
          ),
          // Filtros
          _buildFilterBar(context),
          // Lista de tareas
          Expanded(child: _buildTaskList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Nueva tarea',
      ),
    );
  }

  /// Barra de filtros
  Widget _buildFilterBar(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              _buildFilterButton(context, 'Todas', TaskFilter.all, provider),
              SizedBox(width: 8),
              _buildFilterButton(
                context,
                'Pendientes',
                TaskFilter.pending,
                provider,
              ),
              SizedBox(width: 8),
              _buildFilterButton(
                context,
                'Completadas',
                TaskFilter.completed,
                provider,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Botón de filtro
  Widget _buildFilterButton(
    BuildContext context,
    String label,
    TaskFilter filter,
    TaskProvider provider,
  ) {
    final isSelected = provider.currentFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        provider.filterTasks(filter);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
    );
  }

  /// Lista de tareas
  Widget _buildTaskList(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return LoadingWidget();
        }

        if (provider.error != null) {
          return ErrorDisplay(
            message: provider.error!,
            onRetry: () => provider.loadTasks(),
          );
        }

        if (provider.tasks.isEmpty) {
          return EmptyStateWidget(
            title: 'Sin tareas',
            message: provider.currentFilter == TaskFilter.completed
                ? 'Aún no hay tareas completadas'
                : provider.currentFilter == TaskFilter.pending
                ? 'Todas las tareas completadas'
                : 'Crea tu primera tarea',
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadTasks(),
          child: ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return TaskCard(
                task: task,
                onEdit: () => _showEditTaskDialog(context, task),
                onDelete: () => _showDeleteConfirmation(context, task.id),
                onToggle: (value) {
                  provider.toggleTaskCompleted(task);
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Diálogo para agregar tarea
  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva Tarea'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Ingresa el título de la tarea',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TaskProvider>().createTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text('Crear'),
          ),
        ],
      ),
    );
  }

  /// Diálogo para editar tarea
  void _showEditTaskDialog(BuildContext context, dynamic task) {
    // Este se puede expandir para mostrar TaskFormView
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidad de edición disponible pronto')),
    );
  }

  /// Confirmación de eliminación
  void _showDeleteConfirmation(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Tarea'),
        content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskProvider>().deleteTask(taskId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
