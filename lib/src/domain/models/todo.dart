import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Todo extends Equatable {
  const Todo({
    required this.uuid,
    required this.title,
    required this.done,
    required this.importance,
    required this.deadline,
    required this.deleted,
    required this.created,
    required this.changed,
    required this.upload,
    required this.autor,
  });

  final String uuid;
  final String title;
  final bool done;
  final String importance;
  final DateTime? deadline;
  final bool deleted;
  final DateTime created;
  final DateTime? changed;
  final bool upload;
  final String? autor;

  @override
  List<Object> get props => [uuid, title, done, importance, created, upload];

  Todo copyWith({
    String? uuid,
    String? title,
    bool? done,
    String? importance,
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
      importance: importance ?? this.importance,
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
        importance: todo.importance,
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
      'importance': importance,
      'deadline': deadline == null ? '' : deadline.toString(),
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
      importance: map['importance'] ?? 'basic',
      deadline:
          map['deadline'] == '' ? DateTime.tryParse(map['deadline']) : null,
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
        'importance': importance,
        'done': done,
        'created_at': created.millisecondsSinceEpoch,
        'changed_at': changed!.millisecondsSinceEpoch,
        'last_updated_by': autor
      };
    } else {
      return {
        'id': uuid, // уникальный идентификатор элемента
        'text': title,
        'importance': importance,
        'deadline': deadline!.millisecondsSinceEpoch,
        'done': done,
        'created_at': created.millisecondsSinceEpoch,
        'changed_at': changed!.millisecondsSinceEpoch,
        'last_updated_by': autor
      };
    }
  }

  factory Todo.fromJson(Map<String, dynamic> parsedJson) {
    return Todo(
      uuid: parsedJson['id'],
      title: parsedJson['text'],
      done: parsedJson['done'],
      importance: parsedJson['importance'],
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
