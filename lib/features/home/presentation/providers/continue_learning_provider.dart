import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/home/domain/entities/continue_learning.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_lessons_provider.dart';

final continueLearningProvider = FutureProvider.autoDispose<ContinueLearning?>((
  ref,
) async {
  final authState = ref.watch(authControllerProvider);

  final user = authState.user;

  if (user == null) {
    return null;
  }

  final enrollments = await ref.watch(enrolledCoursesProvider(user.id).future);

  if (enrollments.isEmpty) {
    return null;
  }

  final enrollment = enrollments.first;

  final lessons = await ref.watch(
    courseLessonsProvider(enrollment.course.id).future,
  );

  if (lessons.isEmpty) {
    return null;
  }

  final completedLessons = enrollment.completedLessons;

  final currentIndex = completedLessons.clamp(0, lessons.length - 1);

  final currentLesson = lessons[currentIndex];

  final progress = completedLessons / lessons.length;

  return ContinueLearning(
    course: enrollment.course,
    lesson: currentLesson,
    lessons: lessons,
    currentIndex: currentIndex,
    progress: progress.clamp(0.0, 1.0),
  );
});
