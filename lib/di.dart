import 'package:get_it/get_it.dart';
import 'package:to_do_list/data/datasources/task_local_data_source.dart';
import 'package:to_do_list/data/repositories/task_repository.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoC / Cubit

  /// Repository Tasks
  getIt.registerLazySingleton<TaskRepositoryImpl>(
    () => TaskRepositoryImpl(localDataSource: getIt()),
  );

  /// Source data
  getIt.registerLazySingleton<TaskLocalDataSourceImpl>(
    () => TaskLocalDataSourceImpl(),
  );
}
