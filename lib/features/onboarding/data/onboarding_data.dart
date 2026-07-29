import 'package:flutter/material.dart';
import '../models/onboarding_slide.dart';

const onboardingSlides = [
  OnboardingSlide(
    emoji: '🇳🇱',
    image:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200',
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
    image:
        'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=1200',
    titleAr: 'دروس يومية مخصصة',
    titleNl: 'Gepersonaliseerde lessen',
    descAr:
        'خوارزمية ذكية تتكيف مع مستواك وسرعة تعلمك.',
    tags: [
      'خطة يومية',
      'أهداف شخصية',
      'تقدم ذكي',
    ],
    gradient: [
      Color(0xFF1E3A8A),
      Color(0xFF2563EB),
    ],
  ),

  OnboardingSlide(
    emoji: '🧠',
    image:
        'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=1200',
    titleAr: 'بطاقات ذكية للحفظ',
    titleNl: 'Slimme flashcards',
    descAr:
        'نظام التكرار المتباعد يساعدك على تذكر الكلمات لفترة أطول.',
    tags: [
      'Flashcards',
      'صوت النطق',
      'تكرار متباعد',
    ],
    gradient: [
      Color(0xFF7C3AED),
      Color(0xFF6D28D9),
    ],
  ),

  OnboardingSlide(
    emoji: '🏆',
    image:
        'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=1200',
    titleAr: 'تتبع تقدمك اليومي',
    titleNl: 'Volg je voortgang',
    descAr:
        'إحصائيات وشارات تحفزك على الاستمرار.',
    tags: [
      'إحصائيات',
      'إنجازات',
      'سلسلة يومية',
    ],
    gradient: [
      Color(0xFF16A34A),
      Color(0xFF059669),
    ],
  ),
];