/// The attendance status of a student for a session.
enum AttendanceStatus {
  confirmed('Confirmed', 0xFF39FF14, 0xFF1A3300),
  pending('Pending',     0xFFFF9500, 0xFF1A0A00),
  cancelled('Cancelled', 0xFFFF3131, 0xFF1A0000);

  const AttendanceStatus(this.label, this.borderArgb, this.bgArgb);

  final String label;

  /// Raw ARGB value for the border color.
  /// Use [AttendanceStatusColors] extension in the ui package
  /// to convert to a Flutter [Color].
  final int borderArgb;

  /// Raw ARGB value for the background fill color.
  final int bgArgb;

  static AttendanceStatus fromString(String value) => switch (value) {
        'confirmed' => confirmed,
        'pending' => pending,
        'cancelled' => cancelled,
        _ => throw ArgumentError('Unknown AttendanceStatus: $value'),
      };

  String toJson() => name;
}
