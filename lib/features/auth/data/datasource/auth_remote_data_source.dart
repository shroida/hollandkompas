import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRemoteDataSource  {

  final SupabaseClient client;

  SupabaseAuthRemoteDataSource (this.client);


  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
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
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'level': level.name,
      'role': 'student',

    });


    return AppUser(
      id: user.id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      level: level,
      role: UserRole.student,
      phoneNumber: phoneNumber,
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
      throw Exception('Invalid email or password');
    }

    final profile = await client
        .from('profiles')
        .select()
        .eq('id', authUser.id)
        .single();

    return AppUser(
      id: authUser.id,
      email: profile['email'],
      firstName: profile['first_name'],
      lastName: profile['last_name'],
      level: DutchLevel.values.byName(profile['level']),
      role: UserRole.values.byName(profile['role']),
      phoneNumber: profile['phone_number'],
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
      firstName: profile['first_name'],
      lastName: profile['last_name'],
      level: DutchLevel.values.byName(profile['level']),
      role: UserRole.values.byName(profile['role']),
      phoneNumber: profile['phone_number'],
    );
  }
}