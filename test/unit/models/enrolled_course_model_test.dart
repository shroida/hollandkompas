import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('EnrolledCourseModel.fromJson', () {
    test('builds correctly when course data is passed explicitly', () {
      final model = EnrolledCourseModel.fromJson(
        {'id': 'enr-1', 'enrolled_at': '2026-09-17T10:00:00.000Z'},
        course: courseJson(),
        totalLessons: 30,
        completedLessons: 12,
      );

      expect(model.totalLessons, 30);
      expect(model.completedLessons, 12);
      expect(model.course.id, 'course-a1');
    });

    test('reads embedded courses data from the row when no course param is given', () {
      final model = EnrolledCourseModel.fromJson({
        'id': 'enr-1',
        'enrolled_at': '2026-09-17T10:00:00.000Z',
        'courses': courseJson(id: 'course-a2'),
      });

      expect(model.course.id, 'course-a2');
    });

    test('throws when there is no course data anywhere', () {
      expect(
        () => EnrolledCourseModel.fromJson({
          'id': 'enr-1',
          'enrolled_at': '2026-09-17T10:00:00.000Z',
        }),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when enrolled_at is missing', () {
      expect(
        () => EnrolledCourseModel.fromJson(
          {'id': 'enr-1'},
          course: courseJson(),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
