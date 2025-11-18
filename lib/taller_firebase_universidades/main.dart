import 'package:flutter/material.dart';
import 'views/universidades_list_view.dart';
import 'views/universidad_form_view.dart';
import 'models/universidad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Universidades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const UniversidadesListView(),
      routes: {
        '/nueva-universidad': (context) => const UniversidadFormView(),
        '/editar-universidad': (context) {
          final universidad =
              ModalRoute.of(context)?.settings.arguments as Universidad?;
          return UniversidadFormView(universidad: universidad);
        },
      },
    );
  }
}
