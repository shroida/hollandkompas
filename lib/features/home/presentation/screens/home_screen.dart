import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';
import 'package:hollandkompas/features/home/presentation/views/mobile_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/tablet_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/desktop_home_view.dart';
import 'package:hollandkompas/shared/widgets/language_selector.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const firstName = "Mohamed";
    const level = "A2";

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBarHomeScreen(firstName: firstName, level: level),

      body: const ResponsiveBuilder(
        mobile: MobileHomeView(),
        tablet: TabletHomeView(),
        desktop: DesktopHomeView(),
      ),
    );
  }
}

