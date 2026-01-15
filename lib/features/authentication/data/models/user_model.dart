import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isOnline;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime lastSeen;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  final List<String> blockedUsers;
  final String? fcmToken;  // NEW: FCM token

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
    this.blockedUsers = const [],
    this.fcmToken,  // NEW
  });

  // JSON Serialization
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Convert to Entity
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    name: name,
    avatarUrl: avatarUrl,
    phoneNumber: phoneNumber,
    isOnline: isOnline,
    lastSeen: lastSeen,
    createdAt: createdAt,
    blockedUsers: blockedUsers,
    fcmToken:fcmToken,
  );

  // Create from Entity
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    avatarUrl: entity.avatarUrl,
    phoneNumber: entity.phoneNumber,
    isOnline: entity.isOnline,
    lastSeen: entity.lastSeen,
    createdAt: entity.createdAt,
    blockedUsers: entity.blockedUsers,
    fcmToken: entity.fcmToken,
  );

  // Helper methods for Firestore timestamp conversion
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

  // CopyWith for immutability
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phoneNumber,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    List<String>? blockedUsers,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}