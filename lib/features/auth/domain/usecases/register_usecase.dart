import 'package:hollandkompas/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<void> call({
    required String fullName,
    required String email,
    required String password,
    required String level,
  }) {
    return repository.register(
      name: fullName,
      email: email,
      password: password,
      level: level,
    );
  }
}