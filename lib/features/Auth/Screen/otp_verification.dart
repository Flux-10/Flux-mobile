import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:flux/features/Auth/bloc/auth_event.dart';
import 'package:flux/features/Auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;

  // Non-const constructor with logging
  OTPVerificationPage({
    Key? key,
    required this.email,
  }) : super(key: key) {
    log('OTPVerificationPage created with email: $email');
  }

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isResendEnabled = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    log('OTP verification page initialized for email: ${widget.email}');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _isResendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _resetResendTimer() {
    setState(() {
      _isResendEnabled = false;
      _resendTimer = 60;
    });
    _startResendTimer();
  }

  void _verifyOTP() {
    if (_formKey.currentState!.validate()) {
      log('Verifying OTP for email: ${widget.email}, OTP: ${_otpController.text}');
      context.read<AuthBloc>().add(
            VerifyEmailRequested(
              email: widget.email,
              otp: _otpController.text,
            ),
          );
          
      // REMOVED: Forced navigation for testing
      // log('TEST MODE: Force navigating to home after OTP verification');
      // Future.delayed(const Duration(milliseconds: 500), () {
      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     Routes.home,
      //     (route) => false,
      //   );
      // });
    }
  }

  void _resendOTP() {
    if (_isResendEnabled) {
      log('Resending OTP for email: ${widget.email}');
      context.read<AuthBloc>().add(
            ResendVerificationRequested(
              email: widget.email,
            ),
          );
      _resetResendTimer();
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
          icon: Icon(Icons.arrow_back, color: AppConstants.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          log('OTP verification state: ${state.status}');
          if (state.status == AuthStatus.authenticated) {
            // Should usually navigate to home if logged in during verification (e.g., 2FA)
            log('Authentication successful (during verification), navigating to home');
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          } else if (state.status == AuthStatus.unauthenticated && state.error == null) {
            // Successfully verified email, immediately go to home screen
            log('Email verified successfully, navigating to home screen');
            Navigator.pushNamedAndRemoveUntil(
              context, 
              Routes.home,
              (route) => false,
            );
          } else if (state.status == AuthStatus.error) {
            log('Error during OTP verification: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Verification failed'),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verify Code',
                        style: GoogleFonts.urbanist(
                          color: AppConstants.primary,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter the 6-digit code sent to:',
                        style: GoogleFonts.manrope(
                          color: AppConstants.labelText,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: GoogleFonts.manrope(
                          color: AppConstants.primary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        cursorColor: AppConstants.primary,
                        keyboardType: TextInputType.number,
                        textStyle: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 45,
                          activeFillColor: AppConstants.primarybg,
                          inactiveFillColor: AppConstants.primarybg,
                          selectedFillColor: AppConstants.primarybg,
                          activeColor: AppConstants.outlinebg,
                          inactiveColor: AppConstants.primarybg,
                          selectedColor: AppConstants.outlinebg,
                        ),
                        animationType: AnimationType.fade,
                        enableActiveFill: true,
                        onCompleted: (value) {
                          _verifyOTP();
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 24),
                      // Resend code option with timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code? ",
                            style: GoogleFonts.manrope(
                              color: AppConstants.labelText,
                              fontSize: 14.0,
                            ),
                          ),
                          InkWell(
                            onTap: _isResendEnabled ? _resendOTP : null,
                            child: Text(
                              _isResendEnabled
                                  ? "Resend"
                                  : "Resend in $_resendTimer sec",
                              style: GoogleFonts.manrope(
                                color: _isResendEnabled
                                    ? AppConstants.primary
                                    : AppConstants.labelText,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (state.status == AuthStatus.loading)
                        Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.primary,
                          ),
                        )
                      else
                        CustomElevatedButton(
                          text: 'Verify',
                          onPressed: _verifyOTP,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
