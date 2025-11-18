import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/universidad.dart';

/// Widget que muestra una tarjeta con la información de una universidad
class UniversidadCard extends StatelessWidget {
  final Universidad universidad;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UniversidadCard({
    Key? key,
    required this.universidad,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  /// Abre la página web de la universidad
  Future<void> _abrirPaginaWeb() async {
    final url = universidad.paginaWeb;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('No se puede abrir la URL: $url');
    }
  }

  /// Copia el teléfono al portapapeles
  void _copiarTelefono(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Teléfono copiado: ${universidad.telefono}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header con nombre y color
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Círculo con inicial
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Text(
                      universidad.nombre.isNotEmpty
                          ? universidad.nombre[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Nombre de la universidad
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        universidad.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIT: ${universidad.nit}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dirección
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: 'Dirección',
                  value: universidad.direccion,
                ),
                const SizedBox(height: 12),
                // Teléfono
                _buildInfoRow(
                  icon: Icons.phone,
                  label: 'Teléfono',
                  value: universidad.telefono,
                  onTap: () => _copiarTelefono(context),
                ),
                const SizedBox(height: 12),
                // Página web
                InkWell(
                  onTap: _abrirPaginaWeb,
                  child: _buildInfoRow(
                    icon: Icons.language,
                    label: 'Página web',
                    value: universidad.paginaWeb,
                    isLink: true,
                  ),
                ),
              ],
            ),
          ),
          // Botones de acciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDelete != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Eliminar'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ),
                if (onEdit != null)
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para mostrar una fila de información
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isLink = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: 220,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLink ? Colors.blue : Colors.black,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
