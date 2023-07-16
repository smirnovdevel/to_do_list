import 'package:freezed_annotation/freezed_annotation.dart';
part 'db_exception.freezed.dart';
part 'db_exception.g.dart';

/// Exception class for local db
@freezed
class DBException with _$DBException implements Exception {
  /// error on local db initialization
  const factory DBException.initException({
    required String stackTrace,
    String? message,
    DateTime? timeStamp,
  }) = _InitException;

  /// error on reading local db
  const factory DBException.readException({
    required String stackTrace,
    String? message,
    DateTime? timeStamp,
  }) = _ReadException;

  /// error on writing local db
  const factory DBException.writeException({
    required String stackTrace,
    String? message,
    DateTime? timeStamp,
  }) = _WriteException;

  /// from json
  factory DBException.fromJson(Map<String, Object?> json) =>
      _$DBExceptionFromJson(json);
}
