import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> getOrCreateChat(
      String userId1,
      String userId2,
      ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final chatId = await remoteDataSource.getOrCreateChat(userId1, userId2);
      AppLogger.info('Chat retrieved/created: $chatId');
      return Right(chatId);
    } on ServerException catch (e) {
      AppLogger.error('Get or create chat error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Get or create chat unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(MessageEntity message) async {
    final messageModel = MessageModel.fromEntity(message);

    try {
      if (await networkInfo.isConnected) {
        // Send message to server
        await remoteDataSource.sendMessage(messageModel);
        // Cache message locally
        await localDataSource.cacheMessage(messageModel);
        AppLogger.info('Message sent: ${message.id}');
        return const Right(null);
      } else {
        // Queue message for later
        await localDataSource.queueMessage(messageModel);
        AppLogger.info('Message queued for sending: ${message.id}');
        return const Right(null);
      }
    } on ServerException catch (e) {
      // If sending fails, queue the message
      await localDataSource.queueMessage(messageModel);
      AppLogger.error('Send message error, queued', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Send message unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> getMessages(String chatId) async* {
    try {
      // First, emit cached messages
      final cachedMessages = await localDataSource.getCachedMessages(chatId);
      if (cachedMessages.isNotEmpty) {
        yield Right(cachedMessages.map((m) => m.toEntity()).toList());
      }

      // Then stream from remote
      yield* remoteDataSource.getMessages(chatId).map(
            (messages) {
          // Cache messages in background
          localDataSource.cacheMessages(messages);
          return Right<Failure, List<MessageEntity>>(
            messages.map((m) => m.toEntity()).toList(),
          );
        },
      ).handleError((error) {
        AppLogger.error('Get messages stream error', error);
        return Left<Failure, List<MessageEntity>>(
          ServerFailure(error.toString()),
        );
      });
    } catch (e) {
      AppLogger.error('Get messages error', e);
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ChatEntity>>> getUserChats(String userId) async* {
    try {
      // First, emit cached chats
      final cachedChats = await localDataSource.getCachedChats();
      if (cachedChats.isNotEmpty) {
        yield Right(cachedChats.map((c) => c.toEntity()).toList());
      }

      // Then stream from remote
      yield* remoteDataSource.getUserChats(userId).map(
            (chats) {
          // Cache chats in background
          localDataSource.cacheChats(chats);
          return Right<Failure, List<ChatEntity>>(
            chats.map((c) => c.toEntity()).toList(),
          );
        },
      ).handleError((error) {
        AppLogger.error('Get user chats stream error', error);
        return Left<Failure, List<ChatEntity>>(
          ServerFailure(error.toString()),
        );
      });
    } catch (e) {
      AppLogger.error('Get user chats error', e);
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String chatId, String userId) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.markAsRead(chatId, userId);
      AppLogger.info('Messages marked as read in chat: $chatId');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Mark as read error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Mark as read unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(
      String chatId,
      String messageId,
      ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.deleteMessage(chatId, messageId);
      AppLogger.info('Message deleted: $messageId');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Delete message error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Delete message unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editMessage(
      String chatId,
      String messageId,
      String newContent,
      ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.editMessage(chatId, messageId, newContent);
      AppLogger.info('Message edited: $messageId');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Edit message error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Edit message unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendTypingIndicator(
      String chatId,
      String userId,
      String userName,
      bool isTyping,
      ) async {
    try {
      // Don't check network - typing indicators are best-effort
      await remoteDataSource.sendTypingIndicator(
        chatId,
        userId,
        userName,
        isTyping,
      );
      return const Right(null);
    } catch (e) {
      // Don't log or return error - typing indicators are not critical
      return const Right(null);
    }
  }

  @override
  Stream<Either<Failure, List<String>>> getTypingIndicators(
      String chatId,
      ) async* {
    try {
      yield* remoteDataSource.getTypingIndicators(chatId).map(
            (indicators) {
          // Extract just the user names
          final userNames = indicators.map((i) => i.userName).toList();
          return Right<Failure, List<String>>(userNames);
        },
      ).handleError((error) {
        // Don't throw - just return empty list
        return const Right<Failure, List<String>>([]);
      });
    } catch (e) {
      yield const Right([]);
    }
  }

  @override
  Future<Either<Failure, void>> addReaction(
      String chatId,
      String messageId,
      String userId,
      String emoji,
      ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.addReaction(chatId, messageId, userId, emoji);
      AppLogger.info('Reaction added to message: $messageId');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Add reaction error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Add reaction unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeReaction(
      String chatId,
      String messageId,
      String userId,
      ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.removeReaction(chatId, messageId, userId);
      AppLogger.info('Reaction removed from message: $messageId');
      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Remove reaction error', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Remove reaction unexpected error', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> searchMessages(
      String chatId,
      String query,
      ) async {
    try {
      // For now, search in cached messages
      final cachedMessages = await localDataSource.getCachedMessages(chatId);
      final results = cachedMessages.where((message) {
        return message.content.toLowerCase().contains(query.toLowerCase());
      }).toList();

      return Right(results.map((m) => m.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Search messages error', e);
      return Left(CacheFailure(e.toString()));
    }
  }
}