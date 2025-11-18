import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/airport.dart';

class AirportService {
  final String _baseUrl =
      dotenv.env['API_COLOMBIA_URL'] ?? 'https://api-colombia.com';

  // Get all airports
  Future<List<Airport>> getAllAirports() async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/Airport');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Airport.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar aeropuertos. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Get airport by ID
  Future<Airport> getAirportById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/Airport/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Airport.fromJson(data);
      } else {
        throw Exception(
          'Error al cargar aeropuerto. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Search airports by name
  Future<List<Airport>> searchAirports(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/Airport/search/$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Airport.fromJson(json)).toList();
      } else {
        throw Exception('Error en busqueda. Codigo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
}
