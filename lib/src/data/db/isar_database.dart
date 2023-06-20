import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/task.dart';

import '../../domain/models/task_isar.dart';

final Logger log = Logger('ISAR DBProvider');

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Isar? _isar;

  Future<Isar> get _isarGetter async {
    final appDir = await getApplicationDocumentsDirectory();

    _isar ??= await Isar.open(
      [TaskModelIsarSchema],
      directory: appDir.path,
    );
    return _isar!;
  }

  // GET ALL Tasks
  Future<List<TaskModel>> getTasks() async {
    final isar = await _isarGetter;
    final items = await isar.taskModelIsars.where().findAll();
    // final items = await isar.githubProfileIsars
    //     .filter()
    //     .loginIsNotEmpty()
    //     .avatarUrlIsNotEmpty()
    //     .loginContains("1")
    //     .findAll();
    return items
        .map(
          (item) => TaskModel(
            id: item.id,
            uuid: item.uuid,
            title: item.title ?? '',
            done: item.done ?? false,
            priority: item.priority ?? 0,
            deadline: item.deadline,
            deleted: item.deleted ?? false,
            created: item.created ?? DateTime.now(),
            changed: item.changed ?? DateTime.now(),
            upload: item.upload ?? false,
            autor: item.autor ?? '',
          ),
        )
        .toList();
  }

  Future<void> saveTask({required TaskModel task}) async {
    final isar = await _isarGetter;
    final isarTask = TaskModelIsar()
      ..uuid = task.uuid
      ..title = task.title
      ..done = task.done
      ..priority = task.priority
      ..deadline = task.deadline
      ..deleted = task.deleted
      ..created = task.created
      ..changed = task.changed
      ..upload = task.upload
      ..autor = task.autor;
    isar.writeTxn(() async {
      task.id = await isar.taskModelIsars.put(isarTask);
    });
  }

  /// DELETE
  Future<void> deleteTask({required TaskModel task}) async {
    if (task.id != null) {
      log.info('delete task uuid: ${task.uuid} ...');
      try {
        final isar = await _isarGetter;
        isar.writeTxn(() async {
          isar.taskModelIsars.delete(task.id!);
        });
        log.info('delete task uuid: ${task.uuid}');
      } catch (e) {
        log.warning('delete task uuid: ${task.uuid} $e');
      }
    } else {
      log.info('delete task uuid: ${task.uuid} imposible, id = null');
    }
  }
}
