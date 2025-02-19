import 'package:flutter/material.dart';
import 'package:flux/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flux/Auth/Screen/widgets/textformfield.dart';
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
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  text: 'Send Code',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, Routes.otpVerification);
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