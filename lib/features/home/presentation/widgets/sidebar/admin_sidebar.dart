import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key, this.selectedIndex = 0, this.onItemSelected});

  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  static const _items = [
    _SidebarItem(title: 'Dashboard', icon: Icons.dashboard_rounded),
    _SidebarItem(title: 'Students', icon: Icons.people_alt_rounded),
    _SidebarItem(title: 'Courses', icon: Icons.menu_book_rounded),
    _SidebarItem(title: 'Lessons', icon: Icons.play_lesson_rounded),
    _SidebarItem(title: 'Quizzes', icon: Icons.quiz_rounded),
    _SidebarItem(title: 'Statistics', icon: Icons.bar_chart_rounded),
    _SidebarItem(title: 'Settings', icon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),

          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'HollandKompas',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),

          Text(
            'Admin Panel',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final selected = index == selectedIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withOpacity(.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        color: selected
                            ? AppColors.primary
                            : Colors.grey.shade700,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: selected ? AppColors.primary : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      onTap: () => onItemSelected?.call(index),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              tileColor: Colors.red.withOpacity(.06),
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // TODO: Logout
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final String title;
  final IconData icon;

  const _SidebarItem({required this.title, required this.icon});
}
