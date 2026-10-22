import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme/app_theme.dart';
import 'notification_service.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _on = NotificationService.enabled;
  TimeOfDay _eve = TimeOfDay(
      hour: NotificationService.hour, minute: NotificationService.minute);
  TimeOfDay _morn = TimeOfDay(
      hour: NotificationService.mHour, minute: NotificationService.mMinute);

  void _msg(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<void> _toggle(bool v) async {
    if (v && !kIsWeb) {
      final ok = await NotificationService.requestPermission();
      if (!ok) {
        if (mounted) {
          _msg('Permission nahi mili. Phone settings se allow karo.');
        }
        return;
      }
    }
    await Hive.box('settings').put('notifOn', v);
    await NotificationService.refresh();
    if (mounted) setState(() => _on = v);
  }

  Future<void> _pick(bool morning) async {
    final t = await showTimePicker(
        context: context, initialTime: morning ? _morn : _eve);
    if (t == null) return;
    final box = Hive.box('settings');
    await box.put(morning ? 'notifMHour' : 'notifHour', t.hour);
    await box.put(morning ? 'notifMMinute' : 'notifMinute', t.minute);
    await NotificationService.refresh();
    if (!mounted) return;
    setState(() {
      if (morning) {
        _morn = t;
      } else {
        _eve = t;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined,
                    color: AppColors.rose),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Roz do message notification',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                Switch(value: _on, onChanged: _toggle),
              ],
            ),
            if (_on)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pick(true),
                    icon: const Icon(Icons.wb_sunny_outlined, size: 18),
                    label: Text('Subah ${_morn.format(context)}'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pick(false),
                    icon: const Icon(Icons.nightlight_outlined, size: 18),
                    label: Text('Shaam ${_eve.format(context)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (kIsWeb) {
                        _msg('Notification sirf asli APK mein chalega.');
                      } else {
                        await NotificationService.showNow();
                      }
                    },
                    child: const Text('Test notification'),
                  ),
                ],
              ),
            if (_on)
              FutureBuilder<int>(
                future: NotificationService.pendingCount(),
                builder: (c, snap) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Schedule: ${snap.data ?? '...'} notification set hain',
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            const SizedBox(height: 6),
            const Text(
              'Roz subah aur shaam, aaj ke mood ke hisaab se ek caring message aayega.',
              style: TextStyle(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
