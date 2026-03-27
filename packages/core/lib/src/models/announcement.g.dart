// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  sentBy: json['sent_by'] as String?,
  targetRole: TargetRole.fromString(json['target_role'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'sent_by': instance.sentBy,
      'target_role': Announcement._targetToJson(instance.targetRole),
      'created_at': instance.createdAt.toIso8601String(),
    };
