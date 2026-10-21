import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../../core/storage/local_store.dart';
import '../messages/message_engine.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static bool get enabled =>
      (Hive.box('settings').get('notifOn', defaultValue: false)) as bool;
  static int get hour =>
      (Hive.box('settings').get('notifHour', defaultValue: 21)) as int;
  static int get minute =>
      (Hive.box('settings').get('notifMinute', defaultValue: 0)) as int;
  static int get mHour =>
      (Hive.box('settings').get('notifMHour', defaultValue: 9)) as int;
  static int get mMinute =>
      (Hive.box('settings').get('notifMMinute', defaultValue: 0)) as int;

  static Future<void> init() async {
    if (kIsWeb || _ready) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'daily_message',
      'Roz ka message',
      channelDescription: 'Roz ek caring message',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  static Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ok = await android?.requestNotificationsPermission();
    return ok ?? true;
  }

  static Future<void> refresh() async {
    if (kIsWeb) return;
    await init();
    await _plugin.cancelAll();
    if (!enabled) return;
    final last = LocalStore.lastPeriod;
    if (last == null) return;
    final len = LocalStore.cycleLength;
    final now = DateTime.now();
    final slots = <(int, int, int, String)>[
      (100, mHour, mMinute, 'Subah ka message'),
      (200, hour, minute, 'Shaam ka message'),
    ];
    for (var i = 0; i < 14; i++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      for (var k = 0; k < slots.length; k++) {
        final sl = slots[k];
        final at = DateTime(day.year, day.month, day.day, sl.$2, sl.$3);
        if (!at.isAfter(now)) continue;
        final msg = messageFor(
            date: day, lastPeriod: last, cycleLength: len, skip: k);
        await _plugin.zonedSchedule(
          id: sl.$1 + i,
          title: sl.$4,
          body: msg,
          scheduledDate: tz.TZDateTime.from(at, tz.UTC),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  static Future<void> showNow() async {
    if (kIsWeb) return;
    await init();
    await _plugin.show(
      id: 1,
      title: 'Cycle Partner',
      body: 'Test: notification sahi chal raha hai.',
      notificationDetails: _details,
    );
  }
}
