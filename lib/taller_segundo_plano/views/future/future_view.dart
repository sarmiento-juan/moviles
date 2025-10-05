import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';
import 'data_service.dart';

/// Vista que demuestra el uso de Future, async/await
/// Muestra estados de: Cargando, Éxito, Error
class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

/// Estados posibles de una petición asíncrona
enum LoadingState { idle, loading, success, error }

class _FutureViewState extends State<FutureView> {
  // Estado actual de la carga
  LoadingState _state = LoadingState.idle;
  
  // Datos obtenidos
  List<Map<String, String>> _usuarios = [];
  
  // Mensaje de error
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Carga inicial de datos
    _cargarUsuarios();
  }

  /// Función que carga usuarios usando async/await
  /// Maneja los estados: loading, success, error
  Future<void> _cargarUsuarios() async {
    // 🟡 ANTES: Establecer estado de carga
    print('📱 [UI] Iniciando carga de usuarios...');
    setState(() {
      _state = LoadingState.loading;
      _errorMessage = '';
    });

    try {
      // 🔵 DURANTE: Esperar la respuesta del servicio
      print('📱 [UI] Esperando respuesta del servicio...');
      final usuarios = await DataService.fetchUsers();
      
      // 🟢 DESPUÉS: Actualizar UI con datos exitosos
      if (!mounted) return;
      setState(() {
        _usuarios = usuarios;
        _state = LoadingState.success;
      });
      print('📱 [UI] ✅ Datos mostrados en pantalla');
      
    } catch (e) {
      // 🔴 ERROR: Manejar el error
      print('📱 [UI] ❌ Error capturado: $e');
      if (!mounted) return;
      setState(() {
        _state = LoadingState.error;
        _errorMessage = e.toString();
      });
    }
  }

  /// Función que carga el dashboard (múltiples Futures en paralelo)
  Future<void> _cargarDashboard() async {
    print('📱 [UI] Cargando dashboard con Future.wait...');
    setState(() {
      _state = LoadingState.loading;
      _errorMessage = '';
    });

    try {
      final data = await DataService.fetchDashboardData();
      
      if (!mounted) return;
      print('📱 [UI] ✅ Dashboard cargado: ${data.keys.length} secciones');
      
      // Mostrar diálogo con los datos del dashboard
      _mostrarDialogoDashboard(data);
      
      setState(() {
        _state = LoadingState.success;
      });
      
    } catch (e) {
      print('📱 [UI] ❌ Error en dashboard: $e');
      if (!mounted) return;
      setState(() {
        _state = LoadingState.error;
        _errorMessage = e.toString();
      });
    }
  }

  void _mostrarDialogoDashboard(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dashboard Cargado'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📊 Estadísticas:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Usuarios: ${data['stats']['usuarios']}'),
              Text('Ventas: ${data['stats']['ventas']}'),
              Text('Ingresos: \$${data['stats']['ingresos']}'),
              const SizedBox(height: 16),
              const Text('🔔 Notificaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...((data['notifications'] as List).map((n) => Text('• $n'))),
              const SizedBox(height: 16),
              const Text('⚡ Actividad Reciente:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...((data['activity'] as List).map((a) => Text('• $a'))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Future & Async/Await',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Indicador de estado
            _buildEstadoBanner(),
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _state == LoadingState.loading ? null : _cargarUsuarios,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recargar Usuarios'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _state == LoadingState.loading ? null : _cargarDashboard,
                    icon: const Icon(Icons.dashboard),
                    label: const Text('Dashboard'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Contenido según el estado
            Expanded(
              child: _buildContenido(),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget que muestra el banner de estado actual
  Widget _buildEstadoBanner() {
    Color color;
    IconData icon;
    String texto;

    switch (_state) {
      case LoadingState.idle:
        color = Colors.grey;
        icon = Icons.info_outline;
        texto = '⚪ Estado: Inactivo';
        break;
      case LoadingState.loading:
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        texto = '🟡 Estado: Cargando...';
        break;
      case LoadingState.success:
        color = Colors.green;
        icon = Icons.check_circle;
        texto = '🟢 Estado: Éxito';
        break;
      case LoadingState.error:
        color = Colors.red;
        icon = Icons.error;
        texto = '🔴 Estado: Error';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget que muestra el contenido según el estado
  Widget _buildContenido() {
    switch (_state) {
      case LoadingState.idle:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Presiona un botón para cargar datos',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );

      case LoadingState.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando datos...'),
              SizedBox(height: 8),
              Text(
                'Revisa la consola para ver el orden de ejecución',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );

      case LoadingState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error al cargar datos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cargarUsuarios,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );

      case LoadingState.success:
        return ListView.builder(
          itemCount: _usuarios.length,
          itemBuilder: (context, index) {
            final usuario = _usuarios[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    usuario['nombre']![0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(usuario['nombre']!),
                subtitle: Text('${usuario['rol']} • ${usuario['email']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        );
    }
  }
}

