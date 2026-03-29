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
}
