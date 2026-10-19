import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_store.dart';
import '../../notifications/notification_service.dart';

class CycleSettings {
  final DateTime? lastPeriod;
  final int cycleLength;
  const CycleSettings(this.lastPeriod, this.cycleLength);
}

class CycleNotifier extends Notifier<CycleSettings> {
  @override
  CycleSettings build() =>
      CycleSettings(LocalStore.lastPeriod, LocalStore.cycleLength);

  Future<void> save(DateTime date, int length) async {
    await LocalStore.saveCycle(date, length);
    state = CycleSettings(date, length);
    NotificationService.refresh();
  }
}

final cycleProvider =
    NotifierProvider<CycleNotifier, CycleSettings>(CycleNotifier.new);
