import 'package:equatable/equatable.dart';
import 'package:flux/core/models/auth_models.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  verificationRequired,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? token;
  final String? error;
  final String? email;
  final String? username;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.error,
    this.email,
    this.username,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? token,
    String? error,
    String? email,
    String? username,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [status, user, token, error, email, username];

  // Factory methods for common states
  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(User user, String token) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );

  factory AuthState.unauthenticated([String? error]) => AuthState(
        status: AuthStatus.unauthenticated,
        error: error,
      );

  factory AuthState.verificationRequired(String email) => AuthState(
        status: AuthStatus.verificationRequired,
        email: email,
      );

  factory AuthState.error(String error) => AuthState(
        status: AuthStatus.error,
        error: error,
      );
} 