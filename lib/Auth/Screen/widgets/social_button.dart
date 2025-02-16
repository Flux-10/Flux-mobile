import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flux/core/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final double? elevation;
  final double? borderRadius;
  final Color? hoverColor;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.width,
    this.height = 44.0,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.elevation = 0.0,
    this.borderRadius = 12.0,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            backgroundColor: backgroundColor ?? AppConstants.primarybg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
              side: BorderSide(
                color: borderColor ?? AppConstants.labelText,
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 20.0,
                color: iconColor ?? AppConstants.primary,
              ),
              const SizedBox(width: 12.0),
              Text(
                text,
                style: GoogleFonts.manrope(
                  color: textColor ?? AppConstants.primary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
