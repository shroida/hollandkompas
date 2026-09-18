import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key, required this.isDark, required this.onPressed});

  final bool isDark;
  final VoidCallback onPressed;

  static const _size = 42.0;
  static const _radius = 14.0;
  static const _animationDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_radius),
          child: AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkMuted : AppColors.muted,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: AnimatedSwitcher(
              duration: _animationDuration,
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
