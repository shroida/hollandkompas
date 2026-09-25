import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:hollandkompas/features/vocabulary/presentation/providers/vocabulary_repository_provider.dart';
import 'package:hollandkompas/features/vocabulary/presentation/screen/pages/favorite_words_screen.dart';
import 'package:hollandkompas/features/vocabulary/presentation/screen/pages/vocabulary_home_screen.dart';
import 'package:hollandkompas/features/vocabulary/presentation/screen/pages/vocabulary_search_screen.dart';
import 'package:hollandkompas/features/vocabulary/presentation/screen/pages/word_details_screen.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/fakes.dart';
import '../test/helpers/pump_app.dart';

VocabularyWord _word({
  required String id,
  required String dutchWord,
  required String arabicMeaning,
  VocabularyLevel level = VocabularyLevel.a1,
  required String category,
}) {
  return VocabularyWord(
    id: id,
    dutchWord: dutchWord,
    arabicMeaning: arabicMeaning,
    level: level.name,
    category: category,
  );
}

final _routes = [
  GoRoute(
    path: '/vocabulary',
    builder: (context, state) => const VocabularyHomeScreen(),
  ),
  GoRoute(
    path: '/vocabulary/search',
    builder: (context, state) => const VocabularySearchScreen(),
  ),
  GoRoute(
    path: '/vocabulary/favorites',
    builder: (context, state) => const FavoriteWordsScreen(),
  ),
  GoRoute(
    path: '/vocabulary/word/:id',
    builder: (context, state) => WordDetailsScreen(
      wordId: state.pathParameters['id']!,
      initialWord: state.extra as VocabularyWord?,
    ),
  ),
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'browsing the word list, opening a word, and favoriting it shows up in Favorites',
    (tester) async {
      final fakeRepo = FakeVocabularyRepository(
        words: [
          _word(
            id: 'w1',
            dutchWord: 'hallo',
            arabicMeaning: 'مرحباً',
            category: 'greeting',
          ),
          _word(id: 'w2', dutchWord: 'dag', arabicMeaning: 'يوم', category: ''),
        ],
      );

      await pumpAppWithRouter(
        tester,
        _routes,
        initialLocation: '/vocabulary',
        overrides: [
          vocabularyRepositoryProvider.overrideWith((ref) => fakeRepo),
        ],
      );

      await tester.pumpAndSettle();

      expect(find.text('hallo'), findsOneWidget);
      expect(find.text('dag'), findsOneWidget);

      await tester.tap(find.text('hallo').last);
      await tester.pumpAndSettle();

      expect(find.byType(WordDetailsScreen), findsOneWidget);
      expect(find.text('مرحباً'), findsOneWidget);

      // Tap the favorite (bookmark) toggle in the app bar.
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      expect(fakeRepo.isFavorite('w1'), isTrue);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('المفضلة'));

      await tester.pumpAndSettle();

      expect(find.byType(FavoriteWordsScreen), findsOneWidget);
      expect(find.text('hallo'), findsOneWidget);

      expect(find.text('dag'), findsNothing);
    },
  );

  testWidgets('searching filters to matching words only', (tester) async {
    final fakeRepo = FakeVocabularyRepository(
      words: [
        _word(
          id: 'w1',
          dutchWord: 'hallo',
          arabicMeaning: 'مرحباً',
          category: 'greeting',
        ),
        _word(
          id: 'w2',
          dutchWord: 'water',
          arabicMeaning: 'مياه',
          category: 'food',
        ),
      ],
    );

    await pumpAppWithRouter(
      tester,
      _routes,
      initialLocation: '/vocabulary/search',
      overrides: [vocabularyRepositoryProvider.overrideWith((ref) => fakeRepo)],
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'wat');

    await tester.pumpAndSettle();

    expect(find.text('water'), findsOneWidget);
    expect(find.text('hallo'), findsNothing);
  });

  testWidgets('an empty word bank shows an empty state instead of crashing', (
    tester,
  ) async {
    final fakeRepo = FakeVocabularyRepository(words: []);

    await pumpAppWithRouter(
      tester,
      _routes,
      initialLocation: '/vocabulary',
      overrides: [vocabularyRepositoryProvider.overrideWith((ref) => fakeRepo)],
    );

    await tester.pumpAndSettle();

    // getDailyWord() throws on an empty bank (by design — see
    // vocabulary_remote_datasource.dart) — the home screen's
    // .when(error: ...) branch should swallow that into an empty
    // SizedBox, not visibly crash.
    expect(tester.takeException(), isNull);
  });
}
