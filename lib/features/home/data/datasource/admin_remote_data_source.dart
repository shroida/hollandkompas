abstract interface class AdminRemoteDataSource {
  Future<int> getStudentsCount();

  Future<int> getCoursesCount();

  Future<int> getLessonsCount();

  Future<int> getEnrollmentsCount();

  Future<List<RecentStudentModel>> getRecentStudents();

  Future<List<RecentCourseModel>> getRecentCourses();
}
