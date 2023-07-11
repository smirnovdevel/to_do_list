import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

part 'todo.g.dart';

enum Priority { low, basic, important }

@freezed
class Todo with _$Todo {
  const Todo._();
  const factory Todo({
    @JsonKey(name: 'id') required String uuid,
    @JsonKey(name: 'text') required String title,
    @JsonKey(fromJson: JSONConverter.boolFromJson) required bool done,
    @JsonKey(
        fromJson: JSONConverter.importanceFromJson,
        toJson: JSONConverter.importanceToJson)
    @Default(Priority.basic)
    Priority importance,
    @Default(null) int? deadline,
    @JsonKey(name: 'created_at') required int? created,
    @JsonKey(name: 'changed_at') required int? changed,
    @Default(false) @JsonKey(fromJson: JSONConverter.boolFromJson) bool deleted,
    @Default(false) @JsonKey(fromJson: JSONConverter.boolFromJson) bool upload,
    @JsonKey(name: 'last_updated_by') required String? deviceId,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  /// При записи в DB используется метод toDB
  ///
  Map<String, dynamic> toDB() {
    Map<String, dynamic> json = toJson();
    json['done'] = json['done'] == true ? 1 : 0;
    json['upload'] = json['upload'] == true ? 1 : 0;
    json['deleted'] = json['deleted'] == true ? 1 : 0;
    return json;
  }
}

/// При чтении из DB, как и при получении с бэкенда
///  используется метод fromJson, но формат bool разный
///
class JSONConverter {
  /// bool
  static bool boolFromJson(dynamic variable) {
    if (variable is bool) {
      return variable;
    }
    return variable == 0 ? false : true;
  }

  /// priority
  static Priority importanceFromJson(String variable) {
    final importance = Priority.values.firstWhere(
        (item) => item.toString() == 'Priority.${variable.toLowerCase()}');
    return importance;
  }

  static String importanceToJson(Priority priority) {
    return priority.toString().split('.').last;
  }
}
