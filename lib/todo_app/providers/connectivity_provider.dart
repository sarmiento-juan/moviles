import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Provider para monitorear conectividad
class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  String get statusText => _isOnline ? 'En línea' : 'Sin conexión';
  Color get statusColor => _isOnline ? Colors.green : Colors.red;

  ConnectivityProvider() {
    _initConnectivity();
  }

  /// Inicializar escucha de conectividad
  void _initConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      _handleConnectivityChange(result);
    });
  }

  /// Manejar cambios de conectividad
  void _handleConnectivityChange(List<ConnectivityResult> result) {
    _isOnline = !result.contains(ConnectivityResult.none);
    notifyListeners();
  }

  /// Verificar conexión actual
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = !result.contains(ConnectivityResult.none);
    notifyListeners();
    return _isOnline;
  }
}
