import 'package:flutter/material.dart';
import 'package:flux/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
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
      title: 'Smart Matching',
      description: 'Our AI understands your preferences and matches you with compatible partners',
      image: 'assets/images/onboard1.png',
    ),
    OnboardingContent(
      title: 'Meaningful Connections',
      description: 'Build authentic relationships based on shared interests and values',
      image: 'assets/images/onboard2.png',
    ),
    OnboardingContent(
      title: 'Safe & Secure',
      description: 'Advanced AI verification ensures you meet real people with genuine intentions',
      image: 'assets/images/onboard3.png',
    ),
  ];

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
                        // Image placeholder
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppConstants.primarybg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // TODO: Add actual image
                          // child: Image.asset(_contents[index].image),
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
                  CustomElevatedButton(
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
