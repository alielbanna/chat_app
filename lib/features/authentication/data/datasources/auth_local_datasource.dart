import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveLoginStatus(bool isLoggedIn);
  Future<bool> getLoginStatus();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<dynamic> userBox;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(
      @Named('usersBox') this.userBox,
      this.sharedPreferences,
      );

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await userBox.put(StorageKeys.currentUserKey, user.toJson());
      AppLogger.info('User cached successfully: ${user.id}');
    } catch (e) {
      AppLogger.error('Cache user error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = userBox.get(StorageKeys.currentUserKey);
      if (userJson == null) return null;

      return UserModel.fromJson(Map<String, dynamic>.from(userJson));
    } catch (e) {
      AppLogger.error('Get cached user error', e);
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await userBox.clear();
      await sharedPreferences.remove(StorageKeys.userId);
      await sharedPreferences.remove(StorageKeys.isLoggedIn);
      AppLogger.info('Cache cleared successfully');
    } catch (e) {
      AppLogger.error('Clear cache error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await sharedPreferences.setString(StorageKeys.userId, userId);
    } catch (e) {
      AppLogger.error('Save user ID error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return sharedPreferences.getString(StorageKeys.userId);
    } catch (e) {
      AppLogger.error('Get user ID error', e);
      return null;
    }
  }

  @override
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    try {
      await sharedPreferences.setBool(StorageKeys.isLoggedIn, isLoggedIn);
    } catch (e) {
      AppLogger.error('Save login status error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<bool> getLoginStatus() async {
    try {
      return sharedPreferences.getBool(StorageKeys.isLoggedIn) ?? false;
    } catch (e) {
      AppLogger.error('Get login status error', e);
      return false;
    }
  }
}