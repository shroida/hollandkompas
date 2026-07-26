import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';


final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);