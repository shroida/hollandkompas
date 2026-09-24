// enrolledCoursesProvider's exact declaration (FutureProvider.family vs a
// codegen @riverpod family function) wasn't in what was shared, so this
// overrides it with the most broadly-compatible `.overrideWith((ref) async
// => ...)` shape. If your real provider needs a different override call,
// swap just that one line — nothing else in this file should need to change.

import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/core/shared/widget/loading_state.dart';
import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/my_courses_screen.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/courses_content.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

final _testUser = AppUser(
  id: 'user-1',
  email: 'mohamed@example.com',
  firstName: 'Mohamed',
  lastName: 'Walid',
  level: DutchLevel.a1,
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
  testWidgets('shows an empty state when the student has no enrollments', (tester) async {
    await pumpApp(
      tester,
      const MyCoursesScreen(),
      overrides: [
        authControllerProvider.overrideWith(
          () => _FixedAuthController(AuthState(isLoading: false, user: _testUser)),
        ),
        enrolledCoursesProvider(_testUser.id).overrideWith((ref) async => []),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
  });

  testWidgets('renders course content once enrollments load', (tester) async {
    final enrollment = EnrolledCourseModel.fromJson(
      {'id': 'enr-1', 'enrolled_at': '2026-09-17T10:00:00.000Z'},
      course: courseJson(),
      totalLessons: 30,
      completedLessons: 12,
    );

    await pumpApp(
      tester,
      const MyCoursesScreen(),
      overrides: [
        authControllerProvider.overrideWith(
          () => _FixedAuthController(AuthState(isLoading: false, user: _testUser)),
        ),
        enrolledCoursesProvider(_testUser.id).overrideWith((ref) async => [enrollment]),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.byType(CoursesContent), findsOneWidget);
    expect(find.textContaining('12'), findsWidgets); // completed-lessons count somewhere on screen
  });

  testWidgets('shows a loading indicator before auth resolves', (tester) async {
    await pumpApp(
      tester,
      const MyCoursesScreen(),
      overrides: [
        authControllerProvider.overrideWith(
          () => _FixedAuthController(const AuthState(isLoading: true)),
        ),
      ],
    );

    expect(find.byType(LoadingState), findsOneWidget);
  });
}
