class ServerException implements Exception {
  final int code;
  final String errorMessage;

  ServerException(this.errorMessage, this.code);

  @override
  String toString() => 'ServerException: $errorMessage ($code)';
}
