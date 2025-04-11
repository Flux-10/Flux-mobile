import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:google_fonts/google_fonts.dart';
 
import 'package:flux/core/router/routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                  'Enter the 4-digit code sent to your email',
                  style: GoogleFonts.manrope(
                    color: AppConstants.labelText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _otpController,
                  cursorColor: AppConstants.primary,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 56,
                    fieldWidth: 56,
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
                    Navigator.pushNamed(context, Routes.resetPassword);
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  text: 'Verify',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, Routes.resetPassword);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
