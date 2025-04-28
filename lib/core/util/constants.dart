import 'dart:ui';

class AppConstants {
  // Theme Colors
  static const Color errortext = Color(0xFFE74852); // Error text color (same for both themes)
  
  // Dark Theme Colors
  static const Color dark_outlinebg = Color(0xFF9489F5); // Outline for text fields in dark mode
  static const Color dark_primarybg = Color(0xFF1A1F24); // Bg for text form fields in dark mode
  static const Color dark_labelText = Color(0xFF95A1AC); // Text in the textfield in dark mode
  static const Color dark_primary = Color(0xFFFFFFFF); // Text in dark mode (white)
  static const Color dark_bg = Color(0xFA101213); // Background in dark mode
  static const Color dark_onBoard1 = Color(0xFFC6FFE1); // Onboarding highlight in dark mode
  
  // Light Theme Colors
  static const Color light_outlinebg = Color(0xFF7B61FF); // Outline for text fields in light mode - rich purple
  static const Color light_primarybg = Color(0xFFFFFFFF); // Bg for text form fields in light mode - white
  static const Color light_labelText = Color(0xFF5F6368); // Text in the textfield in light mode - soft gray
  static const Color light_primary = Color(0xFF000000); // Text in light mode - black
  static const Color light_bg = Color(0xFFF9F9FB); // Background in light mode - very light gray/white
  static const Color light_onBoard1 = Color(0xFF2A9D8F); // Onboarding highlight in light mode - vibrant teal
  
  // Current Theme Colors (defaults to dark theme values)
  // These will be replaced by the ThemeProvider
  static Color outlinebg = dark_outlinebg;
  static Color primarybg = dark_primarybg;
  static Color labelText = dark_labelText;
  static Color primary = dark_primary;
  static Color bg = dark_bg;
  static Color onBoard1 = dark_onBoard1;
}