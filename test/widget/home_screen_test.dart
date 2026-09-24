// The admin-vs-student branch test below renders AdminShell/ResponsiveBuilder,
// which may reach for providers not overridden here (e.g. whatever
// AdminDashboard or the mobile/tablet/desktop home views read for their own
// data). If it fails with a "no provider found"-style error, that's not a
// wrong test — add the missing override(s) it's asking for, the same way
// authControllerProvider is overridden below.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/admin_shell.dart';

import '../helpers/pump_app.dart';

AppUser _user({UserRole role = UserRole.student}) {
  return AppUser(
    id: 'user-1',
    email: 'mohamed@example.com',
    firstName: 'Mohamed',
    lastName: 'Walid',
    level: DutchLevel.a1,
    role: role,
    phoneNumber: '+201000000000',
  );
}

void main() {
  testWidgets('shows a loading spinner while auth state is loading', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const HomeScreen(),
      overrides: [
        authControllerProvider.overrideWith(
          () => _FixedAuthController(const AuthState(isLoading: true)),
        ),
      ],
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows "User not found" when loading finished with no user', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const HomeScreen(),
      overrides: [
        authControllerProvider.overrideWith(
          () => _FixedAuthController(
            const AuthState(isLoading: false, user: null),
          ),
        ),
      ],
    );

    expect(find.text('User not found'), findsOneWidget);
  });

  testWidgets(
    'an admin user is routed into AdminShell, not the student views',
    (tester) async {
      await pumpApp(
        tester,
        const HomeScreen(),
        overrides: [
          authControllerProvider.overrideWith(
            () => _FixedAuthController(
              AuthState(isLoading: false, user: _user(role: UserRole.admin)),
            ),
          ),
        ],
      );
      await tester.pump();

      expect(find.byType(AdminShell), findsOneWidget);
    },
  );
}

/// A tiny fixed-state stand-in for AuthController — returns [state] from
/// build() and never changes it, so tests don't need a real repository just
/// to check how HomeScreen reacts to a given state.
class _FixedAuthController extends AuthController {
  _FixedAuthController(this._fixedState);
  final AuthState _fixedState;

  @override
  AuthState build() => _fixedState;
}
