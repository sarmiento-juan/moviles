import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

/// Vista que demuestra el uso de Timer
/// Implementa un cronómetro con funciones de:
/// - Iniciar, Pausar, Reanudar, Reiniciar
class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  // Timer para el cronómetro
  Timer? _timer;

  // Contador de segundos
  int _segundos = 0;

  // Estado del cronómetro
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    print('⏱️ [TIMER] Cronómetro inicializado');
  }

  @override
  void dispose() {
    // IMPORTANTE: Cancelar el timer al salir de la vista
    _timer?.cancel();
    print('⏱️ [TIMER] Cronómetro destruido - recursos liberados');
    super.dispose();
  }

  /// Inicia el cronómetro
  void _iniciarTimer() {
    if (_isRunning) return;

    print('▶️ [TIMER] Cronómetro iniciado');
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    // Timer.periodic ejecuta una función cada intervalo de tiempo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundos++;
      });
      print('⏱️ [TIMER] Tiempo: $_segundos segundos');
    });
  }

  /// Pausa el cronómetro
  void _pausarTimer() {
    if (!_isRunning || _isPaused) return;

    print('⏸️ [TIMER] Cronómetro pausado en $_segundos segundos');
    setState(() {
      _isPaused = true;
    });

    // Cancelar el timer pero mantener el contador
    _timer?.cancel();
  }

  /// Reanuda el cronómetro
  void _reanudarTimer() {
    if (!_isPaused) return;

    print('▶️ [TIMER] Cronómetro reanudado desde $_segundos segundos');
    setState(() {
      _isPaused = false;
    });

    // Reiniciar el timer desde donde se pausó
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundos++;
      });
      print('⏱️ [TIMER] Tiempo: $_segundos segundos');
    });
  }

  /// Reinicia el cronómetro
  void _reiniciarTimer() {
    print('🔄 [TIMER] Cronómetro reiniciado');

    // Cancelar el timer actual
    _timer?.cancel();

    setState(() {
      _segundos = 0;
      _isRunning = false;
      _isPaused = false;
    });
  }

  /// Convierte segundos a formato MM:SS
  String _formatearTiempo() {
    int minutos = _segundos ~/ 60;
    int segundos = _segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Timer - Cronómetro',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de estado
            _buildEstadoBanner(),
            const SizedBox(height: 32),

            // Marcador del cronómetro
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.timer, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    _formatearTiempo(),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minutos : Segundos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Botones de control
            _buildBotones(),

            const SizedBox(height: 32),

            // Información adicional
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoBanner() {
    String texto;
    Color color;
    IconData icon;

    if (!_isRunning) {
      texto = '⚪ Estado: Detenido';
      color = Colors.grey;
      icon = Icons.stop_circle_outlined;
    } else if (_isPaused) {
      texto = '🟡 Estado: Pausado';
      color = Colors.orange;
      icon = Icons.pause_circle_outlined;
    } else {
      texto = '🟢 Estado: En ejecución';
      color = Colors.green;
      icon = Icons.play_circle_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildBotones() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        // Botón Iniciar
        ElevatedButton.icon(
          onPressed: (!_isRunning && !_isPaused) ? _iniciarTimer : null,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Iniciar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),

        // Botón Pausar
        ElevatedButton.icon(
          onPressed: (_isRunning && !_isPaused) ? _pausarTimer : null,
          icon: const Icon(Icons.pause),
          label: const Text('Pausar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),

        // Botón Reanudar
        ElevatedButton.icon(
          onPressed: _isPaused ? _reanudarTimer : null,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Reanudar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),

        // Botón Reiniciar
        ElevatedButton.icon(
          onPressed: (_isRunning || _segundos > 0) ? _reiniciarTimer : null,
          icon: const Icon(Icons.refresh),
          label: const Text('Reiniciar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Información del Timer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('• El timer se actualiza cada 1 segundo'),
          const Text('• Los recursos se liberan automáticamente al salir'),
          const Text('• Revisa la consola para ver los eventos'),
          const SizedBox(height: 8),
          Text(
            'Tiempo total: $_segundos segundos',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
