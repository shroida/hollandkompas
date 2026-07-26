import 'package:flutter/material.dart';
import 'package:hollandkompas/core/router/app_router.dart';

class HollandKompas extends StatelessWidget {
  const HollandKompas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'HollandKompas',
      routerConfig: appRouter,
    );
  }
}