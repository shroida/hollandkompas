import 'package:flutter/material.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';
import 'package:hollandkompas/features/home/presentation/views/desktop_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/mobile_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/tablet_home_view.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobile: MobileHomeView(),
      tablet: TabletHomeView(),
      desktop: DesktopHomeView(),
    );
  }
}