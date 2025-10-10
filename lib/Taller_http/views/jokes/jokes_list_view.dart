import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/chuck_norris_service.dart';
import '../../models/joke.dart';
import '../../widgets/base_view.dart';

/// Vista principal con listado de bromas de Chuck Norris
///
/// Funcionalidades:
/// - ListView.builder para mostrar multiples bromas
/// - Estados: cargando, exito, error
/// - Navegacion al detalle al tocar una broma
/// - Pull to refresh
/// - Filtrado por categorias
class JokesListView extends StatefulWidget {
  const JokesListView({super.key});

  @override
  State<JokesListView> createState() => _JokesListViewState();
}

class _JokesListViewState extends State<JokesListView> {
  final ChuckNorrisService _service = ChuckNorrisService();
  List<Joke> _jokes = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Carga inicial: categorias y bromas
  Future<void> _loadInitialData() async {
    await _loadCategories();
    await _loadJokes();
  }

  /// Obtiene las categorias disponibles de la API
  Future<void> _loadCategories() async {
    try {
      final categories = await _service.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      debugPrint('Error al cargar categorias: $e');
    }
  }

  /// Carga multiples bromas aleatorias o por categoria
  Future<void> _loadJokes({String? category}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedCategory = category;
    });

    try {
      final List<Joke> jokes = [];

      // Obtener 10 bromas
      for (int i = 0; i < 10; i++) {
        final joke = category != null
            ? await _service.getJokeByCategory(category)
            : await _service.getRandomJoke();
        jokes.add(joke);
      }

      setState(() {
        _jokes = jokes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar las bromas: $e';
        _isLoading = false;
      });

      // Mostrar mensaje de error al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexion: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: () => _loadJokes(category: category),
            ),
          ),
        );
      }
    }
  }

  /// Muestra dialog para seleccionar categoria
  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona una categoria'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Opcion: Todas las categorias
              ListTile(
                title: const Text(
                  'TODAS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.apps),
                onTap: () {
                  Navigator.pop(context);
                  _loadJokes();
                },
              ),
              const Divider(),
              // Lista de categorias especificas
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ListTile(
                      title: Text(
                        category.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      leading: const Icon(Icons.label_outline),
                      onTap: () {
                        Navigator.pop(context);
                        _loadJokes(category: category);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  /// Navega a la pantalla de detalle pasando la broma completa
  void _navigateToDetail(Joke joke) {
    context.pushNamed(
      'detail',
      pathParameters: {'id': joke.id},
      extra: {
        'value': joke.value,
        'iconUrl': joke.iconUrl,
        'url': joke.url,
        'categories': joke.categories,
        'createdAt': joke.createdAt,
        'updatedAt': joke.updatedAt,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Chuck Norris Jokes',
      actions: [
        // Boton para filtrar por categoria
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filtrar por categoria',
          onPressed: _isLoading ? null : _showCategoriesDialog,
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () => _loadJokes(category: _selectedCategory),
        child: Column(
          children: [
            // Header con titulo y categoria seleccionada
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade50, Colors.orange.shade100],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sentiment_very_satisfied,
                    size: 32,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chuck Norris Facts',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                        ),
                        if (_selectedCategory != null)
                          Text(
                            'Categoria: ${_selectedCategory!.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Estado: Cargando
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cargando bromas...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            // Estado: Error
            else if (_error != null && _jokes.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _loadJokes(category: _selectedCategory),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            // Estado: exito - ListView.builder
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _jokes.length,
                  itemBuilder: (context, index) {
                    final joke = _jokes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToDetail(joke),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagen de Chuck Norris
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  joke.iconUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.orange.shade100,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.orange,
                                          size: 40,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Contenido de la broma
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Texto de la broma (maximo 3 lineas)
                                    Text(
                                      joke.value,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Categorias o ID
                                    Row(
                                      children: [
                                        if (joke.hasCategories)
                                          ...joke.categories
                                              .take(2)
                                              .map(
                                                (cat) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 4,
                                                      ),
                                                  child: Chip(
                                                    label: Text(
                                                      cat.toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.orange.shade100,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ),
                                              )
                                        else
                                          Text(
                                            'ID: ${joke.id.substring(0, 8)}...',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Icono de navegacion
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
