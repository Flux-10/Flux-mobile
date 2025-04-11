 

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
    switch (settings.name) {

      //!AUTHENTICATION ROUTES
      //Splash Screen
      case Routes.splash:
      return  MaterialPageRoute(builder: (_) => const SplashScreen());
      //onboard Screen
      case Routes.onboard:
      return  MaterialPageRoute(builder: (_) => const OnboardingScreen());

      //SignUpPage
      case Routes.signup:
      return MaterialPageRoute(builder: (_) => const SignUpPage());

      //sign in
      case Routes.login:
      return MaterialPageRoute(builder: (_) => const SignInPage());

      //Forgot Password
      case Routes.forgotPassword:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case Routes.otpVerification:
        return MaterialPageRoute(builder: (_) => const OTPVerificationPage());
      
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());

        //! AUTHERNTICATION ROUTES END

        //!Home route
        case Routes.home:
          return MaterialPageRoute(builder: (_) => const HomeScreen());

    //Home Screen
    
      default:
      return MaterialPageRoute(builder: (_) => Scaffold(
        body: Center(
          child: Text('Unknown route: ${settings.name}'),
        ),

      ));
    }

  }
}

