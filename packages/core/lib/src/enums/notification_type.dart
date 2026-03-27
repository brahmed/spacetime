/// The type of a push notification.
enum NotificationType {
  reminder,
  cancellation,
  announcement;

  static NotificationType fromString(String value) => switch (value) {
        'reminder' => reminder,
        'cancellation' => cancellation,
        'announcement' => announcement,
        _ => throw ArgumentError('Unknown NotificationType: $value'),
      };

  String toJson() => name;
}
