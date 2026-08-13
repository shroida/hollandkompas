import 'package:flutter/material.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_grid.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_header.dart';

class DesktopAdminDashboard extends StatelessWidget {
  const DesktopAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 40),
            DashboardGrid(crossAxisCount: 4),
          ],
        ),
      ),
    );
  }
}
