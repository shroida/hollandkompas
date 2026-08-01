import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String level,
  });
}