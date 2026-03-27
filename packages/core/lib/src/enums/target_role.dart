/// The audience target for an announcement.
enum TargetRole {
  all,
  student,
  teacher;

  static TargetRole fromString(String value) => switch (value) {
        'all' => all,
        'student' => student,
        'teacher' => teacher,
        _ => throw ArgumentError('Unknown TargetRole: $value'),
      };

  String toJson() => name;
}
