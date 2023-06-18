import 'package:isar/isar.dart';

part 'task_isar.g.dart';

@collection
class TaskModelIsar {
  Id id = Isar.autoIncrement;
  String? uuid;
  String? title;
  bool? done;
  int? priority;
  DateTime? deadline;
  bool? deleted;
  DateTime? created;
  DateTime? changed;
  bool? upload;
  String? autor;
}
