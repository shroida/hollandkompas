import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const ThemeToggle({super.key, required this.isDark, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkMuted : AppColors.muted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                size: 20,
                color: isDark ? AppColors.warning : AppColors.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
