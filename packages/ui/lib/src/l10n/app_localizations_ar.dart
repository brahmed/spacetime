// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سبيس تايم';

  @override
  String get appNameBackoffice => 'سبيس تايم — لوحة الإدارة';

  @override
  String get backOfficeLabel => 'لوحة الإدارة';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInToYourAccount => 'سجّل دخولك إلى حسابك';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get emailRequired => 'أدخل بريدك الإلكتروني';

  @override
  String get emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get passwordRequired => 'أدخل كلمة المرور';

  @override
  String get welcomeBack => 'مرحباً بعودتك،';

  @override
  String get yourSchedule => 'جدولك الدراسي';

  @override
  String get todaysSessions => 'حصص اليوم';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String welcomeBackNamed(String name) {
    return 'مرحباً بعودتك، $name';
  }

  @override
  String get students => 'الطلاب';

  @override
  String get teachers => 'الأساتذة';

  @override
  String get courses => 'الدورات';

  @override
  String get todaysSessionsCount => 'حصص اليوم';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مجدداً.';

  @override
  String get accessDenied => 'الوصول مرفوض. حسابات المشرفين فقط.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSchedule => 'الجدول';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get nextSession => 'الحصة القادمة';

  @override
  String get noUpcomingSessions => 'لا توجد حصص قادمة';

  @override
  String get announcements => 'الإعلانات';

  @override
  String get noAnnouncements => 'لا توجد إعلانات بعد';

  @override
  String get schedule => 'الجدول الدراسي';

  @override
  String get noSchedule => 'جدولك الدراسي فارغ';

  @override
  String get sessionDetail => 'تفاصيل الحصة';

  @override
  String get confirmAttendance => 'تأكيد الحضور';

  @override
  String get cancelAttendance => 'إلغاء الحضور';

  @override
  String get attendanceConfirmed => 'تم تأكيد الحضور';

  @override
  String get attendanceCancelled => 'تم إلغاء الحضور';

  @override
  String get sessionCancelled => 'تم إلغاء هذه الحصة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String weekOf(String date) {
    return 'أسبوع $date';
  }

  @override
  String sessionTime(String startTime, String endTime) {
    return '$startTime – $endTime';
  }

  @override
  String get rememberMe => 'تذكّرني';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get cancel => 'إلغاء';

  @override
  String get teacherSchedule => 'حصصي';

  @override
  String get noTeacherSessions => 'لا توجد حصص قادمة';

  @override
  String get attendanceList => 'الحضور';

  @override
  String attendees(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count طالب',
      many: '$count طالباً',
      few: '$count طلاب',
      two: 'طالبان',
      one: 'طالب واحد',
      zero: 'لا طلاب',
    );
    return '$_temp0';
  }

  @override
  String get cancelSession => 'إلغاء الحصة';

  @override
  String get cancelSessionConfirmTitle => 'إلغاء هذه الحصة؟';

  @override
  String get cancelSessionConfirmMessage =>
      'سيتم إشعار الطلاب. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancelSessionConfirmButton => 'نعم، إلغاء';

  @override
  String get sessionCancelledSuccess => 'تم إلغاء الحصة';

  @override
  String get editSession => 'تعديل الحصة';

  @override
  String get editRoom => 'القاعة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get sessionUpdated => 'تم تحديث الحصة';
}
