import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/auth_repository_provider.dart';
import '../usecases/register_usecase.dart';

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});
