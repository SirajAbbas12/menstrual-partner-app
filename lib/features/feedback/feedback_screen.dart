import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/local_store.dart';
import '../../core/theme/app_theme.dart';

const _feedbackUrl = 'https://formspree.io/f/xljgqoae';

class FeedbackButton extends StatelessWidget {
  const FeedbackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FeedbackScreen()),
      ),
      icon: const Icon(Icons.rate_review_outlined),
      label: const Text('Feedback do'),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _msg = TextEditingController();
  final _contact = TextEditingController();
  int? _rating;
  bool _sending = false;

  @override
  void dispose() {
    _msg.dispose();
    _contact.dispose();
    super.dispose();
  }

  void _toast(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<void> _send() async {
    if (_msg.text.trim().isEmpty) {
      _toast('Kuch likho, phir bhejo');
      return;
    }
    setState(() => _sending = true);
    try {
      final res = await http.post(
        Uri.parse(_feedbackUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': _msg.text.trim(),
          'contact': _contact.text.trim(),
          'rating': _rating?.toString() ?? '',
          'role': LocalStore.role,
          'app': 'Cycle Partner',
        }),
      );
      if (!mounted) return;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        _msg.clear();
        _contact.clear();
        setState(() => _rating = null);
        _toast('Shukriya! Feedback mil gaya.');
      } else {
        _toast('Nahi gaya, thodi der baad try karo.');
      }
    } catch (_) {
      if (mounted) _toast('Internet check karo aur dobara try karo.');
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback do'),
        backgroundColor: AppColors.blush,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Kya achha laga? Kya samajh nahi aaya? Koi bug?'),
          const SizedBox(height: 12),
          TextField(
            controller: _msg,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Yahan likho',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('App kaisa laga? (1 = kharab, 5 = bahut achha)'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (var i = 1; i <= 5; i++)
                ChoiceChip(
                  label: Text('$i'),
                  selected: _rating == i,
                  onSelected: (_) => setState(() => _rating = i),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contact,
            decoration: const InputDecoration(
              hintText: 'Email ya WhatsApp (zaroori nahi)',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _sending ? null : _send,
            child: Text(_sending ? 'Bhej rahe hain...' : 'Bhejo'),
          ),
        ],
      ),
    );
  }
}
