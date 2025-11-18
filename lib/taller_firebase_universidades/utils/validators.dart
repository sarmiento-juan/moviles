/// Utilidades para validar datos de universidades
class Validators {
  /// Valida que el NIT no esté vacío
  /// NIT debe estar en formato: 890.123.456-7
  static String? validateNit(String? value) {
    if (value == null || value.isEmpty) {
      return 'El NIT es requerido';
    }

    // Remover caracteres especiales para validar
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length < 8) {
      return 'El NIT debe tener al menos 8 dígitos';
    }

    return null;
  }

  /// Valida que el nombre no esté vacío
  static String? validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }

    if (value.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (value.length > 100) {
      return 'El nombre no puede exceder 100 caracteres';
    }

    return null;
  }

  /// Valida que la dirección no esté vacía
  static String? validateDireccion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La dirección es requerida';
    }

    if (value.length < 5) {
      return 'La dirección debe tener al menos 5 caracteres';
    }

    return null;
  }

  /// Valida que el teléfono esté en formato válido
  static String? validateTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }

    // Remover caracteres especiales para validar
    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.length < 7) {
      return 'El teléfono debe tener al menos 7 dígitos';
    }

    return null;
  }

  /// Valida que la URL de página web sea válida
  static String? validatePaginaWeb(String? value) {
    if (value == null || value.isEmpty) {
      return 'La página web es requerida';
    }

    // Expresión regular para validar URLs
    final urlRegex = RegExp(
      r'^(https?:\/\/)?'
      r'(www\.)?'
      r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.'
      r'[a-zA-Z0-9()]{1,6}\b'
      r'([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida (ej: https://www.ejemplo.com)';
    }

    return null;
  }

  /// Formatea un NIT agregando puntos y guión
  /// Entrada: 890123456789 -> Salida: 890.123.456-7
  static String formatNit(String nit) {
    final cleaned = nit.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length < 8) return cleaned;

    // Agregar formato básico para números colombianos
    return cleaned.replaceFirstMapped(
      RegExp(r'(\d{1,3})(\d{1,3})(\d{1,3})(\d{0,3})'),
      (match) =>
          '${match.group(1)}.${match.group(2)}.${match.group(3)}-${match.group(4)}',
    );
  }

  /// Formatea un teléfono
  /// Entrada: 576022242202 -> Salida: +57 602 224 2202
  static String formatTelefono(String telefono) {
    final cleaned = telefono.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.startsWith('+57') && cleaned.length >= 12) {
      return '+57 ${cleaned.substring(3, 6)} ${cleaned.substring(6, 9)} ${cleaned.substring(9)}';
    }

    if (cleaned.length >= 10) {
      return '+57 ${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6)}';
    }

    return cleaned;
  }
}
