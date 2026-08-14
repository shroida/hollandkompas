class RecentStudent {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String level;
  final DateTime createdAt;

  const RecentStudent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.level,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
}
