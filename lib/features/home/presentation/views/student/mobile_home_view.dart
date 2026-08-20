import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';
import 'package:hollandkompas/features/home/presentation/widgets/welcome_section.dart';

class MobileHomeView extends ConsumerWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(publishedCoursesProvider);

    return coursesAsync.when(
      loading: () => const _CoursesLoading(),

      error: (error, stackTrace) {
        return _CoursesError(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(publishedCoursesProvider);
          },
        );
      },

      data: (courses) {
        if (courses.isEmpty) {
          return const _EmptyCourses();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: WelcomeSection()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      course: courses[index],
                      onTap: () {
                        // TODO: Navigate to course details
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
