import 'package:json_annotation/json_annotation.dart';

part 'typing_indicator_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TypingIndicatorModel {
  final String chatId;
  final String userId;
  final String userName;
  final bool isTyping;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime timestamp;

  const TypingIndicatorModel({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.isTyping,
    required this.timestamp,
  });

  factory TypingIndicatorModel.fromJson(Map<String, dynamic> json) =>
      _$TypingIndicatorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TypingIndicatorModelToJson(this);

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

  TypingIndicatorModel copyWith({
    String? chatId,
    String? userId,
    String? userName,
    bool? isTyping,
    DateTime? timestamp,
  }) {
    return TypingIndicatorModel(
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isTyping: isTyping ?? this.isTyping,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TypingIndicatorModel &&
              runtimeType == other.runtimeType &&
              chatId == other.chatId &&
              userId == other.userId;

  @override
  int get hashCode => chatId.hashCode ^ userId.hashCode;
}