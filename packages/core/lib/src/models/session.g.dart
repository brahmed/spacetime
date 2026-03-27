// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  id: json['id'] as String,
  courseId: json['course_id'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
  status: SessionStatus.fromString(json['status'] as String),
  reminderSent: json['reminder_sent'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'course_id': instance.courseId,
  'starts_at': instance.startsAt.toIso8601String(),
  'ends_at': instance.endsAt.toIso8601String(),
  'status': Session._statusToJson(instance.status),
  'reminder_sent': instance.reminderSent,
  'created_at': instance.createdAt.toIso8601String(),
};
