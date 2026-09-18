import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
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

  final String label;
  final String hint;
  final IconData? icon;
  final Widget? suffix;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  bool get _usesLtrText =>
      keyboardType == TextInputType.emailAddress ||
      keyboardType == TextInputType.phone ||
      obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          textDirection: _usesLtrText ? TextDirection.ltr : TextDirection.rtl,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 20, color: AppColors.subtitleColor(context)),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.cardColor(context),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: _border(context),
            enabledBorder: _border(context),
            focusedBorder: _border(context, color: AppColors.primary, width: 2),
            errorBorder: _border(context, color: theme.colorScheme.error),
            focusedErrorBorder: _border(
              context,
              color: theme.colorScheme.error,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(
    BuildContext context, {
    Color? color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color ?? AppColors.borderColor(context),
        width: width,
      ),
    );
  }
}
