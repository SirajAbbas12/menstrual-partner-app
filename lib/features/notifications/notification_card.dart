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
  TimeOfDay _time = TimeOfDay(
      hour: NotificationService.hour, minute: NotificationService.minute);

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

  Future<void> _pick() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t == null) return;
    await Hive.box('settings').put('notifHour', t.hour);
    await Hive.box('settings').put('notifMinute', t.minute);
    await NotificationService.refresh();
    if (mounted) setState(() => _time = t);
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
                  child: Text('Roz ka message notification',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                Switch(value: _on, onChanged: _toggle),
              ],
            ),
            if (_on)
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _pick,
                    icon: const Icon(Icons.schedule, size: 18),
                    label: Text(_time.format(context)),
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
            const SizedBox(height: 6),
            const Text(
              'Roz is samay aaj ke mood ke hisaab se ek caring message aayega.',
              style: TextStyle(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
