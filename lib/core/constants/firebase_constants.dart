class FirebaseConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String typingCollection = 'typing';

  // Storage Paths
  static const String avatarsPath = 'avatars';
  static const String chatImagesPath = 'chat_images';
  static const String chatFilesPath = 'chat_files';
  static const String voiceMessagesPath = 'voice_messages';

  // User Fields
  static const String userId = 'id';
  static const String email = 'email';
  static const String name = 'name';
  static const String avatarUrl = 'avatarUrl';
  static const String isOnline = 'isOnline';
  static const String lastSeen = 'lastSeen';
  static const String createdAt = 'createdAt';

  // Message Fields
  static const String messageId = 'id';
  static const String chatId = 'chatId';
  static const String senderId = 'senderId';
  static const String content = 'content';
  static const String type = 'type';
  static const String timestamp = 'timestamp';
  static const String status = 'status';

  // Chat Fields
  static const String participantIds = 'participantIds';
  static const String lastMessage = 'lastMessage';
  static const String lastMessageTime = 'lastMessageTime';
  static const String unreadCounts = 'unreadCounts';
}