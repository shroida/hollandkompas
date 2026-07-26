import 'package:flutter/material.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: const MobileHomeView(),
      tablet: const TabletHomeView(),
      desktop: const DesktopHomeView(),
    );
  }
}