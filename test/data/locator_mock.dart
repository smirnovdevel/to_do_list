import 'package:get_it/get_it.dart';
import 'package:to_do_list/src/data/datasources/local_data_source.dart';
import 'package:to_do_list/src/data/db/database.dart';
import 'package:to_do_list/src/domain/repositories/todo_repository.dart';

import 'datasource/remote_data_source_mock.dart';
import 'web/api_http_mock.dart';

// This is our global ServiceLocator
GetIt locator = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Repository Todos
  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepository(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  /// Source data
  locator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSource(locator()),
  );

  locator.registerLazySingleton<RemoteDataSourceMock>(
    () => RemoteDataSourceMock(locator()),
  );

  // External
  locator.registerLazySingleton(() => DBProvider(isTest: true));
  locator.registerLazySingleton(() => HttpMock()..init(10));
}
