import 'package:flutter/widgets.dart';

class AppDirection {
  static bool isRtl(Locale locale) {
    return locale.languageCode == 'ar';
  }
}