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
}
