import '../cycle/domain/cycle_calculator.dart';
import 'message_bank.dart';
import 'mood_bucket.dart';

String messageFor({
  required DateTime date,
  required DateTime lastPeriod,
  required int cycleLength,
  int skip = 0,
}) {
  final info = CycleCalculator.calculate(
    lastPeriodStart: lastPeriod,
    cycleLength: cycleLength,
    today: date,
  );
  final list = messageBank[bucketFor(info.cycleDay, cycleLength)]!;
  return list[(info.cycleDay + skip) % list.length];
}
