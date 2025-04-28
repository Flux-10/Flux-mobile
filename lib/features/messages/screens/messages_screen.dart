import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flux/core/theme/theme_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  // Add tab controller
  late TabController _tabController;
  
  // Sample data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      'username': 'user1',
      'fullName': 'User One',
      'lastMessage': 'Hey, how are you?',
      'timestamp': '2m',
      'unread': true,
    },
    {
      'username': 'techguru',
      'fullName': 'Tech Guru',
      'lastMessage': 'Check out this cool new feature!',
      'timestamp': '1h',
      'unread': false,
    },
    {
      'username': 'traveler',
      'fullName': 'Travel Enthusiast',
      'lastMessage': 'I\'m visiting your campus next week!',
      'timestamp': '3h',
      'unread': true,
    },
    {
      'username': 'foodie',
      'fullName': 'Food Lover',
      'lastMessage': 'Have you tried that new restaurant?',
      'timestamp': '1d',
      'unread': false,
    },
    {
      'username': 'artist',
      'fullName': 'Creative Artist',
      'lastMessage': 'Thanks for the feedback on my artwork!',
      'timestamp': '2d',
      'unread': false,
    },
  ];

  // Sample data for group conversations
  final List<Map<String, dynamic>> _groupConversations = [
    {
      'username': 'study_group',
      'fullName': 'Study Group',
      'lastMessage': 'Meeting at 4pm today in the library',
      'timestamp': '30m',
      'unread': true,
      'members': 12,
    },
    {
      'username': 'campus_events',
      'fullName': 'Campus Events',
      'lastMessage': 'New event posted: Spring Festival',
      'timestamp': '2h',
      'unread': false,
      'members': 45,
    },
    {
      'username': 'dorm_chat',
      'fullName': 'Dorm Chat',
      'lastMessage': 'Anyone want to order food?',
      'timestamp': '5h',
      'unread': true,
      'members': 28,
    },
    {
      'username': 'class_101',
      'fullName': 'Computer Science 101',
      'lastMessage': 'Assignment due tomorrow!',
      'timestamp': '1d',
      'unread': true,
      'members': 32,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          'Messages',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppConstants.primary),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
        bottom: authState.status == AuthStatus.authenticated
            ? TabBar(
                controller: _tabController,
                indicatorColor: AppConstants.outlinebg,
                labelColor: AppConstants.outlinebg,
                unselectedLabelColor: AppConstants.labelText,
                tabs: const [
                  Tab(text: 'Direct Messages'),
                  Tab(text: 'Groups'),
                ],
              )
            : null,
      ),
      body: authState.status == AuthStatus.authenticated
          ? Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for messages',
                      hintStyle: TextStyle(color: AppConstants.labelText),
                      prefixIcon: Icon(Icons.search, color: AppConstants.labelText),
                      filled: true,
                      fillColor: AppConstants.primarybg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: AppConstants.primary),
                  ),
                ),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Direct Messages Tab
                      ListView.builder(
                        itemCount: _conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _conversations[index];
                          return _buildConversationTile(conversation);
                        },
                      ),
                      
                      // Groups Tab
                      ListView.builder(
                        itemCount: _groupConversations.length,
                        itemBuilder: (context, index) {
                          final groupConversation = _groupConversations[index];
                          return _buildGroupConversationTile(groupConversation);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to view your messages',
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
                // Show new message dialog
                _showNewMessageDialog();
              },
              backgroundColor: AppConstants.outlinebg,
              child: Icon(Icons.edit, color: Colors.white),
            )
          : null,
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
  
  Widget _buildConversationTile(Map<String, dynamic> conversation) {
    return InkWell(
      onTap: () {
        // Navigate to chat detail
        _navigateToChatDetail(conversation);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppConstants.labelText.withOpacity(0.3), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Profile picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppConstants.labelText.withOpacity(0.2),
                  child: Text(
                    conversation['username'][0].toUpperCase(),
                    style: TextStyle(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (conversation['unread'])
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppConstants.outlinebg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppConstants.bg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation['fullName'],
                        style: TextStyle(
                          color: AppConstants.primary,
                          fontWeight: conversation['unread'] ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        conversation['timestamp'],
                        style: TextStyle(
                          color: conversation['unread'] ? AppConstants.outlinebg : AppConstants.labelText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      color: conversation['unread'] ? AppConstants.primary : AppConstants.labelText,
                      fontWeight: conversation['unread'] ? FontWeight.w500 : FontWeight.normal,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGroupConversationTile(Map<String, dynamic> conversation) {
    return InkWell(
      onTap: () {
        // Navigate to group chat detail
        _navigateToGroupChatDetail(conversation);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppConstants.labelText.withOpacity(0.3), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Group avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppConstants.labelText.withOpacity(0.2),
                  child: Icon(
                    Icons.group,
                    color: AppConstants.primary,
                    size: 26,
                  ),
                ),
                if (conversation['unread'])
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppConstants.outlinebg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppConstants.bg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Group content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation['fullName'],
                          style: TextStyle(
                            color: AppConstants.primary,
                            fontWeight: conversation['unread'] ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conversation['timestamp'],
                        style: TextStyle(
                          color: conversation['unread'] ? AppConstants.outlinebg : AppConstants.labelText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${conversation['members']} members',
                    style: TextStyle(
                      color: AppConstants.labelText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      color: conversation['unread'] ? AppConstants.primary : AppConstants.labelText,
                      fontWeight: conversation['unread'] ? FontWeight.w500 : FontWeight.normal,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToChatDetail(Map<String, dynamic> conversation) {
    // In a real app, you would navigate to a chat detail screen
    // with the selected conversation
    log('Navigating to chat with ${conversation['fullName']}');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.primarybg,
          title: Text(
            'Chat with ${conversation['fullName']}',
            style: TextStyle(color: AppConstants.primary),
          ),
          content: Text(
            'This is where the chat detail would be displayed.\nFull implementation coming soon!',
            style: TextStyle(color: AppConstants.labelText),
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: AppConstants.outlinebg)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
  
  void _navigateToGroupChatDetail(Map<String, dynamic> conversation) {
    log('Navigating to group chat: ${conversation['fullName']}');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.primarybg,
          title: Text(
            '${conversation['fullName']} (${conversation['members']} members)',
            style: TextStyle(color: AppConstants.primary),
          ),
          content: Text(
            'This is where the group chat would be displayed.\nFull implementation coming soon!',
            style: TextStyle(color: AppConstants.labelText),
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: AppConstants.outlinebg)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
  
  void _showNewMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.primarybg,
          title: Text(
            'New Message',
            style: TextStyle(color: AppConstants.primary),
          ),
          content: Text(
            'This is where you would start a new conversation.\nFull implementation coming soon!',
            style: TextStyle(color: AppConstants.labelText),
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: AppConstants.outlinebg)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
} 