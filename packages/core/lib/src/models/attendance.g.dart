// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  studentId: json['student_id'] as String,
  status: AttendanceStatus.fromString(json['status'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'student_id': instance.studentId,
      'status': Attendance._statusToJson(instance.status),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
