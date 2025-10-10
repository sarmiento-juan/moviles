import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/joke.dart';

/// Servicio para consumir la API de Chuck Norris
/// Documentacion oficial de la API
class ChuckNorrisService {
  // Base URL de la API desde variables de entorno
  final String _baseUrl = dotenv.env['CHUCK_NORRIS_API_URL'] ?? '';

  /// Obtiene una broma aleatoria
  ///
  /// Endpoint: GET /jokes/random
  ///
  /// Ejemplo de respuesta:
  /// ```json
  /// {
  ///   "categories": [],
  ///   "created_at": "2020-01-05 13:42:24.142371",
  ///   "icon_url": "...",
  ///   "id": "SR9ceDDCQX2Wc5uEHtYGPA",
  ///   "updated_at": "2020-01-05 13:42:24.142371",
  ///   "url": "...",
  ///   "value": "Chuck Norris jumped out of the fire..."
  /// }
  /// ```
  Future<Joke> getRandomJoke() async {
    try {
      final url = Uri.parse('$_baseUrl/jokes/random');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Joke.fromJson(data);
      } else {
        throw Exception(
          'Error al cargar la broma. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  /// Obtiene las categorias disponibles
  ///
  /// Endpoint: GET /jokes/categories
  ///
  /// Ejemplo de respuesta:
  /// ```json
  /// ["animal","career","celebrity","dev","explicit","fashion","food","history","money","movie","music","political","religion","science","sport","travel"]
  /// ```
  Future<List<String>> getCategories() async {
    try {
      final url = Uri.parse('$_baseUrl/jokes/categories');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((category) => category.toString()).toList();
      } else {
        throw Exception(
          'Error al cargar las categorias. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  /// Obtiene una broma aleatoria de una categoria especifica
  ///
  /// Endpoint: GET /jokes/random?category={category}
  ///
  /// [category] debe ser una categoria valida obtenida de getCategories()
  Future<Joke> getJokeByCategory(String category) async {
    try {
      final url = Uri.parse('$_baseUrl/jokes/random?category=$category');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Joke.fromJson(data);
      } else {
        throw Exception(
          'Error al cargar la broma. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  /// Busca bromas por texto
  ///
  /// Endpoint: GET /jokes/search?query={query}
  ///
  /// [query] es el texto a buscar en las bromas
  ///
  /// Ejemplo de respuesta:
  /// ```json
  /// {
  ///   "total": 5,
  ///   "result": [
  ///     {
  ///       "categories": [],
  ///       "created_at": "...",
  ///       "icon_url": "...",
  ///       "id": "...",
  ///       "updated_at": "...",
  ///       "url": "...",
  ///       "value": "..."
  ///     }
  ///   ]
  /// }
  /// ```
  Future<List<Joke>> searchJokes(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/jokes/search?query=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['result'] ?? [];
        return results.map((joke) => Joke.fromJson(joke)).toList();
      } else {
        throw Exception(
          'Error al buscar bromas. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
}
