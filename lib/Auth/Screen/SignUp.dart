// ignore: file_names
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flux/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flux/Auth/Screen/widgets/textformfield.dart';
import 'package:flux/Auth/Screen/widgets/social_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppConstants.bg,
      body: SafeArea(
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
                child:   SingleChildScrollView(
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
                          child:   Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      'Let\'s create your dating profile',
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
                                        'Let\'s get started by filling out the form below.',
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
                                              controller: _nameController,
                                              focusNode: _nameFocus,
                                              labelText: 'Name',
                                              keyboardType: TextInputType.name,
                                              autofillHints: const [AutofillHints.name],
                                              autofocus: true,

                                            ),
                                          ),
                                      ),

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
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                        child: CustomElevatedButton(
                                          text: 'Create Account',
                                          height: 44.0,
                                          elevation: 3.0,
                                          borderRadius: 12.0,
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              // Form is valid, proceed with account creation
                                              //!Implement logic for auth when endpoint is ready
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Expanded(
                                              child: Divider(
                                                thickness: 1,
                                                color: AppConstants.labelText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: Text(
                                                'OR',
                                                style: GoogleFonts.manrope(
                                                  color: AppConstants.labelText,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              child: Divider(
                                                thickness: 1,
                                                color: AppConstants.labelText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SocialLoginButton(
                                        text: 'Continue with Google',
                                        icon: FontAwesomeIcons.google,
                                        onPressed: () async {
                                          // TODO: Implement Google Sign In
                                        },
                                      ),
                                       SocialLoginButton(
                                        text: 'Continue with Apple',
                                        icon: FontAwesomeIcons.apple,
                                        onPressed: () async {
                                          // TODO: Implement Apple Sign In
                                        },
                                      ),
                                      Align(
                                        alignment: const AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                          child: RichText(
                                            textScaler: MediaQuery.of(context).textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Already have an account? ',
                                                  style: GoogleFonts.manrope(
                                                    color: AppConstants.labelText,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Sign In here',
                                                  style: GoogleFonts.manrope(
                                                    color: AppConstants.outlinebg,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
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
              )
              )
          ],
        )
        ),
    );
  }
}