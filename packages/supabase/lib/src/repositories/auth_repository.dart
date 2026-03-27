import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository(this._supabase);

  final SupabaseClient _supabase;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<Profile> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = response.user?.id;
      if (userId == null) throw const UnauthorisedException('Sign in failed');
      return _fetchProfile(userId);
    } on AuthException catch (e, st) {
      log('Sign in failed', name: 'auth', error: e, stackTrace: st);
      throw UnauthorisedException(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e, st) {
      log('Sign out failed', name: 'auth', error: e, stackTrace: st);
      throw NetworkException(e.message);
    }
  }

  Future<Profile> fetchCurrentProfile() async {
    final userId = currentUser?.id;
    if (userId == null) throw const UnauthorisedException('No authenticated user');
    return _fetchProfile(userId);
  }

  Future<Profile> _fetchProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return Profile.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch profile for $userId',
        name: 'auth',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
