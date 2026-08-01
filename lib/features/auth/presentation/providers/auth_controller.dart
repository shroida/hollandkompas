import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final RegisterUseCase registerUseCase;

  AuthController(this.registerUseCase)
      : super(const AuthState());

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
      final user = await registerUseCase(
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