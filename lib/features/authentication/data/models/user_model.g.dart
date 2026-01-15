// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  isOnline: json['isOnline'] as bool,
  lastSeen: UserModel._dateTimeFromTimestamp(json['lastSeen']),
  createdAt: UserModel._dateTimeFromTimestamp(json['createdAt']),
  blockedUsers:
      (json['blockedUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  fcmToken: json['fcmToken'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'avatarUrl': instance.avatarUrl,
  'phoneNumber': instance.phoneNumber,
  'isOnline': instance.isOnline,
  'lastSeen': UserModel._dateTimeToTimestamp(instance.lastSeen),
  'createdAt': UserModel._dateTimeToTimestamp(instance.createdAt),
  'blockedUsers': instance.blockedUsers,
  'fcmToken': instance.fcmToken,
};
