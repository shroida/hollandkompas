class Course {
  final String id;
  final String title;
  final Map<String, String> descriptions;
  final String level;
  final String? imageUrl;
  final bool isPublished;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double price;

  const Course({
    required this.id,
    required this.title,
    required this.descriptions,
    required this.level,
    required this.imageUrl,
    required this.isPublished,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
  });

  String getDescription(String languageCode) {
    final language = languageCode.toLowerCase();

    return descriptions[language] ??
        descriptions['en'] ??
        descriptions.values.firstOrNull ??
        '';
  }
}
