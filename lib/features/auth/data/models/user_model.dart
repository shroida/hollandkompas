import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.level,
    required super.role,
    required super.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      level: DutchLevel.values.byName(json['level'] as String),
      role: UserRole.values.byName(json['role'] as String),
      phoneNumber: json['phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'level': level.name,
      'role': role.name,
      'phone_number': phoneNumber,
    };
  }
}