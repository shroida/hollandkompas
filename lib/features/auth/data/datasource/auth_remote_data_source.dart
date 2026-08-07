import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';

class SupabaseAuthRemoteDataSource {
  final SupabaseClient client;

  SupabaseAuthRemoteDataSource(this.client);

  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception('Registration failed.');
    }

    try {
      await client.from('profiles').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'level': level.name,
        'role': UserRole.student.name,
      });
    } catch (e, stackTrace) {
      debugPrint('INSERT PROFILE ERROR');
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }

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
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final authUser = response.user;

      if (authUser == null) {
        throw Exception('Invalid email or password.');
      }

      final profile = await client
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .single();

      return AppUser(
        id: authUser.id,
        email: profile['email'] as String,
        firstName: profile['first_name'] as String,
        lastName: profile['last_name'] as String,
        level: DutchLevel.values.byName(profile['level'] as String),
        role: UserRole.values.byName(profile['role'] as String),
        phoneNumber: profile['phone_number'] as String,
      );
    } on AuthException catch (e) {
      switch (e.message.toLowerCase()) {
        case 'invalid login credentials':
          throw Exception('Incorrect email or password.');

        case 'email not confirmed':
          throw Exception('Please verify your email before logging in.');

        case 'user not found':
          throw Exception('No account exists with this email.');

        case 'too many requests':
          throw Exception(
            'Too many login attempts. Please try again later.',
          );

        default:
          throw Exception(e.message);
      }
    } catch (e, stackTrace) {
      debugPrint('LOGIN ERROR');
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
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
      email: profile['email'] as String,
      firstName: profile['first_name'] as String,
      lastName: profile['last_name'] as String,
      level: DutchLevel.values.byName(profile['level'] as String),
      role: UserRole.values.byName(profile['role'] as String),
      phoneNumber: profile['phone_number'] as String,
    );
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      final redirectUrl = kIsWeb
          ? '${Uri.base.origin}/reset-password'
          : 'hollandkompas://reset-password';

      await client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectUrl,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await client.auth.updateUser(
        UserAttributes(password: password),
      );
    } catch (e, stackTrace) {
      debugPrint('UPDATE PASSWORD ERROR');
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}