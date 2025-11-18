import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../models/touristic_attraction.dart';

class AttractionDetailView extends StatelessWidget {
  final int id;
  final TouristicAttraction? attraction;

  const AttractionDetailView({super.key, required this.id, this.attraction});

  @override
  Widget build(BuildContext context) {
    if (attraction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: const Center(child: Text('No se pudo cargar la atraccion')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
              tooltip: 'Regresar',
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                attraction!.name,
                style: const TextStyle(
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: attraction!.hasImages
                  ? Image.network(
                      attraction!.mainImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFFCD116),
                          child: const Icon(
                            Icons.attractions_outlined,
                            size: 100,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFFCD116),
                      child: const Icon(
                        Icons.attractions_outlined,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSection(context, 'Descripcion', Icons.description, [
                    Text(
                      attraction!.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Coordinates
                  _buildSection(context, 'Ubicacion', Icons.location_on, [
                    _buildInfoRow('Coordenadas', attraction!.coordinates),
                    if (attraction!.latitude != null)
                      _buildCopyableInfo(
                        context,
                        'Latitud',
                        attraction!.latitude!,
                      ),
                    if (attraction!.longitude != null)
                      _buildCopyableInfo(
                        context,
                        'Longitud',
                        attraction!.longitude!,
                      ),
                  ]),

                  const SizedBox(height: 16),

                  // Images Gallery
                  if (attraction!.images.length > 1)
                    _buildSection(
                      context,
                      'Galeria (${attraction!.images.length} imagenes)',
                      Icons.photo_library,
                      [
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: attraction!.images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    attraction!.images[index],
                                    width: 150,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 150,
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  if (attraction!.images.length > 1) const SizedBox(height: 16),

                  // Technical Info
                  _buildSection(context, 'Informacion Tecnica', Icons.info, [
                    _buildCopyableInfo(
                      context,
                      'ID',
                      attraction!.id.toString(),
                    ),
                    if (attraction!.cityId != null)
                      _buildCopyableInfo(
                        context,
                        'ID Ciudad',
                        attraction!.cityId.toString(),
                      ),
                  ]),
                ],
              ),
            ),
          ),
        ],
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
                Icon(icon, color: const Color(0xFFFCD116)),
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
            width: 100,
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
