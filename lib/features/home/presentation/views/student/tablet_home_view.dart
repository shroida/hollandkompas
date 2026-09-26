import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/section_header.dart';
import 'package:hollandkompas/features/flashcards/presentation/widgets/flashcards_home_card.dart';
import 'package:hollandkompas/features/home/presentation/views/student/student_courses_view.dart';
import 'package:hollandkompas/features/home/presentation/widgets/continue_learning_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/vocabulary_home_card.dart';

class TabletHomeView extends StudentCoursesView {
  const TabletHomeView({super.key});

  static const _horizontalPadding = 28.0;
  static const _gridSpacing = 18.0;
  static const _courseHeight = 410.0;

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

        // Continue Learning
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(child: ContinueLearningSection()),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Vocabulary
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(child: VocabularyHomeCard()),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Flashcards
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(child: FlashcardsHomeCard()),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // Courses header
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Your courses',
              subtitle: 'Continue your Dutch learning journey.',
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Courses
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          sliver: SliverGrid.builder(
            itemCount: sortedCourses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: _gridSpacing,
              mainAxisSpacing: _gridSpacing,
              mainAxisExtent: _courseHeight,
            ),
            itemBuilder: (context, index) {
              final course = sortedCourses[index];

              return CourseCard(
                course: course,
                isEnrolled: false,
                onTap: () => _openCourse(context, course),
              );
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  List<Course> _sortCoursesByLevel(List<Course> courses) {
    const levelOrder = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6};

    return List<Course>.of(courses)..sort(
      (a, b) =>
          (levelOrder[a.level] ?? 999).compareTo(levelOrder[b.level] ?? 999),
    );
  }

  void _openCourse(BuildContext context, Course course) {
    context.push(RoutePaths.courseLessons, extra: course);
  }
}
