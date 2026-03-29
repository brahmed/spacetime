part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched on app start — subscribes to the Supabase auth stream.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Dispatched by the login screen.
final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Dispatched by any screen with a logout button.
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
