import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class PostTaskScreen extends StatefulWidget {
  const PostTaskScreen({Key? key}) : super(key: key);

  @override
  State<PostTaskScreen> createState() => _PostTaskScreenState();
}

class _PostTaskScreenState extends State<PostTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Tutoring';
  String _selectedPaymentMode = 'Monetary';
  
  // Available categories and payment modes
  final List<String> _categories = [
    'Tutoring',
    'Tech Help',
    'Moving',
    'Errands',
    'Research',
    'Design',
    'Other',
  ];
  
  final List<String> _paymentModes = [
    'Monetary',
    'Skill Swap',
    'Services',
  ];
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task posted successfully!'),
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
          'Post a Task',
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
                // Title field
                Text(
                  'Task Title',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'E.g., Need help with math homework',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Description field
                Text(
                  'Description',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Describe your task in detail...',
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
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Category dropdown
                Text(
                  'Category',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppConstants.primarybg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: AppConstants.primary),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: AppConstants.primary),
                      dropdownColor: AppConstants.primarybg,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: _categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Payment mode dropdown
                Text(
                  'Mode of Payment',
                  style: GoogleFonts.manrope(
                    color: AppConstants.primary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppConstants.primarybg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPaymentMode,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: AppConstants.primary),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: AppConstants.primary),
                      dropdownColor: AppConstants.primarybg,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPaymentMode = newValue!;
                        });
                      },
                      items: _paymentModes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.outlinebg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Post Task',
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