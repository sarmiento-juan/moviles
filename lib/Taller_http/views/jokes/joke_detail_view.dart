import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/base_view.dart';

/// Vista de detalle de una broma de Chuck Norris
///
/// Recibe parametros por ruta:
/// - id: ID de la broma (path parameter)
/// - jokeData: Datos completos de la broma (extra)
///
/// Muestra informacion ampliada:
/// - Imagen de Chuck Norris
/// - Texto completo de la broma
/// - Categorias
/// - ID unico
/// - Fechas de creacion/actualizacion
/// - URL de la broma
class JokeDetailView extends StatelessWidget {
  final String id;
  final Map<String, dynamic>? jokeData;

  const JokeDetailView({super.key, required this.id, this.jokeData});

  /// Copia el texto de la broma al portapapeles
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Broma copiada al portapapeles'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Muestra un dialogo con informacion tecnica
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Informacion Tecnica'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('ID', id),
            const Divider(),
            if (jokeData != null) ...[
              _buildInfoRow('Creado', jokeData!['createdAt'] ?? 'N/A'),
              _buildInfoRow('Actualizado', jokeData!['updatedAt'] ?? 'N/A'),
              _buildInfoRow('URL', jokeData!['url'] ?? 'N/A'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para mostrar filas de informacion
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extraer datos de jokeData si estan disponibles
    final value = jokeData?['value'] ?? 'Cargando broma...';
    final iconUrl = jokeData?['iconUrl'] ?? '';
    final categories = jokeData?['categories'] as List<dynamic>? ?? [];

    return BaseView(
      title: 'Detalle',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero image con icono de Chuck Norris
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                ),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    iconUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titulo
                  Row(
                    children: [
                      const Icon(
                        Icons.format_quote,
                        color: Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Chuck Norris Fact',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Texto completo de la broma
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange.shade200,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Categorias
                  if (categories.isNotEmpty) ...[
                    const Text(
                      'Categorias',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade300,
                                Colors.orange.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.shade200,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.label,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.toString().toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ID de la broma
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.fingerprint,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'ID: $id',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botones de accion
                  Row(
                    children: [
                      // Boton: Copiar
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _copyToClipboard(context, value),
                          icon: const Icon(Icons.copy),
                          label: const Text('Copiar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Boton: Info
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showInfoDialog(context),
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Info'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange.shade700,
                            padding: const EdgeInsets.all(16),
                            side: BorderSide(
                              color: Colors.orange.shade700,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Boton: Volver
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver al Listado'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.all(16),
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
}
