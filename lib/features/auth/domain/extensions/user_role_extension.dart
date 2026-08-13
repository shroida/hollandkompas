import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';

extension UserRoleExtension on AppUser {
  bool get isAdmin => role == UserRole.admin;
  bool get isStudent => role == UserRole.student;
}