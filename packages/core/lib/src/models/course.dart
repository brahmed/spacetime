import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Course extends Equatable {
  const Course({
    required this.id,
    required this.name,
    this.discipline,
    this.room,
    this.teacherId,
    required this.recurrenceDays,
    required this.recurrenceTime,
    this.recurrenceEndsAt,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? discipline;
  final String? room;
  final String? teacherId;

  /// Days of week using ISO weekday: 1=Monday … 7=Sunday.
  final List<int> recurrenceDays;

  /// Time of day stored as HH:mm string (e.g. "18:00").
  final String recurrenceTime;
  final DateTime? recurrenceEndsAt;
  final DateTime createdAt;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        discipline,
        room,
        teacherId,
        recurrenceDays,
        recurrenceTime,
        recurrenceEndsAt,
        createdAt,
      ];
}
