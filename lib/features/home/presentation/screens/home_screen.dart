import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';

import 'package:hollandkompas/features/home/presentation/views/desktop_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/mobile_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/tablet_home_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final locale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HollandKompas'),
        actions: [
          DropdownButton<String>(
            value: locale.languageCode,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: 'ar',
                child: Text('🇪🇬 العربية'),
              ),
              DropdownMenuItem(
                value: 'nl',
                child: Text('🇳🇱 Nederlands'),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text('🇺🇸 English'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(appLocaleProvider.notifier)
                    .changeLanguage(value);
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const ResponsiveBuilder(
        mobile: MobileHomeView(),
        tablet: TabletHomeView(),
        desktop: DesktopHomeView(),
      ),
    );
  }
} 