import 'package:hollandkompas/features/auth/data/models/user_model.dart';
import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String level,
  });
}
class SupabaseAuthRemoteDataSource
    implements AuthRemoteDataSource {

  final SupabaseClient client;

  SupabaseAuthRemoteDataSource(this.client);
  @override
 Future<AppUser> register({
  required String name,
  required String email,
  required String password,
  required String level,
}) async {
  final response = await client.auth.signUp(
    email: email,
    password: password,
  );

  final user = response.user;

  if (user == null) {
    throw Exception("Registration failed");
  }

  final model = UserModel(
    id: user.id,
    fullName: name,
    email: email,
    level: level,
    role: 'student',
  );

  await client.from('profiles').insert(model.toJson());

  return model;
}
}