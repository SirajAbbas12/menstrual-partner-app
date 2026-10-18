import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/cycle_calculator.dart';
import '../domain/cycle_phase.dart';

class WeekStrip extends StatelessWidget {
  final DateTime lastPeriod;
  final int cycleLength;
  const WeekStrip(
      {super.key, required this.lastPeriod, required this.cycleLength});

  @override
  Widget build(BuildContext context) {
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    return Row(
      children: [
        for (var i = -3; i <= 3; i++)
          Expanded(
            child: _Day(today.add(Duration(days: i)), i == 0, lastPeriod,
                cycleLength),
          ),
      ],
    );
  }
}

class _Day extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final DateTime last;
  final int len;
  const _Day(this.date, this.isToday, this.last, this.len);

  @override
  Widget build(BuildContext context) {
    final phase = CycleCalculator.calculate(
      lastPeriodStart: last,
      cycleLength: len,
      today: date,
    ).phase;
    return Column(
      children: [
        Text(DateFormat('E').format(date),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday ? phase.color : phase.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: AppColors.plum, width: 2) : null,
          ),
          child: Text('${date.day}',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isToday ? Colors.white : phase.color)),
        ),
      ],
    );
  }
}

class InfoCards extends StatelessWidget {
  final DateTime lastPeriod;
  final int cycleLength;
  const InfoCards(
      {super.key, required this.lastPeriod, required this.cycleLength});

  @override
  Widget build(BuildContext context) {
    final info = CycleCalculator.calculate(
        lastPeriodStart: lastPeriod, cycleLength: cycleLength);
    final ov = cycleLength - 14;
    final toOv = info.cycleDay <= ov
        ? ov - info.cycleDay
        : cycleLength - info.cycleDay + ov;
    final toPeriod = info.daysUntilNextPeriod;
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final f = DateFormat('d MMM');
    return Row(
      children: [
        Expanded(
          child: _Info(
            icon: Icons.water_drop,
            label: 'Agla period',
            value: '$toPeriod din',
            date: f.format(today.add(Duration(days: toPeriod))),
            color: AppColors.menstrual,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Info(
            icon: Icons.wb_sunny,
            label: 'Agla ovulation',
            value: toOv == 0 ? 'Aaj' : '$toOv din',
            date: f.format(today.add(Duration(days: toOv))),
            color: AppColors.ovulation,
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String date;
  final Color color;
  const _Info({
    required this.icon,
    required this.label,
    required this.value,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 12.5)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            Text(date, style: const TextStyle(fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}

class SettingsPills extends StatelessWidget {
  final DateTime lastPeriod;
  final int cycleLength;
  final VoidCallback onDate;
  final VoidCallback onCycle;
  const SettingsPills({
    super.key,
    required this.lastPeriod,
    required this.cycleLength,
    required this.onDate,
    required this.onCycle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Pill(
            icon: Icons.event,
            label: 'Last period',
            value: DateFormat('d MMM').format(lastPeriod),
            onTap: onDate,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Pill(
            icon: Icons.tune,
            label: 'Cycle',
            value: '$cycleLength din',
            onTap: onCycle,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _Pill({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blushDeep,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.rose),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 11.5)),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Icon(Icons.edit, size: 16, color: AppColors.plum),
            ],
          ),
        ),
      ),
    );
  }
}
