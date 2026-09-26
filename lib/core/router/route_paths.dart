abstract final class RoutePaths {
  // Root
  static const splash = '/';

  // Onboarding
  static const onboarding = '/onboarding';

  // Authentication
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  // Student
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  static const myCourses = '/my-courses';
  static const courseLessons = '/course-lessons';
  static const lessonViewer = '/lesson-viewer';
  static const payment = '/payment';

  // Vocabulary
  static const vocabulary = '/vocabulary';
  static const vocabularySearch = '/vocabulary/search';
  static const vocabularyFavorites = '/vocabulary/favorites';
  static const vocabularyProgress = '/vocabulary/progress';
  static const lessonVocabulary = '/lesson-vocabulary';

  static const vocabularyWord = '/vocabulary/word/:id';
  //flashcards
  static const flashcards = '/flashcards';

  // Admin
  static const admin = '/admin';
  static const totalStudents = 'total-students';
}
