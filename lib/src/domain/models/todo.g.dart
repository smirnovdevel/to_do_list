// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Todo _$$_TodoFromJson(Map<String, dynamic> json) => _$_Todo(
      uuid: json['id'] as String?,
      title: json['text'] as String,
      done: JSONConverter.boolFromJson(json['done']),
      importance: json['importance'] == null
          ? Priority.basic
          : JSONConverter.importanceFromJson(json['importance'] as String),
      deadline: json['deadline'] as int? ?? null,
      created: json['created_at'] as int?,
      changed: json['changed_at'] as int?,
      deleted: json['deleted'] == null
          ? false
          : JSONConverter.boolFromJson(json['deleted']),
      upload: json['upload'] == null
          ? false
          : JSONConverter.boolFromJson(json['upload']),
      deviceId: json['last_updated_by'] as String?,
    );

Map<String, dynamic> _$$_TodoToJson(_$_Todo instance) => <String, dynamic>{
      'id': instance.uuid,
      'text': instance.title,
      'done': instance.done,
      'importance': JSONConverter.importanceToJson(instance.importance),
      'deadline': instance.deadline,
      'created_at': instance.created,
      'changed_at': instance.changed,
      'deleted': instance.deleted,
      'upload': instance.upload,
      'last_updated_by': instance.deviceId,
    };
