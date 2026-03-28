import 'dart:async';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    // Rehydrate session if one already exists (app relaunch)
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      try {
        final profile = await _authRepository.fetchCurrentProfile();
        emit(AuthAuthenticated(profile));
      } catch (e) {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }

    // Listen for future sign-in / sign-out events
    await emit.forEach<AuthState>(
      _authRepository.authStateChanges.asyncMap((authState) async {
        if (authState.event == AuthChangeEvent.signedIn ||
            authState.event == AuthChangeEvent.tokenRefreshed) {
          try {
            final profile = await _authRepository.fetchCurrentProfile();
            return AuthAuthenticated(profile);
          } catch (e, st) {
            log('Failed to fetch profile on auth change', error: e, stackTrace: st);
            return const AuthUnauthenticated();
          }
        }
        return const AuthUnauthenticated();
      }),
      onData: (state) => state,
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final profile = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(profile));
    } on UnauthorisedException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(const AuthFailure('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(const AuthUnauthenticated());
  }

}
