import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class ProfileMenu extends StatelessWidget {
  final String firstName;
  final String level;

  final VoidCallback? onMyCourses;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  const ProfileMenu({
    super.key,
    required this.firstName,
    required this.level,
    this.onMyCourses,
    this.onProfile,
    this.onSettings,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProfileMenuAction>(
      tooltip: 'Account menu',

      offset: const Offset(0, 58),

      elevation: 10,

      color: Theme.of(context).colorScheme.surface,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      onSelected: (action) {
        switch (action) {
          case ProfileMenuAction.myCourses:
            onMyCourses?.call();
            break;

          case ProfileMenuAction.profile:
            onProfile?.call();
            break;

          case ProfileMenuAction.settings:
            onSettings?.call();
            break;

          case ProfileMenuAction.logout:
            _showLogoutDialog(context);
            break;
        }
      },

      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: ProfileMenuHeader(firstName: firstName, level: level),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem(
          value: ProfileMenuAction.myCourses,
          child: _MenuItem(icon: Icons.menu_book_rounded, title: 'My Courses'),
        ),

        const PopupMenuItem(
          value: ProfileMenuAction.profile,
          child: _MenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Profile',
          ),
        ),

        const PopupMenuItem(
          value: ProfileMenuAction.settings,
          child: _MenuItem(icon: Icons.settings_outlined, title: 'Settings'),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem(
          value: ProfileMenuAction.logout,
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

enum ProfileMenuAction { myCourses, profile, settings, logout }

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

class ProfileMenuHeader extends StatelessWidget {
  final String firstName;
  final String level;

  const ProfileMenuHeader({
    super.key,
    required this.firstName,
    required this.level,
  });

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
