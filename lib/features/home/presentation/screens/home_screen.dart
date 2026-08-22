import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';
import 'package:hollandkompas/features/auth/domain/extensions/user_role_extension.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/home/presentation/providers/current_user_provider.dart';
import 'package:hollandkompas/features/home/presentation/screens/admin_dashboard.dart';
import 'package:hollandkompas/features/home/presentation/views/student/desktop_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/student/mobile_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/student/tablet_home_view.dart';
import 'package:hollandkompas/features/home/presentation/widgets/app_bar_home_screen.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/admin_shell.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),

      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text("User not found")));
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBarHomeScreen(
            firstName: user.firstName,
            level: user.level.name.toUpperCase(),

            onMyCourses: () {
              // TODO: navigate to My Courses
            },

            onProfile: () {
              // TODO: navigate to Profile
            },

            onSettings: () {
              // TODO: navigate to Settings
            },
            onLogout: () async {
              await ref.read(authControllerProvider.notifier).logout();

              if (!context.mounted) return;

              context.go('/login');
            },
          ),

          body: user.isAdmin
              ? AdminShell(child: const AdminDashboard())
              : const ResponsiveBuilder(
                  mobile: MobileHomeView(),
                  tablet: TabletHomeView(),
                  desktop: DesktopHomeView(),
                ),
        );
      },
    );
  }
}
