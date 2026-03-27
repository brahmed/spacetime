// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      body: json['body'] as String?,
      type: NotificationType.fromString(json['type'] as String),
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'type': AppNotification._typeToJson(instance.type),
      'read': instance.read,
      'created_at': instance.createdAt.toIso8601String(),
    };
