import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum CyclePhase { menstrual, follicular, ovulation, luteal }

extension CyclePhaseInfo on CyclePhase {
  String get title => switch (this) {
        CyclePhase.menstrual => 'Menstrual Phase',
        CyclePhase.follicular => 'Follicular Phase',
        CyclePhase.ovulation => 'Ovulation Phase',
        CyclePhase.luteal => 'Luteal & PMS Phase',
      };

  String get description => switch (this) {
        CyclePhase.menstrual =>
          'Bleeding, cramps, headache, low energy aur irritability ho sakti hai.',
        CyclePhase.follicular =>
          'Fresh aur relaxed feel, mood uplift, energy dheere dheere badhti hai.',
        CyclePhase.ovulation =>
          'Excited, confident, high energy. Mood aksar sabse achha hota hai.',
        CyclePhase.luteal =>
          'Bloating, irritability, cravings, cramps ya nausea ho sakti hai.',
      };

  Color get color => switch (this) {
        CyclePhase.menstrual => AppColors.menstrual,
        CyclePhase.follicular => AppColors.follicular,
        CyclePhase.ovulation => AppColors.ovulation,
        CyclePhase.luteal => AppColors.luteal,
      };

  IconData get icon => switch (this) {
        CyclePhase.menstrual => Icons.water_drop,
        CyclePhase.follicular => Icons.spa,
        CyclePhase.ovulation => Icons.wb_sunny,
        CyclePhase.luteal => Icons.cloud,
      };
}
