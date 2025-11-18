/// Modelo de datos para Universidad
/// Representa un documento en la colección 'universidades' de Firestore
class Universidad {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  Universidad({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  /// Convierte un documento de Firestore a objeto Universidad
  factory Universidad.fromFirestore(Map<String, dynamic> data, String id) {
    return Universidad(
      id: id,
      nit: data['nit'] ?? '',
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      paginaWeb: data['pagina_web'] ?? '',
    );
  }

  /// Convierte un objeto Universidad a mapa para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }

  /// Crea una copia del objeto Universidad con algunos campos modificados
  Universidad copyWith({
    String? id,
    String? nit,
    String? nombre,
    String? direccion,
    String? telefono,
    String? paginaWeb,
  }) {
    return Universidad(
      id: id ?? this.id,
      nit: nit ?? this.nit,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      paginaWeb: paginaWeb ?? this.paginaWeb,
    );
  }

  @override
  String toString() {
    return 'Universidad{id: $id, nit: $nit, nombre: $nombre, direccion: $direccion, telefono: $telefono, paginaWeb: $paginaWeb}';
  }
}
