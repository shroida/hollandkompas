class Course {
  final String id;
  final String title;
  final String description;
  final String level;
  final String? imageUrl;
  final bool isPublished;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int price;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.imageUrl,
    required this.isPublished,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
  });
}
