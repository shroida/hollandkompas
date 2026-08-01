import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<void> register({
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
  Future<void> register({
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

    await client.from('profiles').insert({
      'id': user.id,
      'full_name': name,
      'email': email,
      'level': level,
      'role': 'student',
    });
  }
}