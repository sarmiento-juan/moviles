import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: const TaskListScreen(),
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  bool completed;
  bool synced; // Indica si fue sincronizado

  Task({
    required this.id,
    required this.title,
    this.completed = false,
    this.synced = true,
  });

  Task copyWith({String? title, bool? completed, bool? synced}) {
    return Task(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
    );
  }

  // Convertir a JSON para almacenamiento
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
    'synced': synced,
  };

  // Crear desde JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      synced: json['synced'] as bool? ?? true,
    );
  }
}

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  late SharedPreferences _prefs;
  bool _isLoaded = false;
  bool _isOnline = true;
  Timer? _connectivityTimer;

  List<Task> get tasks => _tasks;
  List<Task> get pendingTasks => _tasks.where((t) => !t.completed).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.completed).toList();
  int get totalTasks => _tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;
  bool get isOnline => _isOnline;
  int get unsyncedCount => _tasks.where((t) => !t.synced).length;

  // Inicializar SharedPreferences y cargar tareas
  Future<void> initialize() async {
    if (_isLoaded) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadTasks();
    _startConnectivityCheck();
    _isLoaded = true;
    notifyListeners();
  }

  // Verificar conectividad cada 10 segundos
  void _startConnectivityCheck() {
    // En Web, asumir siempre en línea (no podemos verificar por CORS)
    if (kIsWeb) {
      _isOnline = true;
      print('🌐 Web: Siempre en línea');
      return;
    }

    // En mobile, verificar cada 10 segundos
    _connectivityTimer = Timer.periodic(Duration(seconds: 10), (_) async {
      await _checkConnectivity();
    });

    // Verificar inmediatamente al inicio
    _checkConnectivity();
  }

  // Verificar si hay conexión intentando ping a un servidor
  Future<void> _checkConnectivity() async {
    // En Web, siempre asumir en línea (CORS bloquea peticiones externas)
    if (kIsWeb) {
      _isOnline = true;
      return;
    }

    try {
      // En mobile, intentar conectar a Google
      final result = await InternetAddress.lookup('google.com').timeout(
        Duration(seconds: 3),
      );

      final wasOnline = _isOnline;
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      print(
        '🌐 Verificación: ${_isOnline ? "✅ En línea" : "❌ Sin conexión"}',
      );

      if (!wasOnline && _isOnline) {
        print('🔄 Conexión recuperada, sincronizando...');
        await _syncPendingTasks();
      }

      if (wasOnline != _isOnline) {
        notifyListeners();
      }
    } catch (e) {
      final wasOnline = _isOnline;
      _isOnline = false;
      print('❌ Sin conexión');

      if (wasOnline != _isOnline) {
        notifyListeners();
      }
    }
  }

  // Cargar tareas del almacenamiento
  Future<void> _loadTasks() async {
    final jsonString = _prefs.getString('tasks');
    if (jsonString != null) {
      try {
        final jsonList = jsonDecode(jsonString) as List;
        _tasks.clear();
        _tasks.addAll(
          jsonList.map((item) => Task.fromJson(item as Map<String, dynamic>)),
        );
      } catch (e) {
        print('Error cargando tareas: $e');
      }
    }
  }

  // Guardar tareas en el almacenamiento
  Future<void> _saveTasks() async {
    final jsonList = _tasks.map((task) => task.toJson()).toList();
    await _prefs.setString('tasks', jsonEncode(jsonList));
  }

  // Sincronizar tareas pendientes
  Future<void> _syncPendingTasks() async {
    final unsyncedTasks = _tasks.where((t) => !t.synced).toList();

    if (unsyncedTasks.isEmpty) return;

    print('🔄 Sincronizando ${unsyncedTasks.length} tareas...');

    for (var task in unsyncedTasks) {
      try {
        // Simular sincronización con espera variable
        await Future.delayed(
          Duration(milliseconds: 500 + (unsyncedTasks.indexOf(task) * 200)),
        );

        // Marcar como sincronizado
        final idx = _tasks.indexWhere((t) => t.id == task.id);
        if (idx >= 0) {
          _tasks[idx] = _tasks[idx].copyWith(synced: true);
        }
      } catch (e) {
        print('Error sincronizando tarea ${task.id}: $e');
      }
    }

    await _saveTasks();
    notifyListeners();
    print('✅ Sincronización completada');
  }

  void addTask(String title) {
    _tasks.add(
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        synced: _isOnline, // Solo sincronizado si hay conexión
      ),
    );
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      _tasks[idx] = _tasks[idx].copyWith(
        completed: !_tasks[idx].completed,
        synced: _isOnline, // Marcar como sin sincronizar si está offline
      );
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  // Sincronizar manualmente
  Future<void> manualSync() async {
    if (!_isOnline) {
      print('⚠️ Sin conexión');
      return;
    }
    await _syncPendingTasks();
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    super.dispose();
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    // Inicializar el provider
    context.read<TaskProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // HEADER CON GRADIENTE
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.blue,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Mis Tareas',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Consumer<TaskProvider>(
                        builder: (_, provider, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${provider.pendingCount} pendientes • ${provider.completedCount} completadas',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            // Indicador de conexión
                            Row(
                              children: [
                                Icon(
                                  provider.isOnline
                                      ? Icons.cloud_done
                                      : Icons.cloud_off,
                                  color: provider.isOnline
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  provider.isOnline
                                      ? 'En línea'
                                      : 'Sin conexión',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: provider.isOnline
                                            ? Colors.greenAccent
                                            : Colors.orangeAccent,
                                      ),
                                ),
                                if (provider.unsyncedCount > 0) ...[
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent.withOpacity(
                                        0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${provider.unsyncedCount} sin sincronizar',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.orangeAccent,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // TABS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildTab('Todas', 0),
                  const SizedBox(width: 8),
                  _buildTab('Pendientes', 1),
                  const SizedBox(width: 8),
                  _buildTab('Completadas', 2),
                ],
              ),
            ),
          ),
          // LISTA DE TAREAS
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Consumer<TaskProvider>(
              builder: (ctx, provider, _) {
                final list = _tab == 0
                    ? provider.tasks
                    : _tab == 1
                    ? provider.pendingTasks
                    : provider.completedTasks;

                if (list.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            _tab == 0
                                ? Icons.done_all
                                : _tab == 1
                                ? Icons.assignment
                                : Icons.check_circle,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _tab == 0
                                ? 'No hay tareas'
                                : _tab == 1
                                ? 'No hay tareas pendientes'
                                : 'No hay tareas completadas',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(task: list[i]),
                    ),
                    childCount: list.length,
                  ),
                );
              },
            ),
          ),
          // ESPACIO AL FINAL
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: Consumer<TaskProvider>(
        builder: (_, provider, __) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Botón de sincronización manual
            if (provider.unsyncedCount > 0 && provider.isOnline)
              FloatingActionButton(
                onPressed: () => provider.manualSync(),
                backgroundColor: Colors.orange,
                tooltip: 'Sincronizar ahora',
                child: const Icon(Icons.sync),
              ),
            const SizedBox(height: 12),
            // Botón agregar tarea
            FloatingActionButton.extended(
              onPressed: () => _showAddTaskDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Nueva Tarea'),
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int idx) {
    final isSelected = _tab == idx;
    return GestureDetector(
      onTap: () => setState(() => _tab = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Describe tu tarea...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.task_alt),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                context.read<TaskProvider>().addTask(ctrl.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

// TARJETA DE TAREA CON DISEÑO MODERNO
class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<TaskProvider>().toggleTask(widget.task.id),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Card(
          elevation: widget.task.completed ? 0 : 2,
          color: widget.task.completed ? Colors.grey[100] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: widget.task.completed
                  ? Colors.green.shade200
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: widget.task.completed
                  ? LinearGradient(
                      colors: [Colors.green.shade50, Colors.blue.shade50],
                    )
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: GestureDetector(
                onTap: () {
                  context.read<TaskProvider>().toggleTask(widget.task.id);
                  if (!widget.task.completed) {
                    _controller.forward();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: widget.task.completed
                            ? LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                              )
                            : null,
                        border: widget.task.completed
                            ? null
                            : Border.all(color: Colors.blue, width: 2),
                      ),
                      child: widget.task.completed
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                    // Indicador de no sincronizado
                    if (!widget.task.synced)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              title: Text(
                widget.task.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  decoration: widget.task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: widget.task.completed
                      ? Colors.grey[500]
                      : Colors.black,
                  fontWeight: widget.task.completed
                      ? FontWeight.normal
                      : FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
                onPressed: () =>
                    context.read<TaskProvider>().deleteTask(widget.task.id),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
