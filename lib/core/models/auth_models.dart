import 'package:equatable/equatable.dart';

// Simplified model classes that don't rely on code generation for testing
class SignUpRequest {
  final String email;
  final String displayName;
  final String password;

  SignUpRequest({
    required this.email,
    required this.displayName,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'displayName': displayName,
    'password': password,
  };
  
  factory SignUpRequest.fromJson(Map<String, dynamic> json) => SignUpRequest(
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    password: json['password'] as String,
  );
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

class VerifyEmailRequest {
  final String email;
  final String otp;

  VerifyEmailRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
  };
  
  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) => VerifyEmailRequest(
    email: json['email'] as String,
    otp: json['otp'] as String,
  );
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
  };
  
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => ForgotPasswordRequest(
    email: json['email'] as String,
  );
}

class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
    'newPassword': newPassword,
  };
  
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
    email: json['email'] as String,
    otp: json['otp'] as String,
    newPassword: json['newPassword'] as String,
  );
}

class ResendVerificationRequest {
  final String email;

  ResendVerificationRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
  };
  
  factory ResendVerificationRequest.fromJson(Map<String, dynamic> json) => ResendVerificationRequest(
    email: json['email'] as String,
  );
}

class AuthResponse {
  final String? token;
  final String? message;
  final bool success;

  AuthResponse({
    this.token,
    this.message,
    required this.success,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['token'] as String?,
    message: json['message'] as String?,
    success: json['success'] as bool? ?? false,
  );
  
  Map<String, dynamic> toJson() => {
    'token': token,
    'message': message,
    'success': success,
  };
}

class User extends Equatable {
  final String email;
  final String displayName;
  final String? id;

  const User({
    required this.email,
    required this.displayName,
    this.id,
  });

  @override
  List<Object?> get props => [id, email, displayName];
} 