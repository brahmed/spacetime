import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  ProfileRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Profile>> fetchProfilesByRole(UserRole role) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('role', role.toJson())
          .order('full_name');
      return data.map(Profile.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch profiles by role ${role.name}',
        name: 'profiles',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Profile> fetchProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return Profile.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch profile $userId',
        name: 'profiles',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Profile> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final data = await _supabase
          .from('profiles')
          .update({
            if (fullName != null) 'full_name': fullName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          })
          .eq('id', userId)
          .select()
          .single();
      return Profile.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to update profile $userId',
        name: 'profiles',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
