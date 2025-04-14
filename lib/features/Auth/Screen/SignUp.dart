// ignore: file_names
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/features/Auth/Screen/widgets/social_button.dart';
import 'package:flux/features/Auth/Screen/widgets/textformfield.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }
  
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      log('Sending sign up request for email: ${_emailController.text}');
      
      try {
        context.read<AuthBloc>().add(
          SignUpRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
        log('SignUpRequested event dispatched successfully');
      } catch (e) {
        log('Error dispatching SignUpRequested event: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.verificationRequired) {
            // Navigate to OTP verification screen with email
            log('Navigating to OTP verification for email: ${_emailController.text}');
            log('State email: ${state.email}');
            
            Navigator.pushNamed(
              context,
              Routes.otpVerification,
              arguments: {'email': state.email ?? _emailController.text},
            );
          } else if (state.status == AuthStatus.error) {
            log('Error during sign up: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Registration failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    width: 100.0,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppConstants.bg,
                    ),
                    alignment: const AlignmentDirectional(0.0, -1.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 140.0,
                              decoration: const BoxDecoration(
                                color: AppConstants.bg,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(0.0),
                                ),
                              ),
                              alignment: const AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Fluxx',
                                    
                                      style: GoogleFonts.manrope(
                                        color: AppConstants.primary,
                                         fontSize: 50.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    //! Update when logo is ready
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(8.0),
                                    //   child: Image.asset(
                                    //     'assets/images/flux.png',
                                    //     width: 50.0,
                                    //     height: 50.0,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // )
                                    //TODO: Add logo
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxWidth: 430.0,
                              ),
                              decoration: const BoxDecoration(
                                color: AppConstants.bg, 
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Let\'s create your Fluxx profile',
                                        style: GoogleFonts.urbanist(
                                          color: AppConstants.primary,
                                          fontSize: 32.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 12.0, 0.0, 24.0
                                        ),
                                        child: Text(
                                          'Get started by registering with your email, you can set up your profile after verification.',
                                          style: GoogleFonts.manrope(
                                            color: AppConstants.labelText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),

                                      //! Textfields
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CustomTextFormField(
                                            controller: _emailController,
                                            focusNode: _emailFocus,
                                            labelText: 'Email',
                                            keyboardType: TextInputType.emailAddress,
                                            autofillHints: const [AutofillHints.email],
                                            autofocus: true,
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
                                        ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CustomTextFormField(
                                            controller: _passwordController,
                                            focusNode: _passwordFocus,
                                            labelText: 'Password',
                                            keyboardType: TextInputType.visiblePassword,
                                            autofillHints: const [AutofillHints.password],
                                            isPassword: true,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your password';
                                              }
                                              if (value.length < 8) {
                                                return 'Password must be at least 8 characters';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CustomTextFormField(
                                            controller: _confirmPasswordController,
                                            focusNode: _confirmPasswordFocus,
                                            labelText: 'Confirm Password',
                                            keyboardType: TextInputType.visiblePassword,
                                            autofillHints: const [AutofillHints.password],
                                            isPassword: true,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please confirm your password';
                                              }
                                              if (value != _passwordController.text) {
                                                return 'Passwords do not match';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
                                        child: state.status == AuthStatus.loading
                                            ? const Center(
                                                child: CircularProgressIndicator(
                                                  color: AppConstants.primary,
                                                ),
                                              )
                                            : CustomElevatedButton(
                                                text: 'Create Account',
                                                onPressed: _signUp,
                                              ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Already have an account? ',
                                                style: GoogleFonts.manrope(
                                                  color: AppConstants.labelText,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                                
                                              TextSpan(
                                                text: 'Sign In',
                                                style: GoogleFonts.manrope(
                                                  color: AppConstants.primary,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.pushNamed(context, Routes.login);
                                                  },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}