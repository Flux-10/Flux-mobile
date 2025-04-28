import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class PostRantScreen extends StatefulWidget {
  const PostRantScreen({Key? key}) : super(key: key);

  @override
  State<PostRantScreen> createState() => _PostRantScreenState();
}

class _PostRantScreenState extends State<PostRantScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  final TextEditingController _rantTextController = TextEditingController();
  bool _hasImage = false;
  
  @override
  void dispose() {
    _rantTextController.dispose();
    super.dispose();
  }
  
  void _submitRant() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rant posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back to home
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.home,
        (route) => false,
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
        title: Text(
          'Post a Rant',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rant text field
                Text(
                  'What\'s on your mind?',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _rantTextController,
                  decoration: InputDecoration(
                    hintText: 'Share your university experience...',
                    fillColor: AppConstants.primarybg,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 16,
                    ),
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Optional image upload
                Text(
                  'Add Photo (Optional)',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Image selector
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasImage = !_hasImage;
                    });
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _hasImage ? Colors.blue.shade200 : AppConstants.primarybg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _hasImage ? Colors.blue.shade400 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasImage ? Icons.check_circle : Icons.add_photo_alternate,
                          size: 48,
                          color: _hasImage ? Colors.blue.shade700 : AppConstants.labelText,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _hasImage ? 'Image Selected' : 'Tap to add a photo',
                          style: GoogleFonts.manrope(
                            color: _hasImage ? Colors.blue.shade700 : AppConstants.labelText,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitRant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.outlinebg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Post Rant',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 