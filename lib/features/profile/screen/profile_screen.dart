import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current auth state to display user data
    final authState = context.watch<AuthBloc>().state;
    
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.manrope(
            color: Colors.black87,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/settings.png',
              width: 24,
              height: 24,
              color: Colors.black87,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.settings, color: Colors.black87),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Profile picture
              if (authState.status == AuthStatus.authenticated && authState.user != null) ...[
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppConstants.primary.withOpacity(0.2),
                    child: Text(
                      authState.user!.displayName.isNotEmpty 
                        ? authState.user!.displayName[0].toUpperCase()
                        : '?',
                      style: GoogleFonts.manrope(
                        color: AppConstants.primary,
                        fontSize: 48.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Display name
                Text(
                  authState.user!.displayName,
                  style: GoogleFonts.manrope(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                // Email
                Text(
                  authState.user!.email,
                  style: GoogleFonts.manrope(
                    color: Colors.black54,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Stats section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('Posts', '0'),
                    _buildStatColumn('Followers', '0'),
                    _buildStatColumn('Following', '0'),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Edit profile button
                OutlinedButton(
                  onPressed: () {
                    // Navigate to edit profile screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile coming soon')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppConstants.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.manrope(
                      color: AppConstants.primary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Placeholder for posts
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 8),
                
                Text(
                  'Your Posts',
                  style: GoogleFonts.manrope(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Placeholder for no posts
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.post_add,
                        color: Colors.grey.shade500,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: GoogleFonts.manrope(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your posts will appear here',
                        style: GoogleFonts.manrope(
                          color: Colors.black54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Not authenticated
                const SizedBox(height: 100),
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 24),
                Text(
                  'Not Signed In',
                  style: GoogleFonts.manrope(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sign in to view your profile',
                  style: GoogleFonts.manrope(
                    color: Colors.black54,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      Routes.login, 
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              
              // Add bottom padding to prevent content being hidden by navbar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
  
  Widget _buildStatColumn(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.manrope(
            color: Colors.black87,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.manrope(
            color: Colors.black54,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}