import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRemoteDataSource  {

  final SupabaseClient client;

  SupabaseAuthRemoteDataSource (this.client);


  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required DutchLevel level,
  }) async {

    final response =
        await client.auth.signUp(
      email: email,
      password: password,
    );


    final user = response.user;

    if (user == null) {
      throw Exception(
        "Registration failed"
      );
    }


    await client
        .from('profiles')
        .insert({

      'id': user.id,
      'full_name': name,
      'email': email,
      'level': level.name,
      'role': 'student',

    });


    return AppUser(
      id: user.id,
      email: email,
      fullName: name,
      level: level,
      role: UserRole.student,
    );

  }

  Future<AppUser> login({
  required String email,
  required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final authUser = response.user;

    if (authUser == null) {
      throw Exception('Login failed');
    }

    final profile = await client
        .from('profiles')
        .select()
        .eq('id', authUser.id)
        .single();

    return AppUser(
      id: authUser.id,
      email: profile['email'] as String,
      fullName: profile['full_name'] as String,
      level: DutchLevel.values.byName(profile['level'] as String),
      role: UserRole.values.byName(profile['role'] as String),
    );
  }
  Future<void> logout() async {
    await client.auth.signOut();
  }
  Future<AppUser?> getCurrentUser() async {
  final authUser = client.auth.currentUser;

  if (authUser == null) return null;

  final profile = await client
      .from('profiles')
      .select()
      .eq('id', authUser.id)
      .single();

  return AppUser(
    id: authUser.id,
    email: profile['email'],
    fullName: profile['full_name'],
    level: DutchLevel.values.byName(profile['level']),
    role: UserRole.values.byName(profile['role']),
  );
  }
}