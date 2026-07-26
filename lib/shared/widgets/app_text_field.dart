import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon),

        filled: true,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}