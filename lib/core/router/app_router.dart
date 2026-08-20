import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/login_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/register_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:hollandkompas/features/home/presentation/screens/admin_dashboard.dart';
import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';
import 'package:hollandkompas/features/home/presentation/screens/pages/total_students_screen.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/admin_shell.dart';
import 'package:hollandkompas/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hollandkompas/features/splash/presentation/pages/splash_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          SplashPage(onDone: () => context.go('/onboarding')),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        onLogin: () => context.go('/home'),
        onRegister: () => context.go('/register'),
        onForgot: () => context.push('/forgot-password'),
      ),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(
        onLogin: () => context.go('/login'),
        onBack: () => context.pop(),
      ),
    ),

    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(
        onBack: () => context.pop(),
        onLogin: () => context.go('/login'),
      ),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) {
        return const AdminShell(child: AdminDashboard());
      },
      routes: [
        GoRoute(
          path: 'students',
          builder: (context, state) {
            return const AdminShell(child: TotalStudentsScreen());
          },
        ),

        // GoRoute(
        //   path: 'courses',
        //   builder: (context, state) {
        //     return const AdminShell(child: AdminCoursesScreen());
        //   },
        // ),

        // GoRoute(
        //   path: 'lessons',
        //   builder: (context, state) {
        //     return const AdminShell(child: AdminLessonsScreen());
        //   },
        // ),

        // GoRoute(
        //   path: 'enrollments',
        //   builder: (context, state) {
        //     return const AdminShell(child: AdminEnrollmentsScreen());
        //   },
        // ),

        // GoRoute(
        //   path: 'analytics',
        //   builder: (context, state) {
        //     return const AdminShell(child: AdminAnalyticsScreen());
        //   },
        // ),

        // GoRoute(
        //   path: 'settings',
        //   builder: (context, state) {
        //     return const AdminShell(child: AdminSettingsScreen());
        //   },
        // ),
      ],
    ),
  ],
);
