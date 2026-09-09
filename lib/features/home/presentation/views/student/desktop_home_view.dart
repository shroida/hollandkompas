import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_card.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/section_header.dart';
import 'package:hollandkompas/features/home/presentation/views/student/student_courses_view.dart';

class DesktopHomeView extends StudentCoursesView {
  const DesktopHomeView({super.key});

  @override
  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: CustomScrollView(
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
                      onPressed: () {
                        context.push('/courses');
                      },
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

  void _openCourse(BuildContext context, Course course) {
    context.push(
      '/course-lessons',
      extra: {'course': course, 'isEnrolled': false},
    );
  }
}
