import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/theme/theme_provider.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:flux/features/settings/screens/theme_demo_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isAuthenticated = authState.status == AuthStatus.authenticated;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        backgroundColor: AppConstants.bg,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAuthenticated && authState.user != null) ...[
                _buildUserHeader(authState),
                const SizedBox(height: 24),
              ],
              
              _buildSectionHeader('Account'),
              _buildSettingItem(
                icon: Icons.person_outline,
                title: 'Profile Settings',
                onTap: () {
                  Navigator.pushNamed(context, Routes.profile);
                },
              ),
              
              if (isAuthenticated) ...[
                _buildSettingItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy settings coming soon')),
                    );
                  },
                ),
                _buildSettingItem(
                  icon: Icons.security_outlined,
                  title: 'Security',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Security settings coming soon')),
                    );
                  },
                ),
              ],
              
              _buildSectionHeader('Preferences'),
              _buildSettingItemWithSwitch(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                value: true,
                onChanged: (value) {
                  // Implement notification settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification settings coming soon')),
                  );
                },
              ),
              _buildSettingItemWithSwitch(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  // Toggle theme using the provider
                  themeProvider.toggleTheme();
                },
              ),
              _buildSettingItem(
                icon: Icons.palette_outlined,
                title: 'Theme Preview',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeDemoScreen(),
                    ),
                  );
                },
              ),
              
              _buildSectionHeader('Support'),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help center coming soon')),
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              
              const SizedBox(height: 24),
              
              if (isAuthenticated) ...[
                _buildLogoutButton(context),
              ] else ...[
                _buildLoginButton(context),
              ],
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
  
  Widget _buildUserHeader(AuthState state) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppConstants.outlinebg.withOpacity(0.2),
          child: Text(
            state.user!.displayName.isNotEmpty 
              ? state.user!.displayName[0].toUpperCase()
              : '?',
            style: GoogleFonts.manrope(
              color: AppConstants.outlinebg,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.user!.displayName,
                style: GoogleFonts.manrope(
                  color: AppConstants.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                state.user!.email,
                style: GoogleFonts.manrope(
                  color: AppConstants.labelText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          color: AppConstants.primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.outlinebg),
      title: Text(
        title,
        style: GoogleFonts.manrope(
          color: AppConstants.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppConstants.labelText),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildSettingItemWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.outlinebg),
      title: Text(
        title,
        style: GoogleFonts.manrope(
          color: AppConstants.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppConstants.outlinebg,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implement logout
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Log Out',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.outlinebg,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Log In',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.bg,
        title: Text(
          'About Fluxx',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppConstants.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: GoogleFonts.manrope(
                color: AppConstants.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fluxx is a social media platform for sharing moments and connecting with friends.',
              style: GoogleFonts.manrope(
                color: AppConstants.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2023 Fluxx Team',
              style: GoogleFonts.manrope(
                color: AppConstants.labelText,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.manrope(
                color: AppConstants.outlinebg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
