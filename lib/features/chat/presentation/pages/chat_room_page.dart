import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../../media/data/models/media_model.dart';
import '../../../media/presentation/bloc/media_bloc.dart';
import '../../../media/presentation/bloc/media_event.dart';
import '../../../media/presentation/bloc/media_state.dart';
import '../../domain/entities/message_entity.dart';
import '../bloc/chat_room/chat_room_bloc.dart';
import '../bloc/chat_room/chat_room_event.dart';
import '../bloc/chat_room/chat_room_state.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  final String currentUserId;
  final String currentUserName;

  const ChatRoomPage({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final ScrollController _scrollController = ScrollController();
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when entering chat
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<ChatRoomBloc>().add(
        ChatRoomMessagesMarkedAsRead(
          chatId: widget.chatId,
          userId: widget.currentUserId,
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String content) {
    if (content.trim().isEmpty) return;

    final message = MessageEntity(
      id: _uuid.v4(),
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      senderName: widget.currentUserName,
      content: content.trim(),
      type: MessageType.text,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
    );

    context.read<ChatRoomBloc>().add(ChatRoomMessageSent(message: message));

    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _handleTyping(bool isTyping) {
    context.read<ChatRoomBloc>().add(
      ChatRoomTypingIndicatorSent(
        chatId: widget.chatId,
        userId: widget.currentUserId,
        userName: widget.currentUserName,
        isTyping: isTyping,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<ChatRoomBloc>()
                ..add(ChatRoomLoadRequested(chatId: widget.chatId)),
        ),
        BlocProvider(create: (context) => getIt<MediaBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.otherUserName),
              BlocBuilder<ChatRoomBloc, ChatRoomState>(
                builder: (context, state) {
                  if (state is ChatRoomLoaded && state.typingUsers.isNotEmpty) {
                    return Text(
                      'typing...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ChatRoomBloc, ChatRoomState>(
              listener: (context, state) {
                if (state is ChatRoomError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
            BlocListener<MediaBloc, MediaState>(
              listener: (context, state) {
                if (state is MediaUploadSuccess) {
                  // Create message with uploaded media
                  final message = MessageEntity(
                    id: _uuid.v4(),
                    chatId: widget.chatId,
                    senderId: widget.currentUserId,
                    senderName: widget.currentUserName,
                    content: '',
                    type: state.media.type == MediaType.image
                        ? MessageType.image
                        : state.media.type == MediaType.voice
                        ? MessageType.voice
                        : MessageType.file,
                    status: MessageStatus.sending,
                    timestamp: DateTime.now(),
                    fileUrl: state.media.url,
                    fileName: state.media.fileName,
                    fileSize: state.media.fileSize,
                  );

                  context.read<ChatRoomBloc>().add(
                    ChatRoomMessageSent(message: message),
                  );

                  Future.delayed(
                    const Duration(milliseconds: 100),
                    _scrollToBottom,
                  );
                } else if (state is MediaError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
                  listener: (context, state) {
                    if (state is ChatRoomError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatRoomLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ChatRoomError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ChatRoomBloc>().add(
                                  ChatRoomLoadRequested(chatId: widget.chatId),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ChatRoomLoaded) {
                      if (state.messages.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: AppColors.gray400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.gray600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Send a message to start the conversation',
                                style: TextStyle(color: AppColors.gray500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: const EdgeInsets.all(16),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                final isMe =
                                    message.senderId == widget.currentUserId;

                                return MessageBubble(
                                  message: message,
                                  isMe: isMe,
                                );
                              },
                            ),
                          ),
                          if (state.typingUsers.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TypingIndicator(),
                            ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              ChatInput(
                onSendMessage: _handleSendMessage,
                onSendImage: _handleSendImage,
                onSendFile: _handleSendFile,
                onSendVoice: _handleSendVoice,
                onTypingChanged: _handleTyping,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSendImage(String imagePath) async {
    // Upload image first
    final mediaBloc = context.read<MediaBloc>();
    mediaBloc.add(
      MediaImageUploadRequested(filePath: imagePath, chatId: widget.chatId),
    );
  }

  void _handleSendFile(String filePath) async {
    final mediaBloc = context.read<MediaBloc>();
    mediaBloc.add(
      MediaFileUploadRequested(filePath: filePath, chatId: widget.chatId),
    );
  }

  void _handleSendVoice(String voicePath, int duration) async {
    final mediaBloc = context.read<MediaBloc>();
    mediaBloc.add(
      MediaVoiceUploadRequested(
        filePath: voicePath,
        duration: duration,
        chatId: widget.chatId,
      ),
    );
  }
}
