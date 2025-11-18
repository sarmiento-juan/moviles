import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/local/task_local_datasource_web.dart';
import 'data/remote/task_remote_datasource.dart';
import 'repositories/task_repository.dart';
import 'providers/task_provider.dart';
import 'providers/connectivity_provider.dart';
import 'views/task_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: _buildApp(),
    );
  }

  Widget _buildApp() {
    try {
      return MultiProvider(
        providers: [
          // Conectividad
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),

          // Data sources
          Provider(create: (_) => TaskLocalDataSourceWeb()),

          Provider<TaskRemoteDataSource>(
            create: (_) =>
                TaskRemoteDataSource(baseUrl: 'http://localhost:3000'),
          ),

          // Repository
          ProxyProvider2<
            TaskLocalDataSourceWeb,
            TaskRemoteDataSource,
            TaskRepository
          >(
            create: (context) => TaskRepository(
              localDataSource: context.read<TaskLocalDataSourceWeb>(),
              remoteDataSource: context.read<TaskRemoteDataSource>(),
            ),
            update: (context, localDataSource, remoteDataSource, previous) {
              return TaskRepository(
                localDataSource: localDataSource,
                remoteDataSource: remoteDataSource,
              );
            },
          ),

          // Task Provider
          ChangeNotifierProxyProvider<TaskRepository, TaskProvider>(
            create: (context) => TaskProvider(context.read<TaskRepository>()),
            update: (context, repository, taskProvider) {
              return taskProvider ?? TaskProvider(repository);
            },
          ),
        ],
        child: TaskListView(),
      );
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Error al inicializar la app'),
              SizedBox(height: 8),
              Text(e.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
  }
}
