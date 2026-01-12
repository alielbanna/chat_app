import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../authentication/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  /// Get user profile by ID
  Future<Either<Failure, UserEntity>> getProfile(String userId);

  /// Update user profile
  Future<Either<Failure, void>> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? bio,
  });

  /// Update user avatar
  Future<Either<Failure, String>> updateAvatar({
    required String userId,
    required String imagePath,
  });

  /// Update online status
  Future<Either<Failure, void>> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  });

  /// Search users by name or email
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);

  /// Block a user
  Future<Either<Failure, void>> blockUser({
    required String userId,
    required String blockedUserId,
  });

  /// Unblock a user
  Future<Either<Failure, void>> unblockUser({
    required String userId,
    required String unblockedUserId,
  });
}