// Este archivo muestra cómo inicializar Firebase si es necesario
// Por defecto, Firebase se inicializa automáticamente en Flutter 3.0+
// pero aquí mostramos cómo hacerlo manual si lo necesitas

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Inicializa Firebase con las opciones específicas de tu proyecto
/// Llamar esto en main() si es necesario
Future<void> initializeFirebase() async {
  // Esta función se ejecuta automáticamente en Flutter 3.0+
  // pero puedes usarla si necesitas inicialización manual
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/* 
INSTRUCCIONES DE CONFIGURACION:

1. Instala Firebase CLI:
   npm install -g firebase-tools

2. Configura Firebase en tu proyecto Flutter:
   flutterfire configure

3. Selecciona:
   - Plataformas: Android, iOS (y Web si lo necesitas)
   - Proyecto Firebase: Tu proyecto

4. Esto genera el archivo firebase_options.dart automáticamente

ALTERNATIVA MANUAL:

Si no tienes firebase-tools instalado:

1. Ve a Firebase Console
2. Project Settings > Your apps
3. Agrega app Android y iOS
4. Descarga google-services.json (Android)
5. Descarga GoogleService-Info.plist (iOS)
6. Coloca en carpetas correctas
*/

// Importa esto en main.dart si inicializas manual:
// import 'firebase_init.dart';
//
// Luego en main():
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeFirebase();
//   runApp(const MyApp());
// }
