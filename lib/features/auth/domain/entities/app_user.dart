import '../enums/dutch_level.dart';
import '../enums/user_role.dart';

class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final DutchLevel level;
  final UserRole role;
  final String phoneNumber;

  const AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.level,
    required this.role,
    required this.phoneNumber,
  });
}