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

class DesktopHomeView extends StudentCoursesView {
  const DesktopHomeView({super.key});

  static const _maxContentWidth = 1440.0;
  static const _horizontalPadding = 32.0;
  static const _spacing = 20.0;

  @override
  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
    Set<String> enrolledCourseIds,
  ) {
    final sortedCourses = _sortCoursesByLevel(courses);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              sliver: const SliverToBoxAdapter(child: _HomeIntro()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: _spacing,
                  mainAxisSpacing: _spacing,
                  childAspectRatio: 1.55,
                ),
                delegate: SliverChildListDelegate(const [
                  ContinueLearningSection(),
                  VocabularyHomeCard(),
                  FlashcardsHomeCard(),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 44)),

            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              sliver: SliverGrid.builder(
                itemCount: sortedCourses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: _spacing,
                  mainAxisSpacing: _spacing,
                  mainAxisExtent: 420,
                ),
                itemBuilder: (context, index) {
                  final course = sortedCourses[index];

                  final isEnrolled = enrolledCourseIds.contains(course.id);

                  return _AnimatedCourseCard(
                    index: index,
                    child: CourseCard(
                      course: course,
                      isEnrolled: isEnrolled,
                      onTap: () {
                        context.push(RoutePaths.courseLessons, extra: course);
                      },
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
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
}

class _HomeIntro extends StatelessWidget {
  const _HomeIntro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Dutch journey',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Learn, practice, and build your Dutch skills every day.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.12
                  : 0.07,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                'Keep learning',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedCourseCard extends StatefulWidget {
  const _AnimatedCourseCard({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_AnimatedCourseCard> createState() => _AnimatedCourseCardState();
}

class _AnimatedCourseCardState extends State<_AnimatedCourseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
      },
      child: AnimatedScale(
        scale: _hovered ? 1.012 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          child: widget.child,
        ),
      ),
    );
  }
}
