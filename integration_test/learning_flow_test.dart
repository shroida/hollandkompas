import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/my_courses_screen.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/courses_content.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/fixtures.dart';
import '../test/helpers/pump_app.dart';

final _student = AppUser(
  id: 'user-1',
  email: 'mohamed@example.com',
  firstName: 'Mohamed',
  lastName: 'Walid',
  level: DutchLevel.a2,
  role: UserRole.student,
  phoneNumber: '+201000000000',
);

class _FixedAuthController extends AuthController {
  _FixedAuthController(this._state);

  final AuthState _state;

  @override
  AuthState build() => _state;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'a student with two enrollments sees both, with correct progress',
    (tester) async {
      final a1 = EnrolledCourseModel.fromJson(
        {'id': 'enr-a1', 'enrolled_at': '2026-09-01T10:00:00.000Z'},
        course: courseJson(id: 'course-a1', title: 'Nederlands A1'),
        totalLessons: 30,
        completedLessons: 30,
      );

      final a2 = EnrolledCourseModel.fromJson(
        {'id': 'enr-a2', 'enrolled_at': '2026-09-10T10:00:00.000Z'},
        course: courseJson(id: 'course-a2', title: 'Nederlands A2'),
        totalLessons: 30,
        completedLessons: 9,
      );

      await pumpApp(
        tester,
        const MyCoursesScreen(),
        overrides: [
          authControllerProvider.overrideWith(
            () => _FixedAuthController(
              AuthState(isLoading: false, user: _student),
            ),
          ),
          enrolledCoursesProvider(
            _student.id,
          ).overrideWith((ref) async => [a1, a2]),
        ],
      );

      await tester.pumpAndSettle();

      // A1 is visible in the initial mobile viewport.
      expect(find.text('Nederlands A1'), findsOneWidget);
      expect(find.text('Course completed 🎉'), findsOneWidget);

      // A2 is below the initial viewport on the Android emulator.
      // Scroll until Flutter builds the second course card.
      await tester.scrollUntilVisible(find.text('Nederlands A2'), 300);

      await tester.pumpAndSettle();

      expect(find.text('Nederlands A2'), findsOneWidget);

      // A2 has 9 completed lessons out of 30.
      expect(find.textContaining('9 /'), findsOneWidget);
    },
  );

  testWidgets(
    'pull-to-refresh on My Courses re-invokes the enrollments provider',
    (tester) async {
      var buildCount = 0;

      await pumpApp(
        tester,
        const MyCoursesScreen(),
        overrides: [
          authControllerProvider.overrideWith(
            () => _FixedAuthController(
              AuthState(isLoading: false, user: _student),
            ),
          ),
          enrolledCoursesProvider(_student.id).overrideWith((ref) async {
            buildCount++;
            return const <EnrolledCourseModel>[];
          }),
        ],
      );

      await tester.pumpAndSettle();

      expect(
        buildCount,
        1,
        reason: 'the provider should have run once on first load',
      );

      await tester.fling(find.byType(EmptyState), const Offset(0, 300), 1000);

      await tester.pumpAndSettle();

      expect(
        buildCount,
        2,
        reason: 'pull-to-refresh should invalidate and re-run the provider',
      );
    },
  );
}
