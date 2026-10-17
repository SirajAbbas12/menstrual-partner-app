import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/cycle_calculator.dart';
import '../domain/cycle_phase.dart';
import '../providers/cycle_provider.dart';
import 'cycle_length_sheet.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final s = ref.read(cycleProvider);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: s.lastPeriod ?? now,
      firstDate: now.subtract(const Duration(days: 120)),
      lastDate: now,
      helpText: 'Last period kab shuru hua?',
    );
    if (picked != null) {
      await ref.read(cycleProvider.notifier).save(picked, s.cycleLength);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(cycleProvider);
    final theme = Theme.of(context);

    if (s.lastPeriod == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month,
                    size: 56, color: AppColors.rose),
                const SizedBox(height: 16),
                Text('Shuru karte hain',
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                  'Last period ki date chuno, app aaj ka phase khud nikal lega.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _pickDate(context, ref),
                  child: const Text('Date chuno'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final len = s.cycleLength;
    final info = CycleCalculator.calculate(
      lastPeriodStart: s.lastPeriod!,
      cycleLength: len,
    );
    final phase = info.phase;
    final dark =
        HSLColor.fromColor(phase.color).withLightness(0.26).toColor();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Aaj ka din',
                      style: theme.textTheme.headlineSmall),
                ),
                TextButton.icon(
                  onPressed: () => _pickDate(context, ref),
                  icon: const Icon(Icons.edit_calendar, size: 18),
                  label: const Text('Date badlo'),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ActionChip(
                avatar: const Icon(Icons.tune, size: 18),
                label: Text('Cycle: $len din (badlo)'),
                onPressed: () => showCycleLengthSheet(context, ref),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [phase.color, dark],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 112,
                        height: 112,
                        child: CustomPaint(
                          painter: _RingPainter(info.cycleDay / len),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Day',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13)),
                                Text('${info.cycleDay}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(phase.icon, color: Colors.white, size: 26),
                            const SizedBox(height: 8),
                            Text(
                              phase.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Next period: ${info.daysUntilNextPeriod} din mein',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    phase.description,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text('Cycle ke 4 phases', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final p in CyclePhase.values)
                  Expanded(child: _PhaseChip(p, p == phase)),
              ],
            ),
            const SizedBox(height: 22),
            Text('Partner ke liye tip', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.rose.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite,
                          color: AppColors.rose, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _tip(phase),
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _tip(CyclePhase p) => switch (p) {
        CyclePhase.menstrual =>
          'Use aaram do, garam paani ya chai offer karo, aur ghar ke kaam mein haath batao.',
        CyclePhase.follicular =>
          'Achha mood hai. Saath bahar jaane ya naya kuch try karne ka plan banao.',
        CyclePhase.ovulation =>
          'Energy high hai. Quality time bitao aur uski tareef karo.',
        CyclePhase.luteal =>
          'Mood sensitive ho sakta hai. Bahas se bacho, dhyan se suno aur uski pasand ka khana do.',
      };
}

class _PhaseChip extends StatelessWidget {
  final CyclePhase phase;
  final bool active;
  const _PhaseChip(this.phase, this.active);

  String get _short => switch (phase) {
        CyclePhase.menstrual => 'Period',
        CyclePhase.follicular => 'Fresh',
        CyclePhase.ovulation => 'Ovulation',
        CyclePhase.luteal => 'PMS',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: active ? phase.color : phase.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(phase.icon,
              size: 22, color: active ? Colors.white : phase.color),
          const SizedBox(height: 6),
          Text(
            _short,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : phase.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 8;
    final bg = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final fg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, bg);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2,
        2 * math.pi * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}
