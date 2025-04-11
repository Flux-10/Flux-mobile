import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      backgroundColor: AppConstants.bg,
      bottomNavigationBar: CustomBottomNav(),
     
    );
  }
}