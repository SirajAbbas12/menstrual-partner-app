import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import 'message_engine.dart';

class TodayMessageCard extends StatefulWidget {
  final DateTime lastPeriod;
  final int cycleLength;
  const TodayMessageCard(
      {super.key, required this.lastPeriod, required this.cycleLength});

  @override
  State<TodayMessageCard> createState() => _TodayMessageCardState();
}

class _TodayMessageCardState extends State<TodayMessageCard> {
  int _skip = 0;

  @override
  Widget build(BuildContext context) {
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final text = messageFor(
      date: today,
      lastPeriod: widget.lastPeriod,
      cycleLength: widget.cycleLength,
      skip: _skip,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blushDeep,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.favorite, size: 18, color: AppColors.rose),
            SizedBox(width: 8),
            Text('Aaj ka message',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          Text('"$text"', style: const TextStyle(fontSize: 16, height: 1.45)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _skip++),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Dusra'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: text));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copy ho gaya')),
                    );
                  }
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy'),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                onPressed: () => launchUrl(
                  Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.send, size: 18),
                label: const Text('WhatsApp'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
