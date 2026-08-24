import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final enrollmentControllerProvider = Provider<EnrollmentController>((ref) {
  return EnrollmentController(Supabase.instance.client);
});

class EnrollmentController {
  final SupabaseClient _supabase;

  EnrollmentController(this._supabase);

  Future<void> enroll(String courseId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated.');
    }

    await _supabase.from('enrollments').insert({
      'student_id': user.id,
      'course_id': courseId,
    });
  }
}
