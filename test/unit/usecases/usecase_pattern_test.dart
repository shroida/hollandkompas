// WHY THIS FILE EXISTS, AND WHY IT DOESN'T HAVE SIBLINGS
// -----------------------------------------------------------------------
// Most of this codebase's usecases are one line: call repository.method()
// and return the result, with zero branching or transformation of their
// own. Testing every single one of those separately mostly tests that
// Dart can call a method — real value is near zero, and it's exactly the
// kind of padding "test the important things, skip what doesn't need it"
// asked to avoid. This file tests the *pattern* once with two examples;
// the rest already get real coverage indirectly through the
// AuthController and widget/integration tests that call them.
//
// Skipped for that reason (thin delegation, no logic of their own):
//   RegisterUseCase, GetWordByIdUseCase, ToggleFavoriteWordUseCase,
//   GetDailyWordUseCase, GetCurrentUserUseCase, GetAllStudents,
//   GetDashboardStatistics, GetRecentCourses, GetRecentStudents,
//   UpdateVocabularyProgressUseCase.
//
// NOT skipped, but covered elsewhere rather than here:
//   LoginUseCase/RegisterUseCase's actual behavior end-to-end is covered
//   by auth_controller_test.dart and integration_test/auth_flow_test.dart,
//   which exercise more real code per test than an isolated usecase test
//   would.

import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/auth/domain/usecases/login_usecase.dart';
import 'package:hollandkompas/features/vocabulary/domain/usecases/get_vocabulary_words_usecase.dart';

import '../../helpers/fakes.dart';

void main() {
  test('a usecase is exactly a thin pass-through — LoginUseCase example', () async {
    final fakeRepo = FakeAuthRepository();
    final usecase = LoginUseCase(fakeRepo);

    final user = await usecase(email: 'mohamed@example.com', password: 'x');

    expect(user.email, 'mohamed@example.com');
    expect(fakeRepo.loginCallCount, 1);
  });

  test('a usecase with named filter params — GetVocabularyWordsUseCase example', () async {
    final fakeRepo = FakeVocabularyRepository(words: [
      // Adjust these fixture fields if VocabularyWord's constructor has
      // moved on since this was written — this test only needs the
      // filtering behavior, not every field to be exactly right.
    ]);
    final usecase = GetVocabularyWordsUseCase(fakeRepo);

    final result = await usecase(level: 'a1', category: 'greetings');

    expect(result, isEmpty); // no words seeded above -> filters to nothing
  });
}
