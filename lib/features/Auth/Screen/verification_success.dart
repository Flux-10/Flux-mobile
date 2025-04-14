import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class VerificationSuccessScreen extends StatefulWidget {
  final String email;

  const VerificationSuccessScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerificationSuccessScreen> createState() => _VerificationSuccessScreenState();
}

class _VerificationSuccessScreenState extends State<VerificationSuccessScreen> {
  @override
  void initState() {
    super.initState();
    log('VerificationSuccessScreen initialized for email: ${widget.email}');
    // Auto-navigate to home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        navigateToHome();
      }
    });
  }

  void navigateToHome() {
    log('Navigating to home screen');
    Navigator.pushReplacementNamed(
      context, 
      Routes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success animation
                Lottie.asset(
                  'assets/animations/verification_success.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 120,
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Verification Successful!',
                  style: GoogleFonts.urbanist(
                    color: AppConstants.primary,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your email has been verified successfully. You will now be redirected to the home screen.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: AppConstants.labelText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                CustomElevatedButton(
                  text: 'Go to Home',
                  onPressed: navigateToHome,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 