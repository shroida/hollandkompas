import '../entities/app_user.dart';
import '../enums/dutch_level.dart';

abstract class AuthRepository {
  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
  });
   Future<AppUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AppUser?> getCurrentUser();

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> updatePassword(String password);
}