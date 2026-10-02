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

  static const _height = 106.0;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final isDark = ref.watch(
      themeModeProvider.select((mode) => mode == ThemeMode.dark),
    );

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _HomeHeader(
                firstName: firstName,
                level: level,
                isDark: isDark,
                isCompact: constraints.maxWidth < 760,
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
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.firstName,
    required this.level,
    required this.isDark,
    required this.isCompact,
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
  final VoidCallback onToggleTheme;
  final VoidCallback? onMyCourses;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.055),
            blurRadius: 24,
            offset: const Offset(0, 7),
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

          if (!isCompact) ...[
            const SizedBox(width: 12),
            LevelBadge(level: level),
          ],

          const SizedBox(width: 8),

          _HeaderAction(
            child: ThemeToggle(isDark: isDark, onPressed: onToggleTheme),
          ),

          const SizedBox(width: 6),

          _HeaderAction(child: const LanguageSelector()),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.mutedColor(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.30 : 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),

          const SizedBox(width: 8),

          Text(
            level.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
