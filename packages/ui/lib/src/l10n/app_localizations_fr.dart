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

  @override
  String get navHome => 'Accueil';

  @override
  String get navSchedule => 'Planning';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navProfile => 'Profil';

  @override
  String get nextSession => 'Prochaine séance';

  @override
  String get noUpcomingSessions => 'Aucune séance à venir';

  @override
  String get announcements => 'Annonces';

  @override
  String get noAnnouncements => 'Aucune annonce pour le moment';

  @override
  String get schedule => 'Planning';

  @override
  String get noSchedule => 'Votre planning est vide';

  @override
  String get sessionDetail => 'Détail de la séance';

  @override
  String get confirmAttendance => 'Confirmer ma présence';

  @override
  String get cancelAttendance => 'Annuler ma présence';

  @override
  String get attendanceConfirmed => 'Présence confirmée';

  @override
  String get attendanceCancelled => 'Présence annulée';

  @override
  String get sessionCancelled => 'Cette séance a été annulée';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get profile => 'Profil';

  @override
  String get loading => 'Chargement…';

  @override
  String get retry => 'Réessayer';

  @override
  String weekOf(String date) {
    return 'Semaine du $date';
  }

  @override
  String sessionTime(String startTime, String endTime) {
    return '$startTime – $endTime';
  }

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'Arabe';
}
