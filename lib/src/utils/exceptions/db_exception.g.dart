// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InitException _$$_InitExceptionFromJson(Map<String, dynamic> json) =>
    _$_InitException(
      stackTrace: json['stackTrace'] as String,
      message: json['message'] as String?,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_InitExceptionToJson(_$_InitException instance) =>
    <String, dynamic>{
      'stackTrace': instance.stackTrace,
      'message': instance.message,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$_ReadException _$$_ReadExceptionFromJson(Map<String, dynamic> json) =>
    _$_ReadException(
      stackTrace: json['stackTrace'] as String,
      message: json['message'] as String?,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_ReadExceptionToJson(_$_ReadException instance) =>
    <String, dynamic>{
      'stackTrace': instance.stackTrace,
      'message': instance.message,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$_WriteException _$$_WriteExceptionFromJson(Map<String, dynamic> json) =>
    _$_WriteException(
      stackTrace: json['stackTrace'] as String,
      message: json['message'] as String?,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_WriteExceptionToJson(_$_WriteException instance) =>
    <String, dynamic>{
      'stackTrace': instance.stackTrace,
      'message': instance.message,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'runtimeType': instance.$type,
    };
