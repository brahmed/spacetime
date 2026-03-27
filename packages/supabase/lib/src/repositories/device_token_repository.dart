import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceTokenRepository {
  DeviceTokenRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<void> upsertToken({
    required String userId,
    required String token,
    required String platform,
  }) async {
    try {
      await _supabase.from('device_tokens').upsert(
        {
          'user_id': userId,
          'token': token,
          'platform': platform,
        },
        onConflict: 'user_id, token',
      );
    } on PostgrestException catch (e, st) {
      log(
        'Failed to upsert device token for user $userId',
        name: 'device_tokens',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<void> removeToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _supabase
          .from('device_tokens')
          .delete()
          .eq('user_id', userId)
          .eq('token', token);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to remove device token for user $userId',
        name: 'device_tokens',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
