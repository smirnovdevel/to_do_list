import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'data/datasources/local_data_source.dart';
import 'data/datasources/remote_data_source.dart';
import 'domain/repositories/todo_service.dart';
import 'utils/core/network_info.dart';

// This is our global ServiceLocator
GetIt locator = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoC / Cubit

  /// Repository Tasks
  locator.registerLazySingleton<TodoService>(
    () => TodoService(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );

  /// Source data
  locator.registerLazySingleton<ITodoLocalDataSource>(
    () => ITodoLocalDataSource(),
  );

  locator.registerLazySingleton<ITodoRemoteDataSource>(
    () => ITodoRemoteDataSource(client: locator()),
  );

// Core
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(locator()),
  );

  // External
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => InternetConnectionChecker());
}
