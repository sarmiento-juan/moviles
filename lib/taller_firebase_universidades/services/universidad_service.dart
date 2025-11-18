import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';

/// Servicio para manejar operaciones CRUD con la colección 'universidades' en Firestore
class UniversidadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'universidades';

  /// Obtiene un stream en tiempo real de todas las universidades
  /// Útil para mostrar la lista actualizada automáticamente
  Stream<List<Universidad>> obtenerUniversidadesStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('nombre') // Ordenar alfabéticamente por nombre
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Universidad.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  /// Obtiene todas las universidades de forma futura (sin stream)
  Future<List<Universidad>> obtenerUniversidades() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('nombre')
          .get();

      return snapshot.docs
          .map((doc) => Universidad.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error al obtener universidades: $e');
      rethrow;
    }
  }

  /// Obtiene una universidad específica por su ID
  Future<Universidad?> obtenerUniversidadPorId(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return Universidad.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error al obtener universidad: $e');
      rethrow;
    }
  }

  /// Crea una nueva universidad en Firestore
  /// Retorna el ID del documento creado
  Future<String> crearUniversidad(Universidad universidad) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(universidad.toFirestore());

      print('Universidad creada con ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error al crear universidad: $e');
      rethrow;
    }
  }

  /// Actualiza una universidad existente
  Future<void> actualizarUniversidad(String id, Universidad universidad) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .update(universidad.toFirestore());

      print('Universidad actualizada: $id');
    } catch (e) {
      print('Error al actualizar universidad: $e');
      rethrow;
    }
  }

  /// Elimina una universidad
  Future<void> eliminarUniversidad(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();

      print('Universidad eliminada: $id');
    } catch (e) {
      print('Error al eliminar universidad: $e');
      rethrow;
    }
  }

  /// Verifica si ya existe una universidad con el mismo NIT
  Future<bool> existeNit(String nit) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('nit', isEqualTo: nit)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar NIT: $e');
      rethrow;
    }
  }

  /// Busca universidades por nombre
  Future<List<Universidad>> buscarPorNombre(String nombre) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('nombre', isGreaterThanOrEqualTo: nombre)
          .where('nombre', isLessThan: nombre + 'z')
          .get();

      return snapshot.docs
          .map((doc) => Universidad.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error al buscar universidades: $e');
      rethrow;
    }
  }

  /// Obtiene el número total de universidades registradas
  Future<int> obtenerTotalUniversidades() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error al obtener total de universidades: $e');
      rethrow;
    }
  }
}
