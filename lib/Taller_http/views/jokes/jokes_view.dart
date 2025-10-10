import 'package:flutter/material.dart';
import '../../services/chuck_norris_service.dart';
import '../../models/joke.dart';
import '../../widgets/base_view.dart';

/// Vista principal para mostrar bromas de Chuck Norris
class JokesView extends StatefulWidget {
  const JokesView({super.key});

  @override
  State<JokesView> createState() => _JokesViewState();
}

class _JokesViewState extends State<JokesView> {
  final ChuckNorrisService _service = ChuckNorrisService();
  Joke? _currentJoke;
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadCategories();
    await _loadRandomJoke();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _service.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      // Si falla la carga de categorias, continuamos sin ellas
      debugPrint('Error al cargar categorias: $e');
    }
  }

  Future<void> _loadRandomJoke() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final joke = await _service.getRandomJoke();
      setState(() {
        _currentJoke = joke;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJokeByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedCategory = category;
    });

    try {
      final joke = await _service.getJokeByCategory(category);
      setState(() {
        _currentJoke = joke;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona una categoria'),
        content: SizedBox(
          width: double.maxFinite,
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
                  _loadJokeByCategory(category);
                },
              );
            },
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

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Chuck Norris Jokes',
      body: RefreshIndicator(
        onRefresh: _loadRandomJoke,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titulo con icono
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_very_satisfied,
                    size: 40,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Chuck Norris Facts',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tarjeta con la broma
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_error != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_currentJoke != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.orange.shade50, Colors.orange.shade100],
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icono de Chuck Norris (siempre esta disponible en la API)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              _currentJoke!.iconUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.orange,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Texto de la broma
                        Text(
                          _currentJoke!.value,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontSize: 18,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // ID de la broma (opcional, para debug)
                        Center(
                          child: Text(
                            'ID: ${_currentJoke!.id}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Categorias si existen
                        if (_currentJoke!.hasCategories)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: _currentJoke!.categories.map((category) {
                              return Chip(
                                label: Text(
                                  category.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.orange.shade200,
                                avatar: const Icon(
                                  Icons.label,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              );
                            }).toList(),
                          ),

                        // Mostrar mensaje si no hay categorias
                        if (!_currentJoke!.hasCategories)
                          Center(
                            child: Chip(
                              label: const Text(
                                'SIN CATEGORiA',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.grey.shade300,
                              avatar: const Icon(
                                Icons.help_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Boton: Siguiente broma aleatoria
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _loadRandomJoke,
                icon: const Icon(Icons.refresh),
                label: const Text('Nueva Broma Aleatoria'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Boton: Categorias
              if (_categories.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _showCategoriesDialog,
                  icon: const Icon(Icons.category),
                  label: Text(
                    _selectedCategory != null
                        ? 'Categoria: ${_selectedCategory!.toUpperCase()}'
                        : 'Ver por Categoria',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    foregroundColor: Colors.orange.shade700,
                    side: BorderSide(color: Colors.orange.shade700, width: 2),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Informacion adicional
              const SizedBox(height: 32),
              Text(
                '💡 Desliza hacia abajo para recargar',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
