import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/models/auth_models.dart';
import 'package:flux/core/repo/auth_repository.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<VerifyEmailRequested>(_onVerifyEmailRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<ResendVerificationRequested>(_onResendVerificationRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    log('SignUp requested for email: ${event.email}, username: ${event.username}');

    // Validate username isn't empty (for profile creation later)
    if (event.username.isEmpty) {
      log('SignUp failed: Username cannot be empty');
      emit(AuthState.error('Username cannot be empty'));
      return;
    }

    try {
      // Backend only expects email and password
      final response = await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );

      log('SignUp response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        log('SignUp successful, verification required for email: ${event.email}');
        // Store the username to be used after verification
        emit(AuthState.verificationRequired(event.email, event.username));
      } else {
        final errorMsg = response.error ?? 'Sign up failed';
        log('SignUp failed: $errorMsg');
        emit(AuthState.error(errorMsg));
      }
    } catch (e) {
      log('SignUp exception: $e');
      emit(AuthState.error('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    log('Login requested for email: ${event.email}');

    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      log('Login response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null && response.data!.token != null) {
        // Assuming the API response includes user details upon login success
        // Let's simulate getting username from the token or a separate user object if available
        // For now, derive from email if not provided.
        final username = response.data!.message?.split(' ').last ?? event.email.split('@').first;
        final user = User(
          email: event.email,
          displayName: username,
        );
        log('Login successful for user: ${user.email}');
        emit(AuthState.authenticated(user, response.data!.token!));
      } else {
        final errorMsg = response.error ?? 'Login failed';
        log('Login failed: $errorMsg');
        emit(AuthState.unauthenticated(errorMsg));
      }
    } catch (e) {
      log('Login exception: $e');
      emit(AuthState.unauthenticated('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onVerifyEmailRequested(
    VerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    log('Email verification requested for email: ${event.email}, OTP: ${event.otp}');

    try {
      final response = await _authRepository.verifyEmail(
        email: event.email,
        otp: event.otp,
      );

      log('Verification response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        if (response.data!.token != null) {
          // If token is provided after verification, auto-login the user
          // Use username from state if available, otherwise derive from email or response
          final username = state.username ?? 
                          response.data!.message?.split(' ').last ?? 
                          event.email.split('@').first;
          
          final user = User(
            email: event.email,
            displayName: username,
          );
          log('Email verification successful with token, user authenticated: ${user.email}');
          emit(AuthState.authenticated(user, response.data!.token!));
        } else {
          // If no token, then just consider verification successful
          log('Email verification successful, no token provided');
          // Keep the email and username for the profile creation step
          emit(AuthState.unauthenticated().copyWith(
            email: event.email, 
            username: state.username,
            status: AuthStatus.verificationRequired
          ));
        }
      } else {
        final errorMsg = response.error ?? 'Email verification failed';
        log('Email verification failed: $errorMsg');
        emit(AuthState.error(errorMsg));
      }
    } catch (e) {
      log('Email verification exception: $e');
      emit(AuthState.error('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    log('Forgot password requested for email: ${event.email}');

    try {
      final response = await _authRepository.forgotPassword(
        email: event.email,
      );

      log('Forgot password response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        log('Forgot password request successful for email: ${event.email}');
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          email: event.email,
        ));
      } else {
        final errorMsg = response.error ?? 'Forgot password request failed';
        log('Forgot password request failed: $errorMsg');
        emit(AuthState.error(errorMsg));
      }
    } catch (e) {
      log('Forgot password exception: $e');
      emit(AuthState.error('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    log('Reset password requested for email: ${event.email}');

    try {
      final response = await _authRepository.resetPassword(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
      );

      log('Reset password response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        log('Password reset successful for email: ${event.email}');
        emit(AuthState.unauthenticated());
      } else {
        final errorMsg = response.error ?? 'Password reset failed';
        log('Password reset failed: $errorMsg');
        emit(AuthState.error(errorMsg));
      }
    } catch (e) {
      log('Reset password exception: $e');
      emit(AuthState.error('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onResendVerificationRequested(
    ResendVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    log('Resend verification requested for email: ${event.email}');

    try {
      final response = await _authRepository.resendVerification(
        email: event.email,
      );

      log('Resend verification response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        log('Verification code resent successfully for email: ${event.email}');
        // Preserve username from current state if available
        emit(AuthState.verificationRequired(event.email, state.username));
      } else {
        final errorMsg = response.error ?? 'Resend verification failed';
        log('Resend verification failed: $errorMsg');
        emit(AuthState.error(errorMsg));
      }
    } catch (e) {
      log('Resend verification exception: $e');
      emit(AuthState.error('An unexpected error occurred: $e'));
    }
  }
} 