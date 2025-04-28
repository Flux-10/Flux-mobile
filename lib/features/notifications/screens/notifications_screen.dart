import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  
  // Sample data for notifications feed
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'bid',
      'username': 'mathwiz',
      'title': 'Bid on your task',
      'taskTitle': 'Help with Calculus Homework',
      'timeAgo': '3h',
      'read': false,
    },
    {
      'type': 'message',
      'username': 'tutorPro',
      'title': 'New message',
      'content': 'Hey, are you available tomorrow?',
      'timeAgo': '5h',
      'read': false,
    },
    {
      'type': 'bid_accepted',
      'username': 'movinghelp',
      'title': 'Bid accepted',
      'taskTitle': 'Need help moving furniture',
      'timeAgo': '1d',
      'read': true,
    },
    {
      'type': 'task_completed',
      'username': 'techgeek',
      'title': 'Task completed',
      'taskTitle': 'Computer troubleshooting',
      'timeAgo': '2d',
      'read': true,
    },
    {
      'type': 'bid',
      'username': 'helpfuljoe',
      'title': 'Bid on your task',
      'taskTitle': 'Pick up groceries',
      'timeAgo': '3d',
      'read': true,
    },
  ];
  
  // List to hold displayed notifications
  List<Map<String, dynamic>> _displayedNotifications = [];
  
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }
  
  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _displayedNotifications = List.from(_notifications);
      _isLoading = false;
    });
  }
  
  Future<void> _refreshNotifications() async {
    setState(() {
      _isLoading = true;
      _displayedNotifications = [];
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _loadNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        backgroundColor: AppConstants.bg,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline, color: AppConstants.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
              setState(() {
                for (var notification in _displayedNotifications) {
                  notification['read'] = true;
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppConstants.outlinebg),
            )
          : _displayedNotifications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _refreshNotifications,
                  color: AppConstants.outlinebg,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _displayedNotifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(_displayedNotifications[index]);
                    },
                  ),
                ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 72,
            color: AppConstants.labelText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: GoogleFonts.manrope(
              color: AppConstants.primary,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you get notifications, they\'ll show up here',
            style: GoogleFonts.manrope(
              color: AppConstants.labelText,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    IconData icon;
    Color iconColor;
    
    // Determine icon and color based on notification type
    switch(notification['type']) {
      case 'bid':
        icon = Icons.gavel;
        iconColor = Colors.orange;
        break;
      case 'message':
        icon = Icons.message;
        iconColor = Colors.green;
        break;
      case 'bid_accepted':
        icon = Icons.check_circle;
        iconColor = Colors.blue;
        break;
      case 'task_completed':
        icon = Icons.task_alt;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppConstants.primary;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      color: notification['read'] ? AppConstants.bg : AppConstants.primarybg.withOpacity(0.3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppConstants.labelText.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Mark as read when tapped
          setState(() {
            notification['read'] = true;
          });
          
          // Show detail or navigate based on notification type
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${notification['title']} details')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '@${notification['username']}',
                          style: GoogleFonts.manrope(
                            color: AppConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          notification['timeAgo'],
                          style: GoogleFonts.manrope(
                            color: AppConstants.labelText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['title'],
                      style: GoogleFonts.manrope(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (notification.containsKey('taskTitle'))
                      Text(
                        'Task: ${notification['taskTitle']}',
                        style: GoogleFonts.manrope(
                          color: AppConstants.primary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      )
                    else if (notification.containsKey('content'))
                      Text(
                        notification['content'],
                        style: GoogleFonts.manrope(
                          color: AppConstants.primary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              
              if (!notification['read'])
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppConstants.outlinebg,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 