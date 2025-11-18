import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/touristic_attraction.dart';

class TouristicAttractionService {
  final String _baseUrl =
      dotenv.env['API_COLOMBIA_URL'] ?? 'https://api-colombia.com';

  // Get all touristic attractions
  Future<List<TouristicAttraction>> getAllAttractions() async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/TouristicAttraction');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TouristicAttraction.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar atracciones. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Get attraction by ID
  Future<TouristicAttraction> getAttractionById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/TouristicAttraction/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TouristicAttraction.fromJson(data);
      } else {
        throw Exception(
          'Error al cargar atraccion. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Search attractions by name
  Future<List<TouristicAttraction>> searchAttractions(String query) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/api/v1/TouristicAttraction/search/$query',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TouristicAttraction.fromJson(json)).toList();
      } else {
        throw Exception('Error en busqueda. Codigo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
}
