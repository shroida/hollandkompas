import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/core/theme/app_theme.dart';

// Adjust this import path if AuthTextField lives somewhere else in your
// project — it was shared as a standalone snippet, not with its file path.
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: field),
      ),
    );
  }

  testWidgets('shows the label and hint text', (tester) async {
    await pump(tester, const AuthTextField(label: 'Email', hint: 'you@example.com'));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('you@example.com'), findsOneWidget);
  });

  testWidgets('shows the prefix icon only when one is given', (tester) async {
    await pump(
      tester,
      const AuthTextField(label: 'Email', hint: 'x', icon: Icons.email_outlined),
    );
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);

    await pump(tester, const AuthTextField(label: 'Email', hint: 'x'));
    expect(find.byIcon(Icons.email_outlined), findsNothing);
  });

  testWidgets('passes obscureText through to the underlying TextField', (tester) async {
    await pump(
      tester,
      const AuthTextField(label: 'Password', hint: 'x', obscureText: true),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);
  });

  testWidgets('email fields render left-to-right for the typed text', (tester) async {
    await pump(
      tester,
      const AuthTextField(
        label: 'Email',
        hint: 'x',
        keyboardType: TextInputType.emailAddress,
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.textDirection, TextDirection.ltr);
  });

  testWidgets('a plain text field (e.g. name, in Arabic) renders right-to-left', (tester) async {
    await pump(tester, const AuthTextField(label: 'Name', hint: 'x'));

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.textDirection, TextDirection.rtl);
  });

  testWidgets('a password field renders left-to-right regardless of keyboardType', (tester) async {
    await pump(
      tester,
      const AuthTextField(label: 'Password', hint: 'x', obscureText: true),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.textDirection, TextDirection.ltr);
  });

  testWidgets('onChanged fires with the typed text', (tester) async {
    String? seen;
    await pump(
      tester,
      AuthTextField(label: 'Name', hint: 'x', onChanged: (v) => seen = v),
    );

    await tester.enterText(find.byType(TextField), 'Mohamed');
    expect(seen, 'Mohamed');
  });
}
