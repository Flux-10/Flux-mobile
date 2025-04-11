import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String username;
  final String password;

  const SignUpRequested({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String otp;

  const VerifyEmailRequested({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

class ResendVerificationRequested extends AuthEvent {
  final String email;

  const ResendVerificationRequested({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
} 