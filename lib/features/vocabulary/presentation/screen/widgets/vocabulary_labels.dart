import 'package:flutter/material.dart';

import '../../../domain/entities/vocabulary_word.dart';

extension VocabularyLevelLabel on VocabularyLevel {
  String get label => name.toUpperCase(); // a1 -> A1
}

extension VocabularyCategoryLabel on VocabularyCategory {
  String get labelAr {
    switch (this) {
      case VocabularyCategory.greetings:
        return 'تحيات';
      case VocabularyCategory.numbers:
        return 'أرقام';
      case VocabularyCategory.family:
        return 'العائلة';
      case VocabularyCategory.food:
        return 'الطعام';
      case VocabularyCategory.dailyLife:
        return 'الحياة اليومية';
      case VocabularyCategory.health:
        return 'الصحة';
      case VocabularyCategory.travel:
        return 'السفر';
      case VocabularyCategory.work:
        return 'العمل';
      case VocabularyCategory.society:
        return 'المجتمع';
      case VocabularyCategory.callCenter:
        return 'كول سنتر';
    }
  }

  IconData get icon {
    switch (this) {
      case VocabularyCategory.greetings:
        return Icons.waving_hand_outlined;
      case VocabularyCategory.numbers:
        return Icons.tag_outlined;
      case VocabularyCategory.family:
        return Icons.family_restroom_outlined;
      case VocabularyCategory.food:
        return Icons.restaurant_outlined;
      case VocabularyCategory.dailyLife:
        return Icons.wb_sunny_outlined;
      case VocabularyCategory.health:
        return Icons.local_hospital_outlined;
      case VocabularyCategory.travel:
        return Icons.flight_outlined;
      case VocabularyCategory.work:
        return Icons.work_outline;
      case VocabularyCategory.society:
        return Icons.groups_outlined;
      case VocabularyCategory.callCenter:
        return Icons.headset_mic_outlined;
    }
  }
}

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
