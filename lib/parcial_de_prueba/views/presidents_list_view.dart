import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/president.dart';
import '../services/president_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/empty_state_widget.dart';

class PresidentsListView extends StatefulWidget {
  const PresidentsListView({super.key});

  @override
  State<PresidentsListView> createState() => _PresidentsListViewState();
}

class _PresidentsListViewState extends State<PresidentsListView> {
  final PresidentService _service = PresidentService();
  List<President> _presidents = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPresidents();
  }

  Future<void> _loadPresidents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final presidents = await _service.getAllPresidents();
      setState(() {
        _presidents = presidents;
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
        title: const Text('Presidentes de Colombia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPresidents,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando presidentes...');
    }

    if (_error != null) {
      return custom.ErrorWidget(message: _error!, onRetry: _loadPresidents);
    }

    if (_presidents.isEmpty) {
      return const EmptyStateWidget(
        message: 'No se encontraron presidentes',
        icon: Icons.account_balance_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPresidents,
      child: ListView.builder(
        itemCount: _presidents.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final president = _presidents[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFCE1126),
                child: president.image != null && president.image!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          president.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                president.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(president.period, style: const TextStyle(fontSize: 12)),
                  if (president.politicalParty != null)
                    Text(
                      president.politicalParty!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push('/presidents/${president.id}', extra: president);
              },
            ),
          );
        },
      ),
    );
  }
}
