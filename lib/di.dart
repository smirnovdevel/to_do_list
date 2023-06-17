import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:to_do_list/data/datasources/task_local_data_source.dart';
import 'package:to_do_list/data/datasources/task_remote_data_source.dart';
import 'package:to_do_list/data/repositories/task_repository.dart';
import 'package:http/http.dart' as http;

import 'core/network_info.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoC / Cubit

  /// Repository Tasks
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepository(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        networkInfo: getIt()),
  );

  /// Source data
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSource(),
  );

  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSource(client: getIt()),
  );

// Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(getIt()),
  );

  // External
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
