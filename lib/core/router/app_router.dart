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
import 'package:flux/features/Auth/Screen/verification_success.dart';
import 'package:flux/features/Tweetpost/screens/post_detail_screen.dart';
import 'package:flux/features/home/screens/home.dart';
import 'package:flux/features/home/screens/post_task_screen.dart';
import 'package:flux/features/home/screens/post_rant_screen.dart';
import 'package:flux/features/home/screens/task_detail_screen/task_detail_screen.dart';
import 'package:flux/features/messages/screens/messages_screen.dart';
import 'package:flux/features/notifications/screens/notifications_screen.dart';
import 'package:flux/features/profile/screen/profile_create_screen.dart';
import 'package:flux/features/profile/screen/profile_screen.dart';
import 'package:flux/features/settings/screens/settings.dart';
import 'package:flux/features/settings/screens/theme_demo_screen.dart';

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
      
      case Routes.messages:
        return MaterialPageRoute(builder: (_) => const MessagesScreen());
      
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      
      case Routes.otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        log('OTP Verification route with email: $email');
        if (email.isEmpty) {
          log('WARNING: Empty email passed to OTP verification page');
        }
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
        
      case Routes.profileCreate:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String?;
        log('ProfileCreate route with email: $email');
        return MaterialPageRoute(
          builder: (_) => const ProfileCreateScreen(),
          settings: RouteSettings(
            arguments: {'email': email},
          ),
        );
        
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      case Routes.verificationSuccess:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        log('VerificationSuccess route with email: $email');
        return MaterialPageRoute(
          builder: (_) => VerificationSuccessScreen(
            email: email,
          ),
        );
      
      case Routes.postDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final post = args?['post'] as Map<String, dynamic>? ?? {};
        final focusBid = args?['focusBid'] as bool? ?? false;
        
        // Check if it's a task post or a rant post
        if (post.containsKey('category')) {
          // It's a task post, use TaskDetailScreen
          return MaterialPageRoute(
            builder: (_) => TaskDetailScreen(
              task: post,
              focusBid: focusBid,
            ),
          );
        } else {
          // It's a rant post, use PostDetailScreen
          return MaterialPageRoute(
            builder: (_) => PostDetailScreen(post: post),
          );
        }
      
      case Routes.themeDemo:
        return MaterialPageRoute(builder: (_) => const ThemeDemoScreen());
      
      case Routes.postTask:
        return MaterialPageRoute(builder: (_) => const PostTaskScreen());
      
      case Routes.postRant:
        return MaterialPageRoute(builder: (_) => const PostRantScreen());
      
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      case Routes.taskDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final task = args?['task'] as Map<String, dynamic>? ?? {};
        final focusBid = args?['focusBid'] as bool? ?? false;
        
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(
            task: task,
            focusBid: focusBid,
          ),
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

