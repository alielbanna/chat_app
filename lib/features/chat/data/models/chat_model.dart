import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/chat_entity.dart';

part 'chat_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatModel {
  final String id;
  final List<String> participantIds;
  @JsonKey(unknownEnumValue: ChatType.oneToOne)
  final ChatType type;
  final String? groupName;
  final String? groupAvatarUrl;
  final String? lastMessage;
  @JsonKey(fromJson: _nullableDateTimeFromTimestamp, toJson: _nullableDateTimeToTimestamp)
  final DateTime? lastMessageTime;
  final Map<String, int> unreadCounts;
  final Map<String, bool>? typingUsers;
  final bool isMuted;
  final bool isPinned;
  @JsonKey(fromJson: _nullableDateTimeFromTimestamp, toJson: _nullableDateTimeToTimestamp)
  final DateTime? createdAt;

  const ChatModel({
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

  // JSON Serialization
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  // Convert to Entity
  ChatEntity toEntity() => ChatEntity(
    id: id,
    participantIds: participantIds,
    type: type,
    groupName: groupName,
    groupAvatarUrl: groupAvatarUrl,
    lastMessage: lastMessage,
    lastMessageTime: lastMessageTime,
    unreadCounts: unreadCounts,
    typingUsers: typingUsers,
    isMuted: isMuted,
    isPinned: isPinned,
    createdAt: createdAt,
  );

  // Create from Entity
  factory ChatModel.fromEntity(ChatEntity entity) => ChatModel(
    id: entity.id,
    participantIds: entity.participantIds,
    type: entity.type,
    groupName: entity.groupName,
    groupAvatarUrl: entity.groupAvatarUrl,
    lastMessage: entity.lastMessage,
    lastMessageTime: entity.lastMessageTime,
    unreadCounts: entity.unreadCounts,
    typingUsers: entity.typingUsers,
    isMuted: entity.isMuted,
    isPinned: entity.isPinned,
    createdAt: entity.createdAt,
  );

  // Timestamp helpers
  static DateTime? _nullableDateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp is String) return DateTime.parse(timestamp);
    // Firestore Timestamp
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);
  }

  static dynamic _nullableDateTimeToTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toIso8601String();
  }

  // CopyWith
  ChatModel copyWith({
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
    return ChatModel(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}