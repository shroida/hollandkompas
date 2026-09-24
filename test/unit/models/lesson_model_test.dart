import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/lesson/data/models/lesson_model.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('LessonModel.fromJson', () {
    test('maps a lesson with no video/audio recorded yet', () {
      final model = LessonModel.fromJson(lessonJson());

      expect(model.videoUrl, isNull);
      expect(model.audioUrl, isNull);
      expect(model.title, 'Kennismaken');
      expect(model.lessonOrder, 1);
    });

    test('maps a lesson that does have video/audio', () {
      final model = LessonModel.fromJson(lessonJson(
        videoUrl: 'https://cdn.example.com/lesson1.m3u8',
        audioUrl: 'https://cdn.example.com/lesson1.mp3',
      ));

      expect(model.videoUrl, 'https://cdn.example.com/lesson1.m3u8');
      expect(model.audioUrl, 'https://cdn.example.com/lesson1.mp3');
    });
  });

  group('LessonModel.toJson', () {
    test('round-trips through fromJson/toJson without losing data', () {
      final original = lessonJson(videoUrl: 'https://cdn.example.com/x.m3u8');
      final model = LessonModel.fromJson(original);
      final json = model.toJson();

      expect(json['id'], original['id']);
      expect(json['video_url'], original['video_url']);
      expect(json['lesson_order'], original['lesson_order']);
      expect(json['duration_minutes'], original['duration_minutes']);
    });
  });
}
