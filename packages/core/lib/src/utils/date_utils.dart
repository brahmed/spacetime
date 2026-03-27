/// Utilities for recurrence and date calculations.
abstract final class SpaceTimeDateUtils {
  /// Returns all dates within [from] and [from] + 28 days (4 weeks)
  /// that fall on one of the given ISO [weekdays] (1=Mon … 7=Sun).
  static List<DateTime> generateDatesForFourWeeks({
    required DateTime from,
    required List<int> weekdays,
  }) {
    final end = from.add(const Duration(days: 28));
    final dates = <DateTime>[];
    var current = from;

    while (!current.isAfter(end)) {
      if (weekdays.contains(current.weekday)) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Parses a time string in "HH:mm" format into hours and minutes.
  static ({int hours, int minutes}) parseTime(String time) {
    final parts = time.split(':');
    assert(parts.length == 2, 'Expected HH:mm format, got: $time');
    return (hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
  }

  /// Combines a [date] with a parsed time string to produce a [DateTime].
  static DateTime combineWithTime(DateTime date, String recurrenceTime) {
    final (:hours, :minutes) = parseTime(recurrenceTime);
    return DateTime(date.year, date.month, date.day, hours, minutes);
  }
}
