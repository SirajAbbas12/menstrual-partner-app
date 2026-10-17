import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../cycle/providers/cycle_provider.dart';
import 'cycle_wheel.dart';
import 'baby_planning_card.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _unlocked =
      (Hive.box('settings').get('premium', defaultValue: false)) as bool;
  DateTime? _date;

  Future<void> _setPremium(bool v) async {
    await Hive.box('settings').put('premium', v);
    setState(() => _unlocked = v);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _unlocked ? _unlockedView(context) : _lockedView(context),
    );
  }

  Widget _lockedView(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.rose.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, size: 40, color: AppColors.rose),
            ),
            const SizedBox(height: 18),
            Text('Premium features', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 18),
            const _LockedRow(
              icon: Icons.event_available,
              title: 'Safe Days ka andaza',
              sub: 'Cycle ke hisaab se kam aur zyada sambhavna wale din',
            ),
            const SizedBox(height: 12),
            const _LockedRow(
              icon: Icons.auto_awesome,
              title: 'Traditional manyata',
              sub: 'Sirf manoranjan ke liye, koi vaigyanik aadhar nahi',
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: () => _setPremium(true),
              icon: const Icon(Icons.lock_open),
              label: const Text('Unlock (test mode)'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Price jald batayi jayegi. Abhi ye button sirf testing ke liye hai.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unlockedView(BuildContext context) {
    final theme = Theme.of(context);
    final s = ref.watch(cycleProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Premium', style: theme.textTheme.headlineSmall),
            ),
            TextButton(
              onPressed: () => _setPremium(false),
              child: const Text('Lock karo (test)'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const _Warn(
          'Ye sirf andaza hai, garbhnirodh (contraception) ka tarika nahi hai. '
          'Cycle badal sakta hai (tanav, bimari, neend, dawai). Pregnancy se '
          'bachne ke liye doctor se salah lo.',
        ),
        const SizedBox(height: 18),
        Text('Safe Days', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        _safeDays(s),
        const SizedBox(height: 22),
        Text('Baby planning', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        BabyPlanningCard(settings: s),
        const SizedBox(height: 22),
        Text('Traditional manyata (manoranjan)',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        _gender(s),
      ],
    );
  }

  DateTime _cycleStart(DateTime last, int len) {
    final now = DateTime.now();
    final t0 = DateTime(now.year, now.month, now.day);
    final start = DateTime(last.year, last.month, last.day);
    final diff = t0.difference(start).inDays;
    return start.add(Duration(days: (diff ~/ len) * len));
  }

  Widget _safeDays(CycleSettings s) {
    if (s.lastPeriod == null) {
      return const _Plain('Pehle Home par last period ki date chuno.');
    }
    final len = s.cycleLength;
    final ov = len - 14;
    final cs = _cycleStart(s.lastPeriod!, len);
    final now = DateTime.now();
    final t0 = DateTime(now.year, now.month, now.day);
    final todayDay = t0.difference(cs).inDays + 1;
    final f = DateFormat('d MMM');
    DateTime d(int day) => cs.add(Duration(days: day - 1));

    final rows = <Widget>[
      _Range('Period', '${f.format(d(1))} - ${f.format(d(5))}',
          AppColors.menstrual),
    ];
    if (ov - 6 >= 6) {
      rows.add(_Range('Kam sambhavna',
          '${f.format(d(6))} - ${f.format(d(ov - 6))}', AppColors.follicular));
    }
    rows.add(_Range('Zyada sambhavna (fertile)',
        '${f.format(d(ov - 5))} - ${f.format(d(ov + 1))}', AppColors.ovulation));
    if (ov + 2 <= len) {
      rows.add(_Range('Kam sambhavna',
          '${f.format(d(ov + 2))} - ${f.format(d(len))}', AppColors.follicular));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 300,
                child: CycleWheel(length: len, today: todayDay),
              ),
            ),
            const SizedBox(height: 14),
            Text('Is cycle ke din ($len din ka cycle)',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...rows,
            const SizedBox(height: 8),
            const Text(
              '"Kam sambhavna" ka matlab "zero risk" nahi hai.',
              style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gender(CycleSettings s) {
    const warn = _Warn(
      'Ye sirf ek purani manyata hai, manoranjan ke liye. Vigyan ke anusaar '
      'baby ka ladka ya ladki hona timing se tay nahi hota, aur koi bhi tarika '
      'is par bharosemand nahi hai. Kisi faisle ke liye is par nirbhar mat raho.',
    );
    if (s.lastPeriod == null) {
      return const Column(children: [
        _Plain('Pehle Home par last period ki date chuno.'),
        SizedBox(height: 10),
        warn,
      ]);
    }
    final len = s.cycleLength;
    final ov = len - 14;
    final cs = _cycleStart(s.lastPeriod!, len);

    String? result;
    if (_date != null) {
      final day = _date!.difference(cs).inDays + 1;
      final before = ov - day;
      if (before >= 0 && before <= 1) {
        result =
            'Purani manyata: ovulation ke bilkul paas, ladke ki taraf jhukav mana jata hai.';
      } else if (before >= 2 && before <= 4) {
        result =
            'Purani manyata: ovulation se 2-4 din pehle, ladki ki taraf jhukav mana jata hai.';
      } else {
        result = 'Is manyata mein is din ke liye koi sanket nahi hai.';
      }
    }

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sambandh ki date chuno'),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final p = await showDatePicker(
                      context: context,
                      initialDate: _date ?? now,
                      firstDate: cs,
                      lastDate: now,
                    );
                    if (p != null) setState(() => _date = p);
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(_date == null
                      ? 'Date chuno'
                      : DateFormat('d MMM yyyy').format(_date!)),
                ),
                if (result != null) ...[
                  const SizedBox(height: 14),
                  Text(result, style: const TextStyle(height: 1.45)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        warn,
      ],
    );
  }
}

class _LockedRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  const _LockedRow(
      {required this.icon, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.rose),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(sub, style: const TextStyle(fontSize: 13.5)),
            ],
          ),
        ),
        const Icon(Icons.lock, size: 18),
      ],
    );
  }
}

class _Warn extends StatelessWidget {
  final String text;
  const _Warn(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1D6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0B04A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFF8A5A00)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13.5, height: 1.45, color: Color(0xFF4A3000)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Plain extends StatelessWidget {
  final String text;
  const _Plain(this.text);

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(text)));
}

class _Range extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Range(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
