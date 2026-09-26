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

class DesktopHomeView extends StudentCoursesView {
  const DesktopHomeView({super.key});

  static const _horizontalPadding = 32.0;
  static const _maxContentWidth = 1400.0;
  static const _gridSpacing = 20.0;
  static const _courseHeight = 460.0;

  @override
  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
  ) {
    final sortedCourses = _sortCoursesByLevel(courses);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Home feature cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: _gridSpacing,
                  mainAxisSpacing: _gridSpacing,
                  childAspectRatio: 1.65,
                ),
                delegate: SliverChildListDelegate(const [
                  ContinueLearningSection(),
                  VocabularyHomeCard(),
                  FlashcardsHomeCard(),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),

            // Courses header
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: _DesktopSectionHeader(
                  onViewAll: () => context.push('/courses'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 18)),

            // Courses
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              sliver: SliverGrid.builder(
                itemCount: sortedCourses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
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

class _DesktopSectionHeader extends StatelessWidget {
  const _DesktopSectionHeader({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: SectionHeader(
            title: 'Your learning journey',
            subtitle: 'Choose a course and continue learning Dutch.',
          ),
        ),
        TextButton.icon(
          onPressed: onViewAll,
          icon: const Icon(Icons.grid_view_rounded, size: 18),
          label: const Text('View all'),
        ),
      ],
    );
  }
}
