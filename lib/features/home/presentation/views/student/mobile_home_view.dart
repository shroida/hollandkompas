import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/home/presentation/views/student/student_courses_view.dart';
import 'package:hollandkompas/features/home/presentation/widgets/continue_learning_card.dart';

class MobileHomeView extends StudentCoursesView {
  const MobileHomeView({super.key});

  @override
  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
  ) {
    final sortedCourses = _sortCoursesByLevel(courses);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: _HomeSectionTitle(
              title: 'Continue Learning',
              subtitle: 'Continue where you left off.',
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(child: ContinueLearningSection()),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: sortedCourses.length,
            itemBuilder: (context, index) {
              final course = sortedCourses[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CourseCard(
                  course: course,
                  isEnrolled: false,
                  onTap: () => _openCourse(context, course),
                ),
              );
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  List<Course> _sortCoursesByLevel(List<Course> courses) {
    const levelOrder = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6};

    final sorted = List<Course>.from(courses);

    sorted.sort((a, b) {
      final aOrder = levelOrder[a.level] ?? 999;
      final bOrder = levelOrder[b.level] ?? 999;

      return aOrder.compareTo(bOrder);
    });

    return sorted;
  }

  void _openCourse(BuildContext context, Course course) {
    context.push(RoutePaths.courseLessons, extra: course);
  }
}

class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}
