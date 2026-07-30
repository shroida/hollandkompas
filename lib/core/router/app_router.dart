import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/auth/presentation/pages/login_screen.dart';

import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';
import 'package:hollandkompas/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hollandkompas/features/splash/presentation/pages/splash_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashPage(
        onDone: () {
          context.go('/onboarding');
        },
      ),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);