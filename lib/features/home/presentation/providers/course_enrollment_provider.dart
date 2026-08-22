import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/app_exception.dart';

final courseEnrollmentProvider = FutureProvider.family<bool, String>((
  ref,
  courseId,
) async {
  final supabase = ref.watch(supabaseClientProvider);

  final user = supabase.auth.currentUser;

  if (user == null) {
    return false;
  }

  final enrollment = await supabase
      .from('enrollments')
      .select('id')
      .eq('user_id', user.id)
      .eq('course_id', courseId)
      .maybeSingle();

  return enrollment != null;
});
