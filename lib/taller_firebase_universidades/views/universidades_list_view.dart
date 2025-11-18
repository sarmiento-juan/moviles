import 'package:flutter/material.dart';
import '../models/universidad.dart';
import '../services/universidad_service.dart';
import '../widgets/universidad_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as error_widgets;
import '../widgets/empty_state_widget.dart';

/// Vista que muestra el listado de universidades en tiempo real desde Firestore
class UniversidadesListView extends StatefulWidget {
  const UniversidadesListView({Key? key}) : super(key: key);

  @override
  State<UniversidadesListView> createState() => _UniversidadesListViewState();
}

class _UniversidadesListViewState extends State<UniversidadesListView> {
  final UniversidadService _service = UniversidadService();
  late Stream<List<Universidad>> _universidadesStream;

  @override
  void initState() {
    super.initState();
    _universidadesStream = _service.obtenerUniversidadesStream();
  }

  /// Muestra un diálogo de confirmación para eliminar una universidad
  void _mostrarDialogoEliminar(Universidad universidad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Universidad'),
        content: Text('¿Deseas eliminar a ${universidad.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _service.eliminarUniversidad(universidad.id);
                Navigator.pop(context);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Universidad eliminada')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: $e')),
                  );
                }
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades'),
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Universidad>>(
        stream: _universidadesStream,
        builder: (context, snapshot) {
          // Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Cargando universidades...');
          }

          // Estado de error
          if (snapshot.hasError) {
            return error_widgets.ErrorWidget(
              message: 'Error al cargar universidades: ${snapshot.error}',
              onRetry: () {
                setState(() {
                  _universidadesStream = _service.obtenerUniversidadesStream();
                });
              },
            );
          }

          // Sin datos
          final universidades = snapshot.data ?? [];
          if (universidades.isEmpty) {
            return EmptyStateWidget(
              title: 'Sin Universidades',
              message:
                  'Aún no hay universidades registradas.\nCrea una nueva para comenzar.',
              icon: Icons.school,
              onAction: () {
                Navigator.pushNamed(context, '/nueva-universidad');
              },
              actionLabel: 'Crear Universidad',
            );
          }

          // Lista de universidades
          return ListView.builder(
            itemCount: universidades.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final universidad = universidades[index];
              return UniversidadCard(
                universidad: universidad,
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    '/editar-universidad',
                    arguments: universidad,
                  );
                },
                onDelete: () => _mostrarDialogoEliminar(universidad),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/nueva-universidad');
        },
        label: const Text('Nueva Universidad'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }
}
