import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType typeController;
  final String errorMessage;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData? icon;
  final int maxLines;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.typeController,
    required this.errorMessage,
    required this.hintText,
    required this.labelText,
    this.icon,
    this.maxLines = 1,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: typeController,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[100],
          prefixIcon: icon != null ? Icon(icon) : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: icon != null ? 16 : 20,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }
}
