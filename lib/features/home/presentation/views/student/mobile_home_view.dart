import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/section_header.dart';
import 'package:hollandkompas/features/home/presentation/views/student/student_courses_view.dart';

class MobileHomeView extends StudentCoursesView {
  const MobileHomeView({super.key});

  @override
  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
  ) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);

    final sortedCourses = [...courses];

    sortedCourses.sort((a, b) {
      const levelOrder = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6};

      final aOrder = levelOrder[a.level] ?? 999;
      final bOrder = levelOrder[b.level] ?? 999;

      return aOrder.compareTo(bOrder);
    });

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              title: strings.startLearning,
              subtitle: strings.chooseCourseImproveDutch,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: sortedCourses.length,
            itemBuilder: (context, index) {
              final course = sortedCourses[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
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

  void _openCourse(BuildContext context, Course course) {
    context.push(
      '/course-lessons',
      extra: {'course': course, 'isEnrolled': false},
    );
  }
}
