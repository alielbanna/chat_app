import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../authentication/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile(String userId);
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? bio,
  });
  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  });
  Future<List<UserModel>> searchUsers(String query);
  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  });
  Future<void> unblockUser({
    required String userId,
    required String unblockedUserId,
  });
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({required this.firestore});

  @override
  Future<UserModel> getProfile(String userId) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw const ServerException('User not found');
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      AppLogger.error('Get profile error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? bio,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates[FirebaseConstants.name] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (bio != null) updates['bio'] = bio;

      if (updates.isEmpty) return;

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update(updates);

      AppLogger.info('Profile updated: $userId');
    } catch (e) {
      AppLogger.error('Update profile error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({
        FirebaseConstants.isOnline: isOnline,
        FirebaseConstants.lastSeen: FieldValue.serverTimestamp(),
      });

      AppLogger.debug('Online status updated: $userId - $isOnline');
    } catch (e) {
      AppLogger.error('Update online status error', e);
      // Don't throw - online status is not critical
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FirebaseConstants.name, isGreaterThanOrEqualTo: query)
          .where(FirebaseConstants.name, isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      AppLogger.error('Search users error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId])
      });

      AppLogger.info('User blocked: $blockedUserId by $userId');
    } catch (e) {
      AppLogger.error('Block user error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unblockUser({
    required String userId,
    required String unblockedUserId,
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({
        'blockedUsers': FieldValue.arrayRemove([unblockedUserId])
      });

      AppLogger.info('User unblocked: $unblockedUserId by $userId');
    } catch (e) {
      AppLogger.error('Unblock user error', e);
      throw ServerException(e.toString());
    }
  }
}