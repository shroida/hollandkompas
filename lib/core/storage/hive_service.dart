import 'package:hive_flutter/hive_flutter.dart';
import 'package:hollandkompas/core/storage/hive_boxes.dart';

class HiveService {
  static late Box settingsBox;
  static late Box userBox;
  static late Box cacheBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    settingsBox = await Hive.openBox(HiveBoxes.settingsBox);
    userBox = await Hive.openBox(HiveBoxes.userBox);
    cacheBox = await Hive.openBox(HiveBoxes.cacheBox);
  }
}