import 'package:dio/dio.dart';
import '../../models/task.dart';

/// Excepción personalizada para errores de API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? originalError;

  ApiException({required this.message, this.statusCode, this.originalError});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Servicio de API REST para tareas
class TaskRemoteDataSource {
  final Dio _dio;
  final String baseUrl;

  TaskRemoteDataSource({required this.baseUrl, Dio? dio})
    : _dio = dio ?? Dio() {
    _setupDio();
  }

  /// Configurar Dio con timeouts y interceptores
  void _setupDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.sendTimeout = Duration(seconds: 30);

    // Interceptor para logs
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        requestHeader: false,
      ),
    );
  }

  /// Obtener todas las tareas
  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Error al obtener tareas',
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = response.data ?? [];
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Obtener tarea por ID
  Future<Task> getTaskById(String id) async {
    try {
      final response = await _dio.get('/tasks/$id');

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Error al obtener tarea',
          statusCode: response.statusCode,
        );
      }

      return Task.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Crear nueva tarea
  Future<Task> createTask(Task task) async {
    try {
      final response = await _dio.post(
        '/tasks',
        data: task.toJson(),
        options: Options(headers: {'Idempotency-Key': task.id}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          message: 'Error al crear tarea',
          statusCode: response.statusCode,
        );
      }

      return Task.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Actualizar tarea
  Future<Task> updateTask(String id, Task task) async {
    try {
      final response = await _dio.put(
        '/tasks/$id',
        data: task.toJson(),
        options: Options(
          headers: {
            'Idempotency-Key': '$id-${task.updatedAt.millisecondsSinceEpoch}',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Error al actualizar tarea',
          statusCode: response.statusCode,
        );
      }

      return Task.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Eliminar tarea
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete(
        '/tasks/$id',
        options: Options(headers: {'Idempotency-Key': '$id-delete'}),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Error al eliminar tarea',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Manejar excepciones de Dio
  ApiException _handleDioException(DioException e) {
    String message = 'Error desconocido';
    int? statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Timeout de conexión. Verifica tu conexión a internet.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Timeout al enviar datos.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Timeout al recibir datos.';
        break;
      case DioExceptionType.badResponse:
        statusCode = e.response?.statusCode;
        message = _getMessageFromStatusCode(statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Solicitud cancelada.';
        break;
      default:
        message = 'Error de conexión: ${e.message}';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      originalError: e.toString(),
    );
  }

  /// Obtener mensaje según código de estado
  String _getMessageFromStatusCode(int? code) {
    switch (code) {
      case 400:
        return 'Solicitud inválida.';
      case 401:
        return 'No autorizado.';
      case 403:
        return 'Acceso prohibido.';
      case 404:
        return 'Recurso no encontrado.';
      case 409:
        return 'Conflicto: la tarea ya existe.';
      case 500:
        return 'Error del servidor. Intenta más tarde.';
      case 503:
        return 'Servicio no disponible.';
      default:
        return 'Error en la solicitud (código: $code).';
    }
  }
}
