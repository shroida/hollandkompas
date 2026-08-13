import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:hollandkompas/features/auth/domain/repositories/auth_repository.dart';

import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthRemoteDataSource  remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
    required UserRole role,
    
  }) {
    return remote.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      level: level,
      phoneNumber: phoneNumber,
      role: role,
    );
  }
  
  @override
  Future<AppUser?> getCurrentUser() {
    return remote.getCurrentUser();
  }
  
  @override
  Future<AppUser> login({required String email, required String password}) {
    return remote.login(email: email, password: password);
  }
  
  @override
  Future<void> logout() {
    return remote.logout();
  }

  @override
  Future<void> forgotPassword({required String email}) {
    return remote.forgotPassword(email: email);
  }
  
  @override
  Future<void> updatePassword(String password) {
    return remote.updatePassword(password);
  }
}