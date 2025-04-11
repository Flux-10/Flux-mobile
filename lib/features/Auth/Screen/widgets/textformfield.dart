import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final String? Function(String?)? validator;
  final bool autofocus;
  final bool isPassword;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.validator,
    this.autofocus = false,
    this.isPassword = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _passwordVisible = false;
  String? _errorText;
  Timer? _errorTimer;

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  void _handleError(String? error) {
    setState(() {
      _errorText = error;
    });
    
    if (error != null) {
      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _errorText = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          autofillHints: widget.autofillHints,
          obscureText: widget.isPassword ? !_passwordVisible : widget.obscureText,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: GoogleFonts.manrope(
              color: AppConstants.labelText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppConstants.primarybg,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppConstants.outlinebg,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppConstants.errortext,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppConstants.errortext,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorStyle: GoogleFonts.manrope(
              color: AppConstants.errortext,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: AppConstants.primarybg,
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                    focusNode: FocusNode(skipTraversal: true),
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppConstants.labelText,
                      size: 24.0,
                    ),
                  )
                : null,
            errorText: _errorText,
          ),
          style: GoogleFonts.manrope(
            letterSpacing: 0.0,
            color: AppConstants.primary,  // Add this line to make input text white
          ),
          keyboardType: widget.keyboardType,
          validator: (value) {
            final error = widget.validator?.call(value);
            _handleError(error);
            return error;
          },
        ),
      ),
    );
  }
}
