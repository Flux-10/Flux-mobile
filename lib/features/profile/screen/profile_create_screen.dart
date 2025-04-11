import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCreateScreen extends StatelessWidget {
  const ProfileCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        title: Text(
          'Create Profile',
           style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppConstants.bg,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Profile creation UI goes here!',
            style: GoogleFonts.manrope(
              color: AppConstants.primary,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}