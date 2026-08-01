import '../entities/app_user.dart';
import '../enums/dutch_level.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<AppUser> call({
    required String fullName,
    required String email,
    required String password,
    required DutchLevel level,
  }) {
    return repository.register(
      name: fullName,
      email: email,
      password: password,
      level: level,
    );
  }
}