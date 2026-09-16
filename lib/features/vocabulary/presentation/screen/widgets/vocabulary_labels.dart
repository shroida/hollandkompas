import 'package:flutter/material.dart';

import '../../../domain/entities/vocabulary_word.dart';

extension VocabularyProgressStatusLabel on VocabularyProgressStatus {
  String get labelAr {
    switch (this) {
      case VocabularyProgressStatus.newWord:
        return 'جديدة';

      case VocabularyProgressStatus.learning:
        return 'بتتعلمها';

      case VocabularyProgressStatus.mastered:
        return 'محفوظة';
    }
  }

  Color color() {
    switch (this) {
      case VocabularyProgressStatus.newWord:
        return Colors.blueGrey;

      case VocabularyProgressStatus.learning:
        return Colors.orange;

      case VocabularyProgressStatus.mastered:
        return Colors.green;
    }
  }
}
