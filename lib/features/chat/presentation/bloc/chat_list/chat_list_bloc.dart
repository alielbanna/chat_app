import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/usecases/get_user_chats_usecase.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetUserChatsUseCase getUserChatsUseCase;
  StreamSubscription? _chatsSubscription;

  ChatListBloc({required this.getUserChatsUseCase})
      : super(const ChatListInitial()) {
    on<ChatListLoadRequested>(_onLoadRequested);
    on<ChatListRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
      ChatListLoadRequested event,
      Emitter<ChatListState> emit,
      ) async {
    emit(const ChatListLoading());

    await _chatsSubscription?.cancel();

    _chatsSubscription = getUserChatsUseCase(
      GetUserChatsParams(userId: event.userId),
    ).listen(
          (result) {
        result.fold(
              (failure) {
            AppLogger.error('Load chats failed', failure.message);
            emit(ChatListError(message: failure.message));
          },
              (chats) {
            AppLogger.debug('Loaded ${chats.length} chats');
            emit(ChatListLoaded(chats: chats));
          },
        );
      },
    );
  }

  Future<void> _onRefreshRequested(
      ChatListRefreshRequested event,
      Emitter<ChatListState> emit,
      ) async {
    // Refresh handled by stream automatically
    AppLogger.debug('Chat list refresh requested');
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}