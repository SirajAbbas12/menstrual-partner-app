import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/cycle/domain/cycle_calculator.dart';
import 'features/cycle/domain/cycle_phase.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final info = CycleCalculator.calculate(
      lastPeriodStart: DateTime.now().subtract(const Duration(days: 10)),
      cycleLength: 28,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: Text(
            '${info.phase.title}\nDay ${info.cycleDay}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
