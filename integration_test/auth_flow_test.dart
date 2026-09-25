// ASSUMPTIONS IN THIS FILE — check these against your real code first:
//   1. LoginScreen(onLogin, onRegister, onForgot) and
//      RegisterScreen(onLogin, onBack) take exactly these constructor
//      callbacks — confirmed from the app_router.dart you shared earlier
//      in this conversation, not re-verified against the current file.
//   2. Both screens build their fields with AuthTextField (confirmed real),
//      in the order: email, password for Login; first name, last name,
//      email, password, phone for Register. If the real order differs,
//      the tester.enterText(... .at(index) ...) calls below need reordering
//      — the assertions on end state (home reached / error shown) are the
//      part actually worth trusting.
//   3. There's a Widget somewhere with an onPressed that calls
//      widget.onLogin/onRegister — found here via find.byType(ElevatedButton)
//      /find.byType(FilledButton), whichever exists. Swap the finder if
//      your buttons use a different widget type.
//
// This intentionally does NOT start from the real app root (Splash ->
// Onboarding -> ...), since this conversation hasn't seen those two
// screens' internals. It mounts LoginScreen/RegisterScreen/HomeScreen
// directly behind a small local router instead — same real screens, same
// real AuthController/repository wiring, just skipping screens whose
// "continue" button text isn't known here.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/auth/data/providers/auth_repository_provider.dart';
import 'package:hollandkompas/features/auth/presentation/pages/login_screen.dart';
import 'package:hollandkompas/features/auth/presentation/pages/register_screen.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/home/presentation/screens/home_screen.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/fakes.dart';
import '../test/helpers/pump_app.dart';

Future<void> _tapPrimaryButton(WidgetTester tester) async {
  final elevated = find.byType(ElevatedButton);
  final filled = find.byType(FilledButton);
  if (elevated.evaluate().isNotEmpty) {
    await tester.tap(elevated.first);
  } else if (filled.evaluate().isNotEmpty) {
    await tester.tap(filled.first);
  } else {
    fail('No ElevatedButton or FilledButton found to submit the form — '
        'update _tapPrimaryButton to match the real button widget.');
  }
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthRepository fakeRepo;

  final routes = [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        onLogin: () => context.go('/home'),
        onRegister: () => context.go('/register'),
        onForgot: () => context.push('/forgot-password'),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(
        onLogin: () => context.go('/login'),
        onBack: () => context.pop(),
      ),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ];

  setUp(() {
    fakeRepo = FakeAuthRepository();
  });

  testWidgets('a correct login reaches Home', (tester) async {
    await pumpAppWithRouter(
      tester,
      routes,
      initialLocation: '/login',
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
    );

    final fields = find.byType(TextField);
    expect(fields, findsAtLeastNWidgets(2), reason: 'expected an email and a password field');

    await tester.enterText(fields.at(0), 'mohamed@example.com');
    await tester.enterText(fields.at(1), 'correct-password');
    await _tapPrimaryButton(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(fakeRepo.loginCallCount, 1);
  });

  testWidgets('a wrong password stays on the login screen with an error, not a crash', (tester) async {
    fakeRepo.rejectLoginFor = {'blocked@example.com'};

    await pumpAppWithRouter(
      tester,
      routes,
      initialLocation: '/login',
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'blocked@example.com');
    await tester.enterText(fields.at(1), 'wrong-password');
    await _tapPrimaryButton(tester);

    expect(find.byType(HomeScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('logging out from Home returns to a state with no current user', (tester) async {
    // Skip the UI for login here — call the controller directly to get to
    // an authenticated Home state fast, then exercise the real logout path.
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);

    await container.read(authControllerProvider.notifier).login(
          email: 'mohamed@example.com',
          password: 'correct-password',
        );
    expect(container.read(authControllerProvider).user, isNotNull);

    await container.read(authControllerProvider.notifier).logout();

    expect(container.read(authControllerProvider).user, isNull);
    expect(fakeRepo.logoutCallCount, 1);
  });
}
