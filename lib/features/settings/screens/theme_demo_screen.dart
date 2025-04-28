import 'package:flutter/material.dart';
import 'package:flux/core/theme/theme_provider.dart';
import 'package:flux/core/theme/theme_util.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theme Preview',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Theme toggle in app bar
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
              color: AppConstants.primary,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme info card
            _buildThemeInfoCard(themeProvider),
            const SizedBox(height: 24),
            
            // Colors showcase
            _buildSectionTitle('Theme Colors'),
            _buildColorsShowcase(),
            const SizedBox(height: 32),
            
            // Typography showcase
            _buildSectionTitle('Typography'),
            _buildTypographyShowcase(),
            const SizedBox(height: 32),
            
            // Form elements showcase
            _buildSectionTitle('Form Elements'),
            _buildFormElementsShowcase(),
            const SizedBox(height: 32),
            
            // Buttons showcase
            _buildSectionTitle('Buttons'),
            _buildButtonsShowcase(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildThemeInfoCard(ThemeProvider themeProvider) {
    return Card(
      color: ThemeUtil.getCardBackgroundColor(),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ThemeUtil.getBorderColor(highlight: true),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Theme',
                  style: ThemeUtil.getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: AppConstants.outlinebg,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: ThemeUtil.getTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              themeProvider.isDarkMode
                  ? 'The dark theme uses a deep background with light text for reduced eye strain in low-light environments.'
                  : 'The light theme uses a bright background with dark text for optimal readability in well-lit environments.',
              style: ThemeUtil.getTextStyle(
                fontSize: 14,
                isLabel: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: ThemeUtil.getTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildColorsShowcase() {
    return Column(
      children: [
        _buildColorRow('Primary', AppConstants.primary),
        _buildColorRow('Background', AppConstants.bg),
        _buildColorRow('Primary Background', AppConstants.primarybg),
        _buildColorRow('Outline Background', AppConstants.outlinebg),
        _buildColorRow('Label Text', AppConstants.labelText),
        _buildColorRow('Error Text', AppConstants.errortext),
        _buildColorRow('Onboarding', AppConstants.onBoard1),
      ],
    );
  }
  
  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeUtil.getBorderColor(),
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: ThemeUtil.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '#${color.value.toRadixString(16).toUpperCase().substring(2)}',
                  style: ThemeUtil.getTextStyle(
                    fontSize: 12,
                    isLabel: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypographyShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heading 1',
          style: ThemeUtil.getTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Heading 2',
          style: ThemeUtil.getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Heading 3',
          style: ThemeUtil.getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Body Text',
          style: ThemeUtil.getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Small Text',
          style: ThemeUtil.getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Label Text',
          style: ThemeUtil.getTextStyle(
            fontSize: 14,
            isLabel: true,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFormElementsShowcase() {
    return Column(
      children: [
        TextField(
          decoration: ThemeUtil.getInputDecoration(
            labelText: 'Text Field',
            hintText: 'Enter text here',
            prefixIcon: Icon(Icons.text_fields, color: AppConstants.labelText),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: ThemeUtil.getInputDecoration(
            labelText: 'Password',
            hintText: 'Enter password',
            prefixIcon: Icon(Icons.lock_outline, color: AppConstants.labelText),
            suffixIcon: Icon(Icons.visibility_off, color: AppConstants.labelText),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: ThemeUtil.getInputDecoration(
            labelText: 'Error Field',
            hintText: 'Error example',
            prefixIcon: Icon(Icons.error_outline, color: AppConstants.errortext),
            hasError: true,
            errorText: 'This field has an error',
          ),
        ),
      ],
    );
  }
  
  Widget _buildButtonsShowcase(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ThemeUtil.getElevatedButtonStyle(),
          child: Text(
            'Primary Button',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ThemeUtil.getElevatedButtonStyle(isPrimary: false),
          child: Text(
            'Secondary Button',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            'Text Button',
            style: GoogleFonts.manrope(
              color: AppConstants.outlinebg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppConstants.outlinebg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Outlined Button',
            style: GoogleFonts.manrope(
              color: AppConstants.outlinebg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: AppConstants.outlinebg),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.star, color: ThemeUtil.getIconColor()),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: ThemeUtil.getIconColor()),
            ),
          ],
        ),
      ],
    );
  }
} 