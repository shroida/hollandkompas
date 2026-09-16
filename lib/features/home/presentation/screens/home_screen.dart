import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/responsive/responsive_builder.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/home/presentation/screens/admin_dashboard.dart';
import 'package:hollandkompas/features/home/presentation/views/student/desktop_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/student/mobile_home_view.dart';
import 'package:hollandkompas/features/home/presentation/views/student/tablet_home_view.dart';
import 'package:hollandkompas/features/home/presentation/widgets/appbar/app_bar_home_screen.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/admin_shell.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (authState.isLoading) {
      return const _HomeLoading();
    }

    final user = authState.user;

    if (user == null) {
      return const _UserNotFound();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarHomeScreen(
        firstName: user.firstName,
        level: user.level.name.toUpperCase(),

        onMyCourses: () {
          context.push('/vocabulary');
        },

        onProfile: () {
          context.push(RoutePaths.profile);
        },

        onSettings: () {
          context.pushNamed('settings');
        },

        onLogout: () {
          _logout(context, ref);
        },
      ),
      body: _HomeBody(userRole: user.role),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).logout();

      if (!context.mounted) return;

      context.go(RoutePaths.login);
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $error')));
    }
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.userRole});

  final UserRole userRole;

  @override
  Widget build(BuildContext context) {
    if (userRole == UserRole.admin) {
      return const AdminShell(child: AdminDashboard());
    }

    return const ResponsiveBuilder(
      mobile: MobileHomeView(),
      tablet: TabletHomeView(),
      desktop: DesktopHomeView(),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _UserNotFound extends StatelessWidget {
  const _UserNotFound();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('User not found')));
  }
}
