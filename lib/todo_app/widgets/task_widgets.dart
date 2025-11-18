import 'package:flutter/material.dart';
import '../models/task.dart';

/// Card para mostrar una tarea
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool?)? onToggle;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: onToggle,
          activeColor: Colors.green,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _formatDate(task.updatedAt),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 12),
                  Text('Editar'),
                ],
              ),
              onTap: onEdit,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Hoy a las ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

/// Widget para estado vacío
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    Key? key,
    this.title = 'Sin tareas',
    this.message = 'No hay tareas para mostrar',
    this.icon = Icons.task_alt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

/// Widget de carga
class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({Key? key, this.message = 'Cargando...'})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}

/// Widget de error
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({Key? key, required this.message, this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('Reintentar'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget de estado offline
class OfflineIndicator extends StatelessWidget {
  final bool isOnline;

  const OfflineIndicator({Key? key, required this.isOnline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOnline) return SizedBox.shrink();

    return Container(
      color: Colors.orange,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            'Modo sin conexión - Los cambios se sincronizarán cuando se restablezca la conexión',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
