import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import 'message_templates.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caring messages'),
        backgroundColor: AppColors.blush,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Text('Message chuno, apne shabdon mein thoda badlo, aur bhejo.'),
          ),
          for (final t in templates) _MsgCard(t),
        ],
      ),
    );
  }
}

class _MsgCard extends StatelessWidget {
  final Template t;
  const _MsgCard(this.t);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.tag,
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.rose)),
            const SizedBox(height: 6),
            Text('"${t.text}"',
                style: const TextStyle(fontSize: 15.5, height: 1.45)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: t.text));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copy ho gaya')),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                    onPressed: () => launchUrl(
                      Uri.parse(
                          'https://wa.me/?text=${Uri.encodeComponent(t.text)}'),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('WhatsApp'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
