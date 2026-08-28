import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_header.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';

class CourseLessonsContent extends StatelessWidget {
  final Course course;
  final List<Lesson> lessons;
  final bool isEnrolled;
  final VoidCallback onEnroll;

  const CourseLessonsContent({
    super.key,
    required this.course,
    required this.lessons,
    required this.isEnrolled,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
        final isTablet = constraints.maxWidth >= 650;

        final horizontalPadding = isDesktop
            ? 48.0
            : isTablet
            ? 32.0
            : 20.0;

        final totalMinutes = lessons.fold<int>(
          0,
          (sum, lesson) => sum + lesson.durationMinutes,
        );

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // COURSE HEADER
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: CourseHeader(
                      course: course,
                      lessonCount: lessons.length,
                      totalMinutes: totalMinutes,
                      isEnrolled: isEnrolled,
                    ),
                  ),
                ),

                // ENROLLMENT BANNER
                if (!isEnrolled)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      18,
                      horizontalPadding,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _EnrollmentBanner(
                        course: course,
                        onEnroll: onEnroll,
                      ),
                    ),
                  ),

                // SECTION HEADER
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    32,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      lessonCount: lessons.length,
                      isEnrolled: isEnrolled,
                    ),
                  ),
                ),

                // LESSONS
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    40,
                  ),
                  sliver: SliverList.builder(
                    itemCount: lessons.length,

                    itemBuilder: (context, index) {
                      final lesson = lessons[index];

                      // Lesson 1 is free.
                      final isFree = index == 0;

                      // If enrolled -> NOTHING is locked.
                      // If not enrolled -> only lesson 1 is open.
                      final isLocked = !isEnrolled && !isFree;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LessonCard(
                          lesson: lesson,
                          isFirst: isFree,
                          isLocked: isLocked,
                          isEnrolled: isEnrolled,

                          onTap: () {
                            if (isLocked) {
                              onEnroll();
                              return;
                            }

                            context.push(
                              '/lesson-viewer',
                              extra: {
                                'lesson': lesson,
                                'isEnrolled': isEnrolled,
                                'totalLessons': lessons.length,
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EnrollmentBanner extends StatelessWidget {
  final Course course;
  final VoidCallback onEnroll;

  const _EnrollmentBanner({required this.course, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(Icons.school_rounded, color: AppColors.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start learning for free',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 4),

                Text(
                  'Lesson 1 is free. Enroll to unlock the entire course.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          FilledButton(onPressed: onEnroll, child: const Text('Enroll')),
        ],
      ),
    );
  }
}
