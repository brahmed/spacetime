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

  @override
  String get cancel => 'Annuler';

  @override
  String get teacherSchedule => 'Mes séances';

  @override
  String get noTeacherSessions => 'Aucune séance à venir';

  @override
  String get attendanceList => 'Présences';

  @override
  String attendees(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count élèves',
      one: '1 élève',
      zero: 'Aucun élève',
    );
    return '$_temp0';
  }

  @override
  String get cancelSession => 'Annuler la séance';

  @override
  String get cancelSessionConfirmTitle => 'Annuler cette séance ?';

  @override
  String get cancelSessionConfirmMessage =>
      'Les élèves seront notifiés. Cette action est irréversible.';

  @override
  String get cancelSessionConfirmButton => 'Oui, annuler';

  @override
  String get sessionCancelledSuccess => 'Séance annulée';

  @override
  String get editSession => 'Modifier la séance';

  @override
  String get editRoom => 'Salle';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get sessionUpdated => 'Séance mise à jour';

  @override
  String get navCourses => 'Cours';

  @override
  String get navStudents => 'Élèves';

  @override
  String get navTeachers => 'Professeurs';

  @override
  String get navAnnouncements => 'Annonces';

  @override
  String get navSessions => 'Séances';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get createCourse => 'Créer un cours';

  @override
  String get editCourse => 'Modifier le cours';

  @override
  String get courseName => 'Nom';

  @override
  String get discipline => 'Discipline';

  @override
  String get room => 'Salle';

  @override
  String get teacher => 'Professeur';

  @override
  String get recurrenceDays => 'Jours';

  @override
  String get recurrenceTime => 'Heure';

  @override
  String get recurrenceEndsAt => 'Se termine le';

  @override
  String get noCourses => 'Aucun cours pour le moment';

  @override
  String get generateSessions => 'Générer les 4 prochaines semaines';

  @override
  String get sessionsGenerated => 'Séances générées';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get courseSaved => 'Cours enregistré';

  @override
  String get noSessions => 'Aucune séance pour ce cours';

  @override
  String get cancelAllFuture => 'Annuler toutes les suivantes';

  @override
  String get cancelAllFutureConfirmTitle =>
      'Annuler toutes les séances futures ?';

  @override
  String get cancelAllFutureConfirmMessage =>
      'Toutes les séances à venir de ce cours seront annulées. Les élèves seront notifiés.';

  @override
  String get cancelAllFutureConfirmButton => 'Oui, tout annuler';

  @override
  String sessionsCancelledCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séances annulées',
      one: '1 séance annulée',
    );
    return '$_temp0';
  }

  @override
  String get createStudent => 'Créer un élève';

  @override
  String get createTeacher => 'Créer un professeur';

  @override
  String get createUser => 'Créer un compte';

  @override
  String get fullName => 'Nom complet';

  @override
  String get noStudents => 'Aucun élève pour le moment';

  @override
  String get noTeachers => 'Aucun professeur pour le moment';

  @override
  String get userCreated => 'Compte créé';

  @override
  String get enrollments => 'Inscriptions';

  @override
  String get enroll => 'Inscrire';

  @override
  String get unenroll => 'Désinscrire';

  @override
  String get unenrollConfirmTitle => 'Désinscrire cet élève ?';

  @override
  String get unenrollConfirmMessage =>
      'L\'élève n\'aura plus accès à ce cours.';

  @override
  String get unenrollConfirmButton => 'Oui, désinscrire';

  @override
  String get assignedCourses => 'Cours assignés';

  @override
  String get assignCourse => 'Assigner un cours';

  @override
  String get sendAnnouncement => 'Envoyer une annonce';

  @override
  String get announcementTitle => 'Titre';

  @override
  String get announcementBody => 'Message';

  @override
  String get targetAudience => 'Audience';

  @override
  String get targetAll => 'Tout le monde';

  @override
  String get targetStudents => 'Élèves uniquement';

  @override
  String get targetTeachers => 'Professeurs uniquement';

  @override
  String get announcementSent => 'Annonce envoyée';

  @override
  String get history => 'Historique';

  @override
  String get noAnnouncementsHistory => 'Aucune annonce envoyée pour le moment';

  @override
  String get settings => 'Paramètres';

  @override
  String get adminProfile => 'Profil administrateur';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Jeu';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sam';

  @override
  String get sunday => 'Dim';

  @override
  String get noneSelected => 'Aucun';
}
