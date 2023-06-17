class CacheException implements Exception {}

class DBException implements Exception {}

class ServerException implements Exception {
  /// Message, describing exception's explanation.
  final String message;

  /// Constructor for [ServerException].
  const ServerException(this.message);

  @override
  String toString() => 'AuthException(message: $message)';
}
