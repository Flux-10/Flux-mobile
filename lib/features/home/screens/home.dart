import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:flux/features/Tweetpost/screens/post_detail_screen.dart';
import 'package:flux/features/home/screens/tasks_feed.dart';
import 'package:flux/features/home/screens/rants_feed.dart';
import 'package:flux/features/home/screens/post_task_screen.dart';
import 'package:flux/features/home/screens/post_rant_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flux/core/theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get current auth state
    final authState = context.watch<AuthBloc>().state;
    
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        backgroundColor: AppConstants.bg,
        elevation: 0,
        title: Text(
          'Flux',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_outline, color: AppConstants.primary),
            onPressed: () {
              Navigator.pushNamed(context, Routes.messages);
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppConstants.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppConstants.primary,
          unselectedLabelColor: AppConstants.labelText,
          indicatorColor: AppConstants.outlinebg,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Rants'),
          ],
        ),
      ),
      body: authState.status == AuthStatus.authenticated
          ? TabBarView(
              controller: _tabController,
              children: const [
                TasksFeed(),
                RantsFeed(),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to view feeds',
                    style: GoogleFonts.manrope(
                      color: AppConstants.primary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        Routes.login, 
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.outlinebg,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32, 
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: authState.status == AuthStatus.authenticated
          ? FloatingActionButton(
              onPressed: () {
                // Show different creation screen based on current tab
                if (_tabController.index == 0) {
                  // Tasks tab
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PostTaskScreen()),
                  );
                } else {
                  // Rants tab
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PostRantScreen()),
                  );
                }
              },
              backgroundColor: AppConstants.outlinebg,
              child: Icon(
                _tabController.index == 0 ? Icons.add_task : Icons.chat_bubble,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}