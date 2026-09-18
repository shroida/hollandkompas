import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/theme/theme_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/profile_menu.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/toggle_theme.dart';
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

  static const _height = 124.0;
  static const _contentHeight = 90.0;
  static const _horizontalPadding = 16.0;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(
      themeModeProvider.select((mode) => mode == ThemeMode.dark),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.headerBlue,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.headerBlue.withValues(alpha: 0.20),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              10,
              _horizontalPadding,
              14,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _AppBarContent(
                  firstName: firstName,
                  level: level,
                  isDark: isDark,
                  isCompact: constraints.maxWidth < 700,
                  surfaceColor: theme.colorScheme.surface,
                  onMyCourses: onMyCourses,
                  onProfile: onProfile,
                  onSettings: onSettings,
                  onLogout: onLogout,
                  onToggleTheme: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent({
    required this.firstName,
    required this.level,
    required this.isDark,
    required this.isCompact,
    required this.surfaceColor,
    required this.onToggleTheme,
    this.onMyCourses,
    this.onProfile,
    this.onSettings,
    this.onLogout,
  });

  final String firstName;
  final String level;
  final bool isDark;
  final bool isCompact;
  final Color surfaceColor;
  final VoidCallback onToggleTheme;
  final VoidCallback? onMyCourses;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppBarHomeScreen._contentHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
          const SizedBox(width: 12),
          Expanded(child: WelcomeSection(firstName: firstName)),
          if (!isCompact) ...[
            const SizedBox(width: 10),
            LevelBadge(level: level),
          ],
          const SizedBox(width: 8),
          ThemeToggle(isDark: isDark, onPressed: onToggleTheme),
          const SizedBox(width: 6),
          const LanguageSelector(),
        ],
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final String level;

  static const _height = 42.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.symmetric(horizontal: 11),
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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
