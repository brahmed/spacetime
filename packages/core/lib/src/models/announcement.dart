import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/target_role.dart';

part 'announcement.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.sentBy,
    required this.targetRole,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String? sentBy;
  @JsonKey(fromJson: TargetRole.fromString, toJson: _targetToJson)
  final TargetRole targetRole;
  final DateTime createdAt;

  static String _targetToJson(TargetRole t) => t.toJson();

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  @override
  List<Object?> get props => [id, title, body, sentBy, targetRole, createdAt];
}
