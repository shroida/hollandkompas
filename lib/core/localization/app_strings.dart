import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;

  const AppStrings(this.locale);

  bool get isArabic => locale.languageCode == 'ar';
  bool get isDutch => locale.languageCode == 'nl';

  String get keepLearning {
    if (isArabic) return 'كمّل تعلُّمك 🚀';
    if (isDutch) return 'Blijf leren 🚀';
    return 'Keep learning 🚀';
  }

  String get learningJourney {
    if (isArabic) return 'رحلتك التعليمية';
    if (isDutch) return 'Jouw leerreis';
    return 'Your learning journey';
  }

  String courses(int count) {
    if (isArabic) {
      return count == 1 ? 'كورس واحد' : '$count كورسات';
    }

    if (isDutch) {
      return count == 1 ? '1 cursus' : '$count cursussen';
    }

    return count == 1 ? '1 course' : '$count courses';
  }

  String averageProgress(int percentage) {
    if (isArabic) {
      return '$percentage% متوسط التقدم';
    }

    if (isDutch) {
      return '$percentage% gemiddelde voortgang';
    }

    return '$percentage% average progress';
  }

  String get myLearning {
    if (isArabic) return 'تعلّمي';
    if (isDutch) return 'Mijn leeromgeving';
    return 'My learning';
  }

  String get continueWhereLeftOff {
    if (isArabic) return 'كمّل من آخر مكان وقفت عنده.';
    if (isDutch) return 'Ga verder waar je gebleven bent.';
    return 'Continue where you left off.';
  }

  String get coursesLabel {
    if (isArabic) return 'الكورسات';
    if (isDutch) return 'Cursussen';
    return 'Courses';
  }

  String get totalLessons {
    if (isArabic) return 'إجمالي الدروس';
    if (isDutch) return 'Totaal lessen';
    return 'Total lessons';
  }

  String get completed {
    if (isArabic) return 'مكتمل';
    if (isDutch) return 'Voltooid';
    return 'Completed';
  }

  String get progress {
    if (isArabic) return 'التقدم';
    if (isDutch) return 'Voortgang';
    return 'Progress';
  }

  String get yourProgress {
    if (isArabic) return 'تقدمك';
    if (isDutch) return 'Jouw voortgang';
    return 'Your progress';
  }

  String get courseCompleted {
    if (isArabic) return 'الكورس اكتمل 🎉';
    if (isDutch) return 'Cursus voltooid 🎉';
    return 'Course completed 🎉';
  }

  String lessons(int completed, int total) {
    if (isArabic) {
      return '$completed من $total درس';
    }

    if (isDutch) {
      return '$completed / $total lessen';
    }

    return '$completed / $total lessons';
  }

  String get continueButton {
    if (isArabic) return 'كمّل';
    if (isDutch) return 'Doorgaan';
    return 'Continue';
  }

  String get review {
    if (isArabic) return 'مراجعة';
    if (isDutch) return 'Herhalen';
    return 'Review';
  }

  String get myCourses {
    if (isArabic) return 'كورساتي';
    if (isDutch) return 'Mijn cursussen';
    return 'My Courses';
  }

  String get exploreCourses {
    if (isArabic) return 'استكشف الكورسات';
    if (isDutch) return 'Ontdek cursussen';
    return 'Explore courses';
  }

  String get settings {
    if (isArabic) return 'الإعدادات';
    if (isDutch) return 'Instellingen';
    return 'Settings';
  }

  String get logout {
    if (isArabic) return 'تسجيل الخروج';
    if (isDutch) return 'Uitloggen';
    return 'Logout';
  }

  String get profile {
    if (isArabic) return 'الملف الشخصي';
    if (isDutch) return 'Profiel';
    return 'Profile';
  }

  String get yourCoursesAreWaiting {
    if (isArabic) return 'الكورسات مستنياك';
    if (isDutch) return 'Je cursussen wachten op je';
    return 'Your courses are waiting';
  }

  String get noEnrolledCourses {
    if (isArabic) {
      return 'لسه مش مشترك في أي كورسات. ابدأ تعلّم الهولندي النهارده.';
    }

    if (isDutch) {
      return 'Je bent nog niet ingeschreven voor cursussen. Begin vandaag met Nederlands leren.';
    }

    return 'You have not enrolled in any courses yet. Start learning Dutch today.';
  }

  String get unableToLoadCourses {
    if (isArabic) return 'مش قادرين نحمّل الكورسات';
    if (isDutch) return 'Je cursussen kunnen niet worden geladen';
    return 'Unable to load your courses';
  }

  String get loadingError {
    if (isArabic) {
      return 'حصلت مشكلة أثناء تحميل الكورسات الخاصة بيك.';
    }

    if (isDutch) {
      return 'Er is iets misgegaan bij het laden van je cursussen.';
    }

    return 'Something went wrong while loading your enrolled courses.';
  }

  String get tryAgain {
    if (isArabic) return 'حاول تاني';
    if (isDutch) return 'Opnieuw proberen';
    return 'Try again';
  }

  String get loading {
    if (isArabic) return 'جاري التحميل...';
    if (isDutch) return 'Laden...';
    return 'Loading...';
  }
}
