import '../entities/app_user.dart';
import '../enums/dutch_level.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<AppUser> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
  }) {
    return repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      level: level,
      phoneNumber: phoneNumber,
    );
  }
}