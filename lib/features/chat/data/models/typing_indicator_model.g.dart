// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_indicator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypingIndicatorModel _$TypingIndicatorModelFromJson(
  Map<String, dynamic> json,
) => TypingIndicatorModel(
  chatId: json['chatId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  isTyping: json['isTyping'] as bool,
  timestamp: TypingIndicatorModel._dateTimeFromTimestamp(json['timestamp']),
);

Map<String, dynamic> _$TypingIndicatorModelToJson(
  TypingIndicatorModel instance,
) => <String, dynamic>{
  'chatId': instance.chatId,
  'userId': instance.userId,
  'userName': instance.userName,
  'isTyping': instance.isTyping,
  'timestamp': TypingIndicatorModel._dateTimeToTimestamp(instance.timestamp),
};
