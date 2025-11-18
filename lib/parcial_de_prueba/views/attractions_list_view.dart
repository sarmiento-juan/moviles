import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/touristic_attraction.dart';
import '../services/touristic_attraction_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/empty_state_widget.dart';

class AttractionsListView extends StatefulWidget {
  const AttractionsListView({super.key});

  @override
  State<AttractionsListView> createState() => _AttractionsListViewState();
}

class _AttractionsListViewState extends State<AttractionsListView> {
  final TouristicAttractionService _service = TouristicAttractionService();
  List<TouristicAttraction> _attractions = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final attractions = await _service.getAllAttractions();
      setState(() {
        _attractions = attractions;
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
        title: const Text('Atracciones Turisticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttractions,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando atracciones...');
    }

    if (_error != null) {
      return custom.ErrorWidget(message: _error!, onRetry: _loadAttractions);
    }

    if (_attractions.isEmpty) {
      return const EmptyStateWidget(
        message: 'No se encontraron atracciones',
        icon: Icons.attractions_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAttractions,
      child: ListView.builder(
        itemCount: _attractions.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final attraction = _attractions[index];
          return Card(
            child: ListTile(
              leading: attraction.hasImages
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        attraction.mainImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFFFCD116),
                            child: const Icon(
                              Icons.attractions_outlined,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD116),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.attractions_outlined,
                        color: Colors.white,
                      ),
                    ),
              title: Text(
                attraction.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                attraction.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(
                  '/attractions/${attraction.id}',
                  extra: attraction,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
