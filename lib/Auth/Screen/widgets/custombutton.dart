import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flux/core/util/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;
  final double? elevation;
  final double? borderRadius;
  final Color? backgroundColor;
  final BorderSide? borderSide;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 44.0,
    this.padding = const EdgeInsets.all(0),
    this.iconPadding = const EdgeInsets.all(0),
    this.elevation = 3.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderSide = const BorderSide(color: Colors.transparent, width: 1.0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          padding: padding,
          backgroundColor: backgroundColor ?? AppConstants.outlinebg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            side: borderSide!,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.0,
          ),
        ),
      ),
    );
  }
}
