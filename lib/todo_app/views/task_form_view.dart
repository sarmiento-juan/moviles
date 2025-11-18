import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

/// Formulario para crear/editar tareas
class TaskFormView extends StatefulWidget {
  final Task? task;
  final VoidCallback? onSuccess;

  const TaskFormView({Key? key, this.task, this.onSuccess}) : super(key: key);

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  late TextEditingController _titleController;
  late bool _completed;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _completed = widget.task?.completed ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Tarea' : 'Nueva Tarea')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ingresa el título de la tarea',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.task_alt),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'El título es requerido';
                  }
                  if (value!.length < 3) {
                    return 'El título debe tener al menos 3 caracteres';
                  }
                  return null;
                },
                maxLines: 3,
                maxLength: 200,
              ),
              SizedBox(height: 16),
              if (isEditing) ...[
                CheckboxListTile(
                  title: Text('Marcar como completada'),
                  value: _completed,
                  onChanged: (value) {
                    setState(() {
                      _completed = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16),
              ],
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Cancelar'),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(isEditing ? 'Actualizar' : 'Crear'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<TaskProvider>();

      if (widget.task == null) {
        // Crear nueva tarea
        provider.createTask(_titleController.text);
      } else {
        // Actualizar tarea existente
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          completed: _completed,
        );
        provider.updateTask(updatedTask);
      }

      widget.onSuccess?.call();
      Navigator.pop(context);
    }
  }
}
