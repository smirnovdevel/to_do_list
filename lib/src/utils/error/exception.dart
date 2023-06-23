class CacheException implements Exception {}

class DBException implements Exception {}

class ServerException implements Exception {

  /// Constructor for [ServerException].
  const ServerException(this.message);
  /// Message, describing exception's explanation.
  final String message;

  @override
  String toString() => 'AuthException(message: $message)';
}
