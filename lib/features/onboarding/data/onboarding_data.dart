import 'package:flutter/material.dart';
import '../models/onboarding_slide.dart';

const onboardingSlides = [
  OnboardingSlide(
    emoji: '🇳🇱',
    titleAr: 'تعلم الهولندية بسهولة',
    titleNl: 'Leer Nederlands gemakkelijk',
    descAr:
        'منهج شامل يأخذك من الصفر إلى مستوى B2 بخطوات منظمة ومدروسة.',
    tags: [
      'مفردات',
      'قواعد',
      'محادثة',
      'قصص',
    ],
    gradient: [
      Color(0xFFFF6B00),
      Color(0xFFE55A00),
    ],
  ),

  OnboardingSlide(
    emoji: '🎯',
    titleAr: 'دروس مخصصة',
    titleNl: 'Persoonlijke lessen',
    descAr:
        'تعلم حسب مستواك الحالي وسرعتك الخاصة.',
    tags: [
      'أهداف',
      'خطة يومية',
      'ذكاء اصطناعي',
    ],
    gradient: [
      Color(0xFF1E3A8A),
      Color(0xFF2563EB),
    ],
  ),
];