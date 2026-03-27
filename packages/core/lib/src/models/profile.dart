import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/user_role.dart';

part 'profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  @JsonKey(fromJson: UserRole.fromString, toJson: _roleToJson)
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;

  static String _roleToJson(UserRole role) => role.toJson();

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  List<Object?> get props => [id, fullName, role, avatarUrl, createdAt];
}
