import 'package:equatable/equatable.dart';

/// Base failure class using Either pattern
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred', super.code]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred', super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection', super.code]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication failed', super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed', super.code]);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied', super.code]);
}

class FileFailure extends Failure {
  const FileFailure([super.message = 'File operation failed', super.code]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred', super.code]);
}