// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SpaceTime';

  @override
  String get appNameBackoffice => 'SpaceTime — Back Office';

  @override
  String get backOfficeLabel => 'Back Office';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInToYourAccount => 'Sign in to your account';

  @override
  String get signOut => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get yourSchedule => 'Your schedule';

  @override
  String get todaysSessions => 'Today\'s sessions';

  @override
  String get dashboard => 'Dashboard';

  @override
  String welcomeBackNamed(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get students => 'Students';

  @override
  String get teachers => 'Teachers';

  @override
  String get courses => 'Courses';

  @override
  String get todaysSessionsCount => 'Today\'s Sessions';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get accessDenied => 'Access denied. Admin accounts only.';

  @override
  String get navHome => 'Home';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navProfile => 'Profile';

  @override
  String get nextSession => 'Next session';

  @override
  String get noUpcomingSessions => 'No upcoming sessions';

  @override
  String get announcements => 'Announcements';

  @override
  String get noAnnouncements => 'No announcements yet';

  @override
  String get schedule => 'Schedule';

  @override
  String get noSchedule => 'Your schedule is empty';

  @override
  String get sessionDetail => 'Session detail';

  @override
  String get confirmAttendance => 'Confirm attendance';

  @override
  String get cancelAttendance => 'Cancel attendance';

  @override
  String get attendanceConfirmed => 'Attendance confirmed';

  @override
  String get attendanceCancelled => 'Attendance cancelled';

  @override
  String get sessionCancelled => 'This session has been cancelled';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get profile => 'Profile';

  @override
  String get loading => 'Loading…';

  @override
  String get retry => 'Retry';

  @override
  String weekOf(String date) {
    return 'Week of $date';
  }

  @override
  String sessionTime(String startTime, String endTime) {
    return '$startTime – $endTime';
  }

  @override
  String get rememberMe => 'Remember me';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';

  @override
  String get languageArabic => 'Arabic';
}
