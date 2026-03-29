part of 'announcements_bloc.dart';

sealed class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object?> get props => [];
}

final class AnnouncementsInitial extends AnnouncementsState {
  const AnnouncementsInitial();
}

final class AnnouncementsLoading extends AnnouncementsState {
  const AnnouncementsLoading();
}

final class AnnouncementsFailure extends AnnouncementsState {
  const AnnouncementsFailure();
}

base class AnnouncementsSuccess extends AnnouncementsState {
  const AnnouncementsSuccess({required this.announcements});

  final List<Announcement> announcements;

  @override
  List<Object?> get props => [announcements];
}

final class AnnouncementsSending extends AnnouncementsSuccess {
  const AnnouncementsSending({required super.announcements});
}

final class AnnouncementSendSuccess extends AnnouncementsSuccess {
  const AnnouncementSendSuccess({required super.announcements});
}

final class AnnouncementSendFailure extends AnnouncementsSuccess {
  const AnnouncementSendFailure({required super.announcements});
}
