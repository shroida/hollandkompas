import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/theme/theme_provider.dart';
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
                // =========================
                // PROFILE MENU
                // =========================
                _ProfileMenu(
                  firstName: firstName,
                  level: level,
                  onMyCourses: onMyCourses,
                  onProfile: onProfile,
                  onSettings: onSettings,
                  onLogout: onLogout,
                ),

                const SizedBox(width: 14),

                // =========================
                // WELCOME
                // =========================
                Expanded(child: _WelcomeSection(firstName: firstName)),

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
// WELCOME SECTION
// ============================================================

class _WelcomeSection extends StatelessWidget {
  final String firstName;

  const _WelcomeSection({required this.firstName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back 👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          firstName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
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

// ============================================================
// PROFILE MENU
// ============================================================

class _ProfileMenu extends StatelessWidget {
  final String firstName;
  final String level;

  final VoidCallback? onMyCourses;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  const _ProfileMenu({
    required this.firstName,
    required this.level,
    this.onMyCourses,
    this.onProfile,
    this.onSettings,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ProfileMenuAction>(
      tooltip: 'Account menu',

      offset: const Offset(0, 58),

      elevation: 10,

      color: Theme.of(context).colorScheme.surface,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      onSelected: (action) {
        switch (action) {
          case _ProfileMenuAction.myCourses:
            onMyCourses?.call();
            break;

          case _ProfileMenuAction.profile:
            onProfile?.call();
            break;

          case _ProfileMenuAction.settings:
            onSettings?.call();
            break;

          case _ProfileMenuAction.logout:
            _showLogoutDialog(context);
            break;
        }
      },

      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: _ProfileMenuHeader(firstName: firstName, level: level),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem(
          value: _ProfileMenuAction.myCourses,
          child: _MenuItem(icon: Icons.menu_book_rounded, title: 'My Courses'),
        ),

        const PopupMenuItem(
          value: _ProfileMenuAction.profile,
          child: _MenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Profile',
          ),
        ),

        const PopupMenuItem(
          value: _ProfileMenuAction.settings,
          child: _MenuItem(icon: Icons.settings_outlined, title: 'Settings'),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem(
          value: _ProfileMenuAction.logout,
          child: _MenuItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            destructive: true,
          ),
        ),
      ],

      child: _ProfileAvatar(firstName: firstName),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),

          content: Text(
            'Are you sure you want to logout?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),

            const SizedBox(width: 8),

            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onLogout?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.destructive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// PROFILE AVATAR
// ============================================================

class _ProfileAvatar extends StatelessWidget {
  final String firstName;

  const _ProfileAvatar({required this.firstName});

  @override
  Widget build(BuildContext context) {
    final initial = firstName.trim().isNotEmpty
        ? firstName.trim()[0].toUpperCase()
        : '?';

    return Tooltip(
      message: 'Account',

      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFFFF8A3D)],
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE MENU HEADER
// ============================================================

class _ProfileMenuHeader extends StatelessWidget {
  final String firstName;
  final String level;

  const _ProfileMenuHeader({required this.firstName, required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfileAvatar(firstName: firstName),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 3),

              Row(
                children: [
                  const Icon(
                    Icons.school_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    'Student • ${level.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MENU ITEM
// ============================================================

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool destructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? AppColors.destructive
        : Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: destructive
                ? AppColors.destructive.withValues(alpha: 0.08)
                : AppColors.muted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MENU ACTION
// ============================================================

enum _ProfileMenuAction { myCourses, profile, settings, logout }
