import 'package:flutter/material.dart';
import 'package:hollandkompas/features/auth/data/providers/auth_repository_provider.dart';
import 'package:hollandkompas/features/auth/domain/providers/forgot_password_usecase_provider.dart';
import 'package:hollandkompas/features/auth/domain/providers/login_usecase_provider.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/home/presentation/providers/current_user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import '../../domain/enums/dutch_level.dart';
import '../../domain/providers/register_usecase_provider.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    // Restore the existing Supabase session when the app starts/reloads.
    Future.microtask(loadCurrentUser);

    return const AuthState(isLoading: true);
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await ref
          .read(registerUseCaseProvider)
          .call(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            level: level,
            phoneNumber: phoneNumber,
          );

      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, user: user, error: null);
    } catch (e) {
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, user: null, error: e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, user: null, error: null);

    try {
      final user = await ref
          .read(loginUseCaseProvider)
          .call(email: email, password: password);

      if (!ref.mounted) return;

      debugPrint('======================================');
      debugPrint('LOGIN SUCCESS');
      debugPrint('Email: ${user.email}');
      debugPrint('User ID: ${user.id}');
      debugPrint(
        'Supabase Auth ID: '
        '${Supabase.instance.client.auth.currentUser?.id}',
      );
      debugPrint('======================================');

      state = state.copyWith(isLoading: false, user: user, error: null);
    } catch (e) {
      if (!ref.mounted) return;

      debugPrint('LOGIN ERROR: $e');

      state = state.copyWith(
        isLoading: false,
        user: null,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    final oldUserId = supabaseUser?.id;

    debugPrint('======================================');
    debugPrint('LOGOUT');
    debugPrint('Supabase User ID: $oldUserId');
    debugPrint('Supabase Email: ${supabaseUser?.email}');
    debugPrint('======================================');

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(authRepositoryProvider).logout();

      if (!ref.mounted) return;

      if (oldUserId != null) {
        ref.invalidate(enrolledCoursesProvider(oldUserId));
      }

      ref.invalidate(currentUserProvider);

      state = const AuthState();

      debugPrint('LOGOUT SUCCESS');
      debugPrint(
        'Supabase current user after logout: '
        '${Supabase.instance.client.auth.currentUser?.id}',
      );
    } catch (e) {
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(forgotPasswordUseCaseProvider).call(email: email);

      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      if (!ref.mounted) return;

      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updatePassword(String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(authRepositoryProvider).updatePassword(password);

      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      debugPrint('======================================');
      debugPrint('RESTORING CURRENT USER');
      debugPrint(
        'Supabase Auth User ID: '
        '${Supabase.instance.client.auth.currentUser?.id}',
      );
      debugPrint(
        'Supabase Auth Email: '
        '${Supabase.instance.client.auth.currentUser?.email}',
      );
      debugPrint('======================================');

      final user = await ref.read(authRepositoryProvider).getCurrentUser();

      if (!ref.mounted) return;

      debugPrint('======================================');
      debugPrint('CURRENT USER RESTORED');
      debugPrint('User ID: ${user?.id}');
      debugPrint('Email: ${user?.email}');
      debugPrint('======================================');

      state = state.copyWith(isLoading: false, user: user, error: null);
    } catch (e) {
      if (!ref.mounted) return;

      debugPrint('======================================');
      debugPrint('RESTORE USER ERROR');
      debugPrint('$e');
      debugPrint('======================================');

      state = state.copyWith(isLoading: false, user: null, error: e.toString());
    }
  }
}
