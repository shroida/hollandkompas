import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/courses_content.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

EnrolledCourseModel _enrollment(
  String courseId, {
  int total = 30,
  int done = 10,
}) {
  return EnrolledCourseModel.fromJson(
    {'id': 'enr-$courseId', 'enrolled_at': '2026-09-17T10:00:00.000Z'},
    course: courseJson(id: courseId, title: 'Course $courseId'),
    totalLessons: total,
    completedLessons: done,
  );
}

Widget _sizedAt(double width, Widget child) {
  return MediaQuery(
    data: MediaQueryData(size: Size(width, 1200)),
    child: child,
  );
}

void main() {
  testWidgets(
    'shows the empty state and no stats row when there are no courses',
    (tester) async {
      var refreshed = false;

      await pumpApp(
        tester,
        CoursesContent(
          courses: const [],
          onRefresh: () async => refreshed = true,
        ),
      );

      expect(find.byType(EmptyState), findsOneWidget);

      await tester.fling(find.byType(EmptyState), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      expect(refreshed, isTrue);
    },
  );

  testWidgets('the stats row totals match the enrolled courses passed in', (
    tester,
  ) async {
    await pumpApp(
      tester,
      CoursesContent(
        courses: [
          _enrollment('c1', total: 30, done: 30),
          _enrollment('c2', total: 30, done: 0),
        ],
        onRefresh: () async {},
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('2'), findsWidgets);
    expect(find.text('60'), findsOneWidget);
    expect(find.text('30'), findsWidgets);

    final progressCard = find.ancestor(
      of: find.text('Progress'),
      matching: find.byType(Card),
    );

    expect(progressCard, findsOneWidget);

    expect(
      find.descendant(of: progressCard, matching: find.text('50%')),
      findsOneWidget,
    );
  });

  testWidgets('uses the grid layout at desktop width', (tester) async {
    await pumpApp(
      tester,
      _sizedAt(
        1100,
        CoursesContent(
          courses: [_enrollment('c1'), _enrollment('c2')],
          onRefresh: () async {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SliverGrid), findsOneWidget);
  });

  testWidgets('uses the list layout at phone width', (tester) async {
    await pumpApp(
      tester,
      _sizedAt(
        400,
        CoursesContent(
          courses: [_enrollment('c1'), _enrollment('c2')],
          onRefresh: () async {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SliverGrid), findsNothing);
    expect(find.byType(SliverList), findsOneWidget);
  });
}
