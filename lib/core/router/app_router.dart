import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/login_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/register_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/screens/course_lessons_screen.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/my_courses_screen.dart';
import 'package:hollandkompas/features/home/presentation/screens/admin_dashboard.dart';
import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';
import 'package:hollandkompas/features/home/presentation/screens/pages/settings_screen.dart';
import 'package:hollandkompas/features/home/presentation/screens/pages/total_students_screen.dart';
import 'package:hollandkompas/features/home/presentation/views/student/profile_screen.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/admin_shell.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:hollandkompas/features/lesson/presentation/screens/lesson_viewer_screen.dart';
import 'package:hollandkompas/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hollandkompas/features/payment/presentation/screen/payment_screen.dart';
import 'package:hollandkompas/features/splash/presentation/pages/splash_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    // ---------------------------------------------------------------------------
    // Splash
    // ---------------------------------------------------------------------------
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) {
        return SplashPage(onDone: () => context.go(RoutePaths.onboarding));
      },
    ),

    // ---------------------------------------------------------------------------
    // Onboarding
    // ---------------------------------------------------------------------------
    GoRoute(
      path: RoutePaths.onboarding,
      builder: (context, state) {
        return const OnboardingScreen();
      },
    ),

    // ---------------------------------------------------------------------------
    // Authentication
    // ---------------------------------------------------------------------------
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) {
        return LoginScreen(
          onLogin: () => context.go(RoutePaths.home),
          onRegister: () => context.go(RoutePaths.register),
          onForgot: () => context.push(RoutePaths.forgotPassword),
        );
      },
    ),

    GoRoute(
      path: RoutePaths.register,
      builder: (context, state) {
        return RegisterScreen(
          onLogin: () => context.go(RoutePaths.login),
          onBack: context.pop,
        );
      },
    ),

    GoRoute(
      path: RoutePaths.forgotPassword,
      builder: (context, state) {
        return ForgotPasswordScreen(
          onBack: context.pop,
          onLogin: () => context.go(RoutePaths.login),
        );
      },
    ),

    GoRoute(
      path: RoutePaths.resetPassword,
      builder: (context, state) {
        return const ResetPasswordScreen();
      },
    ),

    // ---------------------------------------------------------------------------
    // Home
    // ---------------------------------------------------------------------------
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),

    // ---------------------------------------------------------------------------
    // Student
    // ---------------------------------------------------------------------------
    GoRoute(
      path: RoutePaths.profile,
      builder: (context, state) {
        return ProfileScreen();
      },
    ),

    GoRoute(
      path: RoutePaths.settings,
      name: 'settings',
      builder: (context, state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.myCourses,
      name: 'myCourses',
      builder: (context, state) {
        return const MyCoursesScreen();
      },
    ),
    GoRoute(
      path: RoutePaths.courseLessons,
      name: 'courseLessons',
      builder: (context, state) {
        final course = state.extra as Course;

        return CourseLessonsScreen(course: course);
      },
    ),

    GoRoute(
      path: RoutePaths.payment,
      name: 'payment',
      builder: (context, state) {
        final course = state.extra as Course;

        return PaymentScreen(
          courseId: course.id,
          courseTitle: course.title,
          price: course.price,
        );
      },
    ),

    GoRoute(
      path: RoutePaths.lessonViewer,
      name: 'lessonViewer',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        final course = extra['course'] as Course;
        final lesson = extra['lesson'] as Lesson;
        final lessons = (extra['lessons'] as List).cast<Lesson>();
        final currentIndex = extra['currentIndex'] as int;
        final isEnrolled = extra['isEnrolled'] as bool;
        final totalLessons = extra['totalLessons'] as int;

        return LessonViewerScreen(
          course: course,
          lesson: lesson,
          lessons: lessons,
          currentIndex: currentIndex,
          isEnrolled: isEnrolled,
          totalLessons: totalLessons,
        );
      },
    ),

    // ---------------------------------------------------------------------------
    // Admin
    // ---------------------------------------------------------------------------
    ShellRoute(
      builder: (context, state, child) {
        return AdminShell(child: child);
      },
      routes: [
        GoRoute(
          path: RoutePaths.admin,
          builder: (context, state) {
            return const AdminDashboard();
          },
          routes: [
            GoRoute(
              path: RoutePaths.totalStudents,
              builder: (context, state) {
                return const TotalStudentsScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
