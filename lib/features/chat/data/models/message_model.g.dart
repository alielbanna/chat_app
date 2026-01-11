// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  chatId: json['chatId'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  content: json['content'] as String,
  type: $enumDecode(
    _$MessageTypeEnumMap,
    json['type'],
    unknownValue: MessageType.text,
  ),
  status: $enumDecode(
    _$MessageStatusEnumMap,
    json['status'],
    unknownValue: MessageStatus.sent,
  ),
  timestamp: MessageModel._dateTimeFromTimestamp(json['timestamp']),
  fileUrl: json['fileUrl'] as String?,
  fileName: json['fileName'] as String?,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  replyToMessageId: json['replyToMessageId'] as String?,
  reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  isEdited: json['isEdited'] as bool? ?? false,
  editedAt: MessageModel._nullableDateTimeFromTimestamp(json['editedAt']),
  isDeleted: json['isDeleted'] as bool? ?? false,
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'timestamp': MessageModel._dateTimeToTimestamp(instance.timestamp),
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'thumbnailUrl': instance.thumbnailUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'replyToMessageId': instance.replyToMessageId,
      'reactions': instance.reactions,
      'isEdited': instance.isEdited,
      'editedAt': MessageModel._nullableDateTimeToTimestamp(instance.editedAt),
      'isDeleted': instance.isDeleted,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.location: 'location',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
