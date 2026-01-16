import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/logger.dart';
import '../../../domain/usecases/get_user_chats_usecase.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetUserChatsUseCase getUserChatsUseCase;

  ChatListBloc({
    required this.getUserChatsUseCase,
  }) : super(const ChatListInitial()) {
    on<ChatListLoadRequested>(_onLoadRequested);
    on<ChatListRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
      ChatListLoadRequested event,
      Emitter<ChatListState> emit,
      ) async {
    emit(const ChatListLoading());

    await emit.forEach(
      getUserChatsUseCase(
        GetUserChatsParams(userId: event.userId),
      ),
      onData: (result) {
        return result.fold(
              (failure) {
            AppLogger.error(
              'Load chats failed',
              failure.message,
            );
            return ChatListError(message: failure.message);
          },
              (chats) {
            AppLogger.debug('Loaded ${chats.length} chats');
            return ChatListLoaded(chats: chats);
          },
        );
      },
      onError: (error, _) {
        AppLogger.error('Chat stream error', error.toString());
        return ChatListError(message: error.toString());
      },
    );
  }

  Future<void> _onRefreshRequested(
      ChatListRefreshRequested event,
      Emitter<ChatListState> emit,
      ) async {
    // Stream handles refresh automatically
    AppLogger.debug('Chat list refresh requested');
  }
}
