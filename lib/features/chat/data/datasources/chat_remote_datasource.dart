import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';
import '../models/typing_indicator_model.dart';

abstract class ChatRemoteDataSource {
  Future<String> getOrCreateChat(String userId1, String userId2);
  Future<void> sendMessage(MessageModel message);
  Stream<List<MessageModel>> getMessages(String chatId);
  Stream<List<ChatModel>> getUserChats(String userId);
  Future<void> markAsRead(String chatId, String userId);
  Future<void> deleteMessage(String chatId, String messageId);
  Future<void> editMessage(String chatId, String messageId, String newContent);
  Future<void> sendTypingIndicator(String chatId, String userId, String userName, bool isTyping);
  Stream<List<TypingIndicatorModel>> getTypingIndicators(String chatId);
  Future<void> addReaction(String chatId, String messageId, String userId, String emoji);
  Future<void> removeReaction(String chatId, String messageId, String userId);
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  @override
  Future<String> getOrCreateChat(String userId1, String userId2) async {
    try {
      final participants = [userId1, userId2]..sort();

      // Check if chat exists
      final querySnapshot = await firestore
          .collection(FirebaseConstants.chatsCollection)
          .where(FirebaseConstants.participantIds, isEqualTo: participants)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }

      // Create new chat
      final chatRef = await firestore
          .collection(FirebaseConstants.chatsCollection)
          .add({
        FirebaseConstants.participantIds: participants,
        'type': 'oneToOne',
        FirebaseConstants.lastMessage: null,
        FirebaseConstants.lastMessageTime: FieldValue.serverTimestamp(),
        'unreadCounts': {userId1: 0, userId2: 0},
        'isMuted': false,
        'isPinned': false,
        FirebaseConstants.createdAt: FieldValue.serverTimestamp(),
      });

      AppLogger.info('Chat created: ${chatRef.id}');
      return chatRef.id;
    } catch (e) {
      AppLogger.error('Get or create chat error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    try {
      final batch = firestore.batch();

      // Add message
      final messageRef = firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(message.chatId)
          .collection(FirebaseConstants.messagesCollection)
          .doc(message.id);

      batch.set(messageRef, message.toJson());

      // Update chat
      final chatRef = firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(message.chatId);

      batch.update(chatRef, {
        FirebaseConstants.lastMessage: message.content,
        FirebaseConstants.lastMessageTime: FieldValue.serverTimestamp(),
      });

      await batch.commit();
      AppLogger.info('Message sent: ${message.id}');
    } catch (e) {
      AppLogger.error('Send message error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    try {
      return firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .orderBy(FirebaseConstants.timestamp, descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return MessageModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      AppLogger.error('Get messages error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<ChatModel>> getUserChats(String userId) {
    try {
      return firestore
          .collection(FirebaseConstants.chatsCollection)
          .where(FirebaseConstants.participantIds, arrayContains: userId)
          .orderBy(FirebaseConstants.lastMessageTime, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ChatModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      AppLogger.error('Get user chats error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsRead(String chatId, String userId) async {
    try {
      final messages = await firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .where(FirebaseConstants.senderId, isNotEqualTo: userId)
          .where(FirebaseConstants.status, isEqualTo: 'sent')
          .get();

      final batch = firestore.batch();
      for (var doc in messages.docs) {
        batch.update(doc.reference, {FirebaseConstants.status: 'read'});
      }
      await batch.commit();

      AppLogger.info('Messages marked as read in chat: $chatId');
    } catch (e) {
      AppLogger.error('Mark as read error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .doc(messageId)
          .update({'isDeleted': true, 'content': 'This message was deleted'});

      AppLogger.info('Message deleted: $messageId');
    } catch (e) {
      AppLogger.error('Delete message error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> editMessage(
      String chatId,
      String messageId,
      String newContent,
      ) async {
    try {
      await firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .doc(messageId)
          .update({
        'content': newContent,
        'isEdited': true,
        'editedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Message edited: $messageId');
    } catch (e) {
      AppLogger.error('Edit message error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendTypingIndicator(
      String chatId,
      String userId,
      String userName,
      bool isTyping,
      ) async {
    try {
      final indicator = TypingIndicatorModel(
        chatId: chatId,
        userId: userId,
        userName: userName,
        isTyping: isTyping,
        timestamp: DateTime.now(),
      );

      if (isTyping) {
        await firestore
            .collection(FirebaseConstants.chatsCollection)
            .doc(chatId)
            .collection(FirebaseConstants.typingCollection)
            .doc(userId)
            .set(indicator.toJson());
      } else {
        await firestore
            .collection(FirebaseConstants.chatsCollection)
            .doc(chatId)
            .collection(FirebaseConstants.typingCollection)
            .doc(userId)
            .delete();
      }

      AppLogger.debug('Typing indicator sent: $userId - isTyping: $isTyping');
    } catch (e) {
      AppLogger.error('Send typing indicator error', e);
      // Don't throw - typing indicators are not critical
    }
  }

  @override
  Stream<List<TypingIndicatorModel>> getTypingIndicators(String chatId) {
    try {
      return firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.typingCollection)
          .where('isTyping', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => TypingIndicatorModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      AppLogger.error('Get typing indicators error', e);
      return Stream.value([]);
    }
  }

  @override
  Future<void> addReaction(
      String chatId,
      String messageId,
      String userId,
      String emoji,
      ) async {
    try {
      await firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .doc(messageId)
          .update({'reactions.$userId': emoji});

      AppLogger.info('Reaction added to message: $messageId');
    } catch (e) {
      AppLogger.error('Add reaction error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeReaction(
      String chatId,
      String messageId,
      String userId,
      ) async {
    try {
      await firestore
          .collection(FirebaseConstants.chatsCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .doc(messageId)
          .update({'reactions.$userId': FieldValue.delete()});

      AppLogger.info('Reaction removed from message: $messageId');
    } catch (e) {
      AppLogger.error('Remove reaction error', e);
      throw ServerException(e.toString());
    }
  }
}