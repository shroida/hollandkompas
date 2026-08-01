import 'package:hollandkompas/features/auth/domain/providers/register_usecase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_state.dart';
import 'register_usecase_provider.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String level,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final user = await ref.read(registerUseCaseProvider)(
        fullName: fullName,
        email: email,
        password: password,
        level: level,
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