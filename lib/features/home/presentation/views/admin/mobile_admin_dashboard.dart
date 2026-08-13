import 'package:flutter/material.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_grid.dart'
    show DashboardGrid;
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_header.dart';

class MobileAdminDashboard extends StatelessWidget {
  const MobileAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 24),
            DashboardGrid(crossAxisCount: 1),
          ],
        ),
      ),
    );
  }
}
