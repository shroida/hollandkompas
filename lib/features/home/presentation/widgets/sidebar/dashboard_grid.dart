import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key, required this.crossAxisCount});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: const [
        _PlaceholderCard(
          title: "Total Students",
          icon: Icons.people_alt_rounded,
        ),
        _PlaceholderCard(title: "Total Courses", icon: Icons.menu_book_rounded),
        _PlaceholderCard(title: "Recent Activity", icon: Icons.history_rounded),
        _PlaceholderCard(title: "Analytics", icon: Icons.bar_chart_rounded),
      ],
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 40),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
