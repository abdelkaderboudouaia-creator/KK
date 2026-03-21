/// Custom exception thrown by API classes when the server returns an
/// unexpected HTTP status code or when a network error occurs.
///
/// [message] is a human-readable description of the error.
/// [statusCode] is the HTTP status code, if one is available.
///
/// Usage:
/// ```dart
/// throw ApiException(message: 'Error Network', statusCode: 500);
/// ```
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}