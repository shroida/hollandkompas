import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/theme/theme_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/profile_menu.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/toggle_theme.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/welcome_section.dart';
import 'package:hollandkompas/features/home/presentation/widgets/course_image.dart';
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

                LevelBadge(level: level),

                const SizedBox(width: 8),

                ThemeToggle(
                  isDark: isDark,
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),

                const SizedBox(width: 8),

                const LanguageSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
