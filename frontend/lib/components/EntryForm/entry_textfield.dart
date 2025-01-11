import 'package:flutter/material.dart';
import 'package:frontend/components/Color/theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// A *reusable* custom text field widget for user input.
class EntryTextField extends StatefulWidget {

  /// Controller for managing the input text
  final TextEditingController controller;

  /// Hint text displayed when the input is empty
  final String hintText;

  /// Label text displayed above the text field
  final String label;

  /// Determines whether the text is obscured
  final bool obscureText;

  /// Icon to display inside the text field
  final String icon;

  const EntryTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.obscureText,
    required this.icon,
  });

  @override
  State<EntryTextField> createState() => _EntryTextFieldState();
}

class _EntryTextFieldState extends State<EntryTextField> {

  // FocusNode to track focus state of the text field
  final FocusNode _focusNode = FocusNode();

  // Tracks whether the text field is focused
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  // Clean up the focus node when the widget is removed.
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(

      // Horizontal padding for alignment.
      padding: const EdgeInsets.symmetric(horizontal: 40.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label displayed above the text field.
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'BaiJamjuree',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // The text field with icon and focus styling
          Container(
            decoration: BoxDecoration(
              // Subtle shadow effect.
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              decoration: InputDecoration(

                // Default border
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: MainTheme.textfieldBorder), 
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),

                // Focused border.
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: MainTheme.textfieldFocus),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),

                // color for textfield
                fillColor: MainTheme.textfieldBackground,
                filled: true,

                hintText: widget.hintText,

                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: MainTheme.placeholderText, // Placeholder text color.
                  fontFamily: 'BaiJamjuree',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),

                // Icon in text field
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Iconify(
                    // Display the provided icon
                    widget.icon, 
                    color: _isFocused
                        ? MainTheme.textfieldFocus // Icon color when focused
                        : MainTheme.placeholderText, // Default icon color
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
