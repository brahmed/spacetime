/// The role of a user in the SpaceTime platform.
enum UserRole {
  student,
  teacher,
  admin;

  static UserRole fromString(String value) => switch (value) {
        'student' => student,
        'teacher' => teacher,
        'admin' => admin,
        _ => throw ArgumentError('Unknown UserRole: $value'),
      };

  String toJson() => name;
}
