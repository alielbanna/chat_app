import 'package:equatable/equatable.dart';
import '../../../domain/entities/message_entity.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object?> get props => [];
}

class ChatRoomLoadRequested extends ChatRoomEvent {
  final String chatId;

  const ChatRoomLoadRequested({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class ChatRoomMessageSent extends ChatRoomEvent {
  final MessageEntity message;

  const ChatRoomMessageSent({required this.message});

  @override
  List<Object> get props => [message];
}

class ChatRoomMessageDeleted extends ChatRoomEvent {
  final String chatId;
  final String messageId;

  const ChatRoomMessageDeleted({
    required this.chatId,
    required this.messageId,
  });

  @override
  List<Object> get props => [chatId, messageId];
}

class ChatRoomMessagesMarkedAsRead extends ChatRoomEvent {
  final String chatId;
  final String userId;

  const ChatRoomMessagesMarkedAsRead({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object> get props => [chatId, userId];
}

class ChatRoomTypingIndicatorSent extends ChatRoomEvent {
  final String chatId;
  final String userId;
  final String userName;
  final bool isTyping;

  const ChatRoomTypingIndicatorSent({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.isTyping,
  });

  @override
  List<Object> get props => [chatId, userId, userName, isTyping];
}