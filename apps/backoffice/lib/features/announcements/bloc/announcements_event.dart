part of 'announcements_bloc.dart';

sealed class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object?> get props => [];
}

final class AnnouncementsLoaded extends AnnouncementsEvent {
  const AnnouncementsLoaded();
}

final class AnnouncementSent extends AnnouncementsEvent {
  const AnnouncementSent({
    required this.title,
    required this.body,
    required this.targetRole,
    required this.sentBy,
  });

  final String title;
  final String body;
  final TargetRole targetRole;
  final String sentBy;

  @override
  List<Object?> get props => [title, body, targetRole, sentBy];
}
