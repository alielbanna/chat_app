import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheMessage(MessageModel message);
  Future<void> cacheMessages(List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(String chatId);
  Future<void> queueMessage(MessageModel message);
  Future<List<MessageModel>> getQueuedMessages();
  Future<void> removeQueuedMessage(String messageId);
  Future<void> cacheChat(ChatModel chat);
  Future<void> cacheChats(List<ChatModel> chats);
  Future<List<ChatModel>> getCachedChats();
  Future<void> clearChatCache(String chatId);
  Future<void> clearAllCache();
}

@LazySingleton(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Box<dynamic> messagesBox;
  final Box<dynamic> chatsBox;
  final Box<dynamic> queuedMessagesBox;

  ChatLocalDataSourceImpl({
    required this.messagesBox,
    required this.chatsBox,
    required this.queuedMessagesBox,
  });

  @override
  Future<void> cacheMessage(MessageModel message) async {
    try {
      final key = '${message.chatId}_${message.id}';
      await messagesBox.put(key, message.toJson());
      AppLogger.debug('Message cached: ${message.id}');
    } catch (e) {
      AppLogger.error('Cache message error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheMessages(List<MessageModel> messages) async {
    try {
      final Map<String, dynamic> messagesToCache = {};
      for (var message in messages) {
        final key = '${message.chatId}_${message.id}';
        messagesToCache[key] = message.toJson();
      }
      await messagesBox.putAll(messagesToCache);
      AppLogger.info('Cached ${messages.length} messages');
    } catch (e) {
      AppLogger.error('Cache messages error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    try {
      final messages = <MessageModel>[];

      for (var key in messagesBox.keys) {
        if (key.toString().startsWith(chatId)) {
          final messageJson = messagesBox.get(key);
          if (messageJson != null) {
            messages.add(
              MessageModel.fromJson(Map<String, dynamic>.from(messageJson)),
            );
          }
        }
      }

      // Sort by timestamp
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      AppLogger.debug('Retrieved ${messages.length} cached messages for chat: $chatId');
      return messages;
    } catch (e) {
      AppLogger.error('Get cached messages error', e);
      return [];
    }
  }

  @override
  Future<void> queueMessage(MessageModel message) async {
    try {
      await queuedMessagesBox.put(message.id, message.toJson());
      AppLogger.info('Message queued for sending: ${message.id}');
    } catch (e) {
      AppLogger.error('Queue message error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getQueuedMessages() async {
    try {
      final messages = <MessageModel>[];

      for (var messageJson in queuedMessagesBox.values) {
        messages.add(
          MessageModel.fromJson(Map<String, dynamic>.from(messageJson)),
        );
      }

      AppLogger.debug('Retrieved ${messages.length} queued messages');
      return messages;
    } catch (e) {
      AppLogger.error('Get queued messages error', e);
      return [];
    }
  }

  @override
  Future<void> removeQueuedMessage(String messageId) async {
    try {
      await queuedMessagesBox.delete(messageId);
      AppLogger.debug('Queued message removed: $messageId');
    } catch (e) {
      AppLogger.error('Remove queued message error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheChat(ChatModel chat) async {
    try {
      await chatsBox.put(chat.id, chat.toJson());
      AppLogger.debug('Chat cached: ${chat.id}');
    } catch (e) {
      AppLogger.error('Cache chat error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    try {
      final Map<String, dynamic> chatsToCache = {};
      for (var chat in chats) {
        chatsToCache[chat.id] = chat.toJson();
      }
      await chatsBox.putAll(chatsToCache);
      AppLogger.info('Cached ${chats.length} chats');
    } catch (e) {
      AppLogger.error('Cache chats error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    try {
      final chats = <ChatModel>[];

      for (var chatJson in chatsBox.values) {
        chats.add(ChatModel.fromJson(Map<String, dynamic>.from(chatJson)));
      }

      // Sort by last message time
      chats.sort((a, b) {
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      AppLogger.debug('Retrieved ${chats.length} cached chats');
      return chats;
    } catch (e) {
      AppLogger.error('Get cached chats error', e);
      return [];
    }
  }

  @override
  Future<void> clearChatCache(String chatId) async {
    try {
      // Remove all messages for this chat
      final keysToDelete = <String>[];
      for (var key in messagesBox.keys) {
        if (key.toString().startsWith(chatId)) {
          keysToDelete.add(key);
        }
      }
      await messagesBox.deleteAll(keysToDelete);

      // Remove chat
      await chatsBox.delete(chatId);

      AppLogger.info('Chat cache cleared: $chatId');
    } catch (e) {
      AppLogger.error('Clear chat cache error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await messagesBox.clear();
      await chatsBox.clear();
      await queuedMessagesBox.clear();
      AppLogger.info('All chat cache cleared');
    } catch (e) {
      AppLogger.error('Clear all cache error', e);
      throw CacheException(e.toString());
    }
  }
}