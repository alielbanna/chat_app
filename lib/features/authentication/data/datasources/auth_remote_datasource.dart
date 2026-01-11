import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
  Future<void> updateProfile(String userId, {String? name, String? phoneNumber});
  Future<void> updateOnlineStatus(String userId, bool isOnline);
  Future<void> resetPassword(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthenticationException('Sign in failed');
      }

      // Update online status
      await updateOnlineStatus(credential.user!.uid, true);

      // Get user data
      final userDoc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw const ServerException('User data not found');
      }

      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in error', e);
      throw AuthenticationException(e.message ?? 'Sign in failed');
    } catch (e) {
      AppLogger.error('Sign in error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthenticationException('Sign up failed');
      }

      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        isOnline: true,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        blockedUsers: const [],
      );

      // Create user document
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.id)
          .set(user.toJson());

      AppLogger.info('User created successfully: ${user.id}');
      return user;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up error', e);
      throw AuthenticationException(e.message ?? 'Sign up failed');
    } catch (e) {
      AppLogger.error('Sign up error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await updateOnlineStatus(currentUser.uid, false);
      }
      await firebaseAuth.signOut();
      AppLogger.info('User signed out successfully');
    } catch (e) {
      AppLogger.error('Sign out error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final userDoc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) return null;

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      AppLogger.error('Get current user error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final userDoc = await firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(user.uid)
            .get();

        if (!userDoc.exists) return null;

        return UserModel.fromJson(userDoc.data()!);
      } catch (e) {
        AppLogger.error('Auth state changes error', e);
        return null;
      }
    });
  }

  @override
  Future<void> updateProfile(
      String userId, {
        String? name,
        String? phoneNumber,
      }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates[FirebaseConstants.name] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

      if (updates.isEmpty) return;

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update(updates);

      AppLogger.info('Profile updated successfully');
    } catch (e) {
      AppLogger.error('Update profile error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({
        FirebaseConstants.isOnline: isOnline,
        FirebaseConstants.lastSeen: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppLogger.error('Update online status error', e);
      // Don't throw - this is not critical
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Reset password error', e);
      throw AuthenticationException(e.message ?? 'Reset password failed');
    } catch (e) {
      AppLogger.error('Reset password error', e);
      throw ServerException(e.toString());
    }
  }
}