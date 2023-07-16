import 'package:get_it/get_it.dart';

import 'data/datasources/local_data_source.dart';
import 'data/datasources/remote_data_source.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'data/db/database.dart';
import 'data/web/http_service.dart';
import 'domain/repositories/config_repository.dart';
import 'domain/repositories/todo_repository.dart';

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

  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(locator()),
  );

  // External
  locator.registerLazySingleton<DBProvider>(() => DBProvider(isTest: false));
  locator.registerLazySingleton<HttpService>(() => HttpService());
}

abstract class DI {
  static final _locator = GetIt.instance;
  static ConfigRepository get configRepository => _locator<ConfigRepository>();

  static Future<void> init() async {
    final configRepo = ConfigRepository(_locator<FirebaseRemoteConfig>());
    await configRepo.init();
    _locator.registerSingleton<ConfigRepository>(configRepo);
  }

  static Future<void> dispose() async {}
}
