import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Stream of auth state changes
  Stream<Either<Failure, UserEntity?>> get authStateChanges;

  /// Reset password
  Future<Either<Failure, void>> resetPassword(String email);
}