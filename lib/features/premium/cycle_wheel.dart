import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CycleWheel extends StatelessWidget {
  final int length;
  final int today;
  const CycleWheel({super.key, required this.length, required this.today});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(painter: _WheelPainter(length, today)),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final int length;
  final int today;
  _WheelPainter(this.length, this.today);

  Color _color(int day) {
    final ov = length - 14;
    if (day <= 5) return AppColors.menstrual;
    if (day >= ov - 5 && day <= ov + 1) return AppColors.ovulation;
    return AppColors.follicular;
  }

  void _text(Canvas canvas, String s, Offset center, double size,
      Color color, FontWeight w) {
    final tp = TextPainter(
      text: TextSpan(
          text: s,
          style: TextStyle(color: color, fontSize: size, fontWeight: w)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final ringR = size.width / 2 - 22;
    final dotR = (2 * math.pi * ringR / length) * 0.42;

    for (var d = 1; d <= length; d++) {
      final a = -math.pi / 2 + 2 * math.pi * (d - 1) / length;
      final p = c + Offset(math.cos(a), math.sin(a)) * ringR;
      canvas.drawCircle(p, dotR, Paint()..color = _color(d));
      if (d == today) {
        canvas.drawCircle(
          p,
          dotR + 4,
          Paint()
            ..color = AppColors.plum
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
      _text(canvas, '$d', p, dotR * 0.95, Colors.white, FontWeight.w700);
    }

    _text(canvas, 'Day $today', c - const Offset(0, 10), 26,
        AppColors.plum, FontWeight.w700);
    _text(canvas, '$length din ka cycle', c + const Offset(0, 16), 13,
        AppColors.plum, FontWeight.w500);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.length != length || old.today != today;
}
