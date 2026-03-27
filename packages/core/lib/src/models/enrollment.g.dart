// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enrollment _$EnrollmentFromJson(Map<String, dynamic> json) => Enrollment(
  id: json['id'] as String,
  courseId: json['course_id'] as String,
  studentId: json['student_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$EnrollmentToJson(Enrollment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'student_id': instance.studentId,
      'created_at': instance.createdAt.toIso8601String(),
    };
