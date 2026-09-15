import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

class ContinueLearning {
  const ContinueLearning({
    required this.course,
    required this.lesson,
    required this.lessons,
    required this.currentIndex,
    required this.progress,
  });

  final Course course;
  final Lesson lesson;
  final List<Lesson> lessons;
  final int currentIndex;
  final double progress;
}
