import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/department.dart';
import '../services/department_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/empty_state_widget.dart';

class DepartmentsListView extends StatefulWidget {
  const DepartmentsListView({super.key});

  @override
  State<DepartmentsListView> createState() => _DepartmentsListViewState();
}

class _DepartmentsListViewState extends State<DepartmentsListView> {
  final DepartmentService _service = DepartmentService();
  List<Department> _departments = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final departments = await _service.getAllDepartments();
      setState(() {
        _departments = departments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Regresar',
        ),
        title: const Text('Departamentos'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando departamentos...');
    }

    if (_error != null) {
      return custom.ErrorWidget(message: _error!, onRetry: _loadDepartments);
    }

    if (_departments.isEmpty) {
      return const EmptyStateWidget(
        message: 'No se encontraron departamentos',
        icon: Icons.map_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDepartments,
      child: ListView.builder(
        itemCount: _departments.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final department = _departments[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF003893),
                child: Text(
                  department.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                department.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '${department.municipalities} municipios',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Poblacion: ${department.population.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(
                  '/departments/${department.id}',
                  extra: department,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
