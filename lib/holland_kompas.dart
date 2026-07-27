import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/router/app_router.dart';
import 'package:hollandkompas/core/theme/app_theme.dart';

class HollandKompas extends ConsumerWidget {
  const HollandKompas({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final locale = ref.watch(
      appLocaleProvider,
    );

   return MaterialApp.router(
  debugShowCheckedModeBanner: false,
  title: 'HollandKompas',

  routerConfig: appRouter,

  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,

  locale: locale,

  builder: (context, child) {
    return Directionality(
      textDirection:
          locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: child!,
    );
  },
);
  }
}