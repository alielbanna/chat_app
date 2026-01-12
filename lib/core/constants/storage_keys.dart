class StorageKeys {
  // Secure Storage (sensitive data)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String encryptionKey = 'encryption_key';
  static const String biometricEnabled = 'biometric_enabled';

  // Shared Preferences (app settings)
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String isLoggedIn = 'is_logged_in';
  static const String isFirstLaunch = 'is_first_launch';
  static const String isDarkMode = 'is_dark_mode';
  static const String languageCode = 'language_code';

  // Hive Box Names
  static const String messagesBox = 'messages_box';
  static const String chatsBox = 'chats_box';
  static const String usersBox = 'users_box';
  static const String queuedMessagesBox = 'queued_messages_box';

  // Hive Data Keys (keys inside boxes)
  static const String currentUserKey = 'current_user';
}