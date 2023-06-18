import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/src/domain/models/task.dart';

import '../../domain/models/task_isar.dart';

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
      isar.taskModelIsars.put(isarTask);
    });
  }

  /// DELETE
  Future<void> deleteTask({required TaskModel task}) async {
    final isar = await _isarGetter;
    isar.writeTxn(() async {
      isar.taskModelIsars.delete(task.id!);
    });
  }
}
