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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Sample data for feed
  final List<Map<String, dynamic>> _feedItems = [
    {
      'username': 'user1',
      'caption': 'This is my first Fluxx post! #awesome #fluxx',
      'likes': 42,
      'comments': 7,
      'color': Colors.purple.shade300, // Placeholder for actual content
    },
    {
      'username': 'techguru',
      'caption': 'Check out this cool new feature in Flutter 3.0! #flutter #dev',
      'likes': 128,
      'comments': 24,
      'color': Colors.blue.shade300,
    },
    {
      'username': 'traveler',
      'caption': 'Beautiful sunset at the beach today! #travel #sunset',
      'likes': 256,
      'comments': 18,
      'color': Colors.orange.shade300,
    },
    {
      'username': 'foodie',
      'caption': 'Made this delicious pasta today! Recipe in comments. #food #homemade',
      'likes': 89,
      'comments': 15,
      'color': Colors.green.shade300,
    },
    {
      'username': 'artist',
      'caption': 'My latest artwork. What do you think? #art #digital',
      'likes': 310,
      'comments': 42,
      'color': Colors.red.shade300,
    },
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get current auth state
    final authState = context.watch<AuthBloc>().state;
    
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Fluxx',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: authState.status == AuthStatus.authenticated
          ? PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: 100, // Simulate "infinite" scroll with a large number
              itemBuilder: (context, index) {
                // Loop through our sample data
                final item = _feedItems[index % _feedItems.length];
                return _buildFeedItem(item);
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to view your feed',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
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
                      backgroundColor: AppConstants.primary,
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
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
  
  Widget _buildFeedItem(Map<String, dynamic> item) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Content placeholder (would be video in real app)
          Container(
            color: item['color'],
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          
          // Overlay gradient at bottom for better text visibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          
          // User info and caption
          Positioned(
            left: 16,
            right: 100,
            bottom: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade800,
                      child: Text(
                        item['username'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '@${item['username']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        minimumSize: const Size(40, 25),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['caption'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Action buttons
          Positioned(
            right: 16,
            bottom: 90,
            child: Column(
              children: [
                _buildActionButton(Icons.favorite, item['likes'].toString()),
                _buildActionButton(Icons.chat_bubble_outline, item['comments'].toString()),
                _buildActionButton(Icons.reply, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}