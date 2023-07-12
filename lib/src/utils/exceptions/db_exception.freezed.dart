// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'db_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DBException _$DBExceptionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'initException':
      return _InitException.fromJson(json);
    case 'readException':
      return _ReadException.fromJson(json);
    case 'writeException':
      return _WriteException.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'DBException',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$DBException {
  String get stackTrace => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DateTime? get timeStamp => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        initException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        readException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        writeException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitException value) initException,
    required TResult Function(_ReadException value) readException,
    required TResult Function(_WriteException value) writeException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitException value)? initException,
    TResult? Function(_ReadException value)? readException,
    TResult? Function(_WriteException value)? writeException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitException value)? initException,
    TResult Function(_ReadException value)? readException,
    TResult Function(_WriteException value)? writeException,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DBExceptionCopyWith<DBException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DBExceptionCopyWith<$Res> {
  factory $DBExceptionCopyWith(
          DBException value, $Res Function(DBException) then) =
      _$DBExceptionCopyWithImpl<$Res, DBException>;
  @useResult
  $Res call({String stackTrace, String? message, DateTime? timeStamp});
}

/// @nodoc
class _$DBExceptionCopyWithImpl<$Res, $Val extends DBException>
    implements $DBExceptionCopyWith<$Res> {
  _$DBExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stackTrace = null,
    Object? message = freezed,
    Object? timeStamp = freezed,
  }) {
    return _then(_value.copyWith(
      stackTrace: null == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitExceptionCopyWith<$Res>
    implements $DBExceptionCopyWith<$Res> {
  factory _$$_InitExceptionCopyWith(
          _$_InitException value, $Res Function(_$_InitException) then) =
      __$$_InitExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stackTrace, String? message, DateTime? timeStamp});
}

/// @nodoc
class __$$_InitExceptionCopyWithImpl<$Res>
    extends _$DBExceptionCopyWithImpl<$Res, _$_InitException>
    implements _$$_InitExceptionCopyWith<$Res> {
  __$$_InitExceptionCopyWithImpl(
      _$_InitException _value, $Res Function(_$_InitException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stackTrace = null,
    Object? message = freezed,
    Object? timeStamp = freezed,
  }) {
    return _then(_$_InitException(
      stackTrace: null == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_InitException implements _InitException {
  const _$_InitException(
      {required this.stackTrace,
      this.message,
      this.timeStamp,
      final String? $type})
      : $type = $type ?? 'initException';

  factory _$_InitException.fromJson(Map<String, dynamic> json) =>
      _$$_InitExceptionFromJson(json);

  @override
  final String stackTrace;
  @override
  final String? message;
  @override
  final DateTime? timeStamp;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'DBException.initException(stackTrace: $stackTrace, message: $message, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InitException &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stackTrace, message, timeStamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitExceptionCopyWith<_$_InitException> get copyWith =>
      __$$_InitExceptionCopyWithImpl<_$_InitException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        initException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        readException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        writeException,
  }) {
    return initException(stackTrace, message, timeStamp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
  }) {
    return initException?.call(stackTrace, message, timeStamp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
    required TResult orElse(),
  }) {
    if (initException != null) {
      return initException(stackTrace, message, timeStamp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitException value) initException,
    required TResult Function(_ReadException value) readException,
    required TResult Function(_WriteException value) writeException,
  }) {
    return initException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitException value)? initException,
    TResult? Function(_ReadException value)? readException,
    TResult? Function(_WriteException value)? writeException,
  }) {
    return initException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitException value)? initException,
    TResult Function(_ReadException value)? readException,
    TResult Function(_WriteException value)? writeException,
    required TResult orElse(),
  }) {
    if (initException != null) {
      return initException(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_InitExceptionToJson(
      this,
    );
  }
}

abstract class _InitException implements DBException {
  const factory _InitException(
      {required final String stackTrace,
      final String? message,
      final DateTime? timeStamp}) = _$_InitException;

  factory _InitException.fromJson(Map<String, dynamic> json) =
      _$_InitException.fromJson;

  @override
  String get stackTrace;
  @override
  String? get message;
  @override
  DateTime? get timeStamp;
  @override
  @JsonKey(ignore: true)
  _$$_InitExceptionCopyWith<_$_InitException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ReadExceptionCopyWith<$Res>
    implements $DBExceptionCopyWith<$Res> {
  factory _$$_ReadExceptionCopyWith(
          _$_ReadException value, $Res Function(_$_ReadException) then) =
      __$$_ReadExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stackTrace, String? message, DateTime? timeStamp});
}

/// @nodoc
class __$$_ReadExceptionCopyWithImpl<$Res>
    extends _$DBExceptionCopyWithImpl<$Res, _$_ReadException>
    implements _$$_ReadExceptionCopyWith<$Res> {
  __$$_ReadExceptionCopyWithImpl(
      _$_ReadException _value, $Res Function(_$_ReadException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stackTrace = null,
    Object? message = freezed,
    Object? timeStamp = freezed,
  }) {
    return _then(_$_ReadException(
      stackTrace: null == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ReadException implements _ReadException {
  const _$_ReadException(
      {required this.stackTrace,
      this.message,
      this.timeStamp,
      final String? $type})
      : $type = $type ?? 'readException';

  factory _$_ReadException.fromJson(Map<String, dynamic> json) =>
      _$$_ReadExceptionFromJson(json);

  @override
  final String stackTrace;
  @override
  final String? message;
  @override
  final DateTime? timeStamp;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'DBException.readException(stackTrace: $stackTrace, message: $message, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReadException &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stackTrace, message, timeStamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReadExceptionCopyWith<_$_ReadException> get copyWith =>
      __$$_ReadExceptionCopyWithImpl<_$_ReadException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        initException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        readException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        writeException,
  }) {
    return readException(stackTrace, message, timeStamp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
  }) {
    return readException?.call(stackTrace, message, timeStamp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
    required TResult orElse(),
  }) {
    if (readException != null) {
      return readException(stackTrace, message, timeStamp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitException value) initException,
    required TResult Function(_ReadException value) readException,
    required TResult Function(_WriteException value) writeException,
  }) {
    return readException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitException value)? initException,
    TResult? Function(_ReadException value)? readException,
    TResult? Function(_WriteException value)? writeException,
  }) {
    return readException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitException value)? initException,
    TResult Function(_ReadException value)? readException,
    TResult Function(_WriteException value)? writeException,
    required TResult orElse(),
  }) {
    if (readException != null) {
      return readException(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReadExceptionToJson(
      this,
    );
  }
}

abstract class _ReadException implements DBException {
  const factory _ReadException(
      {required final String stackTrace,
      final String? message,
      final DateTime? timeStamp}) = _$_ReadException;

  factory _ReadException.fromJson(Map<String, dynamic> json) =
      _$_ReadException.fromJson;

  @override
  String get stackTrace;
  @override
  String? get message;
  @override
  DateTime? get timeStamp;
  @override
  @JsonKey(ignore: true)
  _$$_ReadExceptionCopyWith<_$_ReadException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_WriteExceptionCopyWith<$Res>
    implements $DBExceptionCopyWith<$Res> {
  factory _$$_WriteExceptionCopyWith(
          _$_WriteException value, $Res Function(_$_WriteException) then) =
      __$$_WriteExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stackTrace, String? message, DateTime? timeStamp});
}

/// @nodoc
class __$$_WriteExceptionCopyWithImpl<$Res>
    extends _$DBExceptionCopyWithImpl<$Res, _$_WriteException>
    implements _$$_WriteExceptionCopyWith<$Res> {
  __$$_WriteExceptionCopyWithImpl(
      _$_WriteException _value, $Res Function(_$_WriteException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stackTrace = null,
    Object? message = freezed,
    Object? timeStamp = freezed,
  }) {
    return _then(_$_WriteException(
      stackTrace: null == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WriteException implements _WriteException {
  const _$_WriteException(
      {required this.stackTrace,
      this.message,
      this.timeStamp,
      final String? $type})
      : $type = $type ?? 'writeException';

  factory _$_WriteException.fromJson(Map<String, dynamic> json) =>
      _$$_WriteExceptionFromJson(json);

  @override
  final String stackTrace;
  @override
  final String? message;
  @override
  final DateTime? timeStamp;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'DBException.writeException(stackTrace: $stackTrace, message: $message, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WriteException &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stackTrace, message, timeStamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WriteExceptionCopyWith<_$_WriteException> get copyWith =>
      __$$_WriteExceptionCopyWithImpl<_$_WriteException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        initException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        readException,
    required TResult Function(
            String stackTrace, String? message, DateTime? timeStamp)
        writeException,
  }) {
    return writeException(stackTrace, message, timeStamp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult? Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
  }) {
    return writeException?.call(stackTrace, message, timeStamp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        initException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        readException,
    TResult Function(String stackTrace, String? message, DateTime? timeStamp)?
        writeException,
    required TResult orElse(),
  }) {
    if (writeException != null) {
      return writeException(stackTrace, message, timeStamp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitException value) initException,
    required TResult Function(_ReadException value) readException,
    required TResult Function(_WriteException value) writeException,
  }) {
    return writeException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitException value)? initException,
    TResult? Function(_ReadException value)? readException,
    TResult? Function(_WriteException value)? writeException,
  }) {
    return writeException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitException value)? initException,
    TResult Function(_ReadException value)? readException,
    TResult Function(_WriteException value)? writeException,
    required TResult orElse(),
  }) {
    if (writeException != null) {
      return writeException(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_WriteExceptionToJson(
      this,
    );
  }
}

abstract class _WriteException implements DBException {
  const factory _WriteException(
      {required final String stackTrace,
      final String? message,
      final DateTime? timeStamp}) = _$_WriteException;

  factory _WriteException.fromJson(Map<String, dynamic> json) =
      _$_WriteException.fromJson;

  @override
  String get stackTrace;
  @override
  String? get message;
  @override
  DateTime? get timeStamp;
  @override
  @JsonKey(ignore: true)
  _$$_WriteExceptionCopyWith<_$_WriteException> get copyWith =>
      throw _privateConstructorUsedError;
}
