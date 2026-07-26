import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../hive_boxes.dart';

part 'storage_provider.g.dart';

@Riverpod(keepAlive: true)
Box settingsBox(Ref ref) {
  return Hive.box(HiveBoxes.settings);
}

@Riverpod(keepAlive: true)
Box userBox(Ref ref) {
  return Hive.box(HiveBoxes.user);
}

@Riverpod(keepAlive: true)
Box cacheBox(Ref ref) {
  return Hive.box(HiveBoxes.cache);
}