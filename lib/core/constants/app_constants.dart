class AppConstants {
  // App Info
  static const String appName = 'Chat App';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int messagesPerPage = 50;
  static const int chatsPerPage = 20;

  // File Upload (in MB)
  static const int maxImageSizeInMB = 10;
  static const int maxFileSizeInMB = 50;
  static const int maxVoiceSizeInMB = 10;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration typingIndicatorTimeout = Duration(seconds: 3);

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double avatarSize = 50;
  static const double maxMessageWidth = 0.7;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxMessageLength = 5000;
  static const int maxGroupNameLength = 50;

  // Recording
  static const int maxVoiceMessageDuration = 300; // 5 minutes in seconds
}