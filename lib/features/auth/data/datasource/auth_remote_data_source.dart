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
}