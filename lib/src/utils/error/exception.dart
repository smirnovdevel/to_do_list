class CacheException implements Exception {}

class DBException implements Exception {
  const DBException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ServerException implements Exception {
  const ServerException(this.message);

  final String message;

  @override
  String toString() => message;
}
