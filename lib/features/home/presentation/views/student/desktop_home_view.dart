import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_error.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_loading.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/section_header.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';

class DesktopHomeView extends ConsumerWidget {
  const DesktopHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(publishedCoursesProvider);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: coursesAsync.when(
          loading: () => const CoursesLoading(),

          error: (error, stack) {
            return CoursesError(
              message: error.toString(),
              onRetry: () {
                ref.invalidate(publishedCoursesProvider);
              },
            );
          },

          data: (courses) {
            if (courses.isEmpty) {
              return const Center(child: Text('No courses available'));
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: [
                        const Expanded(
                          child: SectionHeader(
                            title: 'Your learning journey',
                            subtitle:
                                'Choose a course and continue learning Dutch.',
                          ),
                        ),

                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.grid_view_rounded, size: 18),
                          label: const Text('View all'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  sliver: SliverGrid.builder(
                    itemCount: courses.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 460,
                        ),

                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return CourseCard(
                        course: course,
                        isEnrolled: false,

                        onTap: () {
                          context.push(
                            '/course-lessons',
                            extra: {'course': course, 'isEnrolled': false},
                          );
                        },
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }
}
