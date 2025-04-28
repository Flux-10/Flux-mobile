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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  final FocusNode _departmentFocus = FocusNode();
  final FocusNode _universityFocus = FocusNode();
  final FocusNode _courseFocus = FocusNode();
  
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String? _defaultAvatar;
  String? _gender;
  String? _sexualOrientation;
  String? email;
  bool _isLoading = false;
  String? _errorMessage;
  
  final List<String> _genderOptions = [
    'Male', 
    'Female', 
    'Non-binary', 
    'Prefer not to say'
  ];
  
  final List<String> _orientationOptions = [
    'Straight', 
    'Gay', 
    'Lesbian', 
    'Bisexual', 
    'Asexual', 
    'Prefer not to say'
  ];
  
  final List<String> _avatarOptions = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
    'assets/images/avatars/avatar5.png',
    'assets/images/avatars/avatar6.png',
  ];

  @override
  void initState() {
    super.initState();
    // We need to wait for the widget to be properly initialized before accessing context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        email = args['email'] as String?;
        log('ProfileCreateScreen initialized with email: $email');
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _departmentController.dispose();
    _universityController.dispose();
    _courseController.dispose();
    
    _usernameFocus.dispose();
    _nameFocus.dispose();
    _bioFocus.dispose();
    _departmentFocus.dispose();
    _universityFocus.dispose();
    _courseFocus.dispose();
    
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
          _defaultAvatar = null; // Clear selected default avatar when custom image is chosen
        });
        log('Image selected: ${image.path}');
      }
    } catch (e) {
      log('Error picking image: $e');
      setState(() {
        _errorMessage = 'Error selecting image: $e';
      });
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
      // Validate required fields
      if (_profileImage == null && _defaultAvatar == null) {
        setState(() {
          _errorMessage = 'Please select a profile picture or choose a default avatar';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_gender == null) {
        setState(() {
          _errorMessage = 'Please select a gender';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_sexualOrientation == null) {
        setState(() {
          _errorMessage = 'Please select a sexual orientation';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      try {
        // TODO: Implement profile creation API call here
        log('Creating profile for email: $email');
        log('Username: ${_usernameController.text}');
        log('Name: ${_nameController.text}');
        log('Bio: ${_bioController.text}');
        log('Department: ${_departmentController.text}');
        log('University: ${_universityController.text}');
        log('Course: ${_courseController.text}');
        log('Gender: $_gender');
        log('Sexual Orientation: $_sexualOrientation');
        log('Profile image: ${_profileImage?.path ?? _defaultAvatar ?? 'None'}');
        
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
          setState(() {
            _errorMessage = 'Error creating profile: $e';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image selector
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppConstants.primarybg,
                              shape: BoxShape.circle,
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : _defaultAvatar != null
                                      ? DecorationImage(
                                          image: AssetImage(_defaultAvatar!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                            child: _profileImage == null && _defaultAvatar == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: AppConstants.primary.withOpacity(0.7),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to upload photo',
                          style: GoogleFonts.manrope(
                            color: AppConstants.labelText,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Default Avatars
                  if (_profileImage == null) ...[
                    Text(
                      'Or select a default avatar:',
                      style: GoogleFonts.manrope(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _avatarOptions.map((avatar) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _defaultAvatar = avatar;
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _defaultAvatar == avatar
                                      ? AppConstants.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(avatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.manrope(
                          fontSize: 14.0,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  
                  // Username field
                  Text(
                    'Username',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                    labelText: 'Choose a unique username',
                    keyboardType: TextInputType.name,
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
                  const SizedBox(height: 16),
                  
                  // Full Name field
                  Text(
                    'Full Name',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    labelText: 'Your full name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Gender dropdown
                  Text(
                    'Gender',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppConstants.primarybg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.outlinebg,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _gender,
                        isExpanded: true,
                        hint: Text(
                          'Select your gender',
                          style: GoogleFonts.manrope(
                            fontSize: 16.0,
                            color: AppConstants.labelText,
                          ),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: AppConstants.primary),
                        dropdownColor: AppConstants.bg,
                        style: GoogleFonts.manrope(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue;
                          });
                        },
                        items: _genderOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sexual Orientation dropdown
                  Text(
                    'Sexual Orientation',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppConstants.primarybg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.outlinebg,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sexualOrientation,
                        isExpanded: true,
                        hint: Text(
                          'Select your sexual orientation',
                          style: GoogleFonts.manrope(
                            fontSize: 16.0,
                            color: AppConstants.labelText,
                          ),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: AppConstants.primary),
                        dropdownColor: AppConstants.bg,
                        style: GoogleFonts.manrope(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _sexualOrientation = newValue;
                          });
                        },
                        items: _orientationOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bio field
                  Text(
                    'Bio',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _bioController,
                    focusNode: _bioFocus,
                    labelText: 'Tell us about yourself',
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.length > 160) {
                        return 'Bio must be less than 160 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // University field
                  Text(
                    'University',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _universityController,
                    focusNode: _universityFocus,
                    labelText: 'Your university',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your university';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Department field
                  Text(
                    'Department',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _departmentController,
                    focusNode: _departmentFocus,
                    labelText: 'Your department',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your department';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Course field
                  Text(
                    'Course',
                    style: GoogleFonts.manrope(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _courseController,
                    focusNode: _courseFocus,
                    labelText: 'Your course',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your course';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Create profile button
                  _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.primary,
                        ),
                      )
                    : CustomElevatedButton(
                        text: 'Create Profile',
                        onPressed: _createProfile,
                      ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}