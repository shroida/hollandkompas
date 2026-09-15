import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/courses_content.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/my_courses_appbar.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const MyCoursesAppBar(),
      body: _buildBody(context, ref, authState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, dynamic authState) {
    if (authState.isLoading) {
      return const _LoadingState();
    }

    final user = authState.user;

    if (user == null) {
      return const EmptyState();
    }

    final coursesAsync = ref.watch(enrolledCoursesProvider(user.id));

    return coursesAsync.when(
      loading: () => const _LoadingState(),
      error: (_, _) => const EmptyState(),
      data: (courses) => CoursesContent(
        courses: courses,
        onRefresh: () => _refreshCourses(ref, user.id),
      ),
    );
  }

  Future<void> _refreshCourses(WidgetRef ref, String userId) async {
    final provider = enrolledCoursesProvider(userId);

    ref.invalidate(provider);

    await ref.read(provider.future);
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
