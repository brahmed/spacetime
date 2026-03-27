import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/session_status.dart';

part 'session.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Session extends Equatable {
  const Session({
    required this.id,
    required this.courseId,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.reminderSent,
    required this.createdAt,
  });

  final String id;
  final String courseId;
  final DateTime startsAt;
  final DateTime endsAt;
  @JsonKey(fromJson: SessionStatus.fromString, toJson: _statusToJson)
  final SessionStatus status;
  final bool reminderSent;
  final DateTime createdAt;

  static String _statusToJson(SessionStatus s) => s.toJson();

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  List<Object?> get props =>
      [id, courseId, startsAt, endsAt, status, reminderSent, createdAt];
}
