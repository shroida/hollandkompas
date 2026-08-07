import 'package:hollandkompas/features/auth/data/providers/auth_repository_provider.dart';
import 'package:hollandkompas/features/auth/domain/providers/forgot_password_usecase_provider.dart';
import 'package:hollandkompas/features/auth/domain/providers/login_usecase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/enums/dutch_level.dart';
import '../../domain/providers/register_usecase_provider.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final user =
          await ref.read(registerUseCaseProvider).call(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                level: level,
                phoneNumber: phoneNumber,
              );
if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
Future<void> login({
  required String email,
  required String password,
}) async {
  state = state.copyWith(
    isLoading: true,
    user: null,
    error: null,
  );

  try {
    final user = await ref.read(loginUseCaseProvider).call(
      email: email,
      password: password,
    );

    if (!ref.mounted) return;

    state = state.copyWith(
      isLoading: false,
      user: user,
      error: null,
    );
  } catch (e) {
    if (!ref.mounted) return;

    state = state.copyWith(
      isLoading: false,
      user: null,
      error: e.toString().replaceFirst('Exception: ', ''),
    );
  }
}
Future<void> forgotPassword({
  required String email,
}) async {
  state = state.copyWith(
    isLoading: true,
    error: null,
  );

  try {
    await ref.read(forgotPasswordUseCaseProvider).call(
      email: email,
    );
if (!ref.mounted) return;
    state = state.copyWith(
      isLoading: false,
      error: null,
    );
  } catch (e) {
      if (!ref.mounted) return;

    state = state.copyWith(
      isLoading: false,
      error: e.toString().replaceFirst("Exception: ", ""),
    );
  }
}

  Future<void> updatePassword(String password) async {
  state = state.copyWith(
    isLoading: true,
    error: null,
  );

  try {
    await ref.read(authRepositoryProvider).updatePassword(password);
if (!ref.mounted) return;
    state = state.copyWith(
      isLoading: false,
    );
  } catch (e, stackTrace) {
      if (!ref.mounted) return;

    print("UPDATE PASSWORD ERROR:");
    print(e);
    print(stackTrace);

    state = state.copyWith(
      isLoading: false,
      error: e.toString(),
    );
  }
}
Future<void> loadCurrentUser() async {
  state = state.copyWith(isLoading: true);

  final user = await ref.read(authRepositoryProvider).getCurrentUser();

  state = state.copyWith(
    isLoading: false,
    user: user,
  );
}
}