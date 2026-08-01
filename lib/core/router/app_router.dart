import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/auth/presentation/pages/forgot_password_screen.dart';

import 'package:hollandkompas/features/auth/presentation/pages/login_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/register_screen.dart';


import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';
import 'package:hollandkompas/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hollandkompas/features/splash/presentation/pages/splash_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashPage(
        onDone: () => context.go('/onboarding'),
      ),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

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
  ],
);