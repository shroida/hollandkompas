import '../enums/dutch_level.dart';
import '../enums/user_role.dart';

class AppUser {
  final String id;
  final String email;
  final String fullName;
  final DutchLevel level;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.level,
    required this.role,
  });
}