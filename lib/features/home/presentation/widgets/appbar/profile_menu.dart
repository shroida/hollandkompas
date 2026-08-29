import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class ProfileMenu extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final language = locale.languageCode.toLowerCase();

    final t = ProfileTranslations(language);

    return PopupMenuButton<ProfileMenuAction>(
      tooltip: t.accountMenu,

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
            _showLogoutDialog(context, t);
            break;
        }
      },

      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: ProfileMenuHeader(
            firstName: firstName,
            level: level,
            translations: t,
          ),
        ),

        const PopupMenuDivider(),

        PopupMenuItem(
          value: ProfileMenuAction.myCourses,
          child: _MenuItem(icon: Icons.menu_book_rounded, title: t.myCourses),
        ),

        PopupMenuItem(
          value: ProfileMenuAction.profile,
          child: _MenuItem(
            icon: Icons.person_outline_rounded,
            title: t.profile,
          ),
        ),

        PopupMenuItem(
          value: ProfileMenuAction.settings,
          child: _MenuItem(icon: Icons.settings_outlined, title: t.settings),
        ),

        const PopupMenuDivider(),

        PopupMenuItem(
          value: ProfileMenuAction.logout,
          child: _MenuItem(
            icon: Icons.logout_rounded,
            title: t.logout,
            destructive: true,
          ),
        ),
      ],

      child: _ProfileAvatar(firstName: firstName, tooltip: t.account),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileTranslations t) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(
            t.logout,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),

          content: Text(
            t.logoutConfirmation,
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
              child: Text(t.cancel),
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
              child: Text(t.logout),
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
  final String tooltip;

  const _ProfileAvatar({required this.firstName, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    final initial = firstName.trim().isNotEmpty
        ? firstName.trim()[0].toUpperCase()
        : '?';

    return Tooltip(
      message: tooltip,

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
  final ProfileTranslations translations;

  const ProfileMenuHeader({
    super.key,
    required this.firstName,
    required this.level,
    required this.translations,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfileAvatar(firstName: firstName, tooltip: translations.account),

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
                    '${translations.student} • ${level.toUpperCase()}',
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

class ProfileTranslations {
  final String language;

  const ProfileTranslations(this.language);

  String get account => _tr(en: 'Account', nl: 'Account', ar: 'الحساب');

  String get accountMenu =>
      _tr(en: 'Account menu', nl: 'Accountmenu', ar: 'قائمة الحساب');

  String get myCourses =>
      _tr(en: 'My Courses', nl: 'Mijn cursussen', ar: 'كورساتي');

  String get profile => _tr(en: 'Profile', nl: 'Profiel', ar: 'الملف الشخصي');

  String get settings =>
      _tr(en: 'Settings', nl: 'Instellingen', ar: 'الإعدادات');

  String get logout => _tr(en: 'Logout', nl: 'Uitloggen', ar: 'تسجيل الخروج');

  String get cancel => _tr(en: 'Cancel', nl: 'Annuleren', ar: 'إلغاء');

  String get logoutConfirmation => _tr(
    en: 'Are you sure you want to logout?',
    nl: 'Weet je zeker dat je wilt uitloggen?',
    ar: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
  );

  String get student => _tr(en: 'Student', nl: 'Student', ar: 'طالب');

  String _tr({required String en, required String nl, required String ar}) {
    switch (language) {
      case 'nl':
        return nl;
      case 'ar':
        return ar;
      case 'en':
      default:
        return en;
    }
  }
}
