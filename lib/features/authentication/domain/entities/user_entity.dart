import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final List<String> blockedUsers;
  final String? fcmToken;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
    this.blockedUsers = const [],
    this.fcmToken,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatarUrl,
    phoneNumber,
    isOnline,
    lastSeen,
    createdAt,
    blockedUsers,
    fcmToken,
  ];

  UserEntity copyWith({
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
    return UserEntity(
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
}