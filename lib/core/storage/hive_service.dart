import 'package:hive_flutter/hive_flutter.dart';
import 'package:hollandkompas/core/storage/hive_boxes.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox(HiveBoxes.settings);
    await Hive.openBox(HiveBoxes.user);
    await Hive.openBox(HiveBoxes.cache);
  }
}