import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool learningReminders = true;
  bool autoPlayPronunciation = true;

  String selectedLevel = 'A2';

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(themeModeProvider);

    final currentLanguage = _getLanguageName(locale.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),

          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),

            children: [
              _SettingsHeader(language: currentLanguage, level: selectedLevel),

              const SizedBox(height: 28),

              const _SectionTitle(
                title: 'Appearance',
                subtitle: 'Customize how HollandKompas looks',
                icon: Icons.palette_outlined,
              ),

              const SizedBox(height: 12),

              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'Choose your preferred language',

                    trailing: _LanguageSelector(
                      currentLanguage: currentLanguage,
                      onChanged: _changeLanguage,
                    ),
                  ),

                  const _SettingsDivider(),

                  _SettingsTile(
                    icon: Icons.brightness_6_outlined,
                    title: 'Theme',
                    subtitle: 'Choose your preferred appearance',

                    trailing: _ThemeSelector(
                      currentMode: themeMode,
                      onChanged: (mode) {
                        ref.read(themeModeProvider.notifier).setTheme(mode);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const _SectionTitle(
                title: 'Learning',
                subtitle: 'Personalize your Dutch learning experience',
                icon: Icons.school_outlined,
              ),

              const SizedBox(height: 12),

              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.signal_cellular_alt_rounded,
                    title: 'Learning Level',
                    subtitle: 'Choose your current Dutch level',

                    trailing: _LevelSelector(
                      value: selectedLevel,
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = value;
                        });

                        // TODO:
                        // Save selected level to Supabase.
                      },
                    ),
                  ),

                  const _SettingsDivider(),

                  _SettingsTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Learning Reminders',
                    subtitle: 'Get reminded to practice Dutch',

                    trailing: Switch.adaptive(
                      value: learningReminders,

                      onChanged: (value) {
                        setState(() {
                          learningReminders = value;
                        });

                        // TODO:
                        // Save notification preference.
                      },
                    ),
                  ),

                  const _SettingsDivider(),

                  _SettingsTile(
                    icon: Icons.volume_up_outlined,
                    title: 'Auto-play Pronunciation',
                    subtitle: 'Automatically play Dutch pronunciation',

                    trailing: Switch.adaptive(
                      value: autoPlayPronunciation,

                      onChanged: (value) {
                        setState(() {
                          autoPlayPronunciation = value;
                        });

                        // TODO:
                        // Save pronunciation preference.
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const _SectionTitle(
                title: 'Learning Data',
                subtitle: 'Manage your learning progress',
                icon: Icons.insights_outlined,
              ),

              const SizedBox(height: 12),

              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.restart_alt_rounded,
                    title: 'Reset Learning Progress',
                    subtitle: 'Delete your lesson progress',

                    destructive: true,

                    onTap: () {
                      _showResetProgressDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const _SectionTitle(
                title: 'Account',
                subtitle: 'Manage your HollandKompas account',
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 12),

              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    subtitle: 'Update your account password',

                    onTap: () {
                      // TODO:
                      // Navigate to change password screen.
                    },
                  ),

                  const _SettingsDivider(),

                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Sign out from your account',

                    destructive: true,

                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 36),

              const _AppFooter(),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'nl':
        return 'Nederlands';

      case 'ar':
        return 'العربية';

      case 'en':
      default:
        return 'English';
    }
  }

  void _changeLanguage(String language) {
    String languageCode;

    switch (language) {
      case 'English':
        languageCode = 'en';
        break;

      case 'Nederlands':
        languageCode = 'nl';
        break;

      case 'العربية':
        languageCode = 'ar';
        break;

      default:
        languageCode = 'en';
    }

    ref.read(appLocaleProvider.notifier).changeLanguage(languageCode);
  }

  void _showResetProgressDialog(BuildContext context) {
    showDialog<void>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: AppColors.destructive.withValues(alpha: 0.10),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.restart_alt_rounded,
              color: AppColors.destructive,
            ),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text(
            'Reset learning progress?',
            textAlign: TextAlign.center,

            style: TextStyle(fontWeight: FontWeight.w700),
          ),

          content: Text(
            'This will permanently delete your lesson progress. '
            'Your enrolled courses will not be removed.',

            textAlign: TextAlign.center,

            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },

                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      _resetProgress();
                    },

                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,

                      minimumSize: const Size(double.infinity, 48),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _resetProgress() {
    // TODO:
    // Call reset progress use case.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Learning progress has been reset.')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: AppColors.destructive.withValues(alpha: 0.10),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.logout_rounded,
              color: AppColors.destructive,
            ),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text(
            'Logout',
            textAlign: TextAlign.center,

            style: TextStyle(fontWeight: FontWeight.w700),
          ),

          content: Text(
            'Are you sure you want to logout?',

            textAlign: TextAlign.center,

            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },

                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      // TODO:
                      // Call logout provider/use case.
                    },

                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,

                      minimumSize: const Size(double.infinity, 48),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String language;
  final String level;

  const _SettingsHeader({required this.language, required this.level});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
        ),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: AppColors.primary,

              borderRadius: BorderRadius.circular(18),

              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),

                  blurRadius: 16,

                  offset: const Offset(0, 7),
                ),
              ],
            ),

            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Settings',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Personalize your learning experience',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,

                  children: [
                    _HeaderBadge(icon: Icons.language_rounded, text: language),

                    _HeaderBadge(icon: Icons.school_rounded, text: level),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeaderBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

      decoration: BoxDecoration(
        color: AppColors.cardColor(context),

        borderRadius: BorderRadius.circular(9),

        border: Border.all(color: AppColors.borderColor(context)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 13, color: AppColors.primary),

          const SizedBox(width: 5),

          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),

            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(icon, size: 20, color: AppColors.primary),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.borderColor(context)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.10
                  : 0.045,
            ),

            blurRadius: 18,

            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Column(children: children),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      endIndent: 16,
      color: AppColors.borderColor(context),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = destructive ? AppColors.destructive : AppColors.primary;

    final titleColor = destructive
        ? AppColors.destructive
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

        child: Row(
          children: [
            // ---------------------------------------------------------
            // ICON
            // ---------------------------------------------------------
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.09),

                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(icon, size: 21, color: iconColor),
            ),

            const SizedBox(width: 14),

            // ---------------------------------------------------------
            // TEXT
            // ---------------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            if (trailing != null)
              Flexible(child: trailing!)
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.subtitleColor(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onChanged;

  const _LanguageSelector({
    required this.currentLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentLanguage,

        borderRadius: BorderRadius.circular(16),

        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),

        items: const [
          DropdownMenuItem(value: 'English', child: Text('English')),

          DropdownMenuItem(value: 'Nederlands', child: Text('Nederlands')),

          DropdownMenuItem(value: 'العربية', child: Text('العربية')),
        ],

        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _LevelSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,

        borderRadius: BorderRadius.circular(16),

        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),

        items: const [
          DropdownMenuItem(value: 'A1', child: Text('A1')),

          DropdownMenuItem(value: 'A2', child: Text('A2')),

          DropdownMenuItem(value: 'B1', child: Text('B1')),

          DropdownMenuItem(value: 'B2', child: Text('B2')),

          DropdownMenuItem(value: 'C1', child: Text('C1')),
        ],

        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelector({required this.currentMode, required this.onChanged});

  String _label() {
    switch (currentMode) {
      case ThemeMode.light:
        return 'Light';

      case ThemeMode.dark:
        return 'Dark';

      case ThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      initialValue: currentMode,

      tooltip: 'Choose theme',

      position: PopupMenuPosition.under,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      onSelected: onChanged,

      itemBuilder: (context) => [
        const PopupMenuItem(
          value: ThemeMode.system,

          child: Row(
            children: [
              Icon(Icons.brightness_auto_rounded, size: 20),

              SizedBox(width: 10),

              Text('System'),
            ],
          ),
        ),

        const PopupMenuItem(
          value: ThemeMode.light,

          child: Row(
            children: [
              Icon(Icons.light_mode_rounded, size: 20),

              SizedBox(width: 10),

              Text('Light'),
            ],
          ),
        ),

        const PopupMenuItem(
          value: ThemeMode.dark,

          child: Row(
            children: [
              Icon(Icons.dark_mode_rounded, size: 20),

              SizedBox(width: 10),

              Text('Dark'),
            ],
          ),
        ),
      ],

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),

        decoration: BoxDecoration(
          color: AppColors.muted,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              currentMode == ThemeMode.dark
                  ? Icons.dark_mode_rounded
                  : currentMode == ThemeMode.light
                  ? Icons.light_mode_rounded
                  : Icons.brightness_auto_rounded,

              size: 16,

              color: AppColors.primary,
            ),

            const SizedBox(width: 6),

            Text(
              _label(),

              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),

            const SizedBox(width: 3),

            const Icon(Icons.keyboard_arrow_down_rounded, size: 17),
          ],
        ),
      ),
    );
  }
}

class _AppFooter extends StatelessWidget {
  const _AppFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 46,
          height: 46,

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [AppColors.primary, AppColors.secondary],
            ),

            borderRadius: BorderRadius.circular(14),
          ),

          child: const Icon(
            Icons.language_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'HollandKompas',

          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Learn Dutch. Build your future.',

          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Version 1.0.0',

          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
