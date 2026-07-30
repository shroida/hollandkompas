import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final Widget? suffix;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon:
                icon != null
                    ? Icon(icon)
                    : null,
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}