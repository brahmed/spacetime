/// The status of a class session.
enum SessionStatus {
  scheduled,
  cancelled;

  static SessionStatus fromString(String value) => switch (value) {
        'scheduled' => scheduled,
        'cancelled' => cancelled,
        _ => throw ArgumentError('Unknown SessionStatus: $value'),
      };

  String toJson() => name;
}
