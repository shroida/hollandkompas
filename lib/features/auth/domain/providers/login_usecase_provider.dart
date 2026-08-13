import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/auth/data/providers/auth_repository_provider.dart';

import '../../domain/usecases/login_usecase.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});
