import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/auth/data/providers/auth_repository_provider.dart';
import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  return ref.read(authRepositoryProvider).getCurrentUser();
});