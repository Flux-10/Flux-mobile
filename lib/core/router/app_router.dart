import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/features/Auth/Screen/SignIn.dart';
import 'package:flux/features/Auth/Screen/SignUp.dart';
import 'package:flux/features/Auth/Screen/forgotpassword.dart';
import 'package:flux/features/Auth/Screen/onboard.dart';
import 'package:flux/features/Auth/Screen/otp_verification.dart';
import 'package:flux/features/Auth/Screen/reset_password.dart';
import 'package:flux/features/Auth/Screen/splashscreen.dart';
import 'package:flux/features/home/screens/home.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log('Navigating to route: ${settings.name} with arguments: ${settings.arguments}');
    
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case Routes.onboard:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      
      case Routes.otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        log('OTP Verification route with email: $email');
        return MaterialPageRoute(
          builder: (_) => OTPVerificationPage(email: email),
        );
      
      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        final otp = args?['otp'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: email, otp: otp),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

