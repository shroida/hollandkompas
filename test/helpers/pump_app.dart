import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Pumps [child] inside a ProviderScope + MaterialApp using the app's real
/// theme, with [overrides] applied. Use this instead of hand-wrapping every
/// widget test so all widget tests render with consistent fonts/colors.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(theme: AppTheme.lightTheme, home: child),
    ),
  );
}

/// Same as [pumpApp], but hosts [child] behind a real GoRouter so
/// `context.push`/`context.go` calls inside it don't throw. Pass the routes
/// the test actually needs — usually just one or two, not the full app
/// router.
Future<void> pumpAppWithRouter(
  WidgetTester tester,
  List<RouteBase> routes, {
  List<Override> overrides = const [],
  String initialLocation = '/',
}) async {
  final router = GoRouter(initialLocation: initialLocation, routes: routes);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    ),
  );
}
