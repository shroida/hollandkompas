import 'package:flutter/material.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';
import 'package:hollandkompas/features/admin/presentation/views/mobile_admin_dashboard.dart';
import 'package:hollandkompas/features/admin/presentation/views/tablet_admin_dashboard.dart';
import 'package:hollandkompas/features/admin/presentation/views/desktop_admin_dashboard.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      mobile: MobileAdminDashboard(),
      tablet: TabletAdminDashboard(),
      desktop: DesktopAdminDashboard(),
    );
  }
}