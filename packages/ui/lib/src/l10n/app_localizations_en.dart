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

  @override
  String get cancel => 'Cancel';

  @override
  String get teacherSchedule => 'My sessions';

  @override
  String get noTeacherSessions => 'No upcoming sessions';

  @override
  String get attendanceList => 'Attendance';

  @override
  String attendees(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      one: '1 student',
      zero: 'No students',
    );
    return '$_temp0';
  }

  @override
  String get cancelSession => 'Cancel session';

  @override
  String get cancelSessionConfirmTitle => 'Cancel this session?';

  @override
  String get cancelSessionConfirmMessage =>
      'Students will be notified. This cannot be undone.';

  @override
  String get cancelSessionConfirmButton => 'Yes, cancel';

  @override
  String get sessionCancelledSuccess => 'Session cancelled';

  @override
  String get editSession => 'Edit session';

  @override
  String get editRoom => 'Room';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get sessionUpdated => 'Session updated';

  @override
  String get navCourses => 'Courses';

  @override
  String get navStudents => 'Students';

  @override
  String get navTeachers => 'Teachers';

  @override
  String get navAnnouncements => 'Announcements';

  @override
  String get navSessions => 'Sessions';

  @override
  String get navSettings => 'Settings';

  @override
  String get createCourse => 'Create course';

  @override
  String get editCourse => 'Edit course';

  @override
  String get courseName => 'Name';

  @override
  String get discipline => 'Discipline';

  @override
  String get room => 'Room';

  @override
  String get teacher => 'Teacher';

  @override
  String get recurrenceDays => 'Days';

  @override
  String get recurrenceTime => 'Time';

  @override
  String get recurrenceEndsAt => 'Ends on';

  @override
  String get noCourses => 'No courses yet';

  @override
  String get generateSessions => 'Generate next 4 weeks';

  @override
  String get sessionsGenerated => 'Sessions generated';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get courseSaved => 'Course saved';

  @override
  String get noSessions => 'No sessions for this course';

  @override
  String get cancelAllFuture => 'Cancel all future';

  @override
  String get cancelAllFutureConfirmTitle => 'Cancel all future sessions?';

  @override
  String get cancelAllFutureConfirmMessage =>
      'All upcoming sessions for this course will be cancelled. Students will be notified.';

  @override
  String get cancelAllFutureConfirmButton => 'Yes, cancel all';

  @override
  String sessionsCancelledCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions cancelled',
      one: '1 session cancelled',
    );
    return '$_temp0';
  }

  @override
  String get createStudent => 'Create student';

  @override
  String get createTeacher => 'Create teacher';

  @override
  String get createUser => 'Create account';

  @override
  String get fullName => 'Full name';

  @override
  String get noStudents => 'No students yet';

  @override
  String get noTeachers => 'No teachers yet';

  @override
  String get userCreated => 'Account created';

  @override
  String get enrollments => 'Enrollments';

  @override
  String get enroll => 'Enroll';

  @override
  String get unenroll => 'Unenroll';

  @override
  String get unenrollConfirmTitle => 'Unenroll student?';

  @override
  String get unenrollConfirmMessage =>
      'The student will lose access to this course.';

  @override
  String get unenrollConfirmButton => 'Yes, unenroll';

  @override
  String get assignedCourses => 'Assigned courses';

  @override
  String get assignCourse => 'Assign course';

  @override
  String get sendAnnouncement => 'Send announcement';

  @override
  String get announcementTitle => 'Title';

  @override
  String get announcementBody => 'Message';

  @override
  String get targetAudience => 'Audience';

  @override
  String get targetAll => 'Everyone';

  @override
  String get targetStudents => 'Students only';

  @override
  String get targetTeachers => 'Teachers only';

  @override
  String get announcementSent => 'Announcement sent';

  @override
  String get history => 'History';

  @override
  String get noAnnouncementsHistory => 'No announcements sent yet';

  @override
  String get settings => 'Settings';

  @override
  String get adminProfile => 'Admin profile';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get noneSelected => 'None';
}
