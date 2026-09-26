import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/flashcards/presentation/widgets/flashcards_home_card.dart';
import 'package:hollandkompas/features/home/presentation/views/student/student_courses_view.dart';
import 'package:hollandkompas/features/home/presentation/widgets/continue_learning_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/vocabulary_home_card.dart';

class MobileHomeView extends StudentCoursesView {
  const MobileHomeView({super.key});

  static const _horizontalPadding = 20.0;
  static const _courseSpacing = 16.0;

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
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: _HomeSectionTitle(
              title: 'Continue Learning',
              subtitle: 'Continue where you left off.',
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(child: ContinueLearningSection()),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(child: VocabularyHomeCard()),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(child: FlashcardsHomeCard()),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverList.builder(
            itemCount: sortedCourses.length,
            itemBuilder: (context, index) {
              final course = sortedCourses[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: _courseSpacing),
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

    final sortedCourses = List<Course>.of(courses)
      ..sort(
        (a, b) =>
            (levelOrder[a.level] ?? 999).compareTo(levelOrder[b.level] ?? 999),
      );

    return sortedCourses;
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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}
