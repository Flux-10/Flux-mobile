import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flux/core/models/auth_models.dart';
import 'package:flux/core/services/api_client.dart';
import 'package:flux/core/util/api_config.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ApiResponse<AuthResponse>> signUp({
    required String email,
    required String displayName,
    required String password,
  }) async {
    log('Repository: Sign up request for email: $email');
    final request = SignUpRequest(
      email: email,
      displayName: displayName,
      password: password,
    );

    final response = await _apiClient.post<AuthResponse>(
      endpoint: ApiConfig.signUp,
      body: request.toJson(),
      fromJson: (json) => AuthResponse.fromJson(json),
    );
    
    log('Repository: Sign up response - success: ${response.isSuccess}, statusCode: ${response.statusCode}');
    return response;
  }

  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    log('Repository: Login request for email: $email');
    final request = LoginRequest(
      email: email,
      password: password,
    );

    final response = await _apiClient.post<AuthResponse>(
      endpoint: ApiConfig.login,
      body: request.toJson(),
      fromJson: (json) => AuthResponse.fromJson(json),
    );
    
    log('Repository: Login response - success: ${response.isSuccess}, statusCode: ${response.statusCode}');
    return response;
  }

  Future<ApiResponse<AuthResponse>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    log('Repository: Verify email request for email: $email, OTP: $otp');
    final request = VerifyEmailRequest(
      email: email,
      otp: otp,
    );

    final response = await _apiClient.post<AuthResponse>(
      endpoint: ApiConfig.verifyEmail,
      body: request.toJson(),
      fromJson: (json) => AuthResponse.fromJson(json),
    );
    
    log('Repository: Verify email response - success: ${response.isSuccess}, statusCode: ${response.statusCode}');
    return response;
  }

  Future<ApiResponse<AuthResponse>> forgotPassword({
    required String email,
  }) async {
    log('Repository: Forgot password request for email: $email');
    final request = ForgotPasswordRequest(
      email: email,
    );

    final response = await _apiClient.post<AuthResponse>(
      endpoint: ApiConfig.forgotPassword,
      body: request.toJson(),
      fromJson: (json) => AuthResponse.fromJson(json),
    );
    
    log('Repository: Forgot password response - success: ${response.isSuccess}, statusCode: ${response.statusCode}');
    return response;
  }

  Future<ApiResponse<AuthResponse>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    log('Repository: Reset password request for email: $email');
    final request = ResetPasswordRequest(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    final response = await _apiClient.post<AuthResponse>(
      endpoint: ApiConfig.resetPassword,
      body: request.toJson(),
      fromJson: (json) => AuthResponse.fromJson(json),
    );
    
    log('Repository: Reset password response - success: ${response.isSuccess}, statusCode: ${response.statusCode}');
    return response;
  }

  Future<ApiResponse<AuthResponse>> resendVerification({
    required String email,
  }) async {
    log('Repository: Resend verification request for email: $email');
    final request = ResendVerificationRequest(
      email: email,
    );

    final response = await _apiClient.post<AuthResponse>(
      endpoint: ApiConfig.resendVerification,
      body: request.toJson(),
      fromJson: (json) => AuthResponse.fromJson(json),
    );
    
    log('Repository: Resend verification response - success: ${response.isSuccess}, statusCode: ${response.statusCode}');
    return response;
  }
} 