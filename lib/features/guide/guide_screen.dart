import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../cycle/domain/cycle_calculator.dart';
import '../cycle/domain/cycle_phase.dart';
import '../cycle/providers/cycle_provider.dart';
import 'wellness_card.dart';

typedef _Tips = ({List<String> dos, List<String> donts, String say});

const Map<CyclePhase, _Tips> _data = {
  CyclePhase.menstrual: (
    dos: [
      'Garam paani ki bottle ya heating pad do',
      'Halka, garam khana ya chai banao',
      'Ghar ke kaam aur zimmedari le lo',
      'Plan halke rakho aur use aaram karne do',
    ],
    donts: [
      'Dard ya mood ko "drama" mat kaho',
      'Zyada sawal ya bahas mat karo',
      'Bhaari ya thakane wale plan mat thopo',
    ],
    say: 'Aaj kuch chahiye to bata dena, main yahin hun.',
  ),
  CyclePhase.follicular: (
    dos: [
      'Saath bahar jaane ka plan banao',
      'Naya kuch try karo: movie, walk, cafe',
      'Uske ideas aur goals dhyan se suno',
      'Zaroori baatein ya planning ab kar lo',
    ],
    donts: [
      'Is achhe mood ka fayda uthake bhaari kaam mat dalo',
      'Ye mat maan lo ki mood hamesha aisa hi rahega',
    ],
    say: 'Chalo aaj kahin bahar chalte hain?',
  ),
  CyclePhase.ovulation: (
    dos: [
      'Quality time bitao, phone door rakho',
      'Dil se tareef karo',
      'Saath mein kuch karo: date, walk, dance',
      'Khulkar baat karo',
    ],
    donts: [
      'Zabardasti kuch mat karo, uski marzi poochho',
      'Apni expectations uspar mat thopo',
    ],
    say: 'Aaj tum bahut achhi lag rahi ho, chalo kuch khaas karte hain.',
  ),
  CyclePhase.luteal: (
    dos: [
      'Dhyan se suno, solution dene mein jaldi mat karo',
      'Uski pasand ka khana ya meetha laao',
      'Neend aur aaram ka dhyan rakho',
      'Chhoti baaton par sabr rakho',
    ],
    donts: [
      'Bahas ya purani baatein mat uthao',
      '"Tum PMS mein ho" mat bolo',
      'Mood badalne ko personally mat lo',
    ],
    say: 'Main sun raha hun. Abhi tumhe kya chahiye?',
  ),
};

class GuideScreen extends ConsumerStatefulWidget {
  const GuideScreen({super.key});

  @override
  ConsumerState<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends ConsumerState<GuideScreen> {
  late CyclePhase _phase;

  @override
  void initState() {
    super.initState();
    final s = ref.read(cycleProvider);
    _phase = s.lastPeriod == null
        ? CyclePhase.follicular
        : CycleCalculator.calculate(
            lastPeriodStart: s.lastPeriod!,
            cycleLength: s.cycleLength,
          ).phase;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tips = _data[_phase]!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Partner Guide', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text('Kaunsa phase dekhna hai? Chip dabao.'),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final p in CyclePhase.values)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _phase = p),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: p == _phase
                            ? p.color
                            : p.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(p.icon,
                          color: p == _phase ? Colors.white : p.color),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _phase.color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_phase.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(_phase.description,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14.5, height: 1.45)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _Section(
              title: 'Kya karo',
              icon: Icons.check_circle,
              color: AppColors.follicular,
              items: tips.dos),
          const SizedBox(height: 14),
          _Section(
              title: 'Kya mat karo',
              icon: Icons.cancel,
              color: AppColors.menstrual,
              items: tips.donts),
          const SizedBox(height: 14),
          WellnessCard(phase: _phase),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble,
                          size: 20, color: AppColors.rose),
                      const SizedBox(width: 8),
                      Text('Aap keh sakte ho',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('"${tips.say}"',
                      style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.5,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Har insaan alag hota hai. Ye general salah hai. Dard bahut zyada ho to doctor se milo.',
            style: TextStyle(fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;
  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            for (final t in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(t,
                          style: const TextStyle(fontSize: 15, height: 1.4)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
