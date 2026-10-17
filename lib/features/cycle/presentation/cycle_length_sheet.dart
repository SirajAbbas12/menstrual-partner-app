import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cycle_provider.dart';

Future<void> showCycleLengthSheet(BuildContext context, WidgetRef ref) async {
  final s = ref.read(cycleProvider);
  final last = s.lastPeriod;
  if (last == null) return;
  var value = s.cycleLength.toDouble();
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aapka cycle kitne din ka hai?',
                style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(
              'Period ke pehle din se agle period ke pehle din tak. '
              'Sabka 28 din ka nahi hota. Pata na ho to 28 rehne do.',
            ),
            const SizedBox(height: 12),
            Center(
              child: Text('${value.round()} din',
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w700)),
            ),
            Slider(
              min: 21,
              max: 45,
              divisions: 24,
              value: value,
              label: '${value.round()}',
              onChanged: (v) => setSheet(() => value = v),
            ),
            FilledButton(
              onPressed: () async {
                await ref
                    .read(cycleProvider.notifier)
                    .save(last, value.round());
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Save karo'),
            ),
          ],
        ),
      ),
    ),
  );
}
