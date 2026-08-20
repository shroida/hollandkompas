import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_error.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_loading.dart';
import 'package:hollandkompas/features/home/presentation/widgets/section_header.dart';
import 'package:hollandkompas/features/home/presentation/widgets/welcome_section.dart';

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

          error: (error, stack) => CoursesError(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(publishedCoursesProvider);
            },
          ),

          data: (courses) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: WelcomeSection()),

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
                          childAspectRatio: 0.95,
                        ),
                    itemBuilder: (context, index) {
                      return CourseCard(course: courses[index], onTap: () {});
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
