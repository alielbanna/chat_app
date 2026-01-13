import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/usecases/delete_message_usecase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/mark_as_read_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../../../domain/usecases/send_typing_indicator_usecase.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

@injectable
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final SendTypingIndicatorUseCase sendTypingIndicatorUseCase;

  StreamSubscription? _messagesSubscription;

  ChatRoomBloc({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.deleteMessageUseCase,
    required this.markAsReadUseCase,
    required this.sendTypingIndicatorUseCase,
  }) : super(const ChatRoomInitial()) {
    on<ChatRoomLoadRequested>(_onLoadRequested);
    on<ChatRoomMessageSent>(_onMessageSent);
    on<ChatRoomMessageDeleted>(_onMessageDeleted);
    on<ChatRoomMessagesMarkedAsRead>(_onMessagesMarkedAsRead);
    on<ChatRoomTypingIndicatorSent>(_onTypingIndicatorSent);
  }

  Future<void> _onLoadRequested(
      ChatRoomLoadRequested event,
      Emitter<ChatRoomState> emit,
      ) async {
    emit(const ChatRoomLoading());

    await _messagesSubscription?.cancel();

    _messagesSubscription = getMessagesUseCase(
      GetMessagesParams(chatId: event.chatId),
    ).listen(
          (result) {
        result.fold(
              (failure) {
            AppLogger.error('Load messages failed', failure.message);
            emit(ChatRoomError(message: failure.message));
          },
              (messages) {
            AppLogger.debug('Loaded ${messages.length} messages');
            emit(ChatRoomLoaded(messages: messages));
          },
        );
      },
    );
  }

  Future<void> _onMessageSent(
      ChatRoomMessageSent event,
      Emitter<ChatRoomState> emit,
      ) async {
    final result = await sendMessageUseCase(
      SendMessageParams(message: event.message),
    );

    result.fold(
          (failure) {
        AppLogger.error('Send message failed', failure.message);
        emit(ChatRoomError(message: failure.message));
      },
          (_) {
        AppLogger.info('Message sent successfully');
        emit(const ChatRoomMessageSentSuccess());
      },
    );
  }

  Future<void> _onMessageDeleted(
      ChatRoomMessageDeleted event,
      Emitter<ChatRoomState> emit,
      ) async {
    final result = await deleteMessageUseCase(
      DeleteMessageParams(
        chatId: event.chatId,
        messageId: event.messageId,
      ),
    );

    result.fold(
          (failure) {
        AppLogger.error('Delete message failed', failure.message);
        emit(ChatRoomError(message: failure.message));
      },
          (_) {
        AppLogger.info('Message deleted successfully');
      },
    );
  }

  Future<void> _onMessagesMarkedAsRead(
      ChatRoomMessagesMarkedAsRead event,
      Emitter<ChatRoomState> emit,
      ) async {
    final result = await markAsReadUseCase(
      MarkAsReadParams(chatId: event.chatId, userId: event.userId),
    );

    result.fold(
          (failure) {
        AppLogger.warning('Mark as read failed', failure.message);
      },
          (_) {
        AppLogger.debug('Messages marked as read');
      },
    );
  }

  Future<void> _onTypingIndicatorSent(
      ChatRoomTypingIndicatorSent event,
      Emitter<ChatRoomState> emit,
      ) async {
    await sendTypingIndicatorUseCase(
      SendTypingIndicatorParams(
        chatId: event.chatId,
        userId: event.userId,
        userName: event.userName,
        isTyping: event.isTyping,
      ),
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}