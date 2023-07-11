// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return _Todo.fromJson(json);
}

/// @nodoc
mixin _$Todo {
  @JsonKey(name: 'id')
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'text')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  bool get done => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: JSONConverter.importanceFromJson,
      toJson: JSONConverter.importanceToJson)
  Priority get importance => throw _privateConstructorUsedError;
  int? get deadline => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  int? get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'changed_at')
  int? get changed => throw _privateConstructorUsedError;
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  bool get deleted => throw _privateConstructorUsedError;
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  bool get upload => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated_by')
  String? get deviceId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodoCopyWith<Todo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoCopyWith<$Res> {
  factory $TodoCopyWith(Todo value, $Res Function(Todo) then) =
      _$TodoCopyWithImpl<$Res, Todo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String uuid,
      @JsonKey(name: 'text') String title,
      @JsonKey(fromJson: JSONConverter.boolFromJson) bool done,
      @JsonKey(
          fromJson: JSONConverter.importanceFromJson,
          toJson: JSONConverter.importanceToJson)
      Priority importance,
      int? deadline,
      @JsonKey(name: 'created_at') int? created,
      @JsonKey(name: 'changed_at') int? changed,
      @JsonKey(fromJson: JSONConverter.boolFromJson) bool deleted,
      @JsonKey(fromJson: JSONConverter.boolFromJson) bool upload,
      @JsonKey(name: 'last_updated_by') String? deviceId});
}

/// @nodoc
class _$TodoCopyWithImpl<$Res, $Val extends Todo>
    implements $TodoCopyWith<$Res> {
  _$TodoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = null,
    Object? done = null,
    Object? importance = null,
    Object? deadline = freezed,
    Object? created = freezed,
    Object? changed = freezed,
    Object? deleted = null,
    Object? upload = null,
    Object? deviceId = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      done: null == done
          ? _value.done
          : done // ignore: cast_nullable_to_non_nullable
              as bool,
      importance: null == importance
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as Priority,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as int?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int?,
      changed: freezed == changed
          ? _value.changed
          : changed // ignore: cast_nullable_to_non_nullable
              as int?,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      upload: null == upload
          ? _value.upload
          : upload // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TodoCopyWith<$Res> implements $TodoCopyWith<$Res> {
  factory _$$_TodoCopyWith(_$_Todo value, $Res Function(_$_Todo) then) =
      __$$_TodoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String uuid,
      @JsonKey(name: 'text') String title,
      @JsonKey(fromJson: JSONConverter.boolFromJson) bool done,
      @JsonKey(
          fromJson: JSONConverter.importanceFromJson,
          toJson: JSONConverter.importanceToJson)
      Priority importance,
      int? deadline,
      @JsonKey(name: 'created_at') int? created,
      @JsonKey(name: 'changed_at') int? changed,
      @JsonKey(fromJson: JSONConverter.boolFromJson) bool deleted,
      @JsonKey(fromJson: JSONConverter.boolFromJson) bool upload,
      @JsonKey(name: 'last_updated_by') String? deviceId});
}

/// @nodoc
class __$$_TodoCopyWithImpl<$Res> extends _$TodoCopyWithImpl<$Res, _$_Todo>
    implements _$$_TodoCopyWith<$Res> {
  __$$_TodoCopyWithImpl(_$_Todo _value, $Res Function(_$_Todo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = null,
    Object? done = null,
    Object? importance = null,
    Object? deadline = freezed,
    Object? created = freezed,
    Object? changed = freezed,
    Object? deleted = null,
    Object? upload = null,
    Object? deviceId = freezed,
  }) {
    return _then(_$_Todo(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      done: null == done
          ? _value.done
          : done // ignore: cast_nullable_to_non_nullable
              as bool,
      importance: null == importance
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as Priority,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as int?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as int?,
      changed: freezed == changed
          ? _value.changed
          : changed // ignore: cast_nullable_to_non_nullable
              as int?,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
      upload: null == upload
          ? _value.upload
          : upload // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Todo extends _Todo {
  const _$_Todo(
      {@JsonKey(name: 'id') required this.uuid,
      @JsonKey(name: 'text') required this.title,
      @JsonKey(fromJson: JSONConverter.boolFromJson) required this.done,
      @JsonKey(
          fromJson: JSONConverter.importanceFromJson,
          toJson: JSONConverter.importanceToJson)
      this.importance = Priority.basic,
      this.deadline = null,
      @JsonKey(name: 'created_at') required this.created,
      @JsonKey(name: 'changed_at') required this.changed,
      @JsonKey(fromJson: JSONConverter.boolFromJson) this.deleted = false,
      @JsonKey(fromJson: JSONConverter.boolFromJson) this.upload = false,
      @JsonKey(name: 'last_updated_by') required this.deviceId})
      : super._();

  factory _$_Todo.fromJson(Map<String, dynamic> json) => _$$_TodoFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String uuid;
  @override
  @JsonKey(name: 'text')
  final String title;
  @override
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  final bool done;
  @override
  @JsonKey(
      fromJson: JSONConverter.importanceFromJson,
      toJson: JSONConverter.importanceToJson)
  final Priority importance;
  @override
  @JsonKey()
  final int? deadline;
  @override
  @JsonKey(name: 'created_at')
  final int? created;
  @override
  @JsonKey(name: 'changed_at')
  final int? changed;
  @override
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  final bool deleted;
  @override
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  final bool upload;
  @override
  @JsonKey(name: 'last_updated_by')
  final String? deviceId;

  @override
  String toString() {
    return 'Todo(uuid: $uuid, title: $title, done: $done, importance: $importance, deadline: $deadline, created: $created, changed: $changed, deleted: $deleted, upload: $upload, deviceId: $deviceId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Todo &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.done, done) || other.done == done) &&
            (identical(other.importance, importance) ||
                other.importance == importance) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.changed, changed) || other.changed == changed) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.upload, upload) || other.upload == upload) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, title, done, importance,
      deadline, created, changed, deleted, upload, deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TodoCopyWith<_$_Todo> get copyWith =>
      __$$_TodoCopyWithImpl<_$_Todo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TodoToJson(
      this,
    );
  }
}

abstract class _Todo extends Todo {
  const factory _Todo(
      {@JsonKey(name: 'id') required final String uuid,
      @JsonKey(name: 'text') required final String title,
      @JsonKey(fromJson: JSONConverter.boolFromJson) required final bool done,
      @JsonKey(
          fromJson: JSONConverter.importanceFromJson,
          toJson: JSONConverter.importanceToJson)
      final Priority importance,
      final int? deadline,
      @JsonKey(name: 'created_at') required final int? created,
      @JsonKey(name: 'changed_at') required final int? changed,
      @JsonKey(fromJson: JSONConverter.boolFromJson) final bool deleted,
      @JsonKey(fromJson: JSONConverter.boolFromJson) final bool upload,
      @JsonKey(name: 'last_updated_by')
      required final String? deviceId}) = _$_Todo;
  const _Todo._() : super._();

  factory _Todo.fromJson(Map<String, dynamic> json) = _$_Todo.fromJson;

  @override
  @JsonKey(name: 'id')
  String get uuid;
  @override
  @JsonKey(name: 'text')
  String get title;
  @override
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  bool get done;
  @override
  @JsonKey(
      fromJson: JSONConverter.importanceFromJson,
      toJson: JSONConverter.importanceToJson)
  Priority get importance;
  @override
  int? get deadline;
  @override
  @JsonKey(name: 'created_at')
  int? get created;
  @override
  @JsonKey(name: 'changed_at')
  int? get changed;
  @override
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  bool get deleted;
  @override
  @JsonKey(fromJson: JSONConverter.boolFromJson)
  bool get upload;
  @override
  @JsonKey(name: 'last_updated_by')
  String? get deviceId;
  @override
  @JsonKey(ignore: true)
  _$$_TodoCopyWith<_$_Todo> get copyWith => throw _privateConstructorUsedError;
}
