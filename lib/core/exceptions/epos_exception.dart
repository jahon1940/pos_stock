class EposException implements Exception {
  final String errorMessage;

  EposException(this.errorMessage);

  @override
  String toString() => 'EposException: $errorMessage';
}
