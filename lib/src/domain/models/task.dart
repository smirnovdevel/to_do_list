import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TaskModel extends Equatable {
  TaskModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.done,
    required this.priority,
    required this.deadline,
    required this.deleted,
    required this.created,
    required this.changed,
    required this.upload,
    required this.autor,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      uuid: map['uuid'],
      title: map['title'],
      done: (map['done'] == 1) ? true : false,
      priority: map['priority'],
      deadline: DateTime.tryParse(map['deadline']),
      deleted: false,
      created: DateTime.tryParse(map['created']) ?? DateTime.now(),
      changed: DateTime.tryParse(map['changed']) ?? DateTime.now(),
      upload: (map['upload'] == 1) ? true : false,
      autor: map['autor'] ?? '',
    );
  }

  factory TaskModel.copyFrom(TaskModel task) {
    return TaskModel(
        id: task.id,
        uuid: task.uuid,
        title: task.title,
        done: task.done,
        priority: task.priority,
        deadline: task.deadline,
        deleted: task.deleted,
        created: task.created,
        changed: task.changed,
        upload: task.upload,
        autor: task.autor);
  }
  factory TaskModel.fromJson(Map<String, dynamic> parsedJson) {
    return TaskModel(
      id: null,
      uuid: parsedJson['id'],
      title: parsedJson['text'],
      done: parsedJson['done'],
      priority: parsedJson['importance'] == 'low'
          ? 0
          : parsedJson['importance'] == 'basic'
              ? 1
              : 2,
      deadline: parsedJson['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(parsedJson['deadline'])
          : null,
      deleted: false,
      created: parsedJson['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(parsedJson['created_at'])
          : DateTime.now(),
      changed: parsedJson['changed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(parsedJson['changed_at'])
          : DateTime.now(),
      upload: true,
      autor: parsedJson['last_updated_by'],
    );
  }
  int? id;
  String? uuid;
  String title;
  bool done;
  int priority;
  DateTime? deadline;
  bool deleted;
  DateTime created;
  DateTime changed;
  bool upload;
  String autor;

  @override
  List<Object?> get props => [uuid, title, done, priority, deadline];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = uuid;
    map['uuid'] = uuid;
    map['title'] = title;
    map['done'] = done ? 1 : 0;
    map['priority'] = priority;
    map['deadline'] = deadline.toString();
    map['deleted'] = deleted ? 1 : 0;
    map['created'] = created.toString();
    map['changed'] = changed.toString();
    map['upload'] = upload ? 1 : 0;
    map['autor'] = autor;
    return map;
  }

  Map<String, dynamic> toJson() {
    if (deadline == null) {
      return {
        'uuid': uuid, // уникальный идентификатор элемента
        'text': title,
        'importance': priority == 0
            ? 'low'
            : priority == 1
                ? 'basic'
                : 'important',
        'done': done,
        'created_at': created.millisecondsSinceEpoch,
        'changed_at': changed.millisecondsSinceEpoch,
        'last_updated_by': autor
      };
    } else {
      return {
        'uuid': uuid, // уникальный идентификатор элемента
        'text': title,
        'importance': priority == 0
            ? 'low'
            : priority == 1
                ? 'basic'
                : 'important',
        'deadline': deadline!.millisecondsSinceEpoch,
        'done': done,
        'created_at': created.millisecondsSinceEpoch,
        'changed_at': changed.millisecondsSinceEpoch,
        'last_updated_by': autor
      };
    }
  }
}
