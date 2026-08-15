import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/core/theme/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      tooltip: isDark ? 'Light Mode' : 'Dark Mode',
      onPressed: () {
        ref.read(themeModeProvider.notifier).state = isDark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.7, end: 1).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(isDark),
        ),
      ),
    );
  }
}
