import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';

class ThemeUtil {
  // Get a text style with appropriate colors based on the current theme
  static TextStyle getTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    bool isLabel = false,
    Color? customColor,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: customColor ?? (isLabel ? AppConstants.labelText : AppConstants.primary),
    );
  }
  
  // Get background color for cards based on the current theme
  static Color getCardBackgroundColor() {
    return AppConstants.primarybg;
  }
  
  // Get appropriate border color based on the current theme
  static Color getBorderColor({bool highlight = false}) {
    return highlight 
        ? AppConstants.outlinebg 
        : AppConstants.labelText.withOpacity(0.3);
  }
  
  // Get input decoration for text fields based on current theme
  static InputDecoration getInputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool hasError = false,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: hasError ? errorText : null,
      labelStyle: TextStyle(color: AppConstants.labelText),
      hintStyle: TextStyle(color: AppConstants.labelText.withOpacity(0.7)),
      errorStyle: TextStyle(color: AppConstants.errortext),
      filled: true,
      fillColor: AppConstants.primarybg,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: getBorderColor()),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppConstants.outlinebg, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppConstants.errortext),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppConstants.errortext, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
  
  // Get a button style based on current theme
  static ButtonStyle getElevatedButtonStyle({bool isPrimary = true}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isPrimary ? AppConstants.outlinebg : AppConstants.primarybg,
      foregroundColor: isPrimary ? Colors.white : AppConstants.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPrimary 
            ? BorderSide.none 
            : BorderSide(color: AppConstants.outlinebg),
      ),
    );
  }
  
  // Get appropriate icon color
  static Color getIconColor({bool isActive = false}) {
    return isActive 
        ? AppConstants.outlinebg 
        : AppConstants.primary.withOpacity(0.7);
  }
} 