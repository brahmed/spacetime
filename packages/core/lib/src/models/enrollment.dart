import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enrollment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Enrollment extends Equatable {
  const Enrollment({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.createdAt,
  });

  final String id;
  final String courseId;
  final String studentId;
  final DateTime createdAt;

  factory Enrollment.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentToJson(this);

  @override
  List<Object?> get props => [id, courseId, studentId, createdAt];
}
