import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/courses_content.dart';

import '../../helpers/fixtures.dart';

EnrolledCourseModel _enrollment({
  required String courseId,
  required int totalLessons,
  required int completedLessons,
}) {
  return EnrolledCourseModel.fromJson(
    {'id': 'enr-$courseId', 'enrolled_at': '2026-09-17T10:00:00.000Z'},
    course: courseJson(id: courseId),
    totalLessons: totalLessons,
    completedLessons: completedLessons,
  );
}

void main() {
  group('CourseStats.from', () {
    test('an empty enrollment list gives all-zero stats, not a crash', () {
      final stats = CourseStats.from(const []);

      expect(stats.coursesCount, 0);
      expect(stats.totalLessons, 0);
      expect(stats.completedLessons, 0);
      expect(stats.averageProgress, 0);
    });

    test('sums lessons and averages progress across several courses', () {
      final stats = CourseStats.from([
        _enrollment(
          courseId: 'c1',
          totalLessons: 30,
          completedLessons: 30,
        ), // 100%
        _enrollment(
          courseId: 'c2',
          totalLessons: 30,
          completedLessons: 0,
        ), // 0%
      ]);

      expect(stats.coursesCount, 2);
      expect(stats.totalLessons, 60);
      expect(stats.completedLessons, 30);
      expect(stats.averageProgress, closeTo(0.5, 0.0001));
    });

    test('a course with zero lessons does not divide by zero', () {
      // This specifically probes EnrolledCourse.progress (completedLessons /
      // totalLessons) for a course with totalLessons == 0. If that getter
      // has no zero-guard, 0/0 is NaN in Dart and this test will fail —
      // that's a real bug this test is designed to catch, not a mistake in
      // the test. If it fails, add a totalLessons == 0 ? 0 : ... guard to
      // the progress getter on the EnrolledCourse entity.
      final stats = CourseStats.from([
        _enrollment(courseId: 'c1', totalLessons: 0, completedLessons: 0),
      ]);

      expect(stats.averageProgress.isNaN, isFalse);
      expect(stats.averageProgress, 0);
    });
  });
}
