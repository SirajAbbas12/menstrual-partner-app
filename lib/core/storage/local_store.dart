import 'package:hive_flutter/hive_flutter.dart';

class LocalStore {
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('settings');
  }

  static DateTime? get lastPeriod {
    final s = _box.get('lastPeriod') as String?;
    return s == null ? null : DateTime.tryParse(s);
  }

  static int get cycleLength => (_box.get('cycleLength') as int?) ?? 28;

  static Future<void> saveCycle(DateTime date, int length) async {
    await _box.put('lastPeriod', date.toIso8601String());
    await _box.put('cycleLength', length);
  }
}
