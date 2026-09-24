/// Fakes, not mocks: each one is a small real implementation of the
/// repository interface, configurable via constructor fields, that you can
/// read and reason about without a mocking framework. Override the relevant
/// Riverpod provider with one of these in tests instead of hitting Supabase.
library;

import 'package:hollandkompas/features/auth/domain/entities/app_user.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/domain/enums/user_role.dart';
import 'package:hollandkompas/features/auth/domain/repositories/auth_repository.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/domain/repositories/course_repository.dart';
import 'package:hollandkompas/features/enrollment/data/utlis/enrollment_gurad.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/coupon.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrollment.dart';
import 'package:hollandkompas/features/enrollment/domain/repositories/enrollment_repository.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:hollandkompas/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:hollandkompas/features/vocabulary/domain/entities/vocabulary_stats.dart';
import 'package:hollandkompas/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:hollandkompas/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:image_picker/image_picker.dart';

// -------------------------------------------------------------------- auth

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? currentUser}) : _currentUser = currentUser;

  AppUser? _currentUser;

  /// Emails that should fail login with "wrong password"-style behavior.
  Set<String> rejectLoginFor = {};

  /// When true, register()/login() throw this instead of succeeding.
  Exception? throwOnNextCall;

  int registerCallCount = 0;
  int loginCallCount = 0;
  int logoutCallCount = 0;
  int forgotPasswordCallCount = 0;

  @override
  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DutchLevel level,
    required String phoneNumber,
    required UserRole role,
  }) async {
    registerCallCount++;
    if (throwOnNextCall != null) {
      final e = throwOnNextCall!;
      throwOnNextCall = null;
      throw e;
    }
    final user = AppUser(
      id: 'fake-user-$registerCallCount',
      email: email,
      firstName: firstName,
      lastName: lastName,
      level: level,
      role: role,
      phoneNumber: phoneNumber,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    loginCallCount++;
    if (rejectLoginFor.contains(email)) {
      throw Exception('Incorrect email or password.');
    }
    if (throwOnNextCall != null) {
      final e = throwOnNextCall!;
      throwOnNextCall = null;
      throw e;
    }
    final user =
        _currentUser ??
        AppUser(
          id: 'fake-user-1',
          email: email,
          firstName: 'Test',
          lastName: 'User',
          level: DutchLevel.a1,
          role: UserRole.student,
          phoneNumber: '+201000000000',
        );
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    logoutCallCount++;
    _currentUser = null;
  }

  @override
  Future<AppUser?> getCurrentUser() async => _currentUser;

  @override
  Future<void> forgotPassword({required String email}) async {
    forgotPasswordCallCount++;
  }

  @override
  Future<void> updatePassword(String password) async {}
}

// ----------------------------------------------------------------- courses

class FakeCourseRepository implements CourseRepository {
  FakeCourseRepository({List<Course>? courses}) : courses = courses ?? [];

  List<Course> courses;

  @override
  Future<List<Course>> getPublishedCourses() async {
    return courses.where((c) => c.isPublished).toList();
  }
}

// -------------------------------------------------------------- enrollment

class FakeEnrollmentRepository implements EnrollmentRepository {
  FakeEnrollmentRepository({
    this.currentStudentId = 'fake-student',
    List<EnrolledCourse>? enrolledCourses,
    Map<String, Enrollment>? existingEnrollments,
    Coupon? coupon,
  }) : enrolledCourses = enrolledCourses ?? [],
       _existingEnrollments = existingEnrollments ?? {},
       _coupon = coupon;

  /// Used to key seeded existing enrollments — set this to match whichever
  /// user id createPaymentRequest is effectively being called for in a
  /// given test, the same way the real datasource uses
  /// supabase.auth.currentUser.id.
  String currentStudentId;

  List<EnrolledCourse> enrolledCourses;
  final Map<String, Enrollment>
  _existingEnrollments; // key: '$studentId:$courseId'
  final Coupon? _coupon;

  /// Set to force createPaymentRequest to throw, simulating an upload or
  /// network failure.
  Exception? throwOnCreatePaymentRequest;

  int createPaymentRequestCallCount = 0;
  Enrollment? lastCreatedEnrollment;

  @override
  Future<Coupon?> getCoupon(String code) async {
    if (_coupon != null && _coupon.code == code && _coupon.isActive) {
      return _coupon;
    }
    return null;
  }

  @override
  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId) async {
    return enrolledCourses;
  }

  @override
  Future<Enrollment> createPaymentRequest({
    required String courseId,
    required double originalPrice,
    required double discountPercentage,
    required double discountAmount,
    required double finalPrice,
    required String? couponCode,
    required XFile receipt,
    required String paymentReference,
  }) async {
    // Enforces the exact same rule as production — see enrollment_guard.dart
    // — so a test exercising this Fake is exercising real decision logic,
    // not just a fake that always says yes.
    final existing = _existingEnrollments['$currentStudentId:$courseId'];
    if (existing != null) {
      final guardResult = checkEnrollmentGuard(
        isPaid: existing.isPaid,
        paymentStatus: existing.paymentStatus,
      );
      final message = enrollmentGuardMessage(guardResult);
      if (message != null) {
        throw Exception(message);
      }
    }

    createPaymentRequestCallCount++;
    if (throwOnCreatePaymentRequest != null) {
      final e = throwOnCreatePaymentRequest!;
      throwOnCreatePaymentRequest = null;
      throw e;
    }
    final enrollment = Enrollment(
      id: 'fake-enrollment-$createPaymentRequestCallCount',
      studentId: currentStudentId,
      courseId: courseId,
      isPaid: false,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      couponCode: couponCode,
      paymentReceiptUrl: 'https://example.com/receipt.jpg',
      paymentReference: paymentReference,
      paymentStatus: 'pending',
      paymentSubmittedAt: DateTime.now(),
      paymentReviewedAt: null,
      paymentReviewedBy: null,
      enrolledAt: DateTime.now(),
    );
    lastCreatedEnrollment = enrollment;
    _existingEnrollments['$currentStudentId:$courseId'] = enrollment;
    return enrollment;
  }

  @override
  Future<Enrollment?> getStudentEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    return _existingEnrollments['$studentId:$courseId'];
  }

  /// Test setup helper — seed an existing enrollment for the guard-logic
  /// scenarios (pending / approved / already paid).
  void seedExistingEnrollment(
    String studentId,
    String courseId,
    Enrollment enrollment,
  ) {
    _existingEnrollments['$studentId:$courseId'] = enrollment;
  }
}

// ------------------------------------------------------------------ lesson

class FakeLessonRepository implements LessonRepository {
  FakeLessonRepository({Map<String, List<Lesson>>? lessonsByCourse})
    : lessonsByCourse = lessonsByCourse ?? {};

  Map<String, List<Lesson>> lessonsByCourse;

  @override
  Future<List<Lesson>> getCourseLessons(String courseId) async {
    return lessonsByCourse[courseId] ?? [];
  }
}

// -------------------------------------------------------------- vocabulary

class FakeVocabularyRepository implements VocabularyRepository {
  FakeVocabularyRepository({List<VocabularyWord>? words}) : words = words ?? [];

  List<VocabularyWord> words;
  final Set<String> _favoriteIds = {};
  final Map<String, VocabularyProgressStatus> _progress = {};
  @override
  Future<List<VocabularyWord>> getWords({
    String? level,
    String? category,
  }) async {
    return words.where((w) {
      final levelOk = level == null || w.level == level;
      final categoryOk = category == null || w.category == category;
      return levelOk && categoryOk;
    }).toList();
  }

  @override
  Future<List<VocabularyWord>> searchWords(String query) async {
    final q = query.toLowerCase();
    return words
        .where(
          (w) =>
              w.dutchWord.toLowerCase().contains(q) ||
              w.arabicMeaning.contains(query),
        )
        .toList();
  }

  @override
  Future<VocabularyWord> getWordById(String id) async {
    return words.firstWhere(
      (w) => w.id == id,
      orElse: () => throw Exception('Word not found: $id'),
    );
  }

  @override
  Future<VocabularyWord> getDailyWord() async {
    if (words.isEmpty) throw StateError('No vocabulary words available.');
    return words.first;
  }

  @override
  Future<List<VocabularyWord>> getFavoriteWords() async {
    return words.where((w) => _favoriteIds.contains(w.id)).toList();
  }

  @override
  Future<void> setFavorite(String wordId, bool isFavorite) async {
    if (isFavorite) {
      _favoriteIds.add(wordId);
    } else {
      _favoriteIds.remove(wordId);
    }
  }

  @override
  Future<void> updateProgress(
    String wordId,
    VocabularyProgressStatus status,
  ) async {
    _progress[wordId] = status;
  }

  @override
  Future<VocabularyStats> getProgressStats() async {
    var masteredWords = 0;
    var learningWords = 0;
    var newWords = 0;

    for (final word in words) {
      final status = _progress[word.id] ?? word.progressStatus;

      switch (status) {
        case VocabularyProgressStatus.mastered:
          masteredWords++;
          break;
        case VocabularyProgressStatus.learning:
          learningWords++;
          break;
        case VocabularyProgressStatus.newWord:
          newWords++;
          break;
      }
    }

    return VocabularyStats(
      totalWords: words.length,
      masteredWords: masteredWords,
      learningWords: learningWords,
      newWords: newWords,
    );
  }

  bool isFavorite(String wordId) => _favoriteIds.contains(wordId);
  VocabularyProgressStatus? progressFor(String wordId) => _progress[wordId];

  @override
  Future<void> refresh() async {}
}
