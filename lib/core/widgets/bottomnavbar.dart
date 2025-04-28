import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'dart:developer';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    log('Tab changed to index: $index');
    
    // Navigate to the appropriate route based on index
    switch(index) {
      case 0: // Home
        if (ModalRoute.of(context)?.settings.name != Routes.home) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            Routes.home,
            (route) => false,
          );
        }
        break;
      case 1: // Post
        _showPostOptionsDialog();
        break;
      case 2: // Notifications
        if (ModalRoute.of(context)?.settings.name != Routes.notifications) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            Routes.notifications,
            (route) => false,
          );
        }
        break;
      case 3: // Profile
        if (ModalRoute.of(context)?.settings.name != Routes.profile) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            Routes.profile,
            (route) => false,
          );
        }
        break;
    }
  }
  
  void _showPostOptionsDialog() {
    // Dialog for choosing what to post
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222222),
          title: Text(
            'What would you like to post?',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.task_alt, color: AppConstants.primary),
                title: Text('Post a Task', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.postTask);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline, color: AppConstants.primary),
                title: Text('Post a Rant', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.postRant);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppConstants.primary)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine current route to highlight the correct tab
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == Routes.home && _selectedIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedIndex = 0);
      });
    } else if (currentRoute == Routes.notifications && _selectedIndex != 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedIndex = 2);
      });
    } else if (currentRoute == Routes.profile && _selectedIndex != 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedIndex = 3);
      });
    }
    
    return Material(
      elevation: 8,
      color: const Color(0xFF1A1A1A), // Darker background like in the image
      // borderRadius: const BorderRadius.only(
      //   topLeft: Radius.circular(25),
      //   topRight: Radius.circular(25),
      // ),
      child: SafeArea(
        child: Container(
          height: 80, // Increased height
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildPostButton(),
              _buildNavItem(2, Icons.notifications, 'Notifications'),
              _buildNavItem(3, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    final isSelected = _selectedIndex == 1;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(1),
        borderRadius: BorderRadius.circular(30), // Larger radius
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjusted padding
          decoration: BoxDecoration(
            color: isSelected 
              ? Colors.grey.shade800.withOpacity(0.9) 
              : Colors.transparent,
            borderRadius: BorderRadius.circular(30), // Larger radius
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: isSelected ? 0.125 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Image.asset(
                  'assets/icons/post_button.png',
                  width: 28, // Larger icon
                  height: 28, // Larger icon
                  color: isSelected ? AppConstants.primary : Colors.white, // White for better visibility
                  errorBuilder: (ctx, err, stack) => Icon(
                    Icons.add_circle,
                    color: isSelected ? AppConstants.primary : Colors.white,
                    size: 28, // Larger icon
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: isSelected ? null : 0,
                  child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0), // Adjusted spacing
                        child: Text(
                          'Post',
                          style: TextStyle(
                            color: AppConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16, // Larger text
                          ),
                        ),
                      )
                    : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(30), // Larger radius
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjusted padding
          decoration: BoxDecoration(
            color: isSelected 
              ? Colors.grey.shade800.withOpacity(0.9) 
              : Colors.transparent,
            borderRadius: BorderRadius.circular(30), // Larger radius
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(
                  icon,
                  color: isSelected ? AppConstants.primary : Colors.white, // White for better visibility
                  size: 24, // Adjusted icon size
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: isSelected ? null : 0,
                  child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0), // Adjusted spacing
                        child: Text(
                          label,
                          style: TextStyle(
                            color: AppConstants.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14, // Adjusted text size
                          ),
                        ),
                      )
                    : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}