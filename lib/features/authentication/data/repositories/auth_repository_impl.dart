import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final user = await remoteDataSource.signIn(email, password);

      // Cache user data
      await localDataSource.cacheUser(user);
      await localDataSource.saveUserId(user.id);
      await localDataSource.saveLoginStatus(true);

      AppLogger.info('Sign in successful: ${user.email}');
      return Right(user.toEntity());
    } on AuthenticationException catch (e) {
      AppLogger.error('Sign in failed', e);
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Sign in server error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Sign in unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final user = await remoteDataSource.signUp(email, password, name);

      // Cache user data
      await localDataSource.cacheUser(user);
      await localDataSource.saveUserId(user.id);
      await localDataSource.saveLoginStatus(true);

      AppLogger.info('Sign up successful: ${user.email}');
      return Right(user.toEntity());
    } on AuthenticationException catch (e) {
      AppLogger.error('Sign up failed', e);
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Sign up server error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Sign up unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();

      AppLogger.info('Sign out successful');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Sign out error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Sign out unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        AppLogger.debug('User loaded from cache');
        return Right(cachedUser.toEntity());
      }

      // If no cache and no network, return null
      if (!await networkInfo.isConnected) {
        return const Right(null);
      }

      // Fetch from remote
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        await localDataSource.cacheUser(user);
        return Right(user.toEntity());
      }

      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Get current user error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Get current user unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, UserEntity?>> get authStateChanges {
    try {
      return remoteDataSource.authStateChanges.map((user) {
        if (user != null) {
          // Cache user in background
          localDataSource.cacheUser(user);
        }
        return Right<Failure, UserEntity?>(user?.toEntity());
      }).handleError((error) {
        AppLogger.error('Auth state changes error', error);
        return Left<Failure, UserEntity?>(ServerFailure(error.toString()));
      });
    } catch (e) {
      AppLogger.error('Auth state changes stream error', e);
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    String? name,
    String? phoneNumber,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final userId = await localDataSource.getUserId();
      if (userId == null) {
        return const Left(AuthenticationFailure('User not logged in'));
      }

      await remoteDataSource.updateProfile(
        userId,
        name: name,
        phoneNumber: phoneNumber,
      );

      // Update cached user
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updatedUser = UserModel(
          id: cachedUser.id,
          email: cachedUser.email,
          name: name ?? cachedUser.name,
          avatarUrl: cachedUser.avatarUrl,
          phoneNumber: phoneNumber ?? cachedUser.phoneNumber,
          isOnline: cachedUser.isOnline,
          lastSeen: cachedUser.lastSeen,
          createdAt: cachedUser.createdAt,
          blockedUsers: cachedUser.blockedUsers,
        );
        await localDataSource.cacheUser(updatedUser);
      }

      AppLogger.info('Profile updated successfully');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Update profile error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Update profile unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateAvatar(String imagePath) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      // This will be implemented when we add StorageRepository
      // For now, return a placeholder
      return const Left(ServerFailure('Not implemented yet'));
    } catch (e) {
      AppLogger.error('Update avatar error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOnlineStatus(bool isOnline) async {
    try {
      final userId = await localDataSource.getUserId();
      if (userId == null) {
        return const Left(AuthenticationFailure('User not logged in'));
      }

      await remoteDataSource.updateOnlineStatus(userId, isOnline);
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Update online status error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Update online status unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.resetPassword(email);
      AppLogger.info('Password reset email sent to: $email');
      return const Right(null);
    } on AuthenticationException catch (e) {
      AppLogger.error('Reset password error', e);
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      AppLogger.error('Reset password unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}