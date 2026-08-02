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
      error: null,
    );

    try {
      final user = await ref.read(loginUseCaseProvider).call(
        email: email,
        password: password,
      );

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
}