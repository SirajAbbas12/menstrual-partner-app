import 'cycle_phase.dart';

class CycleInfo {
  final CyclePhase phase;
  final int cycleDay;
  final int daysUntilNextPeriod;
  const CycleInfo(this.phase, this.cycleDay, this.daysUntilNextPeriod);
}

class CycleCalculator {
  static const int periodLength = 5;

  static CycleInfo calculate({
    required DateTime lastPeriodStart,
    required int cycleLength,
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final start = DateTime(
        lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final current = DateTime(now.year, now.month, now.day);

    final diff = current.difference(start).inDays;
    final day = (diff % cycleLength) + 1;

    final ovulationDay = cycleLength - 14;

    final CyclePhase phase;
    if (day <= periodLength) {
      phase = CyclePhase.menstrual;
    } else if (day < ovulationDay - 1) {
      phase = CyclePhase.follicular;
    } else if (day <= ovulationDay + 1) {
      phase = CyclePhase.ovulation;
    } else {
      phase = CyclePhase.luteal;
    }

    return CycleInfo(phase, day, cycleLength - day + 1);
  }
}
