import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chat_entity.dart';
import '../widgets/user_avatar.dart';

class ChatListTile extends StatelessWidget {
  final ChatEntity chat;

  const ChatListTile({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = chat.unreadCounts['current-user-id'] ?? 0;
    final hasUnread = unreadCount > 0;

    return ListTile(
      leading: UserAvatar(
        name: chat.groupName ?? 'Unknown',
        imageUrl: chat.groupAvatarUrl,
      ),
      title: Text(
        chat.groupName ?? 'Unknown Chat',
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        chat.lastMessage ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: hasUnread ? AppColors.gray800 : AppColors.gray600,
          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chat.lastMessageTime != null)
            Text(
              timeago.format(chat.lastMessageTime!),
              style: TextStyle(
                fontSize: 12,
                color: hasUnread ? AppColors.primary : AppColors.gray500,
              ),
            ),
          if (hasUnread) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        // TODO: Navigate to chat room
      },
    );
  }
}