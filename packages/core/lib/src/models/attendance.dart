import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/attendance_status.dart';

part 'attendance.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Attendance extends Equatable {
  const Attendance({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.status,
    required this.updatedAt,
  });

  final String id;
  final String sessionId;
  final String studentId;
  @JsonKey(fromJson: AttendanceStatus.fromString, toJson: _statusToJson)
  final AttendanceStatus status;
  final DateTime updatedAt;

  static String _statusToJson(AttendanceStatus s) => s.toJson();

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  @override
  List<Object?> get props => [id, sessionId, studentId, status, updatedAt];
}
