import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String email;
  final String password;
  
  // Username is no longer part of the model as it's not expected by backend
  SignUpRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
  factory SignUpRequest.fromJson(Map<String, dynamic> json) => _$SignUpRequestFromJson(json);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

@JsonSerializable()
class VerifyEmailRequest {
  final String email;
  final String otp;

  VerifyEmailRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => _$VerifyEmailRequestToJson(this);
  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) => _$VerifyEmailRequestFromJson(json);
}

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestFromJson(json);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestFromJson(json);
}

@JsonSerializable()
class ResendVerificationRequest {
  final String email;

  ResendVerificationRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => _$ResendVerificationRequestToJson(this);
  factory ResendVerificationRequest.fromJson(Map<String, dynamic> json) => _$ResendVerificationRequestFromJson(json);
}

@JsonSerializable()
class AuthResponse {
  final String? token;
  final String? message;
  final bool? success;

  AuthResponse({
    this.token,
    this.message,
    this.success,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
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