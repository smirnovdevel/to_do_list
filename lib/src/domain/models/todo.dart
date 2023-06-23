import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo({
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

  final String? uuid;
  final String title;
  final bool done;
  final int priority;
  final DateTime? deadline;
  final bool deleted;
  final DateTime created;
  final DateTime changed;
  final bool upload;
  final String? autor;

  Todo copyWith({
    String? uuid,
    String? title,
    bool? done,
    int? priority,
    DateTime? deadline,
    bool? deleted,
    DateTime? created,
    DateTime? changed,
    bool? upload,
    String? autor,
  }) {
    return Todo(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      done: done ?? this.done,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      deleted: deleted ?? this.deleted,
      created: created ?? this.created,
      changed: changed ?? this.changed,
      upload: upload ?? this.upload,
      autor: autor ?? this.autor,
    );
  }

  factory Todo.copyFrom(Todo todo) {
    return Todo(
        uuid: todo.uuid,
        title: todo.title,
        done: todo.done,
        priority: todo.priority,
        deadline: todo.deadline,
        deleted: todo.deleted,
        created: todo.created,
        changed: todo.changed,
        upload: todo.upload,
        autor: todo.autor);
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'done': done ? 1 : 0,
      'priority': priority,
      'deadline': deadline.toString(),
      'deleted': deleted ? 1 : 0,
      'created': created.toString(),
      'changed': changed.toString(),
      'upload': upload ? 1 : 0,
      'autor': autor,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      uuid: map['uuid'],
      title: map['title'] ?? '',
      done: (map['done'] == 1) ? true : false,
      priority: map['priority'] ?? 0,
      deadline:
          map['deadline'] != null ? DateTime.tryParse(map['deadline']) : null,
      deleted: (map['deleted'] == 1) ? true : false,
      created: DateTime.tryParse(map['created']) ?? DateTime.now(),
      changed: DateTime.tryParse(map['changed']) ?? DateTime.now(),
      upload: (map['upload'] == 1) ? true : false,
      autor: map['autor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    if (deadline == null) {
      return {
        'id': uuid, // уникальный идентификатор элемента
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
        'id': uuid, // уникальный идентификатор элемента
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

  factory Todo.fromJson(Map<String, dynamic> parsedJson) {
    return Todo(
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
          : DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
      changed: parsedJson['changed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(parsedJson['changed_at'])
          : DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
      upload: true,
      autor: parsedJson['last_updated_by'],
    );
  }
}
