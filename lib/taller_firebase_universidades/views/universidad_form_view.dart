import 'package:flutter/material.dart';
import '../models/universidad.dart';
import '../services/universidad_service.dart';
import '../utils/validators.dart';

/// Vista para crear o editar una universidad
class UniversidadFormView extends StatefulWidget {
  final Universidad?
  universidad; // Si es null, es crear; si tiene valor, es editar

  const UniversidadFormView({Key? key, this.universidad}) : super(key: key);

  @override
  State<UniversidadFormView> createState() => _UniversidadFormViewState();
}

class _UniversidadFormViewState extends State<UniversidadFormView> {
  final _formKey = GlobalKey<FormState>();
  final UniversidadService _service = UniversidadService();

  late TextEditingController _nitController;
  late TextEditingController _nombreController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  late TextEditingController _paginaWebController;

  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.universidad != null;

    _nitController = TextEditingController(text: widget.universidad?.nit ?? '');
    _nombreController = TextEditingController(
      text: widget.universidad?.nombre ?? '',
    );
    _direccionController = TextEditingController(
      text: widget.universidad?.direccion ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.universidad?.telefono ?? '',
    );
    _paginaWebController = TextEditingController(
      text: widget.universidad?.paginaWeb ?? '',
    );
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }

  /// Guarda o actualiza la universidad
  Future<void> _guardarUniversidad() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final universidad = Universidad(
        id: widget.universidad?.id ?? '',
        nit: _nitController.text.trim(),
        nombre: _nombreController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        paginaWeb: _paginaWebController.text.trim(),
      );

      if (_isEditing) {
        // Actualizar universidad existente
        await _service.actualizarUniversidad(universidad.id, universidad);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Universidad actualizada exitosamente'),
            ),
          );
        }
      } else {
        // Crear nueva universidad
        await _service.crearUniversidad(universidad);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Universidad creada exitosamente')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Universidad' : 'Nueva Universidad'),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título descriptivo
              Text(
                _isEditing
                    ? 'Actualiza la información de la universidad'
                    : 'Completa los datos de la nueva universidad',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Campo NIT
              TextFormField(
                controller: _nitController,
                decoration: InputDecoration(
                  labelText: 'NIT',
                  hintText: '890.123.456-7',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: Validators.validateNit,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Campo Nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Universidad',
                  hintText: 'UCEVA',
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: Validators.validateNombre,
              ),
              const SizedBox(height: 16),

              // Campo Dirección
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Cra 27A #48-144, Tuluá - Valle',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: Validators.validateDireccion,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Campo Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: '+57 602 2242202',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: Validators.validateTelefono,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Campo Página Web
              TextFormField(
                controller: _paginaWebController,
                decoration: InputDecoration(
                  labelText: 'Página Web',
                  hintText: 'https://www.uceva.edu.co',
                  prefixIcon: const Icon(Icons.language),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: Validators.validatePaginaWeb,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),

              // Botones de acción
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Botón Guardar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _guardarUniversidad,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue.shade600,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _isEditing ? 'Actualizar' : 'Crear',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    // Botón Cancelar
                    OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
