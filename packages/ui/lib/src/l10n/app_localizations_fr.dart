// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'SpaceTime';

  @override
  String get appNameBackoffice => 'SpaceTime — Back Office';

  @override
  String get backOfficeLabel => 'Back Office';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInToYourAccount => 'Connectez-vous à votre compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get emailRequired => 'Entrez votre e-mail';

  @override
  String get emailInvalid => 'Entrez un e-mail valide';

  @override
  String get passwordRequired => 'Entrez votre mot de passe';

  @override
  String get welcomeBack => 'Bienvenue,';

  @override
  String get yourSchedule => 'Votre planning';

  @override
  String get todaysSessions => 'Séances d\'aujourd\'hui';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String welcomeBackNamed(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get students => 'Élèves';

  @override
  String get teachers => 'Professeurs';

  @override
  String get courses => 'Cours';

  @override
  String get todaysSessionsCount => 'Séances du jour';

  @override
  String get somethingWentWrong =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get accessDenied =>
      'Accès refusé. Comptes administrateurs uniquement.';
}
