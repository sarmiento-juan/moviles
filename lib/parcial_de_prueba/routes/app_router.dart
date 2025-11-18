import 'package:go_router/go_router.dart';
import '../views/dashboard_view.dart';
import '../views/departments_list_view.dart';
import '../views/department_detail_view.dart';
import '../views/presidents_list_view.dart';
import '../views/president_detail_view.dart';
import '../views/attractions_list_view.dart';
import '../views/attraction_detail_view.dart';
import '../views/airports_list_view.dart';
import '../views/airport_detail_view.dart';
import '../models/department.dart';
import '../models/president.dart';
import '../models/touristic_attraction.dart';
import '../models/airport.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Dashboard (Home)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const DashboardView(),
      ),

      // Departments routes
      GoRoute(
        path: '/departments',
        name: 'departments',
        builder: (context, state) => const DepartmentsListView(),
      ),
      GoRoute(
        path: '/departments/:id',
        name: 'department_detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id'] ?? '0');
          final department = state.extra as Department?;
          return DepartmentDetailView(id: id, department: department);
        },
      ),

      // Presidents routes
      GoRoute(
        path: '/presidents',
        name: 'presidents',
        builder: (context, state) => const PresidentsListView(),
      ),
      GoRoute(
        path: '/presidents/:id',
        name: 'president_detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id'] ?? '0');
          final president = state.extra as President?;
          return PresidentDetailView(id: id, president: president);
        },
      ),

      // Touristic Attractions routes
      GoRoute(
        path: '/attractions',
        name: 'attractions',
        builder: (context, state) => const AttractionsListView(),
      ),
      GoRoute(
        path: '/attractions/:id',
        name: 'attraction_detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id'] ?? '0');
          final attraction = state.extra as TouristicAttraction?;
          return AttractionDetailView(id: id, attraction: attraction);
        },
      ),

      // Airports routes
      GoRoute(
        path: '/airports',
        name: 'airports',
        builder: (context, state) => const AirportsListView(),
      ),
      GoRoute(
        path: '/airports/:id',
        name: 'airport_detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id'] ?? '0');
          final airport = state.extra as Airport?;
          return AirportDetailView(id: id, airport: airport);
        },
      ),
    ],
  );
}
