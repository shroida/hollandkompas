import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_error.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_loading.dart';
import 'package:hollandkompas/features/home/presentation/widgets/section_header.dart';

class TabletHomeView extends ConsumerWidget {
  const TabletHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(publishedCoursesProvider);

    return coursesAsync.when(
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
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: SectionHeader(
                  title: 'Your courses',
                  subtitle: 'Continue your Dutch learning journey.',
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverGrid.builder(
                itemCount: courses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  return CourseCard(course: courses[index], onTap: () {});
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
