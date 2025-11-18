import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/airport.dart';
import '../services/airport_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/empty_state_widget.dart';

class AirportsListView extends StatefulWidget {
  const AirportsListView({super.key});

  @override
  State<AirportsListView> createState() => _AirportsListViewState();
}

class _AirportsListViewState extends State<AirportsListView> {
  final AirportService _service = AirportService();
  List<Airport> _airports = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAirports();
  }

  Future<void> _loadAirports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final airports = await _service.getAllAirports();
      setState(() {
        _airports = airports;
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
        title: const Text('Aeropuertos de Colombia'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAirports),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando aeropuertos...');
    }

    if (_error != null) {
      return custom.ErrorWidget(message: _error!, onRetry: _loadAirports);
    }

    if (_airports.isEmpty) {
      return const EmptyStateWidget(
        message: 'No se encontraron aeropuertos',
        icon: Icons.flight_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAirports,
      child: ListView.builder(
        itemCount: _airports.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final airport = _airports[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF009739),
                child: const Icon(Icons.flight, color: Colors.white),
              ),
              title: Text(
                airport.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(airport.codes, style: const TextStyle(fontSize: 11)),
                  Text(
                    'Tipo: ${airport.type}',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push('/airports/${airport.id}', extra: airport);
              },
            ),
          );
        },
      ),
    );
  }
}
