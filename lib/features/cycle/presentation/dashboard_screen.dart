import 'package:flutter/material.dart';
import '../domain/cycle_calculator.dart';
import '../domain/cycle_phase.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final info = CycleCalculator.calculate(
      lastPeriodStart: DateTime.now().subtract(const Duration(days: 10)),
      cycleLength: 28,
    );
    final phase = info.phase;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Aaj ka din', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: phase.color,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(phase.icon, color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    phase.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cycle Day ${info.cycleDay}  |  Next period in ${info.daysUntilNextPeriod} din',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    phase.description,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Partner ke liye tip', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  _tip(phase),
                  style: const TextStyle(fontSize: 15, height: 1.5),
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
