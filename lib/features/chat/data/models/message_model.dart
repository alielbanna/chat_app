import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  @JsonKey(unknownEnumValue: MessageType.text)
  final MessageType type;
  @JsonKey(unknownEnumValue: MessageStatus.sent)
  final MessageStatus status;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime timestamp;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;
  final String? replyToMessageId;
  final Map<String, String>? reactions;
  final bool isEdited;
  @JsonKey(fromJson: _nullableDateTimeFromTimestamp, toJson: _nullableDateTimeToTimestamp)
  final DateTime? editedAt;
  final bool isDeleted;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.status,
    required this.timestamp,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
    this.replyToMessageId,
    this.reactions,
    this.isEdited = false,
    this.editedAt,
    this.isDeleted = false,
  });

  // JSON Serialization
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  // Convert to Entity
  MessageEntity toEntity() => MessageEntity(
    id: id,
    chatId: chatId,
    senderId: senderId,
    senderName: senderName,
    content: content,
    type: type,
    status: status,
    timestamp: timestamp,
    fileUrl: fileUrl,
    fileName: fileName,
    fileSize: fileSize,
    thumbnailUrl: thumbnailUrl,
    latitude: latitude,
    longitude: longitude,
    replyToMessageId: replyToMessageId,
    reactions: reactions,
    isEdited: isEdited,
    editedAt: editedAt,
    isDeleted: isDeleted,
  );

  // Create from Entity
  factory MessageModel.fromEntity(MessageEntity entity) => MessageModel(
    id: entity.id,
    chatId: entity.chatId,
    senderId: entity.senderId,
    senderName: entity.senderName,
    content: entity.content,
    type: entity.type,
    status: entity.status,
    timestamp: entity.timestamp,
    fileUrl: entity.fileUrl,
    fileName: entity.fileName,
    fileSize: entity.fileSize,
    thumbnailUrl: entity.thumbnailUrl,
    latitude: entity.latitude,
    longitude: entity.longitude,
    replyToMessageId: entity.replyToMessageId,
    reactions: entity.reactions,
    isEdited: entity.isEdited,
    editedAt: entity.editedAt,
    isDeleted: entity.isDeleted,
  );

  // Timestamp conversion helpers
  static DateTime _dateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp is String) return DateTime.parse(timestamp);
    // Firestore Timestamp
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);
  }

  static dynamic _dateTimeToTimestamp(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  static DateTime? _nullableDateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    return _dateTimeFromTimestamp(timestamp);
  }

  static dynamic _nullableDateTimeToTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toIso8601String();
  }

  // CopyWith
  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? thumbnailUrl,
    double? latitude,
    double? longitude,
    String? replyToMessageId,
    Map<String, String>? reactions,
    bool? isEdited,
    DateTime? editedAt,
    bool? isDeleted,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      reactions: reactions ?? this.reactions,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MessageModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}