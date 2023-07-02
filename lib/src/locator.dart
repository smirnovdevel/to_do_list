import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'data/datasources/local_data_source.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/db/database.dart';
import 'domain/repositories/todo_service.dart';
import 'utils/core/network_info.dart';

// This is our global ServiceLocator
GetIt locator = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Repository Todos
  locator.registerLazySingleton<TodoService>(
    () => TodoService(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );

  /// Source data
  locator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSource(locator()),
  );

  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(),
  );

// Core
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(locator()),
  );

  // External
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DBProvider(null));
  locator.registerLazySingleton(() => InternetConnectionChecker());
}
