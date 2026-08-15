class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String level;
  final String role;
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.level,
    required this.role,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
}
