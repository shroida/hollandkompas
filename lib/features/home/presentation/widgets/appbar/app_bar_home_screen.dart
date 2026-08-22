import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/theme/theme_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/profile_menu.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/welcome_section.dart';
import 'package:hollandkompas/shared/widgets/language_selector.dart';

class AppBarHomeScreen extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarHomeScreen({
    super.key,
    required this.firstName,
    required this.level,
    this.onMyCourses,
    this.onProfile,
    this.onSettings,
    this.onLogout,
  });

  final String firstName;
  final String level;

  final VoidCallback? onMyCourses;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  @override
  Size get preferredSize => const Size.fromHeight(132);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.headerBlue,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.headerBlue.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Container(
            height: 88,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                ProfileMenu(
                  firstName: firstName,
                  level: level,
                  onMyCourses: onMyCourses,
                  onProfile: onProfile,
                  onSettings: onSettings,
                  onLogout: onLogout,
                ),

                const SizedBox(width: 14),

                Expanded(child: WelcomeSection(firstName: firstName)),

                const SizedBox(width: 10),

                // =========================
                // LEVEL
                // =========================
                _LevelBadge(level: level),

                const SizedBox(width: 8),

                // =========================
                // THEME TOGGLE
                // =========================
                _ThemeToggle(
                  isDark: isDark,
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),

                const SizedBox(width: 8),

                // =========================
                // LANGUAGE
                // =========================
                const LanguageSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LEVEL BADGE
// ============================================================

class _LevelBadge extends StatelessWidget {
  final String level;

  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: AppColors.primary,
              size: 15,
            ),
          ),

          const SizedBox(width: 7),

          Text(
            level.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// THEME TOGGLE
// ============================================================

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _ThemeToggle({required this.isDark, required this.onPressed});

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
