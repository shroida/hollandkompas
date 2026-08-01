import 'package:hollandkompas/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:hollandkompas/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String level,
  }) {
    return remote.register(
      name: name,
      email: email,
      password: password,
      level: level,
    );
  }
}