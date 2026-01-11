// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
  id: json['id'] as String,
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  type: $enumDecode(
    _$ChatTypeEnumMap,
    json['type'],
    unknownValue: ChatType.oneToOne,
  ),
  groupName: json['groupName'] as String?,
  groupAvatarUrl: json['groupAvatarUrl'] as String?,
  lastMessage: json['lastMessage'] as String?,
  lastMessageTime: ChatModel._nullableDateTimeFromTimestamp(
    json['lastMessageTime'],
  ),
  unreadCounts: Map<String, int>.from(json['unreadCounts'] as Map),
  typingUsers: (json['typingUsers'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
  isMuted: json['isMuted'] as bool? ?? false,
  isPinned: json['isPinned'] as bool? ?? false,
  createdAt: ChatModel._nullableDateTimeFromTimestamp(json['createdAt']),
);

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
  'id': instance.id,
  'participantIds': instance.participantIds,
  'type': _$ChatTypeEnumMap[instance.type]!,
  'groupName': instance.groupName,
  'groupAvatarUrl': instance.groupAvatarUrl,
  'lastMessage': instance.lastMessage,
  'lastMessageTime': ChatModel._nullableDateTimeToTimestamp(
    instance.lastMessageTime,
  ),
  'unreadCounts': instance.unreadCounts,
  'typingUsers': instance.typingUsers,
  'isMuted': instance.isMuted,
  'isPinned': instance.isPinned,
  'createdAt': ChatModel._nullableDateTimeToTimestamp(instance.createdAt),
};

const _$ChatTypeEnumMap = {
  ChatType.oneToOne: 'oneToOne',
  ChatType.group: 'group',
};
