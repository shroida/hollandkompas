import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class AdminSidebar extends StatelessWidget {
  final bool collapsed;
  final VoidCallback? onToggle;
  final VoidCallback? onItemSelected;

  const AdminSidebar({
    super.key,
    this.collapsed = false,
    this.onToggle,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: collapsed ? 82 : 260,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: AppColors.borderColor(context)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),

          _buildLogo(context),

          const SizedBox(height: 32),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _sectionTitle(context, 'MAIN'),

                  _AdminMenuItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/home'),
                    onTap: () {
                      context.go('/home');
                      onItemSelected?.call();
                    },
                  ),

                  _AdminMenuItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Students',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/admin/students'),
                    onTap: () {
                      context.go('/admin/students');
                      onItemSelected?.call();
                    },
                  ),

                  _AdminMenuItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Courses',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/admin/courses'),
                    onTap: () {
                      context.go('/admin/courses');
                      onItemSelected?.call();
                    },
                  ),

                  _AdminMenuItem(
                    icon: Icons.play_lesson_rounded,
                    title: 'Lessons',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/admin/lessons'),
                    onTap: () {
                      context.go('/admin/lessons');
                      onItemSelected?.call();
                    },
                  ),

                  _AdminMenuItem(
                    icon: Icons.assignment_ind_rounded,
                    title: 'Enrollments',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/admin/enrollments'),
                    onTap: () {
                      context.go('/admin/enrollments');
                      onItemSelected?.call();
                    },
                  ),

                  const SizedBox(height: 24),

                  _sectionTitle(context, 'MANAGEMENT'),

                  _AdminMenuItem(
                    icon: Icons.analytics_rounded,
                    title: 'Analytics',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/admin/analytics'),
                    onTap: () {
                      context.go('/admin/analytics');
                      onItemSelected?.call();
                    },
                  ),

                  _AdminMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    collapsed: collapsed,
                    selected: _isCurrentRoute(context, '/admin/settings'),
                    onTap: () {
                      context.go('/admin/settings');
                      onItemSelected?.call();
                    },
                  ),
                ],
              ),
            ),
          ),

          if (onToggle != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: collapsed ? Alignment.center : Alignment.centerRight,
                child: IconButton(
                  tooltip: collapsed ? 'Expand sidebar' : 'Collapse sidebar',
                  onPressed: onToggle,
                  icon: Icon(
                    collapsed
                        ? Icons.keyboard_double_arrow_right_rounded
                        : Icons.keyboard_double_arrow_left_rounded,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);

    if (collapsed) {
      return Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.explore_rounded, color: Colors.white, size: 26),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HollandKompas',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    if (collapsed) {
      return const SizedBox(height: 12);
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.subtitleColor(context),
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  bool _isCurrentRoute(BuildContext context, String route) {
    final location = GoRouterState.of(context).uri.toString();

    return location == route;
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool collapsed;
  final bool selected;
  final VoidCallback onTap;

  const _AdminMenuItem({
    required this.icon,
    required this.title,
    required this.collapsed,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedColor = AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 14),
            decoration: BoxDecoration(
              color: selected
                  ? selectedColor.withValues(alpha: 0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? selectedColor
                      : AppColors.textColor(context),
                ),

                if (!collapsed) ...[
                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? selectedColor
                            : AppColors.textColor(context),
                      ),
                    ),
                  ),

                  if (selected)
                    Container(
                      width: 5,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
