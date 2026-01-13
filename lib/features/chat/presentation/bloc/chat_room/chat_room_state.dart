import 'package:equatable/equatable.dart';
import '../../../domain/entities/message_entity.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object> get props => [];
}

class ChatRoomInitial extends ChatRoomState {
  const ChatRoomInitial();
}

class ChatRoomLoading extends ChatRoomState {
  const ChatRoomLoading();
}

class ChatRoomLoaded extends ChatRoomState {
  final List<MessageEntity> messages;
  final List<String> typingUsers;

  const ChatRoomLoaded({
    required this.messages,
    this.typingUsers = const [],
  });

  @override
  List<Object> get props => [messages, typingUsers];

  ChatRoomLoaded copyWith({
    List<MessageEntity>? messages,
    List<String>? typingUsers,
  }) {
    return ChatRoomLoaded(
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
    );
  }
}

class ChatRoomError extends ChatRoomState {
  final String message;

  const ChatRoomError({required this.message});

  @override
  List<Object> get props => [message];
}

class ChatRoomSendingMessage extends ChatRoomState {
  const ChatRoomSendingMessage();
}

class ChatRoomMessageSentSuccess extends ChatRoomState {
  const ChatRoomMessageSentSuccess();
}