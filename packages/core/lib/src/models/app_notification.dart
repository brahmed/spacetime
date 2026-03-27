import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/notification_type.dart';

part 'app_notification.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.userId,
    this.title,
    this.body,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String? title;
  final String? body;
  @JsonKey(fromJson: NotificationType.fromString, toJson: _typeToJson)
  final NotificationType type;
  final bool read;
  final DateTime createdAt;

  static String _typeToJson(NotificationType t) => t.toJson();

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  @override
  List<Object?> get props =>
      [id, userId, title, body, type, read, createdAt];
}
