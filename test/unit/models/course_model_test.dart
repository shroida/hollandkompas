import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/courses/data/models/course_model.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('CourseModel.fromJson — description parsing', () {
    test('parses a real Map description and lowercases its keys', () {
      final model = CourseModel.fromJson(courseJson(
        description: {'EN': 'Hello', 'NL': 'Hallo', 'AR': 'مرحباً'},
      ));

      expect(model.descriptions['en'], 'Hello');
      expect(model.descriptions['nl'], 'Hallo');
      expect(model.descriptions['ar'], 'مرحباً');
    });

    test('parses a JSON-encoded string description the same way as a Map', () {
      final model = CourseModel.fromJson(courseJson(
        description: '{"en": "Hello", "nl": "Hallo"}',
      ));

      expect(model.descriptions['en'], 'Hello');
      expect(model.descriptions['nl'], 'Hallo');
    });

    test('treats a plain non-JSON string as an English-only description', () {
      final model = CourseModel.fromJson(courseJson(
        description: 'Just a plain description, not JSON.',
      ));

      expect(model.descriptions, {'en': 'Just a plain description, not JSON.'});
    });

    test('treats an empty string as no description at all', () {
      final model = CourseModel.fromJson(courseJson(description: ''));

      expect(model.descriptions, isEmpty);
    });

    test('treats a null description as no description at all', () {
      final model = CourseModel.fromJson(courseJson(description: null));

      expect(model.descriptions, isEmpty);
    });

    test('a JSON array (valid JSON, but not a Map) falls back to empty, not a crash', () {
      final model = CourseModel.fromJson(courseJson(description: '["not", "a", "map"]'));

      expect(model.descriptions, isEmpty);
    });
  });

  group('CourseModel.fromJson — the rest of the fields', () {
    test('maps every column to the right field', () {
      final model = CourseModel.fromJson(courseJson(
        id: 'course-b1',
        title: 'Nederlands B1',
        level: 'B1',
        isPublished: false,
        price: 5500,
      ));

      expect(model.id, 'course-b1');
      expect(model.title, 'Nederlands B1');
      expect(model.level, 'B1');
      expect(model.isPublished, false);
      expect(model.price, 5500);
    });

    test('is_published defaults to false when the column is missing', () {
      final json = courseJson()..remove('is_published');
      final model = CourseModel.fromJson(json);

      expect(model.isPublished, false);
    });

    test('price defaults to 0.0 when the column is null', () {
      final json = courseJson();
      json['price'] = null;
      final model = CourseModel.fromJson(json);

      expect(model.price, 0.0);
    });
  });
}
