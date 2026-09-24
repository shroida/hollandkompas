// Overrides authRepositoryProvider only, on the assumption that
// loginUseCaseProvider/registerUseCaseProvider/forgotPasswordUseCaseProvider
// are each built on top of it via `ref.watch(authRepositoryProvider)` — the
// same pattern courseRepositoryProvider follows. If any of those usecase
// providers instead construct their own repository directly, override that
// specific usecase provider too (same .overrideWithValue/.overrideWith
// shape).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/auth/data/providers/auth_repository_provider.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAuthRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);
  });

  group('AuthController.login', () {
    test('a correct email/password sets the user and clears loading', () async {
      await container.read(authControllerProvider.notifier).login(
            email: 'mohamed@example.com',
            password: 'correct-password',
          );

      final state = container.read(authControllerProvider);
      expect(state.isLoading, false);
      expect(state.user, isNotNull);
      expect(state.error, isNull);
    });

    test('a rejected email sets an error and leaves user null', () async {
      fakeRepo.rejectLoginFor = {'blocked@example.com'};

      await container.read(authControllerProvider.notifier).login(
            email: 'blocked@example.com',
            password: 'whatever',
          );

      final state = container.read(authControllerProvider);
      expect(state.isLoading, false);
      expect(state.user, isNull);
      expect(state.error, isNotNull);
    });

    test('the Exception: prefix is stripped from the error message shown to the user', () async {
      fakeRepo.throwOnNextCall = Exception('Incorrect email or password.');

      await container.read(authControllerProvider.notifier).login(
            email: 'x@example.com',
            password: 'y',
          );

      final state = container.read(authControllerProvider);
      expect(state.error, 'Incorrect email or password.');
      expect(state.error, isNot(contains('Exception:')));
    });
  });

  group('AuthController.register', () {
    test('a successful registration sets the new user', () async {
      await container.read(authControllerProvider.notifier).register(
            firstName: 'Mohamed',
            lastName: 'Walid',
            email: 'new@example.com',
            password: 'password123',
            level: DutchLevel.a1,
            phoneNumber: '+201000000000',
          );

      final state = container.read(authControllerProvider);
      expect(state.user, isNotNull);
      expect(state.user!.email, 'new@example.com');
      expect(fakeRepo.registerCallCount, 1);
    });

    test('a failed registration sets an error and leaves user null', () async {
      fakeRepo.throwOnNextCall = Exception('Email already registered.');

      await container.read(authControllerProvider.notifier).register(
            firstName: 'Mohamed',
            lastName: 'Walid',
            email: 'dup@example.com',
            password: 'password123',
            level: DutchLevel.a1,
            phoneNumber: '+201000000000',
          );

      final state = container.read(authControllerProvider);
      expect(state.user, isNull);
      expect(state.error, isNotNull);
    });
  });

  group('AuthController.logout', () {
    test('clears the user back to the initial state', () async {
      await container.read(authControllerProvider.notifier).login(
            email: 'mohamed@example.com',
            password: 'correct-password',
          );
      expect(container.read(authControllerProvider).user, isNotNull);

      await container.read(authControllerProvider.notifier).logout();

      final state = container.read(authControllerProvider);
      expect(state.user, isNull);
      expect(fakeRepo.logoutCallCount, 1);
    });
  });

  group('AuthController.forgotPassword', () {
    test('completes without setting a user, and clears loading', () async {
      await container.read(authControllerProvider.notifier).forgotPassword(
            email: 'mohamed@example.com',
          );

      final state = container.read(authControllerProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(fakeRepo.forgotPasswordCallCount, 1);
    });
  });
}
