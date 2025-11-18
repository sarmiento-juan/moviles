import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/department.dart';

class DepartmentService {
  final String _baseUrl =
      dotenv.env['API_COLOMBIA_URL'] ?? 'https://api-colombia.com';

  // Get all departments
  Future<List<Department>> getAllDepartments() async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/Department');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar departamentos. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Get department by ID
  Future<Department> getDepartmentById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/Department/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Department.fromJson(data);
      } else {
        throw Exception(
          'Error al cargar departamento. Codigo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }

  // Search departments by name
  Future<List<Department>> searchDepartments(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/Department/search/$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Error en busqueda. Codigo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
}
