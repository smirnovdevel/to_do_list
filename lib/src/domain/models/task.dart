import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TaskModel extends Equatable {
  String? id;
  String title;
  bool active;
  int priority;
  bool unlimited;
  DateTime deadline;
  bool deleted;
  DateTime created;
  DateTime changed;
  bool upload;
  String autor;

  TaskModel({
    required this.id,
    required this.title,
    required this.active,
    required this.priority,
    required this.unlimited,
    required this.deadline,
    required this.deleted,
    required this.created,
    required this.changed,
    required this.upload,
    required this.autor,
  });

  @override
  List<Object?> get props => [id, title, active, priority, unlimited, deadline];

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['active'] = active ? 1 : 0;
    map['priority'] = priority;
    map['unlimited'] = unlimited ? 1 : 0;
    map['deadline'] = deadline.toString();
    map['deleted'] = deleted ? 1 : 0;
    map['created'] = created.toString();
    map['changed'] = changed.toString();
    map['upload'] = upload ? 1 : 0;
    map['autor'] = autor;
    return map;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      active: (map['active'] == 1) ? true : false,
      priority: map['priority'],
      unlimited: (map['unlimited'] == 1) ? true : false,
      deadline: DateTime.tryParse(map['deadline']) ?? DateTime.now(),
      deleted: false,
      created: DateTime.tryParse(map['created']) ?? DateTime.now(),
      changed: DateTime.tryParse(map['changed']) ?? DateTime.now(),
      upload: (map['upload'] == 1) ? true : false,
      autor: map['autor'] ?? '',
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> parsedJson) {
    return TaskModel(
      id: parsedJson['id'],
      title: parsedJson['text'],
      active: !parsedJson['done'],
      priority: parsedJson['importance'] == 'low'
          ? 0
          : parsedJson['importance'] == 'basic'
              ? 1
              : 2,
      unlimited: parsedJson['deadline'] == null ? true : false,
      deadline: parsedJson['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(parsedJson['deadline'])
          : DateTime.now(),
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

  Map<String, dynamic> toJson() => {
        'id': id, // уникальный идентификатор элемента
        'text': title,
        'importance': priority == 0
            ? 'low'
            : priority == 1
                ? 'basic'
                : 'important',
        'deadline': deadline.millisecondsSinceEpoch,
        'done': !active,
        'created_at': created.millisecondsSinceEpoch,
        'changed_at': changed.millisecondsSinceEpoch,
        'last_updated_by': autor,
      };
}
