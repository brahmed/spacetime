// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  role: UserRole.fromString(json['role'] as String),
  avatarUrl: json['avatar_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'role': Profile._roleToJson(instance.role),
  'avatar_url': instance.avatarUrl,
  'created_at': instance.createdAt.toIso8601String(),
};
