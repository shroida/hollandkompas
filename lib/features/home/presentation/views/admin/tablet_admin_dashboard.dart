import 'package:flutter/material.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_grid.dart'
    show DashboardGrid;
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_header.dart';

class TabletAdminDashboard extends StatelessWidget {
  const TabletAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 30),
            DashboardGrid(crossAxisCount: 2),
          ],
        ),
      ),
    );
  }
}
