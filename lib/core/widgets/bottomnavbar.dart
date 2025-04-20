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
      case 1: // Post/Fluxx it
        // Show post creation dialog or navigate to post creation page
        _showPostDialog();
        break;
      case 2: // Profile
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
  
  void _showPostDialog() {
    // Simple dialog for post creation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222222),
          title: Text(
            'Create a New Fluxx',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'This is where you\'ll create a new post (Fluxx).\nFull implementation coming soon!',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: AppConstants.primary)),
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
    } else if (currentRoute == Routes.profile && _selectedIndex != 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedIndex = 2);
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildPostButton(),
              _buildNavItem(2, Icons.person, 'Profile'),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Increased padding
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
                        padding: const EdgeInsets.only(left: 12.0), // More spacing
                        child: Text(
                          'Fluxx it',
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Increased padding
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
                  size: 28, // Larger icon
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: isSelected ? null : 0,
                  child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12.0), // More spacing
                        child: Text(
                          label,
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
}