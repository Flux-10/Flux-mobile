import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/features/Auth/Screen/widgets/textformfield.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flux/core/router/routes.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _requestPasswordReset() {
    if (_formKey.currentState!.validate()) {
      log('Requesting password reset for email: ${_emailController.text}');
      
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(
          email: _emailController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        backgroundColor: AppConstants.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          log('Forgot password state: ${state.status}');
          
          if (state.status == AuthStatus.unauthenticated && state.email != null) {
            log('Password reset request successful, navigating to OTP verification for: ${state.email}');
            Navigator.pushNamed(
              context, 
              Routes.otpVerification,
              arguments: {'email': state.email},
            );
          } else if (state.status == AuthStatus.error) {
            log('Password reset request error: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to send reset code'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: GoogleFonts.urbanist(
                        color: AppConstants.primary,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your email and we\'ll send you a code to reset your password',
                      style: GoogleFonts.manrope(
                        color: AppConstants.labelText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Basic email validation
                        final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    state.status == AuthStatus.loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primary,
                            ),
                          )
                        : CustomElevatedButton(
                            text: 'Send Code',
                            onPressed: _requestPasswordReset,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}