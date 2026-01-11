import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  /// Get or create a one-to-one chat
  Future<Either<Failure, String>> getOrCreateChat(
      String userId1,
      String userId2,
      );

  /// Send a message
  Future<Either<Failure, void>> sendMessage(MessageEntity message);

  /// Get messages stream for a chat
  Stream<Either<Failure, List<MessageEntity>>> getMessages(String chatId);

  /// Get user's chats stream
  Stream<Either<Failure, List<ChatEntity>>> getUserChats(String userId);

  /// Mark messages as read
  Future<Either<Failure, void>> markAsRead(String chatId, String userId);

  /// Delete a message
  Future<Either<Failure, void>> deleteMessage(String chatId, String messageId);

  /// Edit a message
  Future<Either<Failure, void>> editMessage(
      String chatId,
      String messageId,
      String newContent,
      );

  /// Send typing indicator
  Future<Either<Failure, void>> sendTypingIndicator(
      String chatId,
      String userId,
      String userName,
      bool isTyping,
      );

  /// Get typing indicators stream (returns list of user names who are typing)
  Stream<Either<Failure, List<String>>> getTypingIndicators(
      String chatId,
      );

  /// Add reaction to message
  Future<Either<Failure, void>> addReaction(
      String chatId,
      String messageId,
      String userId,
      String emoji,
      );

  /// Remove reaction from message
  Future<Either<Failure, void>> removeReaction(
      String chatId,
      String messageId,
      String userId,
      );

  /// Search messages
  Future<Either<Failure, List<MessageEntity>>> searchMessages(
      String chatId,
      String query,
      );
}