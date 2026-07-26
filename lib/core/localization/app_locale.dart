import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    return const Locale('ar');
  }

  void changeLanguage(String languageCode) {
    state = Locale(languageCode);
  }
}