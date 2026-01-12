import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../media/domain/repositories/storage_repository.dart';
import '../../../media/domain/usecases/upload_image_usecase.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final StorageRepository storageRepository;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.storageRepository,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getProfile(String userId) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final user = await remoteDataSource.getProfile(userId);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      AppLogger.error('Get profile error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Get profile unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? bio,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.updateProfile(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        bio: bio,
      );

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
  Future<Either<Failure, String>> updateAvatar({
    required String userId,
    required String imagePath,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      // Upload image to storage
      final uploadResult = await storageRepository.uploadImage(
        filePath: imagePath,
        folder: 'avatars/$userId',
      );

      return uploadResult.fold(
            (failure) => Left(failure),
            (media) async {
          // Update user profile with new avatar URL
          await remoteDataSource.updateProfile(
            userId: userId,
            name: null,
            phoneNumber: null,
            bio: null,
          );

          AppLogger.info('Avatar updated successfully');
          return Right(media.url);
        },
      );
    } on FileException catch (e) {
      AppLogger.error('Update avatar error', e);
      return Left(FileFailure(e.message));
    } catch (e) {
      AppLogger.error('Update avatar unexpected error', e);
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await remoteDataSource.updateOnlineStatus(
        userId: userId,
        isOnline: isOnline,
      );
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
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final users = await remoteDataSource.searchUsers(query);
      return Right(users.map((u) => u.toEntity()).toList());
    } on ServerException catch (e) {
      AppLogger.error('Search users error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Search users unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.blockUser(
        userId: userId,
        blockedUserId: blockedUserId,
      );

      AppLogger.info('User blocked successfully');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Block user error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Block user unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unblockUser({
    required String userId,
    required String unblockedUserId,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.unblockUser(
        userId: userId,
        unblockedUserId: unblockedUserId,
      );

      AppLogger.info('User unblocked successfully');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Unblock user error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unblock user unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}