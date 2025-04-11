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
import 'package:flux/features/home/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      log('Attempting login for email: ${_emailController.text}');
      
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
      
      // REMOVED: Forced navigation for testing
      // log('TEST MODE: Force navigating to home after login');
      // Future.delayed(const Duration(milliseconds: 500), () {
      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     Routes.home,
      //     (route) => false,
      //   );
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          log('Login state changed: ${state.status}');
          
          if (state.status == AuthStatus.authenticated) {
            log('User authenticated, navigating to home');
            Navigator.pushNamedAndRemoveUntil(
              context, 
              Routes.home,
              (route) => false,
            );
          } else if (state.status == AuthStatus.error) {
            log('Login error: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Login failed'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == AuthStatus.verificationRequired) {
            log('Email verification required for: ${state.email}');
            Navigator.pushNamed(
              context,
              Routes.otpVerification,
              arguments: {'email': state.email},
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
                                        'Welcome back to Fluxx',
                                        style: GoogleFonts.urbanist(
                                          color: AppConstants.primary,
                                          fontSize: 32.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 24.0),
                                        child: Text(
                                          'Login to your account to continue',
                                          style: GoogleFonts.manrope(
                                            color: AppConstants.labelText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: CustomTextFormField(
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
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: CustomTextFormField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          labelText: 'Password',
                                          isPassword: true,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, Routes.forgotPassword);
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'Forgot password?',
                                              style: GoogleFonts.manrope(
                                                color: AppConstants.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 24.0),
                                        child: state.status == AuthStatus.loading
                                            ? const Center(
                                                child: CircularProgressIndicator(
                                                  color: AppConstants.primary,
                                                ),
                                              )
                                            : CustomElevatedButton(
                                                text: 'Sign In',
                                                onPressed: _signIn,
                                              ),
                                      ),
                                    
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Don't have an account? ",
                                                style: GoogleFonts.manrope(
                                                  color: AppConstants.labelText,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Sign Up',
                                                style: GoogleFonts.manrope(
                                                  color: AppConstants.primary,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.pushNamed(context, Routes.signup);
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