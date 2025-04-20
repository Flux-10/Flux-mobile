import 'dart:developer';
import 'dart:math' show min;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/models/auth_models.dart';
import 'package:flux/core/repo/auth_repository.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  // Demo user credentials
  static const String _demoEmail = 'demo@gmail.com';
  static const String _demoPassword = 'demo123';

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
    log('SignUp requested for email: ${event.email}');

    try {
      // Backend only expects email and password
      final response = await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );

      log('SignUp response: status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        // Always derive username from email to avoid null values
        final username = event.email.split('@').first;
        
        // Check if the signup response includes a token for auto-login
        if (response.data!.token != null) {
          // If token is provided, auto-login the user
          final user = User(
            email: event.email,
            displayName: username,
          );
          log('SignUp successful with token, user authenticated: ${user.email}');
          emit(AuthState.authenticated(user, response.data!.token!));
        } else {
          // If no token, verification is required
          log('SignUp successful, verification required for email: ${event.email}');
          final verificationState = AuthState.verificationRequired(event.email);
          log('Emitting verificationRequired state with email: ${verificationState.email}');
          emit(verificationState);
        }
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
    log('AuthBloc: Login started for email: ${event.email}');
    emit(AuthState.loading());
    log('AuthBloc: Emitted loading state');

    // Check for demo user credentials
    if (event.email == _demoEmail && event.password == _demoPassword) {
      log('AuthBloc: Demo user login detected');
      
      // Create a demo user with a fake token
      final user = User(
        email: _demoEmail,
        displayName: 'Demo User',
      );
      
      final demoToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
      log('AuthBloc: Created demo user with token: ${demoToken.substring(0, min(10, demoToken.length))}...');
      
      // Create the authentication state
      final authState = AuthState.authenticated(user, demoToken);
      log('AuthBloc: Created authenticated state for demo user');
      
      // Emit the authenticated state
      emit(authState);
      log('AuthBloc: Emitted authenticated state for demo user');
      
      return; // Skip API call for demo user
    }

    try {
      log('AuthBloc: Calling login API');
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      log('AuthBloc: Login response received - status=${response.statusCode}, error=${response.error}, success=${response.isSuccess}, has data=${response.data != null}, has token=${response.data?.token != null}');
      
      if (response.data != null) {
        log('AuthBloc: Response data details - token=${response.data!.token != null ? "present" : "missing"}, message=${response.data!.message}');
      }

      // Define condition for successful authentication
      bool isAuthSuccessful = response.isSuccess && 
                             response.data != null && 
                             response.data!.token != null &&
                             response.data!.token!.isNotEmpty;
      
      log('AuthBloc: Authentication successful? $isAuthSuccessful');

      if (isAuthSuccessful) {
        // Always derive username from email to avoid null values
        final username = event.email.split('@').first;
        
        final user = User(
          email: event.email,
          displayName: username,
        );
        log('AuthBloc: Login successful for user: ${user.email}, token: ${response.data!.token!.substring(0, min(10, response.data!.token!.length))}...');
        
        // Create the authentication state
        final authState = AuthState.authenticated(user, response.data!.token!);
        log('AuthBloc: Created authenticated state: ${authState.status}, has token: ${authState.token != null}');
        
        // Emit the authentication state
        emit(authState);
        log('AuthBloc: Emitted authenticated state');
        
        // For testing, manually emit the state again with a delay to ensure it's received
        Future.delayed(const Duration(milliseconds: 300), () {
          log('AuthBloc: Re-emitting authenticated state after delay');
          emit(authState.copyWith());
        });
      } else {
        final errorMsg = response.error ?? 'Login failed - no valid token received';
        log('AuthBloc: Login failed: $errorMsg');
        emit(AuthState.unauthenticated(errorMsg));
        log('AuthBloc: Emitted unauthenticated state with error: $errorMsg');
      }
    } catch (e) {
      log('AuthBloc: Login exception: $e');
      emit(AuthState.unauthenticated('An unexpected error occurred: $e'));
      log('AuthBloc: Emitted unauthenticated state with error from exception');
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
        // Always derive username from email to avoid null values
        final username = event.email.split('@').first;
        
        final user = User(
          email: event.email,
          displayName: username,
        );
        
        if (response.data!.token != null) {
          // If token is provided after verification, auto-login the user
          log('Email verification successful with token, user authenticated: ${user.email}');
          emit(AuthState.authenticated(user, response.data!.token!));
        } else {
          // Even if no token is provided, we'll consider user authenticated for a better UX
          // Generate a placeholder token as the server didn't provide one
          log('Email verification successful without token, treating as authenticated: ${event.email}');
          emit(AuthState.authenticated(user, 'temp_token_${DateTime.now().millisecondsSinceEpoch}'));
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
        emit(AuthState.verificationRequired(event.email));
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