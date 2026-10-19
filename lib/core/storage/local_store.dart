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

  static String _logKey(DateTime d) => 'log_${d.year}-${d.month}-${d.day}';

  static Map<String, dynamic>? getLog(DateTime d) {
    final v = _box.get(_logKey(d));
    return v == null ? null : Map<String, dynamic>.from(v as Map);
  }

  static Future<void> saveLog(DateTime d, Map<String, dynamic> data) =>
      _box.put(_logKey(d), data);

  static String get role => (_box.get('role') as String?) ?? 'partner';
  static String get relation => (_box.get('relation') as String?) ?? 'partner';
  static bool get onboarded =>
      (_box.get('onboarded') as bool?) ?? (lastPeriod != null);

  static Future<void> saveProfile(String role, String relation) async {
    await _box.put('role', role);
    await _box.put('relation', relation);
  }

  static Future<void> setOnboarded() => _box.put('onboarded', true);
}
