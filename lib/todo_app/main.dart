import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/local/task_local_datasource_web.dart';
import 'data/local/task_local_datasource_base.dart';
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
      home: MultiProvider(
        providers: [
          // Conectividad
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),

          // Data sources
          Provider<TaskLocalDataSourceBase>(
            create: (_) => TaskLocalDataSourceWeb(),
          ),

          Provider<TaskRemoteDataSource>(
            create: (_) =>
                TaskRemoteDataSource(baseUrl: 'http://localhost:3000'),
          ),

          // Repository
          ProxyProvider2<
            TaskLocalDataSourceBase,
            TaskRemoteDataSource,
            TaskRepository
          >(
            create: (context) => TaskRepository(
              localDataSource: context.read<TaskLocalDataSourceBase>(),
              remoteDataSource: context.read<TaskRemoteDataSource>(),
            ),
            update: (context, localDS, remoteDS, previous) {
              return TaskRepository(
                localDataSource: localDS,
                remoteDataSource: remoteDS,
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
      ),
    );
  }
}
