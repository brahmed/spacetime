import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'SpaceTime'**
  String get appName;

  /// Back office application name
  ///
  /// In en, this message translates to:
  /// **'SpaceTime — Back Office'**
  String get appNameBackoffice;

  /// Subtitle shown under logo on backoffice login
  ///
  /// In en, this message translates to:
  /// **'Back Office'**
  String get backOfficeLabel;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToYourAccount;

  /// Logout button tooltip and label
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Validation: email empty
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailRequired;

  /// Validation: email format invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// Validation: password empty
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordRequired;

  /// Greeting shown on home screens above the user name
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// Placeholder card label on student home screen
  ///
  /// In en, this message translates to:
  /// **'Your schedule'**
  String get yourSchedule;

  /// Placeholder card label on teacher home screen
  ///
  /// In en, this message translates to:
  /// **'Today\'s sessions'**
  String get todaysSessions;

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Dashboard greeting with user name
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackNamed(String name);

  /// Stats card label
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// Stats card label
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// Stats card label
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// Stats card label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sessions'**
  String get todaysSessionsCount;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// Error shown when non-admin tries to log into backoffice
  ///
  /// In en, this message translates to:
  /// **'Access denied. Admin accounts only.'**
  String get accessDenied;

  /// Bottom nav: home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav: schedule tab
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// Bottom nav: notifications tab
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// Bottom nav: profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Section header on home screen
  ///
  /// In en, this message translates to:
  /// **'Next session'**
  String get nextSession;

  /// Empty state when student has no scheduled sessions
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions'**
  String get noUpcomingSessions;

  /// Section header on home screen
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// Empty state for announcements
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get noAnnouncements;

  /// Schedule screen title
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Empty state for student schedule
  ///
  /// In en, this message translates to:
  /// **'Your schedule is empty'**
  String get noSchedule;

  /// Session detail screen title
  ///
  /// In en, this message translates to:
  /// **'Session detail'**
  String get sessionDetail;

  /// Button to confirm attendance
  ///
  /// In en, this message translates to:
  /// **'Confirm attendance'**
  String get confirmAttendance;

  /// Button to cancel attendance
  ///
  /// In en, this message translates to:
  /// **'Cancel attendance'**
  String get cancelAttendance;

  /// Success message after confirming
  ///
  /// In en, this message translates to:
  /// **'Attendance confirmed'**
  String get attendanceConfirmed;

  /// Success message after cancelling
  ///
  /// In en, this message translates to:
  /// **'Attendance cancelled'**
  String get attendanceCancelled;

  /// Banner shown when session status is cancelled
  ///
  /// In en, this message translates to:
  /// **'This session has been cancelled'**
  String get sessionCancelled;

  /// Notifications screen title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Empty state for notifications list
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// Button to mark all notifications as read
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Section header grouping sessions by week
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String weekOf(String date);

  /// Session time range display
  ///
  /// In en, this message translates to:
  /// **'{startTime} – {endTime}'**
  String sessionTime(String startTime, String endTime);

  /// Remember me checkbox label on login screen
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Language setting label on profile screen
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Teacher schedule screen title
  ///
  /// In en, this message translates to:
  /// **'My sessions'**
  String get teacherSchedule;

  /// Empty state on teacher schedule
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions'**
  String get noTeacherSessions;

  /// Section header for attendance list in teacher session detail
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceList;

  /// Number of students enrolled in a session
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No students} =1{1 student} other{{count} students}}'**
  String attendees(int count);

  /// Button to cancel a session
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get cancelSession;

  /// Dialog title when confirming session cancellation
  ///
  /// In en, this message translates to:
  /// **'Cancel this session?'**
  String get cancelSessionConfirmTitle;

  /// Dialog body when confirming session cancellation
  ///
  /// In en, this message translates to:
  /// **'Students will be notified. This cannot be undone.'**
  String get cancelSessionConfirmMessage;

  /// Confirm button in cancel session dialog
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get cancelSessionConfirmButton;

  /// Snackbar after teacher cancels a session
  ///
  /// In en, this message translates to:
  /// **'Session cancelled'**
  String get sessionCancelledSuccess;

  /// Button / bottom sheet title for editing a session
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get editSession;

  /// Field label for room in edit session sheet
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get editRoom;

  /// Save button in edit session sheet
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// Snackbar after teacher edits a session
  ///
  /// In en, this message translates to:
  /// **'Session updated'**
  String get sessionUpdated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
