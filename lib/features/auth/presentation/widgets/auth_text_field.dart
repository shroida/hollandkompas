import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final Widget? suffix;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.suffix,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = AppColors.textColor(context);
    final subtitleColor = AppColors.subtitleColor(context);
    final borderColor = AppColors.borderColor(context);
    final cardColor = AppColors.cardColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================
        // Label
        // =========================
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        const SizedBox(height: 6),

        // =========================
        // Text Field
        // =========================
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,

          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),

          cursorColor: colorScheme.primary,

          textDirection:
              (keyboardType == TextInputType.emailAddress || obscureText)
              ? TextDirection.ltr
              : TextDirection.rtl,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: TextStyle(color: subtitleColor, fontSize: 14),

            prefixIcon: icon != null
                ? Icon(icon, color: subtitleColor, size: 20)
                : null,

            suffixIcon: suffix,

            // =========================
            // Background
            // =========================
            filled: true,
            fillColor: cardColor,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // =========================
            // Normal Border
            // =========================
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),

            // =========================
            // Focused Border
            // =========================
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),

            // =========================
            // Error Border
            // =========================
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
