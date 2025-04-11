import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current auth state
    final authState = context.watch<AuthBloc>().state;
    
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        backgroundColor: AppConstants.bg,
        title: Text(
          'Fluxx',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppConstants.primary),
            onPressed: () {
              // Add logout functionality here later
              Navigator.pushNamedAndRemoveUntil(
                context, 
                Routes.login, 
                (route) => false
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (authState.status == AuthStatus.authenticated && authState.user != null) ...[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppConstants.primary.withOpacity(0.2),
                  child: Text(
                    authState.user!.displayName.isNotEmpty 
                      ? authState.user!.displayName[0].toUpperCase()
                      : '?',
                    style: GoogleFonts.manrope(
                      color: AppConstants.primary,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome, ${authState.user!.displayName}!',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  authState.user!.email,
                  style: GoogleFonts.manrope(
                    color: AppConstants.labelText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                const Text('User not authenticated'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      Routes.login, 
                      (route) => false
                    );
                  },
                  child: const Text('Go to Login'),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}