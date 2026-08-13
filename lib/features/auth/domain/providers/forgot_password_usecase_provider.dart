import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/auth_repository_provider.dart';
import '../usecases/forgot_password_usecase.dart';

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
});
