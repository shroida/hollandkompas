import '../entities/app_user.dart';
import '../enums/dutch_level.dart';

abstract class AuthRepository {
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required DutchLevel level,
  });
}