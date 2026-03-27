// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
  id: json['id'] as String,
  name: json['name'] as String,
  discipline: json['discipline'] as String?,
  room: json['room'] as String?,
  teacherId: json['teacher_id'] as String?,
  recurrenceDays: (json['recurrence_days'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  recurrenceTime: json['recurrence_time'] as String,
  recurrenceEndsAt: json['recurrence_ends_at'] == null
      ? null
      : DateTime.parse(json['recurrence_ends_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'discipline': instance.discipline,
  'room': instance.room,
  'teacher_id': instance.teacherId,
  'recurrence_days': instance.recurrenceDays,
  'recurrence_time': instance.recurrenceTime,
  'recurrence_ends_at': instance.recurrenceEndsAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};
