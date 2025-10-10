import 'package:go_router/go_router.dart';
import '../views/jokes/jokes_list_view.dart';
import '../views/jokes/joke_detail_view.dart';

/// Configuracion de rutas de la aplicacion usando GoRouter
///
/// Rutas definidas:
/// - / : Pantalla principal con listado de bromas
/// - /detail/:id : Pantalla de detalle de una broma especifica
class AppRouter {
  static const String home = '/';
  static const String detail = '/detail';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      // Ruta principal: Listado de bromas
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const JokesListView(),
      ),

      // Ruta de detalle: Informacion ampliada de una broma
      // Parametros recibidos via extra (objeto Joke completo)
      GoRoute(
        path: '$detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;

          return JokeDetailView(id: id, jokeData: extra);
        },
      ),
    ],

    // Manejo de errores de navegacion
    errorBuilder: (context, state) => const JokesListView(),
  );
}
