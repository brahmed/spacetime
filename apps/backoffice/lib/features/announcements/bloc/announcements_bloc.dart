import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  AnnouncementsBloc({
    required AnnouncementRepository announcementRepository,
  })  : _announcementRepository = announcementRepository,
        super(const AnnouncementsInitial()) {
    on<AnnouncementsLoaded>(_onLoaded);
    on<AnnouncementSent>(_onSent);
  }

  final AnnouncementRepository _announcementRepository;

  Future<void> _onLoaded(
    AnnouncementsLoaded event,
    Emitter<AnnouncementsState> emit,
  ) async {
    emit(const AnnouncementsLoading());
    try {
      final announcements = await _announcementRepository.fetchAnnouncements();
      emit(AnnouncementsSuccess(announcements: announcements));
    } catch (e, st) {
      log(
        'Failed to load announcements',
        name: 'announcements',
        error: e,
        stackTrace: st,
      );
      emit(const AnnouncementsFailure());
    }
  }

  Future<void> _onSent(
    AnnouncementSent event,
    Emitter<AnnouncementsState> emit,
  ) async {
    final current = state;
    if (current is! AnnouncementsSuccess) return;
    emit(AnnouncementsSending(announcements: current.announcements));
    try {
      final announcement = await _announcementRepository.createAnnouncement(
        title: event.title,
        body: event.body,
        sentBy: event.sentBy,
        targetRole: event.targetRole,
      );
      final updated = [announcement, ...current.announcements];
      emit(AnnouncementSendSuccess(announcements: updated));
    } catch (e, st) {
      log(
        'Failed to send announcement',
        name: 'announcements',
        error: e,
        stackTrace: st,
      );
      emit(AnnouncementSendFailure(announcements: current.announcements));
    }
  }
}
