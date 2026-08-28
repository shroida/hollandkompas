import 'package:hollandkompas/features/courses/domain/entities/course.dart';

class EnrolledCourse {
  final Course course;
  final DateTime enrolledAt;
  final int totalLessons;
  final int completedLessons;

  const EnrolledCourse({
    required this.course,
    required this.enrolledAt,
    required this.totalLessons,
    required this.completedLessons,
  });

  double get progress {
    if (totalLessons <= 0) {
      return 0.0;
    }

    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }
}
