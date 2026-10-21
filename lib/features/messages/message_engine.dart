import '../cycle/domain/cycle_calculator.dart';
import '../../core/storage/local_store.dart';
import 'message_bank.dart';
import 'self_message_bank.dart';
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
  final bank = LocalStore.role == 'self' ? selfMessageBank : messageBank;
  final list = bank[bucketFor(info.cycleDay, cycleLength)]!;
  return list[(info.cycleDay + skip) % list.length];
}
