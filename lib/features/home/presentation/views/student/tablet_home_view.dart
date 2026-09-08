import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/section_header.dart';
import 'package:hollandkompas/features/home/presentation/views/student/student_courses_view%20.dart';

class TabletHomeView extends StudentCoursesView {
  const TabletHomeView({super.key});

  @override
  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
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
              mainAxisExtent: 410,
            ),
            itemBuilder: (context, index) {
              final course = courses[index];

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

  void _openCourse(BuildContext context, Course course) {
    context.push(
      '/course-lessons',
      extra: {'course': course, 'isEnrolled': false},
    );
  }
}
