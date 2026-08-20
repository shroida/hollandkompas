import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/admin_sidebar.dart';

class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool collapsed = false;

  void _toggleSidebar() {
    setState(() {
      collapsed = !collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    if (isMobile) {
      return _buildMobile(context);
    }

    if (isTablet) {
      return _buildTablet(context);
    }

    return _buildDesktop(context);
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          AdminSidebar(collapsed: collapsed, onToggle: _toggleSidebar),

          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          AdminSidebar(collapsed: true, onToggle: _toggleSidebar),

          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: AdminSidebar(
            collapsed: false,
            onItemSelected: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              tooltip: 'Menu',
              icon: Icon(
                Icons.menu_rounded,
                color: AppColors.textColor(context),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.explore_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Admin',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
