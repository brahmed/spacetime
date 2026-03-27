import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementRepository {
  AnnouncementRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final data = await _supabase
          .from('announcements')
          .select()
          .order('created_at', ascending: false);
      return data.map(Announcement.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch announcements',
        name: 'announcements',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Announcement> createAnnouncement({
    required String title,
    required String body,
    required String sentBy,
    required TargetRole targetRole,
  }) async {
    try {
      final data = await _supabase
          .from('announcements')
          .insert({
            'title': title,
            'body': body,
            'sent_by': sentBy,
            'target_role': targetRole.toJson(),
          })
          .select()
          .single();
      return Announcement.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to create announcement',
        name: 'announcements',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
