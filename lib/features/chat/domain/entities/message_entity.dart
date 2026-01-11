import 'package:equatable/equatable.dart';

enum MessageType { text, image, file, voice, location }
enum MessageStatus { sending, sent, delivered, read, failed }

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final MessageStatus status;
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
  final DateTime? editedAt;
  final bool isDeleted;

  const MessageEntity({
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

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    senderName,
    content,
    type,
    status,
    timestamp,
    fileUrl,
    fileName,
    fileSize,
    thumbnailUrl,
    latitude,
    longitude,
    replyToMessageId,
    reactions,
    isEdited,
    editedAt,
    isDeleted,
  ];

  MessageEntity copyWith({
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
    return MessageEntity(
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
}