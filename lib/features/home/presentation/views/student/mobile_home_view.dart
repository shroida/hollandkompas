import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_empty.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_error.dart';
import 'package:hollandkompas/features/home/presentation/widgets/courses_loading.dart';
import 'package:hollandkompas/features/home/presentation/widgets/section_header.dart';

class MobileHomeView extends ConsumerWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(publishedCoursesProvider);

    return coursesAsync.when(
      loading: () => const CoursesLoading(),

      error: (error, stackTrace) {
        return CoursesError(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(publishedCoursesProvider);
          },
        );
      },

      data: (courses) {
        if (courses.isEmpty) {
          return const EmptyCourses();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Start learning',
                  subtitle: 'Choose a course and improve your Dutch.',
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      course: course,
                      onTap: () {
                        context.push(
                          '/course-lessons',
                          extra: {'course': course, 'isEnrolled': false},
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}
