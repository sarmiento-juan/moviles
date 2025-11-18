import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/president.dart';

class PresidentService {
  final String _baseUrl =
      dotenv.env['API_COLOMBIA_URL'] ?? 'https://api-colombia.com';

  // Get all presidents
  Future<List<President>> getAllPresidents() async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/President');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => President.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar presidentes. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Get president by ID
  Future<President> getPresidentById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/President/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return President.fromJson(data);
      } else {
        throw Exception(
          'Error al cargar presidente. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Search presidents by name
  Future<List<President>> searchPresidents(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/President/search/$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => President.fromJson(json)).toList();
      } else {
        throw Exception('Error en busqueda. Codigo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
}
