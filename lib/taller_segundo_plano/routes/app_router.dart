import 'package:go_router/go_router.dart';
import '../views/home/home_screen.dart';
import '../views/ciclo_vida/ciclo_vida_screen.dart';
import '../views/paso_parametros/paso_parametros_screen.dart';
import '../views/future/future_view.dart';
import '../views/future/timer_view.dart';
import '../views/isolate/isolate_view.dart';

// Configuración del router de la aplicación
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta principal
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Ruta de ciclo de vida
    GoRoute(
      path: '/ciclo_vida',
      name: 'ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),

    // Ruta de paso de parámetros
    GoRoute(
      path: '/paso_parametros',
      name: 'paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),

    // Ruta de Future (async/await)
    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureView(),
    ),

    // Ruta de Timer (cronómetro)
    GoRoute(
      path: '/timer',
      name: 'timer',
      builder: (context, state) => const TimerView(),
    ),

    // Ruta de Isolate (tareas pesadas)
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateView(),
    ),
  ],
);
