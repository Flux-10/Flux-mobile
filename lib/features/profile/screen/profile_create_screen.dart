import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/features/Auth/Screen/widgets/custombutton.dart';
import 'package:flux/features/Auth/Screen/widgets/textformfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String? email;
  String? initialUsername;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // We need to wait for the widget to be properly initialized before accessing context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        email = args['email'] as String?;
        initialUsername = args['username'] as String?;
        
        if (initialUsername != null && initialUsername!.isNotEmpty) {
          _usernameController.text = initialUsername!;
        }
        
        log('ProfileCreateScreen initialized with email: $email, initialUsername: $initialUsername');
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _usernameFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        log('Image selected: ${image.path}');
      }
    } catch (e) {
      log('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // TODO: Implement profile creation API call here
        log('Creating profile for email: $email');
        log('Username: ${_usernameController.text}');
        log('Bio: ${_bioController.text}');
        log('Profile image: ${_profileImage?.path ?? 'None'}');
        
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        
        // After successful profile creation, navigate to home
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
        }
      } catch (e) {
        log('Error creating profile: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        title: Text(
          'Create Your Profile',
           style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppConstants.bg,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile image selector
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppConstants.primarybg,
                            backgroundImage: _profileImage != null 
                                ? FileImage(_profileImage!) 
                                : null,
                            child: _profileImage == null 
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppConstants.primary,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppConstants.primary,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Profile Photo',
                    style: GoogleFonts.manrope(
                      color: AppConstants.labelText,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Username field
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          labelText: 'Username',
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.username],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 8),
                          child: Text(
                            'Choose a unique username for your profile',
                            style: GoogleFonts.manrope(
                              color: AppConstants.labelText,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bio field
                  SizedBox(
                    width: double.infinity,
                    child: CustomTextFormField(
                      controller: _bioController,
                      focusNode: _bioFocus,
                      labelText: 'Bio (Optional)',
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value != null && value.length > 160) {
                          return 'Bio must be less than 160 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Create profile button
                  _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.primary,
                        ),
                      )
                    : CustomElevatedButton(
                        text: 'Create Profile',
                        onPressed: _createProfile,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}