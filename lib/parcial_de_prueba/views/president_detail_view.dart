import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../models/president.dart';

class PresidentDetailView extends StatelessWidget {
  final int id;
  final President? president;

  const PresidentDetailView({super.key, required this.id, this.president});

  @override
  Widget build(BuildContext context) {
    if (president == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Regresar',
          ),
          title: const Text('Detalle'),
        ),
        body: const Center(child: Text('No se pudo cargar el presidente')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Regresar',
        ),
        title: Text(president!.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFCE1126), Color(0xFFE53945)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: president!.image != null && president!.image!.isNotEmpty
                  ? Image.network(
                      president!.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    )
                  : const Icon(Icons.person, size: 100, color: Colors.white),
            ),

            // Biography Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biografia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFCE1126),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Nombre Completo', president!.fullName),
                          const Divider(),
                          _buildInfoRow('Nombre', president!.name),
                          const Divider(),
                          _buildInfoRow('Apellido', president!.lastName),
                          if (president!.politicalParty != null &&
                              president!.politicalParty!.isNotEmpty) ...[
                            const Divider(),
                            _buildInfoRow(
                              'Partido Politico',
                              president!.politicalParty!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Period Section
                  const Text(
                    'Periodo Presidencial',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFCE1126),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Periodo', president!.period),
                          const Divider(),
                          _buildInfoRow(
                            'Inicio',
                            president!.startPeriodDate ?? 'N/A',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Fin',
                            president!.endPeriodDate ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Technical Info Section
                  const Text(
                    'Informacion Tecnica',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFCE1126),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCopyableRow(
                            context,
                            'ID',
                            president!.id.toString(),
                          ),
                          if (president!.image != null &&
                              president!.image!.isNotEmpty) ...[
                            const Divider(),
                            _buildCopyableRow(
                              context,
                              'URL Imagen',
                              president!.image!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copiado al portapapeles')),
              );
            },
          ),
        ],
      ),
    );
  }
}
