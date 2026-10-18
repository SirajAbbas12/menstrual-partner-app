import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'guide_content.dart';

class SituationsScreen extends StatelessWidget {
  const SituationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abhi kya ho raha hai?'),
        backgroundColor: AppColors.blush,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Text('Jo situation chal rahi hai, uspar dabao.'),
          ),
          for (final s in situations) _SituationCard(s),
          const SizedBox(height: 8),
          const Text(
            'Har insaan alag hota hai, aur mood hamesha cycle ki wajah se nahi hota. '
            'Udaasi ya chidchidapan lamba chale to kisi visheshagya se baat karo.',
            style: TextStyle(
                fontSize: 12.5, fontStyle: FontStyle.italic, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SituationCard extends StatelessWidget {
  final Situation s;
  const _SituationCard(this.s);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(s.title,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Line(Icons.lightbulb_outline, 'Kyun hota hai', s.why,
                AppColors.luteal),
            _Line(Icons.chat_bubble_outline, 'Kya bolo', '"${s.say}"',
                AppColors.follicular),
            _Line(Icons.block, 'Kya mat bolo', s.dont, AppColors.menstrual),
            _Line(Icons.favorite_border, 'Kya karo', s.doIt, AppColors.rose),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final Color color;
  const _Line(this.icon, this.label, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700)),
                Text(text, style: const TextStyle(fontSize: 14.5, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
