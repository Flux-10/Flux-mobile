import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      bottomNavigationBar: Container(
      
        decoration: BoxDecoration(
             color: AppConstants.primarybg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
       
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: AppConstants.primarybg,
            color: AppConstants.labelText,
            activeColor: AppConstants.primary,
            gap: 8,
            iconSize: 24,
            tabBackgroundColor:Colors.grey.shade800,
            padding: const EdgeInsets.all(16),
            onTabChange: (index) {
              print(index);
            },
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.favorite_border, text: 'Flux it',),
              GButton(icon: Icons.settings, text: 'Settings'),
              GButton(icon: Icons.person, text: 'Profile'),
            ]
            ),
        ),
      ),
    );
  }
}