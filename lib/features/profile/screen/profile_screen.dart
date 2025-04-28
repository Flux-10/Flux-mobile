import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Profile picture and info
            if (authState.status == AuthStatus.authenticated && authState.user != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
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
                        _buildStatColumn('Tasks', '0'),
                        _buildStatColumn('Rants', '0'),
                        _buildStatColumn('Followers', '0'),
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
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: AppConstants.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppConstants.outlinebg,
                tabs: const [
                  Tab(text: 'Posted Tasks'),
                  Tab(text: 'Posted Rants'),
                  Tab(text: 'Applied Tasks'),
                ],
              ),
              
              // Tab Bar View - Using a fixed height container
              Container(
                height: 400, // Fixed height for the tab content
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPostedTasks(),
                    _buildPostedRants(),
                    _buildAppliedTasks(),
                  ],
                ),
              ),
              
              // Add bottom padding to prevent content being hidden by navbar
              const SizedBox(height: 80),
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
              
              // Add bottom padding to prevent content being hidden by navbar
              const SizedBox(height: 100),
            ],
          ],
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
  
  Widget _buildPostedTasks() {
    // Placeholder for posted tasks
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks posted yet',
            style: GoogleFonts.manrope(
              color: Colors.black87,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your posted tasks will appear here',
            style: GoogleFonts.manrope(
              color: Colors.black54,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, Routes.postTask);
            },
            icon: Icon(Icons.add, size: 18),
            label: Text('Post a Task'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.outlinebg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostedRants() {
    // Placeholder for posted rants
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No rants posted yet',
            style: GoogleFonts.manrope(
              color: Colors.black87,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your posted rants will appear here',
            style: GoogleFonts.manrope(
              color: Colors.black54,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, Routes.postRant);
            },
            icon: Icon(Icons.add, size: 18),
            label: Text('Post a Rant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.outlinebg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppliedTasks() {
    // Placeholder for applied tasks
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No applied tasks yet',
            style: GoogleFonts.manrope(
              color: Colors.black87,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tasks you apply for will appear here',
            style: GoogleFonts.manrope(
              color: Colors.black54,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home,
                (route) => false,
              );
            },
            icon: Icon(Icons.search, size: 18),
            label: Text('Browse Tasks'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.outlinebg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}