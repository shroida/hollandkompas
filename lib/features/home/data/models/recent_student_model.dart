import 'package:hollandkompas/features/home/domain/entities/recent_student.dart';

class RecentStudentModel extends RecentStudent {
  const RecentStudentModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.level,
    required super.createdAt,
  });

  factory RecentStudentModel.fromMap(Map<String, dynamic> map) {
    return RecentStudentModel(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      level: map['level'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'level': level,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
