import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

/// Vista que demuestra el uso de Isolates
/// Ejecuta tareas CPU-bound en un hilo separado para no bloquear la UI
class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  String _resultado = "Presiona un botón para ejecutar una tarea";
  bool _isLoading = false;
  int _contador = 0;

  // Timer para demostrar que la UI no se bloquea
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    // Timer que actualiza un contador cada segundo para demostrar que la UI sigue respondiendo
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _contador++;
        });
      }
    });
    print('🧵 [ISOLATE] Vista inicializada');
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    print('🧵 [ISOLATE] Vista destruida - recursos liberados');
    super.dispose();
  }

  /// Ejecuta una tarea pesada SIN Isolate (bloqueará la UI)
  void _ejecutarSinIsolate() {
    print('🔴 [SIN ISOLATE] Iniciando tarea pesada en el hilo principal...');
    setState(() {
      _isLoading = true;
      _resultado = "Ejecutando en hilo principal...\n⚠️ La UI está bloqueada!";
    });

    // Simular tarea pesada (esto bloqueará la UI)
    int suma = 0;
    for (int i = 0; i < 1000000000; i++) {
      suma += i;
      if (i % 100000000 == 0) {
        print('🔴 [SIN ISOLATE] Procesando: ${(i / 1000000000 * 100).toStringAsFixed(0)}%');
      }
    }

    setState(() {
      _isLoading = false;
      _resultado = "✅ Tarea completada SIN Isolate\nResultado: $suma\n\n⚠️ Notaste que la UI se bloqueó?";
    });
    print('🔴 [SIN ISOLATE] Tarea completada');
  }

  /// Ejecuta una tarea pesada CON Isolate (NO bloqueará la UI)
  Future<void> _ejecutarConIsolate() async {
    print('🟢 [CON ISOLATE] Iniciando tarea pesada en Isolate...');
    setState(() {
      _isLoading = true;
      _resultado = "Ejecutando en Isolate...\n✅ La UI sigue respondiendo!";
    });

    try {
      final receivePort = ReceivePort();
      
      // Crear el Isolate
      await Isolate.spawn(_tareaPesada, receivePort.sendPort);
      
      // Obtener el SendPort del Isolate
      final sendPort = await receivePort.first as SendPort;
      
      // Crear puerto para recibir respuesta
      final responsePort = ReceivePort();
      
      // Enviar datos al Isolate
      sendPort.send({
        'limite': 1000000000,
        'replyPort': responsePort.sendPort,
      });
      
      // Esperar resultado
      final resultado = await responsePort.first as Map<String, dynamic>;
      
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _resultado = """
✅ Tarea completada CON Isolate
Resultado: ${resultado['suma']}
Tiempo: ${resultado['tiempo']} ms

✅ La UI nunca se bloqueó!
Puedes ver que el contador siguió funcionando.
        """;
      });
      print('🟢 [CON ISOLATE] Tarea completada');
      
    } catch (e) {
      print('🔴 [ERROR] $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _resultado = "❌ Error: $e";
      });
    }
  }

  /// Ejecuta múltiples cálculos en paralelo usando varios Isolates
  Future<void> _ejecutarMultiplesIsolates() async {
    print('🟣 [MÚLTIPLES ISOLATES] Iniciando cálculos en paralelo...');
    setState(() {
      _isLoading = true;
      _resultado = "Ejecutando 3 tareas en paralelo...\nUsando múltiples Isolates";
    });

    try {
      // Ejecutar 3 tareas en paralelo
      final futures = [
        _ejecutarCalculoEnIsolate(100000000, 'Isolate 1'),
        _ejecutarCalculoEnIsolate(200000000, 'Isolate 2'),
        _ejecutarCalculoEnIsolate(150000000, 'Isolate 3'),
      ];

      final resultados = await Future.wait(futures);
      
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _resultado = """
✅ Tareas paralelas completadas

${resultados[0]['nombre']}: ${resultados[0]['suma']} (${resultados[0]['tiempo']} ms)
${resultados[1]['nombre']}: ${resultados[1]['suma']} (${resultados[1]['tiempo']} ms)
${resultados[2]['nombre']}: ${resultados[2]['suma']} (${resultados[2]['tiempo']} ms)

✅ Todas ejecutadas simultáneamente!
        """;
      });
      print('🟣 [MÚLTIPLES ISOLATES] Todas las tareas completadas');
      
    } catch (e) {
      print('🔴 [ERROR] $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _resultado = "❌ Error: $e";
      });
    }
  }

  /// Helper para ejecutar un cálculo en un Isolate
  Future<Map<String, dynamic>> _ejecutarCalculoEnIsolate(int limite, String nombre) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_tareaPesada, receivePort.sendPort);
    
    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();
    
    sendPort.send({
      'limite': limite,
      'replyPort': responsePort.sendPort,
    });
    
    final resultado = await responsePort.first as Map<String, dynamic>;
    resultado['nombre'] = nombre;
    return resultado;
  }

  /// Función que se ejecuta en el Isolate
  /// Esta función realiza cálculos intensivos
  static void _tareaPesada(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    
    await for (final message in port) {
      final data = message as Map<String, dynamic>;
      final limite = data['limite'] as int;
      final replyPort = data['replyPort'] as SendPort;
      
      print('🧵 [ISOLATE] Iniciando cálculo hasta $limite...');
      final stopwatch = Stopwatch()..start();
      
      // Tarea CPU-bound: suma de números
      int suma = 0;
      for (int i = 0; i < limite; i++) {
        suma += i;
        if (i % 100000000 == 0 && i > 0) {
          print('🧵 [ISOLATE] Progreso: ${(i / limite * 100).toStringAsFixed(0)}%');
        }
      }
      
      stopwatch.stop();
      print('🧵 [ISOLATE] Cálculo completado en ${stopwatch.elapsedMilliseconds} ms');
      
      // Enviar resultado de vuelta
      replyPort.send({
        'suma': suma,
        'tiempo': stopwatch.elapsedMilliseconds,
      });
      
      port.close();
      Isolate.exit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Isolate - Tareas Pesadas",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contador de UI (demuestra que la UI sigue respondiendo)
            _buildContadorUI(),
            const SizedBox(height: 16),
            
            // Área de resultado
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: _isLoading
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Procesando...'),
                            SizedBox(height: 8),
                            Text(
                              'Observa que el contador sigue funcionando',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        )
                      : Text(
                          _resultado,
                          style: const TextStyle(fontSize: 14),
                        ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            _buildBotones(),
            
            const SizedBox(height: 16),
            
            // Info
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildContadorUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contador de UI',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                '$_contador segundos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotones() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _ejecutarSinIsolate,
                icon: const Icon(Icons.block),
                label: const Text('Sin Isolate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _ejecutarConIsolate,
                icon: const Icon(Icons.check_circle),
                label: const Text('Con Isolate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _ejecutarMultiplesIsolates,
            icon: const Icon(Icons.workspaces),
            label: const Text('Múltiples Isolates en Paralelo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Diferencias',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('🔴 Sin Isolate: Bloquea la UI', style: TextStyle(fontSize: 12)),
          Text('🟢 Con Isolate: UI sigue respondiendo', style: TextStyle(fontSize: 12)),
          Text('🟣 Múltiples: Procesamiento paralelo', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

