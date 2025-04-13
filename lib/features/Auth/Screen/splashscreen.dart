import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 5000));
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.onboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add app logo here
            Text(
              'Fluxx',
              style: GoogleFonts.manrope(
                color: AppConstants.primary,
                fontSize: 64.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'One account to rule them all',
              style: GoogleFonts.manrope(
                color: AppConstants.labelText,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
               const SizedBox(height: 90),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              ),
              )
          ],
        ),
      ),
    );
  }
}
