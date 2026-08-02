import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/repositories/auth_repository.dart';

import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthRemoteDataSource  remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required DutchLevel level,
  }) {
    return remote.register(
      name: name,
      email: email,
      password: password,
      level: level,
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
}