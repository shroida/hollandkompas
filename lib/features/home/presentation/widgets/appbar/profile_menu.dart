import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(
      appLocaleProvider.select((locale) => locale.languageCode.toLowerCase()),
    );
    final translations = ProfileTranslations(language);

    return PopupMenuButton<ProfileMenuAction>(
      tooltip: translations.accountMenu,
      offset: const Offset(0, 58),
      elevation: 10,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (action) => _handleAction(context, action, translations),
      itemBuilder: (context) => [
        PopupMenuItem<ProfileMenuAction>(
          enabled: false,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: ProfileMenuHeader(
            firstName: firstName,
            level: level,
            translations: translations,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: ProfileMenuAction.myCourses,
          child: _MenuItem(
            icon: Icons.menu_book_rounded,
            title: translations.myCourses,
          ),
        ),
        PopupMenuItem(
          value: ProfileMenuAction.profile,
          child: _MenuItem(
            icon: Icons.person_outline_rounded,
            title: translations.profile,
          ),
        ),
        PopupMenuItem(
          value: ProfileMenuAction.settings,
          child: _MenuItem(
            icon: Icons.settings_outlined,
            title: translations.settings,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: ProfileMenuAction.logout,
          child: _MenuItem(
            icon: Icons.logout_rounded,
            title: translations.logout,
            destructive: true,
          ),
        ),
      ],
      child: _ProfileAvatar(
        firstName: firstName,
        tooltip: translations.account,
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    ProfileMenuAction action,
    ProfileTranslations translations,
  ) {
    switch (action) {
      case ProfileMenuAction.myCourses:
        onMyCourses?.call();
      case ProfileMenuAction.profile:
        onProfile?.call();
      case ProfileMenuAction.settings:
        onSettings?.call();
      case ProfileMenuAction.logout:
        _showLogoutDialog(context, translations);
    }
  }

  void _showLogoutDialog(
    BuildContext context,
    ProfileTranslations translations,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            translations.logout,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            translations.logoutConfirmation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions: [
            TextButton(
              onPressed: dialogContext.pop,
              child: Text(translations.cancel),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                dialogContext.pop();
                onLogout?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(translations.logout),
            ),
          ],
        );
      },
    );
  }
}

enum ProfileMenuAction { myCourses, profile, settings, logout }

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = destructive ? colorScheme.error : colorScheme.onSurface;

    final backgroundColor = destructive
        ? colorScheme.error.withValues(alpha: 0.08)
        : colorScheme.surfaceContainerHighest;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.firstName, required this.tooltip});

  final String firstName;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final trimmedName = firstName.trim();
    final initial = trimmedName.isEmpty
        ? '?'
        : trimmedName.characters.first.toUpperCase();

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.primaryContainer],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class ProfileMenuHeader extends StatelessWidget {
  const ProfileMenuHeader({
    super.key,
    required this.firstName,
    required this.level,
    required this.translations,
  });

  final String firstName;
  final String level;
  final ProfileTranslations translations;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.school_rounded,
                    size: 13,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${translations.student} • ${level.toUpperCase()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
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
  const ProfileTranslations(this.language);

  final String language;

  String get account => _translate(en: 'Account', nl: 'Account', ar: 'الحساب');

  String get accountMenu =>
      _translate(en: 'Account menu', nl: 'Accountmenu', ar: 'قائمة الحساب');

  String get myCourses =>
      _translate(en: 'My Courses', nl: 'Mijn cursussen', ar: 'كورساتي');

  String get profile =>
      _translate(en: 'Profile', nl: 'Profiel', ar: 'الملف الشخصي');

  String get settings =>
      _translate(en: 'Settings', nl: 'Instellingen', ar: 'الإعدادات');

  String get logout =>
      _translate(en: 'Logout', nl: 'Uitloggen', ar: 'تسجيل الخروج');

  String get cancel => _translate(en: 'Cancel', nl: 'Annuleren', ar: 'إلغاء');

  String get logoutConfirmation => _translate(
    en: 'Are you sure you want to logout?',
    nl: 'Weet je zeker dat je wilt uitloggen?',
    ar: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
  );

  String get student => _translate(en: 'Student', nl: 'Student', ar: 'طالب');

  String _translate({
    required String en,
    required String nl,
    required String ar,
  }) {
    return switch (language) {
      'nl' => nl,
      'ar' => ar,
      _ => en,
    };
  }
}
