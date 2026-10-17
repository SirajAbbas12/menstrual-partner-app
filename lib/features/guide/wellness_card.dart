import 'package:flutter/material.dart';
import '../cycle/domain/cycle_phase.dart';

const Map<CyclePhase, ({List<String> food, List<String> move})> _wellness = {
  CyclePhase.menstrual: (
    food: [
      'Garam aur aasani se pachne wala khana: dal, khichdi, soup, pakki sabziyan',
      'Iron wala khana aur nuts, paani khub piyo',
      'Bleeding zyada ho to iron ki kami ki jaanch karwao',
    ],
    move: [
      'Bhaari workout zaroori nahi',
      'Halki walk, stretching, gehri saans, halka yoga',
      'Dard zyada ho to aaram karo',
    ],
  ),
  CyclePhase.follicular: (
    food: [
      'Protein wala poshak khana: dal, paneer (non-veg ho to ande, machhli, chicken)',
      'Maida ki jagah makka, ragi, jowar, brown rice; aate ka chokar mat nikalo',
      'Achhi fat: nuts, seeds, desi ghee, olive oil',
    ],
    move: [
      'Strength training aur normal workout achha rehta hai',
      'Yoga bhi theek hai, energy badh rahi hoti hai',
    ],
  ),
  CyclePhase.ovulation: (
    food: [
      'Halka, protein wala khana, paani khub piyo',
      'Zyada meetha aur bloating karne wale khane kam rakho',
    ],
    move: [
      'Moderate exercise bilkul theek hai',
    ],
  ),
  CyclePhase.luteal: (
    food: [
      'Meetha, bakery, chips, cold drink kam lo, cravings badhti hain',
      'Protein snack lo: nuts, dahi, chana, fruit aur nuts, garam doodh',
      'Magnesium wale khane, jaise seeds aur nuts',
    ],
    move: [
      'Roz ki walk, yoga, gehri saans aur pranayam',
      'Neend aur stress ka dhyan rakho',
    ],
  ),
};

class WellnessCard extends StatelessWidget {
  final CyclePhase phase;
  const WellnessCard({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    final w = _wellness[phase]!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Khana aur exercise',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _Block(
                icon: Icons.restaurant,
                title: 'Khana',
                items: w.food,
                color: phase.color),
            const SizedBox(height: 10),
            _Block(
                icon: Icons.directions_walk,
                title: 'Exercise',
                items: w.move,
                color: phase.color),
            const SizedBox(height: 8),
            const Text(
              'General salah hai. PCOS, khaas bimari ya zyada bleeding ho to doctor ya dietitian se poochho.',
              style: TextStyle(
                  fontSize: 12.5, fontStyle: FontStyle.italic, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final Color color;
  const _Block(
      {required this.icon,
      required this.title,
      required this.items,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        for (final t in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 26),
            child: Text('•  $t', style: const TextStyle(fontSize: 14.5, height: 1.4)),
          ),
      ],
    );
  }
}
