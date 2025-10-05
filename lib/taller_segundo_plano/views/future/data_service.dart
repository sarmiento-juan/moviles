import 'dart:math';

/// Servicio simulado para demostrar el uso de Future, async/await
/// Este servicio simula llamadas a una API con delays y posibles errores
class DataService {
  /// Simula la obtención de datos de usuarios
  /// Puede fallar aleatoriamente para demostrar manejo de errores
  static Future<List<Map<String, String>>> fetchUsers() async {
    print('🟡 [ANTES] Iniciando petición de usuarios...');
    
    // Simula tiempo de respuesta de API (2-3 segundos)
    await Future.delayed(const Duration(seconds: 2));
    
    print('🔵 [DURANTE] Procesando datos del servidor...');
    
    // Simula error aleatorio (20% de probabilidad)
    if (Random().nextInt(10) < 2) {
      print('🔴 [ERROR] Fallo en la conexión con el servidor');
      throw Exception('Error de conexión: El servidor no responde');
    }
    
    // Simula procesamiento de datos
    await Future.delayed(const Duration(seconds: 1));
    
    print('🟢 [DESPUÉS] Datos obtenidos exitosamente');
    
    return [
      {'nombre': 'Juan Pérez', 'rol': 'Desarrollador', 'email': 'juan@example.com'},
      {'nombre': 'María García', 'rol': 'Diseñadora', 'email': 'maria@example.com'},
      {'nombre': 'Carlos López', 'rol': 'Product Manager', 'email': 'carlos@example.com'},
      {'nombre': 'Ana Martínez', 'rol': 'QA Tester', 'email': 'ana@example.com'},
      {'nombre': 'Luis Rodríguez', 'rol': 'DevOps', 'email': 'luis@example.com'},
    ];
  }

  /// Simula la obtención de un perfil de usuario específico
  static Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    print('🟡 [ANTES] Cargando perfil del usuario $userId...');
    
    await Future.delayed(const Duration(seconds: 2));
    
    print('🔵 [DURANTE] Obteniendo datos del perfil...');
    
    // Simula error aleatorio
    if (Random().nextInt(10) < 3) {
      print('🔴 [ERROR] Usuario no encontrado');
      throw Exception('Usuario no encontrado en la base de datos');
    }
    
    print('🟢 [DESPUÉS] Perfil cargado correctamente');
    
    return {
      'id': userId,
      'nombre': 'Usuario Demo',
      'edad': Random().nextInt(50) + 20,
      'ciudad': 'Bogotá',
      'pais': 'Colombia',
      'biografia': 'Desarrollador Flutter apasionado por crear apps increíbles',
    };
  }

  /// Simula múltiples peticiones simultáneas
  static Future<Map<String, dynamic>> fetchDashboardData() async {
    print('🟡 [ANTES] Iniciando carga de dashboard...');
    
    // Ejecuta múltiples Futures en paralelo usando Future.wait
    final results = await Future.wait([
      _fetchStats(),
      _fetchNotifications(),
      _fetchRecentActivity(),
    ]);
    
    print('🟢 [DESPUÉS] Dashboard cargado completamente');
    
    return {
      'stats': results[0],
      'notifications': results[1],
      'activity': results[2],
    };
  }

  static Future<Map<String, int>> _fetchStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'usuarios': 1250,
      'ventas': 350,
      'ingresos': 45000,
    };
  }

  static Future<List<String>> _fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return [
      'Nueva venta realizada',
      'Usuario registrado',
      'Actualización disponible',
    ];
  }

  static Future<List<String>> _fetchRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      'Login desde dispositivo móvil',
      'Actualización de perfil',
      'Nueva configuración guardada',
    ];
  }
}
