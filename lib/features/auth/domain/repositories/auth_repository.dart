abstract class AuthRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String level,
  });
}