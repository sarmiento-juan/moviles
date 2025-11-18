import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../models/department.dart';

class DepartmentDetailView extends StatelessWidget {
  final int id;
  final Department? department;

  const DepartmentDetailView({super.key, required this.id, this.department});

  @override
  Widget build(BuildContext context) {
    if (department == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: const Center(child: Text('No se pudo cargar el departamento')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Regresar',
        ),
        title: Text(department!.name),
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
            // Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003893), Color(0xFF0056D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    department!.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Departamento de Colombia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSection(context, 'Descripcion', Icons.description, [
                    _buildInfoText(department!.description),
                  ]),

                  const SizedBox(height: 24),

                  // Statistics
                  _buildSection(context, 'Estadisticas', Icons.analytics, [
                    _buildInfoRow(
                      'Municipios',
                      '${department!.municipalities}',
                    ),
                    _buildInfoRow(
                      'Poblacion',
                      department!.population.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      ),
                    ),
                    _buildInfoRow('Superficie', '${department!.surface} km²'),
                    if (department!.phonePrefix != null)
                      _buildInfoRow(
                        'Prefijo',
                        '+57 ${department!.phonePrefix}',
                      ),
                  ]),

                  const SizedBox(height: 24),

                  // Technical Information
                  _buildSection(context, 'Informacion Tecnica', Icons.info, [
                    _buildCopyableInfo(
                      context,
                      'ID',
                      department!.id.toString(),
                    ),
                    if (department!.cityCapitalId != null)
                      _buildCopyableInfo(
                        context,
                        'ID Capital',
                        department!.cityCapitalId!,
                      ),
                    if (department!.regionId != null)
                      _buildCopyableInfo(
                        context,
                        'ID Region',
                        department!.regionId.toString(),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF003893)),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

  Widget _buildInfoText(String text) {
    return Text(text, style: const TextStyle(fontSize: 16, height: 1.5));
  }

  Widget _buildCopyableInfo(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: _buildInfoRow(label, value)),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
