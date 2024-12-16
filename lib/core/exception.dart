class ServerException implements Exception {
  final String message;

  ServerException({this.message = "An error occurred on the server."});

  @override
  String toString() => "ServerException: $message";
}

class EmptyCacheException implements Exception {
  final String message;

  EmptyCacheException({this.message = "No data found in the cache."});

  @override
  String toString() => "EmptyCacheException: $message";
}

class OfflineException implements Exception {
  final String message;

  OfflineException({this.message = "No internet connection."});

  @override
  String toString() => "OfflineException: $message";
}
