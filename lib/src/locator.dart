import 'package:get_it/get_it.dart';

import 'data/datasources/local_data_source.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/db/database.dart';
import 'data/web/http_service.dart';
import 'domain/repositories/todo_service.dart';

// This is our global ServiceLocator
GetIt locator = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Repository Todos
  locator.registerLazySingleton<TodoService>(
    () => TodoService(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  /// Source data
  locator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSource(locator()),
  );

  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(locator()),
  );

  // External
  locator.registerLazySingleton(() => DBProvider(isTest: false));
  locator.registerLazySingleton(() => HttpService());
}
