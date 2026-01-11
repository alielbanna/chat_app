/// Base exception class for the app
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when server returns an error
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred', super.code]);
}

/// Thrown when cache operations fail
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred', super.code]);
}

/// Thrown when network is unavailable
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection', super.code]);
}

/// Thrown when authentication fails
class AuthenticationException extends AppException {
  const AuthenticationException([super.message = 'Authentication failed', super.code]);
}

/// Thrown when validation fails
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation failed', super.code]);
}

/// Thrown when permission is denied
class PermissionException extends AppException {
  const PermissionException([super.message = 'Permission denied', super.code]);
}

/// Thrown when file operations fail
class FileException extends AppException {
  const FileException([super.message = 'File operation failed', super.code]);
}