import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';

const _unset = Object();

class AuthState {
  final bool isLoading;
  final AppUser? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    Object? user = _unset,
    Object? error = _unset,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user == _unset ? this.user : user as AppUser?,
      error: error == _unset ? this.error : error as String?,
    );
  }
}