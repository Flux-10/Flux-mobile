import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Meet Your Classmates',
      description: 'Connect with students in your classes, clubs, or dorms to build your campus network',
      image: 'assets/images/adduser.png',
    ),
    OnboardingContent(
      title: 'Stay in the Loop',
      description: 'Discover campus events, study groups, and parties happening around you',
      image: 'assets/images/connect.png',
    ),
    OnboardingContent(
      title: 'Share Your Campus Vibe',
      description: 'Post about your uni life, from lecture moments to late-night study sessions',
      image: 'assets/images/message.png',
    ),
    OnboardingContent(
      title: 'Share Your Campus Vibe',
      description: 'Post about your uni life, from lecture moments to late-night study sessions',
      image: 'assets/images/network.png',
    ),
  ];
  
  void _skipToLastPage() {
    _pageController.animateToPage(
      _contents.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _contents[index].image,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Show error placeholder if image fails to load
                              return Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppConstants.primarybg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _contents[index].title,
                          style: GoogleFonts.urbanist(
                            color: AppConstants.primary,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _contents[index].description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: AppConstants.labelText,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _contents.length,
                    effect: ExpandingDotsEffect(
                      dotColor: AppConstants.primarybg,
                      activeDotColor: AppConstants.outlinebg,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      // Skip button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _skipToLastPage,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppConstants.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.manrope(
                              color: AppConstants.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Next/Get Started button
                      Expanded(
                        child: CustomElevatedButton(
                          text: _currentPage == _contents.length - 1 ? 'Get Started' : 'Next',
                          onPressed: () {
                            if (_currentPage == _contents.length - 1) {
                              Navigator.pushReplacementNamed(context, Routes.signup);
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}