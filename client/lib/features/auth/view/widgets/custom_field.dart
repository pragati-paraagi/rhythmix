import 'package:flutter/material.dart';

// Reusable widget for the input fields
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;  // Optional controller
  final bool isReadOnly;
  final VoidCallback? onTap;  // Callback for onTap action

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.isReadOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,  // Assign controller if provided
      readOnly: isReadOnly,
      onTap: isReadOnly ? onTap : null,  // Assign onTap if readOnly is true
      cursorColor: Colors.white54,  // Make cursor white
      style: TextStyle(color: Colors.white54),  // Text color inside the field
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white54),  // Default label color (unfocused state)
        floatingLabelBehavior: FloatingLabelBehavior.auto,  // Keep label floating
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 75, 134, 155), // Inactive border color (custom color)
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // Active border color (grey)
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isReadOnly ? Icon(Icons.file_upload, color: Colors.white54) : null,  // Icon for pick song, white icon
      ),
    );
  }
}
