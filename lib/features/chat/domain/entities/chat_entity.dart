import 'package:equatable/equatable.dart';

enum ChatType { oneToOne, group }

class ChatEntity extends Equatable {
  final String id;
  final List<String> participantIds;
  final ChatType type;
  final String? groupName;
  final String? groupAvatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final Map<String, int> unreadCounts;
  final Map<String, bool>? typingUsers;
  final bool isMuted;
  final bool isPinned;
  final DateTime? createdAt;

  const ChatEntity({
    required this.id,
    required this.participantIds,
    required this.type,
    this.groupName,
    this.groupAvatarUrl,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCounts,
    this.typingUsers,
    this.isMuted = false,
    this.isPinned = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    participantIds,
    type,
    groupName,
    groupAvatarUrl,
    lastMessage,
    lastMessageTime,
    unreadCounts,
    typingUsers,
    isMuted,
    isPinned,
    createdAt,
  ];

  ChatEntity copyWith({
    String? id,
    List<String>? participantIds,
    ChatType? type,
    String? groupName,
    String? groupAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    Map<String, int>? unreadCounts,
    Map<String, bool>? typingUsers,
    bool? isMuted,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      type: type ?? this.type,
      groupName: groupName ?? this.groupName,
      groupAvatarUrl: groupAvatarUrl ?? this.groupAvatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      typingUsers: typingUsers ?? this.typingUsers,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}